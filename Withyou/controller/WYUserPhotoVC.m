//
//  WYUserPhotoVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/5/11.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYUserPhotoVC.h"
#import "WYUserDetailHeaderView.h"
#import "WYAlbumCollectionViewCell.h"
#import "WYUserDetailApi.h"

@interface WYUserPhotoVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic, assign)BOOL isAll;
@property(nonatomic, strong)UIButton *browseBtn;
@property(nonatomic, strong)UIButton *allBtn;
@end

@implementation WYUserPhotoVC

/*
 一个分区
 */

static NSString * userPhotoCell = @"userPhotoCell";
static NSString * headerViewIdentifier = @"headerViewIdentifier";


-(NSMutableArray *)imageArr{
    if (_imageArr == nil) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

-(void)setUpCollectionView{
    CGFloat height = [WYUserDetailHeaderView calculateHeaderHeight:self.userInfo];
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //创建CollectionView
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, kAppScreenHeight) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.bounces = YES;
    collectionView.contentInset = UIEdgeInsetsMake(height + 40,0,0,0);
    [collectionView registerClass:[WYAlbumCollectionViewCell class] forCellWithReuseIdentifier:userPhotoCell];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier];
    self.collectionView = collectionView;
    [self.view addSubview:self.collectionView];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WYAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:userPhotoCell forIndexPath:indexPath];
    WYPhoto *photo = self.imageArr[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:photo.url]];
    cell.imageView.tag = indexPath.row + 10000;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds = YES;

    return cell;
}

//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier forIndexPath:indexPath];
        
        //设置view 不自定义只适合一个分区的情况
        UIView *view = [header viewWithTag:1000 + indexPath.section];
        if (view == nil) {
            view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 25)];
            view.backgroundColor = UIColorFromHex(0xf5f5f5);
            view.tag = 1000 + indexPath.section;
            [self addContent:view];
            [header addSubview:view];
        }
        return header;
    }
    //如果底部视图if([kind isEqualToString:UICollectionElementKindSectionFooter])
    return nil;
}

//补充头部内容
-(void)addContent:(UIView *)header{
    
    //第一次默认选择浏览按钮 所以浏览按钮不可以按
    _browseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _browseBtn.enabled = NO;
    [_browseBtn setImage:[UIImage imageNamed:@"otherpage_browse"] forState:UIControlStateNormal];
    [_browseBtn setImage:[UIImage imageNamed:@"otherpage_browse_pressed"] forState:UIControlStateDisabled];
    [_browseBtn addTarget:self action:@selector(browseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_browseBtn setTitle:@"浏览" forState:UIControlStateNormal];
    [_browseBtn setTitleColor:UIColorFromHex(0xc5c5c5) forState:UIControlStateNormal];
    [_browseBtn setTitleColor:UIColorFromHex(666666) forState:UIControlStateDisabled];
    _browseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_browseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
    [_browseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];

    
    _allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_allBtn setImage:[UIImage imageNamed:@"otherpage_all_default"] forState:UIControlStateNormal];
    [_allBtn setImage:[UIImage imageNamed:@"otherpage_all_pressed"] forState:UIControlStateDisabled];
    [_allBtn addTarget:self action:@selector(allBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_allBtn setTitle:@"大图" forState:UIControlStateNormal];
    [_allBtn setTitleColor:UIColorFromHex(0xc5c5c5) forState:UIControlStateNormal];
    [_allBtn setTitleColor:UIColorFromHex(666666) forState:UIControlStateDisabled];
    _allBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_allBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
    [_allBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];

   
    [header addSubview:_allBtn];
    [_allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.centerY.equalTo(0);
        make.width.equalTo(50);
    }];

    [header addSubview:_browseBtn];
    [_browseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_allBtn.mas_left);
        make.centerY.equalTo(0);
        make.width.equalTo(50);
    }];
}

-(void)browseBtnClick{
    //点击后自己失能 另外一颗按钮可以按
    _browseBtn.enabled = NO;
    _allBtn.enabled = YES;
    _isAll = NO;
    [self.collectionView reloadData];
}

