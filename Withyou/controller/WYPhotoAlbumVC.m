//
//  WYMorePhotosVC.m
//  Withyou
//
//  Created by Tong Lu on 8/8/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import "WYPhoto.h"
#import "WYPhotoAlbumVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "WYMorePhotoCell.h"
#import "UIImage+WYUtils.h"
#import "WYAlbumCollectionViewCell.h"


@interface WYPhotoAlbumVC ()
{
    UITableView *_tableView;
    NSMutableArray *_photos;
    UIToolbar *_toolBar;
    WYPhoto *_photoInAction;
    UIActionSheet *_asReport;
    UIActionSheet *_asMoreBtnClick;
    
    WYMorePhotoCell *emptyCellForHeightCalculation;
}

@end

static NSString *cellIdentifier = @"multipleImageCellIdentifier";


@implementation WYPhotoAlbumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"图集";
    _photos = [[NSMutableArray alloc] init];
    emptyCellForHeightCalculation = [[WYMorePhotoCell alloc] init];
    
    [self createTableView];
    [self createNavigationItems];
    [self loadPhotos];
    
}

- (void)createNavigationItems
{
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIBarButtonItem *moreBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"naviRightBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(moreBtnAction)];
    
    //对自己单独发布的相册，我们开放这种情况下的原图保存
    BOOL publishOnlyToMe = [self.post.targetType isEqualToNumber:@4] && [self.post.targetUuid isEqualToString:kuserUUID];
    BOOL meIsAuthor = [self.post.author.uuid isEqualToString:kuserUUID];
    
    if(publishOnlyToMe || meIsAuthor)
        self.navigationItem.rightBarButtonItem = moreBtn;
}
- (void)createTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kHeightNavigationItemAndStatusBar, kAppScreenWidth, kAppScreenHeight - kHeightNavigationItemAndStatusBar) style:UITableViewStylePlain];

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[WYMorePhotoCell class] forCellReuseIdentifier:cellIdentifier];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tableView];
    
}

- (void)loadPhotos
{
    if(self.post.images)
    {
        _photos = [NSMutableArray arrayWithArray:self.post.images];
    }
}
#pragma mark -
- (void)moreBtnAction
{    
    UIActionSheet *as;
    as = [[UIActionSheet alloc] initWithTitle:@"相册" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"下载相册原图到本地", nil];
    _asMoreBtnClick = as;
    as.delegate = self;
    [as showInView:self.view];
}

- (void)starBtnAction
{
    [OMGToast showWithText:@"已经开始上传"];
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
                [OMGToast showWithText:@"没有照片！"];
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
            [OMGToast showWithText:@"编辑文字介绍"];
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
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _photos.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WYMorePhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    WYPhoto *f = _photos[indexPath.row];
    [cell setupCellFromPhoto:f :indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    WYPhoto *photo = _photos[indexPath.row];
    return [emptyCellForHeightCalculation setupCellFromPhoto:photo :indexPath.row];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger num = [title integerValue];
    return num;
}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *ma;
    for(int i=0; i<_photos.count; i++)
    {
        NSString *a = [NSString stringWithFormat:@"%d", i];
        [ma addObject:a];
    }
    
    return [NSArray arrayWithArray:ma];
}

#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WYMorePhotoCell *cell = (WYMorePhotoCell *)[_tableView cellForRowAtIndexPath:indexPath];

    // 加载网络图片
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    
    for(int i = 0;i < [_photos count];i++){
        
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        
        WYPhoto *photo = _photos[i];
        browseItem.bigImageUrl = photo.url;// 加载网络图片大图地址
        browseItem.smallImageView = cell.myImageView;// 小图
        [browseItemArray addObject:browseItem];
    }
    MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:indexPath.row];
    //bvc.isEqualRatio = NO;// 大图小图不等比时需要设置这个属性（建议等比）
    [bvc showBrowseViewController];

}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
