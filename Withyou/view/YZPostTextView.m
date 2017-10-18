//
//  YZPostTextView.m
//  Withyou
//
//  Created by ping on 2017/5/13.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZPostTextView.h"
#import "WYphotosOfTypeTextCell.h"
#import "WYPdfsCellInPostDetail.h"

#define itemWH ((kAppScreenWidth - (15 * 2 + 2 * 4))/3.0)
#define lineSpace 3.0;
@interface YZPostTextView()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)WYPost *post;
@end

@implementation YZPostTextView


- (UILabel *)titleLabel {
    if(!_titleLabel) {
        UILabel *titleLabel = [UILabel new];
        [self.bodyView addSubview:titleLabel];
        titleLabel.font = kPostTitleFont;
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = UIColorFromHex(0x3333333);
        titleLabel.userInteractionEnabled = YES;
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}
- (UITextView *)contentTV {
    if (!_contentTV) {
        UITextView *content = [[UITextView alloc] init];
        [self.bodyView addSubview:content];
        content.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
        content.delegate = self;
        content.scrollEnabled = NO;
        content.editable = NO;
        content.textContainer.lineFragmentPadding = 0;
        content.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        content.textColor = UIColorFromHex(0x333333);
        content.font = kPostContentFont;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textClick:)];
        [content addGestureRecognizer:tap];
        _contentTV = content;
    }
    return _contentTV;
}

-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.itemSize = CGSizeMake(itemWH, itemWH);
        //弹性的
        layout.minimumLineSpacing = lineSpace;
        layout.minimumInteritemSpacing = lineSpace;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollsToTop = NO;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[WYphotosOfTypeTextCell class] forCellWithReuseIdentifier:@"WYphotosOfTypeTextCell"];
        [self.bodyView addSubview:_collectionView];
    }
    return _collectionView;
}

//详情页
-(UITableView *)pdfsView{
    if (_pdfsView == nil) {
        _pdfsView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _pdfsView.backgroundColor = [UIColor whiteColor];
        
        _pdfsView.backgroundColor = [UIColor blueColor];
        
        _pdfsView.delegate = self;
        _pdfsView.dataSource = self;
        _pdfsView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_pdfsView registerClass:[WYPdfsCellInPostDetail class] forCellReuseIdentifier:@"WYPdfsCellInPostDetail"];
        [self.bodyView addSubview:_pdfsView];
    }
    return _pdfsView;
}


-(UIImageView *)attachmentIV{
    if (!_attachmentIV) {
        UIImageView *imageView = [UIImageView new];
        [self.bodyView addSubview:imageView];
        _attachmentIV = imageView;
    }
    return _attachmentIV;
}

- (UILabel *)attachmentLB {
    if (!_attachmentLB) {
        UILabel *label = [UILabel new];
        label.userInteractionEnabled = YES;
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = kRGB(252, 145, 39);
        label.font = kPostAttachmentFont;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(attachmentAction)];
        [label addGestureRecognizer:tap];
        [self.bodyView addSubview:label];
        _attachmentLB = label;
    }
    return _attachmentLB;
}

-(void)setPostFrame:(WYCellPostFrame *)postFrame {
    [super setPostFrame:postFrame];
    WYPost *post = postFrame.post;
    
    // setup data
    self.titleLabel.text = post.title;
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithAttributedString:[YZMarkText convert:post.content abilityToTapStringWith:self.postFrame.post.mention FontSize:kPostContentFont.pointSize]];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;
    
    [content addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
    
    self.contentTV.attributedText = content;
    
    // setup frames
    self.titleLabel.frame = postFrame.textTitleFrame;
    self.contentTV.frame = postFrame.textContentFrame;
    
    //九图
    if (postFrame.post.images >  0) {
        [self setUpCollectionView:postFrame];
        self.collectionView.hidden = NO;
    }else{
        self.collectionView.frame = CGRectZero;
        self.collectionView.hidden = YES;
    }
    //pdfs
    if(postFrame.post.extension.pdfs.count > 0 ) {
        
        self.attachmentIV.hidden = NO;
        self.attachmentLB.hidden = NO;
        
        self.attachmentLB.frame = postFrame.textAttachmentFrame;
        self.attachmentLB.text = [NSString stringWithFormat:@"%lu个附件",postFrame.post.extension.pdfs.count];
        
        [self.attachmentIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.attachmentLB);
            make.left.equalTo(0);
        }];
        self.attachmentIV.image = [UIImage imageNamed:@"sharePdf"];

    }else {
        self.attachmentIV.frame = CGRectZero;
        self.attachmentLB.frame = CGRectZero;
        
        self.attachmentIV.hidden = YES;
        self.attachmentLB.hidden = YES;
    }
}

