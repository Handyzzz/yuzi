//
//  WYMorePhotosVC.m
//  Withyou
//
//  Created by Tong Lu on 8/8/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import "iCarousel.h"
#import "WYPhoto.h"
#import "WYMorePhotosVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "WYMorePhotoCell.h"
#import "UIImage+WYUtils.h"


@interface WYMorePhotosVC ()<iCarouselDelegate,iCarouselDataSource>

@property(nonatomic, strong)NSMutableArray *photos;
@property(nonatomic, strong)UIToolbar *toolBar;
@property(nonatomic, strong)UIActionSheet *asReport;
@property(nonatomic, strong)UIActionSheet *asMoreBtnClick;
@property(nonatomic, strong)iCarousel*ic;
@property(nonatomic, assign)BOOL haveTap;
@property(nonatomic, assign)NSInteger index;
@property(nonatomic, strong)NSMutableArray *textViewArr;
@property(nonatomic, strong)UIView *photoIV;

@end

@implementation WYMorePhotosVC


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = YES;
}

-(NSMutableArray*)textViewArr{
    if (_textViewArr == nil) {
        _textViewArr = [NSMutableArray array];
    }
    return _textViewArr;
}



-(NSMutableArray*)photos{
    if (_photos == nil) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}
-(void)initData{
    if(self.post.images)
    {
        self.photos = [NSMutableArray arrayWithArray:self.post.images];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.post.albumTitle;
    //_emptyCellForHeightCalculation = [[WYMorePhotoCell alloc] init];
    [self initData];
    //[self createTableView];
    [self createNavigationItems];
    [self ic];
    
    
}

- (iCarousel *)ic {
    if(_ic == nil) {
        _ic = [[iCarousel alloc] init];
        _ic.delegate = self;
        _ic.dataSource = self;
        [self.view addSubview:_ic];
        [_ic mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        //显示的类型 0 ~ 11
        _ic.type = 0;
        //自动滚动, 0不能滚动, 数字越大 滚动越快
        //+ - 号 表示滚动方向
        //_ic.autoscroll = -1;
        //显示的方向
        //_ic.vertical = YES;
        
        //手动滑动时的惯性
        _ic.scrollSpeed = 1;
        _ic.bounces=NO;
        _ic.pagingEnabled=YES;
        
    }
    return _ic;
}


- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return self.photos.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    UIImageView* photoIV = [[UIImageView alloc]initWithFrame:self.view.bounds];
    
    //手势
    UITapGestureRecognizer *contentGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick)];
    [photoIV addGestureRecognizer:contentGesture];
    photoIV.userInteractionEnabled = YES;
    [photoIV sd_setImageWithURL:[NSURL URLWithString:((WYPhoto*)(_photos[index])).url]
               placeholderImage:[UIImage imageNamed:@"111111-0"]];
    photoIV.contentMode = UIViewContentModeScaleAspectFit;
    photoIV.backgroundColor = [UIColor colorWithRed:31/255.0 green:32/255.0 blue:36/255.0 alpha:1];
    
    UITextView *textView = [UITextView new];
    [photoIV addSubview:textView];
    textView.showsVerticalScrollIndicator = NO;
    textView.editable = NO;
    textView.backgroundColor = [UIColor colorWithRed:31/255.0 green:32/255.0 blue:36/255.0 alpha:0.5];
    NSString *titleStr = [NSString stringWithFormat:@"%lu/%lu. ",index+1,self.photos.count];
    NSString *contentStr = ((WYPhoto*)(_photos[index])).content;

    //设置字符串的字体 然后拼接
    
    NSMutableString *str = [NSMutableString stringWithString:titleStr];
    [str appendString:contentStr];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, titleStr.length)];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(titleStr.length, contentStr.length)];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attr.length)];
    if (((WYPhoto*)(_photos[index])).content.length > 0) {
        textView.attributedText = attr;
    }else{
        textView.attributedText = [[NSAttributedString alloc]initWithString:@""];
    }
    CGSize size = [textView.attributedText boundingRectWithSize:CGSizeMake(kAppScreenWidth, 200) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(size.height+30);
    }];
    view = photoIV;
    [self.textViewArr addObject:textView];
    return view;
}

-(void)imageClick{
    if (_haveTap != YES) {
        CGRect frame = ((UITextView*)(self.textViewArr[self.ic.currentItemIndex])).frame;
        frame.size.width = 0;
        ((UITextView*)(self.textViewArr[self.ic.currentItemIndex])).frame = frame;
        _haveTap = YES;
    }else{
        //_ic.currentItemView 只读 又栽倒readonly上了 
        CGRect frame = ((UITextView*)(self.textViewArr[self.ic.currentItemIndex])).frame;
        frame.size.width = kAppScreenWidth;
        ((UITextView*)(self.textViewArr[self.ic.currentItemIndex])).frame = frame;
        _haveTap = NO;
    }
}

//当页数发生变化时
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    _haveTap = NO;
}
//点击以后
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
}


- (void)createNavigationItems
{
    UIBarButtonItem *moreBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"naviRightBlack"] style:UIBarButtonItemStylePlain target:self action:@selector(moreBtnAction)];
    
    //对自己单独发布的相册，我们开放这种情况下的原图保存
    BOOL publishOnlyToMe = [self.post.targetType isEqualToNumber:@4] && [self.post.targetUuid isEqualToString:kuserUUID];
    BOOL meIsAuthor = [self.post.author.uuid isEqualToString:kuserUUID];
    
    if(publishOnlyToMe || meIsAuthor)
        self.navigationItem.rightBarButtonItem = moreBtn;
}


#pragma mark -
- (void)moreBtnAction
{    
    UIActionSheet *as;
    BOOL meIsAuthor = [self.post.author.uuid isEqualToString:kuserUUID];
    if(meIsAuthor)
        as = [[UIActionSheet alloc] initWithTitle:@"相册" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"下载相册原图到本地", @"编辑文字介绍", nil];
    else
        as = [[UIActionSheet alloc] initWithTitle:@"相册" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"下载相册原图到本地", nil];
    
    _asMoreBtnClick = as;
    as.delegate = self;
    [as showInView:self.view];
}

- (void)starBtnAction
{
    [WYUtility showAlertWithTitle:@"starred"];
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == actionSheet.cancelButtonIndex){
        return;
    }
    
    if (_asMoreBtnClick == actionSheet) {
        //outside as clicked
        if(buttonIndex == 0)
        {
            if(_photos.count == 0){
                [WYUtility showAlertWithTitle:@"没有照片"];
            }else{
                NSMutableArray *ar = [NSMutableArray array];
                for(WYPhoto *p in _photos)
                {
                    [ar addObject:p.url];
                }
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [WYUtility downloadFullResolutionImagesFromQiniuThumbnails:[ar copy]];
                });
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
            
        }
        else if(buttonIndex == 1){
             [WYUtility showAlertWithTitle:@"编辑文字介绍"];
        }
        else
        {
            UIActionSheet *reportSheet = [[UIActionSheet alloc]
                                          initWithTitle:@"举报分类"
                                          delegate:self
                                          cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:@"泄露隐私", @"人身攻击", @"色情文字", @"违反法律", @"垃圾信息", @"其他", nil ];
            
            _asReport = reportSheet;
            [reportSheet showInView:self.view];
            
        }
    }
    else if(_asReport == actionSheet)
    {
        [WYUtility showAlertWithTitle:[NSString stringWithFormat:@"post uuid %@ is reproted", self.post.uuid]];
        
    }
}

@end
