//
//  WYPostListVC.m
//  Withyou
//
//  Created by Tong Lu on 8/8/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import "WYPostListVC.h"
#import "WYPublishVC.h"
#import "WYMorePhotosVC.h"
#import "YZPostListApi.h"
#import "WYGroup.h"
#import "WYAccountApi.h"
#import "WYQiniuApi.h"
#import "ZFPlayer.h"
#import "WYFollow.h"
#import "WYHotTagAndPostVC.h"
#import "YZPostListApi.h"


@interface WYPostListVC ()
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,assign)BOOL loadDataLock;//加锁

@end

@implementation WYPostListVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _loadDataLock = false;
    [self setNaviItem];
    [self registerNotifications];
    [self initData];
}

-(void)setNaviItem{
    UIImage *rightImage = [[UIImage imageNamed:@"post_to_publish"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(toPublishAction)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

#pragma mark -
- (void)registerNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:kNotificationUserLoggedIn object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutAction) name:kNotificationUserLoggedOut object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPublishPost:) name:kNotificationNewPublishPostAction object:nil];
}

- (void)dealloc{
    
    [self deregisterNotifications];
}

-(void)SwitchAction{
    
    NSMutableArray *frameArr = [NSMutableArray array];
    for (WYCellPostFrame *frame in self.dataSource) {
        WYCellPostFrame *myframe = [[WYCellPostFrame alloc] initWithPost:frame.post];
        [frameArr addObject:myframe];
    }
    [self.dataSource removeAllObjects];
    self.dataSource = [frameArr mutableCopy];
    [self.tableView reloadData];
}

- (void)deregisterNotifications{
    
    // 移除 slef所有通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)reloadData{
    
    [self.tableView reloadData];
}

- (void)scrollToTop
{
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

#pragma mark - actions
- (void)logoutAction
{
    [self.dataSource removeAllObjects];
    [self reloadData];
}

#pragma mark - Init Data
- (void)initData{
    //只有在登录的情况下，这些才执行
    if([[WYUIDTool sharedWYUIDTool] isLoggedIn]){

        // 1. load from Cache, if time expired, then request from web
        [self loadFromCache];
        // 2. load from web
        [self requestForFeeds];
    }
}

- (void)requestForFeeds
{
    [YZPostListApi requestFeedsByParam:@{} Handler:^(NSArray *postArray) {
        if(postArray.count > 0){
            [WYPost deleteAllPostFromCache];
            [self.dataSource removeAllObjects];
            
            for (WYPost *post in postArray)
            {
                WYCellPostFrame *frame = [[WYCellPostFrame alloc] initWithPost:post];
                [self.dataSource addObject:frame];
                [WYPost savePostToDB:post];
            }
            
            [self reloadData];
            self.tableView.mj_footer.hidden = NO;
        }else {
            self.tableView.mj_footer.hidden = YES;
            [self reloadData];
        }
    }];
}

- (void)loadFromCache
{
    NSArray *postArray = [WYPost queryPostsFromCache];
    
    if(postArray.count > 0){
        self.tableView.mj_footer.hidden = NO;
        NSMutableArray *tempArray = [NSMutableArray array];
        
        for (WYPost *post in postArray)
        {
            WYCellPostFrame *frame = [[WYCellPostFrame alloc] initWithPost:post];
            [tempArray addObject:frame];
        }
        self.dataSource = tempArray;
        [self reloadData];
    }else {
        self.tableView.mj_footer.hidden = YES;
    }
}


#pragma mark - Refresh View

- (void)onPullToRefresh {
    [self loadNewData];
}

- (void)onLoadMore {
    [self loadMoreData];
}

- (void)loadNewData
{
    if(!_loadDataLock){
        
        _loadDataLock = true;
        [YZPostListApi requestFeedsByParam:@{} Handler:^(NSArray *postArray) {
            [self.tableView.mj_header endRefreshing];

            _loadDataLock = false;
            if(postArray.count > 0)
            {
                [WYPost deleteAllPostFromCache];
                [self.dataSource removeAllObjects];
                
                NSMutableArray *tempArray = [NSMutableArray array];
                for (WYPost *post in postArray)
                {
                    WYCellPostFrame *frame = [[WYCellPostFrame alloc] initWithPost:post];
                    [tempArray addObject:frame];
                    [WYPost savePostToDB:post];
                }
                self.dataSource = tempArray;
                [self reloadData];
            }
        }];
    }else{
        [self.tableView.mj_header endRefreshing];
    }
}

- (void)loadMoreData
{
    debugMethod();
    
    if(self.dataSource.count == 0)
    {
        [self loadNewData];
    }
    else
    {
        if(!_loadDataLock) {
            _loadDataLock = true;
            
            debugLog(@"requesting");
            
            [YZPostListApi requestFeedsByParam:@{@"t": [self getOldesPostCreatedTime]} Handler:^(NSArray *postArray) {
                if(postArray.count > 0) {
                    for (WYPost *post in postArray) {
                        WYCellPostFrame *frame = [[WYCellPostFrame alloc] initWithPost:post];
                        [self.dataSource addObject:frame];
                        [WYPost savePostToDB:post];
                    }
                    [self reloadData];
                    [self.tableView.mj_footer endRefreshing];
                }
                else {
                    [self.tableView.mj_footer endRefreshing];
                    /**
                     如果后端报错，那么回调回来的数据是空的，会导致之后也没法刷新，所以不用这种方法
                     [self.tableView.mj_footer endRefreshingWithNoMoreData];
                     [OMGToast showWithText:@"公开分享已经看完了，试试关注更多朋友，或者自己发一条吧" duration:2.0];
                     */
                }
                _loadDataLock = false;
            }];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
    }
}
- (NSNumber *)getOldesPostCreatedTime{
    
    WYCellPostFrame *pf = [self.dataSource lastObject];
    return pf.post.createdAtFloat;
}

#pragma mark - Navigation View
- (void)onPublishPost:(NSNotification *)note  {
    WYPost *post = [note object];
    if(post){
        WYCellPostFrame *frame = [[WYCellPostFrame alloc] initWithPost:post];
        [self.dataSource insertObject:frame atIndex:0];
        [self reloadData];
        [self scrollToTop];
    }
}

-(void)toPublishAction{
    __weak WYPostListVC *weakSelf = self;
    WYPublishVC *vc = [WYPublishVC new];
    vc.publishInfoBlock = ^(NSDictionary *dict) {
        [weakSelf onPublishPostAction:dict];
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onPublishPostAction:(NSDictionary *)dict {

    [self.navigationController popToRootViewControllerAnimated:YES];
    NSInteger type = (NSInteger)[dict objectForKey:@"target_type"];
    if ( type == 3) {
        [WYUtility requireSetAccountNameOrAlreadyHasName:^{
            [WYPostApi addPostFromDict:dict WithBlock:^(WYPost *post) {
                if(post){
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewPublishPostAction object:post];
                }
            }];
        } navigationController:self.tabBarController.viewControllers[self.tabBarController.selectedIndex]];
    }else{
        [WYUtility requireSetAccountNameOrAlreadyHasName:^{
            [WYPostApi addPostFromDict:dict WithBlock:^(WYPost *post) {
                if(post){
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewPublishPostAction object:post];
                }
            }];
        } navigationController:self.tabBarController.viewControllers[self.tabBarController.selectedIndex]];
    }
}

@end
