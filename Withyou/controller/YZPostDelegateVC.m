//
//  WYPostBaseVC.m
//  Withyou
//
//  Created by ping on 2017/2/19.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYPostBaseVC.h"
#import "YZMapViewController.h"
#import "WYUserVC.h"
#import "YZPostDelegateVC.h"
#import "YZPostDetailVC.h"
#import "WYUserVC.h"
#import "WYPdfListVC.h"
#import "WYPreViewPdfVC.h"
#import "WYPublishAddTagsVC.h"
#import "WYTagsResultPostListVC.h"

static NSString *cellIdentifierPostDetail = @"CellIdentifierPostDetail";

#define YZPostTextCellIdentifier @"YZPostTextCell"
#define YZPostSingleImageCellIdentifier @"YZPostSingleImageCell"
#define YZPostLinkCellIdentifier @"YZPostLinkCellIdentifier"
#define YZPostVideoCellIdentifier @"YZPostVideoCellIdentifier"
#define YZPostAlbumCellIdentifier @"YZPostAlbumCellIdentifier"

@interface YZPostDelegateVC () <ZFPlayerDelegate>
{
    UIActionSheet *_asReport;
    UIActionSheet *_asMoreBtnClickReport;
    UIActionSheet *_asMoreBtnClickDelete;
    WYPost *_postInAction;
}

@end

@implementation YZPostDelegateVC

#pragma mark lazy load
- (ZFPlayerView *)playerView
{
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        
        // 当cell划出屏幕的时候停止播放
        _playerView.stopPlayWhileCellNotVisable = YES;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 静音
        // _playerView.mute = YES;
    }
    return _playerView;
}

- (ZFPlayerControlView *)controlView
{
    if (!_controlView) {
        _controlView = [[ZFPlayerControlView alloc] init];
    }
    return _controlView;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopVidoIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resumeVidoIfNeeded];
}
- (void)stopVidoIfNeeded {
    if(self.playerView.state == ZFPlayerStatePlaying || self.playerView.state == ZFPlayerStateBuffering) {
        [self.playerView pause];
        self.videoResume = YES;
    }else {
        self.videoResume = NO;
    }
}