-(void)allBtnClick{
    //点击后自己失能 另外一颗按钮可以按
    _browseBtn.enabled = YES;
    _allBtn.enabled = NO;
    _isAll = YES;
    [self.collectionView reloadData];
}

-(void)addFooterRefresh{
    __weak WYUserPhotoVC *weakSelf = self;
    
    [self.collectionView addFooterRefresh:^{

        WYPhoto *lastPhoto = weakSelf.imageArr.lastObject;
        
        if (!lastPhoto.createdAtFloat) {
            [OMGToast showWithText:@"TA还没有发布照片哦!"];
            [weakSelf.collectionView endFooterRefresh];
            return ;
        }
       [WYUserDetailApi listMorePhotos:weakSelf.userInfo.uuid time:lastPhoto.createdAtFloat Block:^(NSArray *photoArr,BOOL success) {
           if (success) {
               if (photoArr.count > 0) {
                   [weakSelf.imageArr addObjectsFromArray:photoArr];
                   [weakSelf.collectionView reloadData];
               }else{
                   [OMGToast showWithText:@"没有更多照片了！"];
               }
           }else{
               [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
           }
           [weakSelf.collectionView endFooterRefresh];
        }];
    }];
    
    self.collectionView.mj_footer.automaticallyHidden = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图集";
    [self setUpCollectionView];
    [self addFooterRefresh];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //进来的时候 默认选择浏览模式
    _isAll = NO;
}

-(void)noti:(NSNotification *)sender{
    CGFloat y = [[sender.userInfo objectForKey:@"contenty"] floatValue];
    //如果发通知的类不是自己发的 就改变contentOfset
    //不是自己发的
    
    self.collectionView.delegate = nil;
    if (![sender.object isKindOfClass:self.class]) {
        //最多同步到顶部
        //最多同步到顶部
        if (y >= -(40 +64)) {
            y = -104;
        }
        CGPoint point = self.collectionView.contentOffset;
        point.y = y;
        self.collectionView.contentOffset = point;
    }
    self.collectionView.delegate = self;

}


#pragma  FlowLayoutDelegate

//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isAll == NO) {
        CGFloat imgWidth = (kAppScreenWidth - 8*2 - (3 - 1)*4)/3;
        CGFloat imgHeight = imgWidth;
        return  CGSizeMake(imgWidth, imgHeight);
    }

    //保证原比例不变
    WYPhoto *photo = self.imageArr[indexPath.row];
    //最小高度为图片本身高度
    if (photo.height/photo.width >= 2/3.0) {
        
        CGFloat imgWidth = kAppScreenWidth;
        CGFloat imgHeight = imgWidth *photo.height/photo.width;
        return CGSizeMake(imgWidth, imgHeight);
    }else{
        //横长图
        CGFloat imgWidth = kAppScreenWidth;
        CGFloat imgHeight = kAppScreenWidth*2/3;
        
        return CGSizeMake(imgWidth, imgHeight);
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return  CGSizeMake(kAppScreenWidth, 25);
}

//设置分区边界, 具体看下图
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (_isAll == NO) {
        return  UIEdgeInsetsMake(0, 8, 0, 8);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (_isAll == NO) {
        return 4;
    }
    return 8;
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (_isAll == NO) {
        return 4;
    }
    return 0;
}

//cell被选择时被调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WYAlbumCollectionViewCell *cell = (WYAlbumCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    // 加载网络图片
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    
    for(int i = 0;i < [self.imageArr count];i++)
    {
        UIImageView *imageView = [cell.contentView viewWithTag:i + 10000];
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        WYPhoto *photo = self.imageArr[i];
        browseItem.bigImageUrl = photo.url;// 加载网络图片大图地址
        browseItem.smallImageView = imageView;// 小图
        [browseItemArray addObject:browseItem];
    }
    MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:cell.imageView.tag - 10000];
    //bvc.isEqualRatio = NO;// 大图小图不等比时需要设置这个属性（建议等比）
    [bvc showBrowseViewController];
}

//cell反选时被调用(多选时才生效)
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
