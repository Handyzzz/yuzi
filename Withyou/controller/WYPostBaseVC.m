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
#import "YZPostDetailVC.h"
#import "WYPdfListVC.h"
#import "WYZoomImage.h"
#import "WYPublishAddTagsVC.h"
#import "WYTagsResultPostListVC.h"
#import "WYPublishAddTagsVC.h"

static NSString *cellIdentifierPostDetail = @"CellIdentifierPostDetail";

#define YZPostTextCellIdentifier @"YZPostTextCell"
#define YZPostSingleImageCellIdentifier @"YZPostSingleImageCell"
#define YZPostLinkCellIdentifier @"YZPostLinkCellIdentifier"
#define YZPostVideoCellIdentifier @"YZPostVideoCellIdentifier"
#define YZPostAlbumCellIdentifier @"YZPostAlbumCellIdentifier"

@interface WYPostBaseVC () <ZFPlayerDelegate>
{
    UIActionSheet *_asReport;
    UIActionSheet *_asMoreBtnClickReport;
    UIActionSheet *_asMoreBtnClickDelete;
    WYPost *_postInAction;
    UIButton *_moreBtn;
}


@end

@implementation WYPostBaseVC

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

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[YZPostTextCell class] forCellReuseIdentifier:YZPostTextCellIdentifier];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if(!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
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
    [self beginTodo];
}

-(void)beginTodo{
    [self setup];
    [self createRefreshView];
    [self desiginNoti];
}

-(void)desiginNoti{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notiUpdatePost:) name:kNotificationUpdatePublishPostAction object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notiDeletePost:) name:kNotificationDeletePublishPostAction object:nil];
}

#pragma notiActions
-(void)notiUpdatePost:(NSNotification *)noti{
 
     WYPost *post = [noti.userInfo objectForKey:@"post"];
     //将新的group更新到对应的位置
     for (int i =0; i < self.dataSource.count; i++) {
     WYCellPostFrame *postFrame = self.dataSource[i];
         if ([postFrame.post.uuid isEqualToString:post.uuid]) {
             [self.dataSource replaceObjectAtIndex:i withObject:[[WYCellPostFrame alloc]initWithPost:post]];
             break;
         }
     }
    [self.tableView reloadData];
}

-(void)notiDeletePost:(NSNotification *)noti{
    WYPost *deletePost = [noti.userInfo objectForKey:@"post"];
    
    //将新的group更新到对应的位置
    for (int i =0; i < self.dataSource.count; i++) {
        WYCellPostFrame *postFrame = self.dataSource[i];
        if ([postFrame.post.uuid isEqualToString:deletePost.uuid]) {
            [self.dataSource removeObjectAtIndex:i];
            break;
        }
    }
    [self.tableView reloadData];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)setup {
    // 去掉 分割线
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Refresh View
- (void)createRefreshView
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(onPullToRefresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    //    [header setTitle:@"" forState:MJRefreshStateIdle];
    //    [header setTitle:@"" forState:MJRefreshStatePulling];
    self.tableView.mj_header = header;
    
    //AutoNormalFooter有问题
//    点击星标，也会请求这个方法
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(onLoadMore)];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(onLoadMore)];
    
    self.tableView.mj_footer.hidden = YES;
    
}

- (void)onPullToRefresh {
    // subclass implement
}

- (void)onLoadMore {
    // subclass implement
}


#pragma UITableViewDelegate custom overwrite
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    WYCellPostFrame * model = self.dataSource[indexPath.row];

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
                playerModel.tableView        = weakSelf.tableView;
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
    if (self.isDetial) {
        [cell setDetailLayout:model];
    }else {
        cell.postFrame = model;
    }
    UIView *lineView = [cell.contentView viewWithTag:1001];
    if (lineView == nil) {
        lineView = [UIView new];
        lineView.tag = 1001;
        lineView.backgroundColor = UIColorFromHex(0xf5f5f5);
        [cell.contentView addSubview:lineView];
    }
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.bottom.equalTo(0);
        make.height.equalTo(kPostSeparationLineHeight);
        make.width.equalTo(kAppScreenWidth);
    }];
    
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.isDetial) return;
    
    WYCellPostFrame * model = self.dataSource[indexPath.row];
    YZPostDetailVC *vc = [[YZPostDetailVC alloc] init];
    vc.postUuid = model.post.uuid;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_dataSource.count > indexPath.row) {
        WYCellPostFrame * model = _dataSource[indexPath.row];
        if([model isKindOfClass:[WYCellPostFrame class]]) {
            return model.cellHeight;
        }
    }
    return 44.f;
}