- (void)resumeVidoIfNeeded {
    if( self.videoResume ) {
        [self.playerView play];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}



#pragma UITableViewDelegate custom overwrite
- (YZPostViewBase *)getPostDetail:(WYCellPostFrame *)frame {
    WYCellPostFrame * model = frame;
    
    YZPostViewBase *view = nil;
    
    switch (model.post.type) {
        case WYPostTypeOnlyText:
            view = [[YZPostTextView alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth, model.cellHeight)];
            break;
        case WYPostTypeSingleImage:
            view = [[YZPostSingleImageView alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth, model.cellHeight)];
            break;
        case WYPostTypeLink:
            view = [[YZPostLinkView alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth, model.cellHeight)];
            break;
        case WYPostTypeAlbum:
            view = [[YZPostAlbumView alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth, model.cellHeight)];
            break;
        case WYPostTypeVideo:
            view = [[YZPostVideoView alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth, model.cellHeight)];
            __weak typeof(self)  weakSelf      = self;
            view.playBlock = ^(WYPost *post, UIView *fatherView){
                ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
                playerModel.title            = @"";
                playerModel.placeholderImage = PlaceHolderImage;
                
                // Todo  转换 数据
                playerModel.videoURL         = [NSURL URLWithString:post.video.url];
                playerModel.fatherView       = fatherView;
                
                // 设置播放控制层和model
                [weakSelf.playerView playerControlView:weakSelf.controlView playerModel:playerModel];
                // 下载功能
                weakSelf.playerView.hasDownload = NO;
                // 自动播放
                [weakSelf.playerView autoPlayTheVideo];
            };
            break;
            
    }
    
    view.delegate = self;
    [view setDetailLayout:model];
    
    return view;

}
- (YZPostCellBase *)tableView:(UITableView *)tableView getCellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath dataSrouce:(NSArray *)dataSrouce isDetial:(BOOL)isDetial{
    WYCellPostFrame * model = dataSrouce[indexPath.row];
    __weak typeof(indexPath) weakIndexPath = indexPath;
    __weak typeof(self)  weakSelf      = self;
    YZPostCellBase *cell = nil;
    
    switch (model.post.type) {
        case WYPostTypeOnlyText:
            cell = [tableView dequeueReusableCellWithIdentifier:YZPostTextCellIdentifier];
            if(cell == nil) {
                cell = [[YZPostTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:YZPostTextCellIdentifier];
            }
            break;
        case WYPostTypeSingleImage:
            cell = [tableView dequeueReusableCellWithIdentifier:YZPostSingleImageCellIdentifier];
            if(cell == nil) {
                cell = [[YZPostSingleImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:YZPostSingleImageCellIdentifier];
            }
            break;
        case WYPostTypeLink:
            cell = [tableView dequeueReusableCellWithIdentifier:YZPostLinkCellIdentifier];
            if(cell == nil) {
                cell = [[YZPostLinkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:YZPostLinkCellIdentifier];
            }
            break;
        case WYPostTypeAlbum:
            cell = [tableView dequeueReusableCellWithIdentifier:YZPostAlbumCellIdentifier];
            if(cell == nil) {
                cell = [[YZPostAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:YZPostAlbumCellIdentifier];
            }
            break;
        case WYPostTypeVideo:
            cell = [tableView dequeueReusableCellWithIdentifier:YZPostVideoCellIdentifier];
            if(cell == nil) {
                cell = [[YZPostVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:YZPostVideoCellIdentifier];
            }
            
            cell.playBlock = ^(WYPost *post, UIView *fatherView){
                ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
                playerModel.title            = @"";
                playerModel.placeholderImage = PlaceHolderImage;
                
                // Todo  转换 数据
                playerModel.videoURL         = [NSURL URLWithString:post.video.url];
                //        playerModel.placeholderImageURLString = model.coverForFeed;
                playerModel.tableView        = tableView;
                playerModel.indexPath        = weakIndexPath;
                playerModel.fatherView       = fatherView;
                
                // 设置播放控制层和model
                [weakSelf.playerView playerControlView:weakSelf.controlView playerModel:playerModel];
                // 下载功能
                weakSelf.playerView.hasDownload = NO;
                // 自动播放
                [weakSelf.playerView autoPlayTheVideo];
            };
            break;
            
    }
    
    cell.delegate = self;
    if (isDetial) {
        [cell setDetailLayout:model];
    }else {
        cell.postFrame = model;
    }
    return  cell;
}

#pragma mark - WYCellPostDelegate

- (void)atStringClick:(YZMarkText *)mark {
    if(mark.content_type == 1) {
        
        WYUserVC *vc = [WYUserVC new];
        
        if([mark.content_uuid isEqualToString:kuserUUID])
        {
            vc.user = kLocalSelf;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            WYUserVC *vc = [WYUserVC new];
            WYUser *user = [WYUser queryUserWithUuid:mark.content_uuid];
            if(user) {
                vc.user = user;
            }else {
                vc.userUuid = mark.content_uuid;
            }
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if(mark.content_type == 2) {
        // 打开地图
        YZMapViewController *map = [[YZMapViewController alloc] init];
        map.latitude = mark.lat;
        map.longitude = mark.lng;
        map.pointName = mark.content_name;
        map.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:map animated:YES];
    }
    
}
- (void)moreActions:(WYPost *)post
{
    //report or copy public address
    
    _postInAction = post;
    
    //如果是本人
    if([_postInAction.author.uuid isEqualToString:[WYUIDTool sharedWYUIDTool].uid.uuid])
    {
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"更多操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享链接", @"删除内容", nil];
        _asMoreBtnClickDelete = as;
        as.delegate = self;
        [as showInView:self.view];
    }
    else
    {
        NSString *subscribeStr = _postInAction.subscribed ? @"取消订阅":@"订阅评论";
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"更多操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享链接", @"举报内容",subscribeStr, nil];
        _asMoreBtnClickReport = as;
        as.delegate = self;
        [as showInView:self.view];
    }
    
    
}

- (void)detail:(WYPost *)post
{
    YZPostDetailVC *vc = [[YZPostDetailVC alloc] init];
    vc.post = post;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma post actions
//星标
- (void)star:(WYPost *)post
{

}

// if subclass need
- (void)iconAction:(WYUser *)user {
    if([user.uuid isEqualToString:kuserUUID])
    {
        WYUserVC *vc = [WYUserVC new];
        vc.user = user;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        WYUserVC *vc = [WYUserVC new];
        vc.user = user;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)iconClick:(WYUser *)user {
    [self iconAction:user];
}
- (void)showImageFromPost:(WYPost *)post
{
    [WYZoomImage showWithImage:nil imageURL:post.mainPic.url];
}

- (void)showAlbumFromPost:(WYPost *)post
{
    WYPhotoAlbumVC *vc = [WYPhotoAlbumVC new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.delegate = self;
    vc.post = post;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showLinkContentFromPost:(WYPost *)post
{
    WYLinkDetailVC *vc = [WYLinkDetailVC new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.post = post;
    [self.navigationController pushViewController:vc animated:YES];
}

//标签
-(void)tagsClick:(WYPost*)post index:(NSInteger)index{
    
    if (index < post.tag_list.count) {
        WYTag *tag = post.tag_list[index];
        WYTagsResultPostListVC *vc = [WYTagsResultPostListVC new];
        vc.hidesBottomBarWhenPushed = YES;
        vc.tagStr = tag.tag_name;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        WYPublishAddTagsVC *vc = [[WYPublishAddTagsVC alloc]initWithType:AddTagFromPost];
        vc.post = post;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)addressClick:(YZAddress *)address {
    // 打开地图
    YZMapViewController *map = [[YZMapViewController alloc] init];
    map.latitude = [address.lat doubleValue];
    map.longitude = [address.lng doubleValue];
    map.pointName = address.name;
    map.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:map animated:YES];
}

//与谁一起
-(void)remindClick:(WYUser *)user{
    WYUserVC *vc = [WYUserVC new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.user = user;
    [self.navigationController pushViewController:vc animated:YES];
}

//pdf 附件
- (void)attchMentPdfsInDetail:(YZPdf *)pdf{
    WYPreViewPdfVC *vc = [WYPreViewPdfVC new];
    vc.targetUrl = pdf.url;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == actionSheet.cancelButtonIndex){
        return;
    }
    
    if (_asMoreBtnClickReport == actionSheet) {
        //outside as clicked
        if(buttonIndex == 0)
        {
            [self shareButtonClick];
        }
        else if(buttonIndex == 1)
        {
            
            UIActionSheet *reportSheet = [[UIActionSheet alloc]
                                          initWithTitle:@"举报分类"
                                          delegate:self
                                          cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:@"泄露隐私", @"人身攻击", @"色情文字", @"违反法律", @"垃圾信息", @"其他", nil ];
            
            _asReport = reportSheet;
            [reportSheet showInView:self.view];
        }else{
            [self subscribeBtnClick];
        }
    }
    else if (_asMoreBtnClickDelete == actionSheet) {
        //outside as clicked
        if(buttonIndex == 0)
        {
            [self shareButtonClick];
        }
        else
        {
            
            [[[UIAlertView alloc] initWithTitle:@"确定删除?"
                                        message:@"一条分享删除后，将无法找回，请谨慎操作"
                               cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
                // Handle "Cancel"
                return;
            }]
                               otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^{
                
                [self deletePost:_postInAction];
                
                // Handle "Delete"
            }], nil] show];
            
            
        }
    }
    else if(_asReport == actionSheet)
    {
        
        [WYPostApi reportPost:_postInAction.uuid Reason:(int)buttonIndex];
        
    }
}
- (void)deletePost:(WYPost *)post
{
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [WYPostApi deletePost:post.uuid WithBlock:^(NSDictionary *dict) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        if(dict)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDeletePublishPostAction object:self userInfo:@{@"post":post}];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
#pragma mark - Test Button
- (void)shareButtonClick
{
    NSString *stringtoshare= [NSString stringWithFormat:@"%@/s/p/%@/",kBaseURL, _postInAction.uuid];
    NSURL *urlToShare = [NSURL URLWithString:stringtoshare];
    //    UIImage *imagetoshare = [UIImage imageNamed:@"settings-c"]; //This is an image to share.
    
    
    //        UIImage *imagetoshare = img; //This is an image to share.
    //        NSArray *activityItems = @[stringtoshare, imagetoshare];
    NSArray *activityItems = @[urlToShare, ];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint, ]; //UIActivityTypePostToTwitter, UIActivityTypePostToWeibo
    [self presentViewController:activityVC animated:TRUE completion:nil];
    
}

-(void)subscribeBtnClick{

}

@end