- (void)setDetailLayout:(WYCellPostFrame *)postFrame {
    [super setDetailLayout:postFrame];
    WYPost *post = postFrame.post;
    
    // setup data
    self.titleLabel.text = post.title;
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithAttributedString:[YZMarkText convert:post.content abilityToTapStringWith:self.postFrame.post.mention FontSize:kPostContentFont.pointSize]];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;
    
    [content addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
    self.contentTV.attributedText = content;
    
    // setup frames
    self.titleLabel.frame = postFrame.textTitleFrame;
    self.contentTV.frame = postFrame.textContentFrame;
    //九图
    if (postFrame.post.images >  0) {
        [self setUpCollectionView:postFrame];
        self.collectionView.hidden = NO;
    }else{
        self.collectionView.frame = CGRectZero;
        self.collectionView.hidden = YES;
    }
    
    //pdfs
    if (postFrame.post.extension.pdfs.count > 0) {
        [self setUpTableView:postFrame];
        self.pdfsView.hidden = NO;
    }else{
        self.pdfsView.frame = CGRectZero;
        self.pdfsView.hidden = YES;
    }
}

- (void)textClick:(UITapGestureRecognizer *)tap {
    if([self.delegate respondsToSelector:@selector(detail:)]){
        [self.delegate detail:self.postFrame.post];
    }
}

-(void)attachmentAction{
    if([self.delegate respondsToSelector:@selector(attchMentPdfs:)]){
        [self.delegate attchMentPdfs:self.postFrame.post.extension.pdfs];
    }
}

//九张图
-(void)setUpCollectionView:(WYCellPostFrame*)postFrame{
   
    self.post = postFrame.post;
    self.collectionView.frame = postFrame.photosFrame;
    [self.collectionView reloadData];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.post.images.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WYphotosOfTypeTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WYphotosOfTypeTextCell" forIndexPath:indexPath];
    WYPhoto *photo = self.post.images[indexPath.row];
    [cell.iconIV sd_setImageWithURL:[NSURL URLWithString:photo.url]];
    cell.iconIV.tag = indexPath.row + 100;

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *ma = [NSMutableArray array];
    for (int i = 0; i < self.post.images.count; i ++) {
        WYPhoto *photo = self.post.images[i];
        [ma addObject:photo.url];
    }
    
    // 加载网络图片
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    
    for(int i = 0;i < [self.post.images count];i++)
    {
        UIImageView *imageView = [self viewWithTag:i + 100];
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        WYPhoto *photo = self.post.images[i];
        browseItem.bigImageUrl = photo.url;// 加载网络图片大图地址
        browseItem.smallImageView = imageView;// 小图
        [browseItemArray addObject:browseItem];
    }
    WYphotosOfTypeTextCell *cell = (WYphotosOfTypeTextCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:cell.iconIV.tag - 100];
    //bvc.isEqualRatio = NO;// 大图小图不等比时需要设置这个属性（建议等比）
    [bvc showBrowseViewController];
}



-(void)setUpTableView:(WYCellPostFrame *)postFrame{
    self.post = postFrame.post;
    self.pdfsView.frame = postFrame.textAttachmentFrame;
    [self.pdfsView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        return 10.0;
    }
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.superview.bounds.size.width, 10)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.post.extension.pdfs.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYPdfsCellInPostDetail *cell = [tableView dequeueReusableCellWithIdentifier:@"WYPdfsCellInPostDetail" forIndexPath:indexPath];

    YZPdf *pdf = self.post.extension.pdfs[indexPath.section];
    cell.iconIV.image = [UIImage imageNamed:@"publish_big_pdf"];
    [cell groundView];
    cell.nameLb.text = pdf.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(attchMentPdfsInDetail:)]){
        [self.delegate attchMentPdfsInDetail:self.postFrame.post.extension.pdfs[indexPath.row]];
    }
}
@end