#pragma mark - WYCellPostDelegate
- (void)detail:(WYPost *)post{
    YZPostDetailVC *vc = [[YZPostDetailVC alloc] init];
    vc.postUuid = post.uuid;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)atStringClick:(YZMarkText *)mark {
    if(mark.content_type == 1) {
        if([mark.content_uuid isEqualToString:kuserUUID])
        {
            
            WYUserVC *vc = [WYUserVC new];
            vc.hidesBottomBarWhenPushed = YES;
            //在登录的时候 有将UID里边的user更新到数据库 只用判断数据库
            vc.user = kLocalSelf;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            WYUserVC *vc = [WYUserVC new];
            vc.hidesBottomBarWhenPushed = YES;
            vc.userUuid = mark.content_uuid;
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
- (void)moreActions:(WYPost *)post btn:(UIButton *)Btn{
    //report or copy public address
    
    _postInAction = post;
    _moreBtn = Btn;
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

#pragma post actions
//星标
- (void)star:(WYPost *)post
{
    __weak WYPostBaseVC *weakSelf = self;
    if(post.starred == 0)
    {
        [WYUtility requireSetAccountNameOrAlreadyHasName:^{
            for (WYCellPostFrame *item in _dataSource)  {
                if ([item.post.uuid isEqualToString:post.uuid]) {
                    item.post.starred = 1;
                    item.post.starNum ++;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdatePublishPostAction object:self userInfo:@{@"post":item.post}];
                    break;
                }
            }
            [self.tableView reloadData];
            
            [WYPostApi addStarToPost:post.uuid WithBlock:^(NSDictionary *response) {
                if(!response){
                    for (WYCellPostFrame *item in _dataSource){
                        if ([item.post.uuid isEqualToString:post.uuid]) {
                            item.post.starred = 0;
                            item.post.starNum --;
                            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdatePublishPostAction object:self userInfo:@{@"post":item.post}];
                            break;
                        }
                    }
                    [weakSelf.tableView reloadData];
                }
            }];
        } navigationController:self.navigationController];
    }
    else{
        for (WYCellPostFrame *item in _dataSource){
            if ([item.post.uuid isEqualToString:post.uuid]) {
                item.post.starred = 0;
                item.post.starNum --;
                 [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdatePublishPostAction object:self userInfo:@{@"post":item.post}];
                break;
            }
        }
        [self.tableView reloadData];
        
        [WYPostApi newRemoveStarToPost:post.uuid WithBlock:^(WYPost *newPost) {
            if(!newPost){
                for (WYCellPostFrame *item in _dataSource)  {
                    if ([item.post.uuid isEqualToString:newPost.uuid]) {
                        item.post.starred = 1;
                        item.post.starNum ++;
                         [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdatePublishPostAction object:self userInfo:@{@"post":item.post}];
                        break;
                    }
                }
                [weakSelf.tableView reloadData];
            }
        }];
    }
}

// if subclass need
- (void)iconAction:(WYUser *)user {
        WYUserVC *vc = [WYUserVC new];
        vc.user = user;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
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
- (void)attchMentPdfs:(NSArray<YZPdf*>*)pdfs{
    WYPdfListVC *vc = [WYPdfListVC new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.pdfArr = [pdfs mutableCopy];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    _moreBtn.selected = NO;
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
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
    __weak WYPostBaseVC *weakSelf = self;
    [self.view showHUDNoHide];
    [WYPostApi deletePost:post.uuid WithBlock:^(NSDictionary *dict) {
        [weakSelf.view hideAllHUD];
        
        if(dict)
        {
            //deleted successfully
            for (WYCellPostFrame *item in weakSelf.dataSource)  {
                if ([item.post.uuid isEqualToString:post.uuid]) {
                    [weakSelf.dataSource removeObject:item];
                       [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDeletePublishPostAction object:self userInfo:@{@"post":item.post}];
                    [OMGToast showWithText:@"删除成功！"];
                    break;
                }
            }
            [self.tableView reloadData];
            
            [WYPost deletePostFromDB:post.uuid];
        }
        
    }];
}
#pragma mark - Test Button
- (void)shareButtonClick
{
    NSString *stringtoshare= [NSString stringWithFormat:@"%@/s/p/%@/",kBaseURL, _postInAction.uuid];
    NSURL *urlToShare = [NSURL URLWithString:stringtoshare];
    NSArray *activityItems = @[urlToShare, ];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint, ]; //UIActivityTypePostToTwitter, UIActivityTypePostToWeibo
    [self presentViewController:activityVC animated:TRUE completion:nil];
    
}

-(void)subscribeBtnClick{
    __weak WYPostBaseVC *weakSelf = self;
    if (_postInAction.subscribed == YES) {
        [WYPostApi cancelSubscribeForPost:_postInAction.uuid Block:^(NSInteger status) {
            //success和failure的回调是在主线程中执行 为什么showWithText的时间还是不对
            if ((status >= 200) && (status < 300)) {
                _postInAction.subscribed = NO;
                for (int i = 0; i < weakSelf.dataSource.count; i ++)  {
                    WYCellPostFrame *item = weakSelf.dataSource[i];
                    if ([item.post.uuid isEqualToString:_postInAction.uuid]) {
                        [weakSelf.dataSource replaceObjectAtIndex:i withObject:[[WYCellPostFrame alloc]initWithPost:_postInAction]];
                        [OMGToast showWithText:@"取消订阅"];

                       [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdatePublishPostAction object:self userInfo:@{@"post":_postInAction}];
                        [weakSelf.tableView reloadData];
                        break;
                    }
                }
            }
        }];
    }else{
        [WYPostApi addSubscribeForPost:_postInAction.uuid Block:^(WYPost *post) {
            //success和failure的回调是在主线程中执行 为什么showWithText的时间还是不对
            if (post) {
                for (int i = 0; i < weakSelf.dataSource.count; i ++)  {
                    WYCellPostFrame *item = weakSelf.dataSource[i];
                    if ([item.post.uuid isEqualToString:post.uuid]) {
                        [weakSelf.dataSource replaceObjectAtIndex:i withObject:[[WYCellPostFrame alloc]initWithPost:post]];
                        [OMGToast showWithText:@"订阅成功"];

                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdatePublishPostAction object:self userInfo:@{@"post":post}];
                        [weakSelf.tableView reloadData];
                        break;
                    }
                }
            }
        }];
    }
}

@end
