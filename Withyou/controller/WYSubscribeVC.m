//
//  WYSubscribeVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/7.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYSubscribeVC.h"

@interface WYSubscribeVC ()
@property (nonatomic, strong)NSMutableArray *postArr;
@property (nonatomic, assign)NSInteger page;
@property(nonatomic, assign)BOOL hasMore;

@end

@implementation WYSubscribeVC

-(NSMutableArray *)postArr{
    if (_postArr == nil) {
        _postArr = [NSMutableArray array];
    }
    return _postArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订阅";
    [self setNaviBar];
    [self initData];
}

-(void)setNaviBar{
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;

}

-(void)initData{
    _page = 1;
    __weak WYSubscribeVC *weakSelf = self;
    [self initHeaderRefreshData];
    
    [self.tableView addHeaderRefresh:^{
        [weakSelf.tableView endHeaderRefresh];
        [weakSelf initHeaderRefreshData];
    }];
    [self.tableView addFooterRefresh:^{
        [weakSelf initFootRefreshData];
    }];
}

//重写清空一下 去除下拉功能 (避免父类下拉影响)
- (void)createRefreshView{}

-(void)initHeaderRefreshData{
    __weak WYSubscribeVC *weakSelf = self;
    [YZPostListApi listSubscribePost:1 Block:^(NSArray *postArr,BOOL hasMore) {
        if (postArr) {
            _page = 2;
            weakSelf.hasMore = hasMore;
            [weakSelf.postArr removeAllObjects];
            [weakSelf.postArr addObjectsFromArray:postArr];
            
            for (WYPost *post in weakSelf.postArr){
                WYCellPostFrame *frame = [[WYCellPostFrame alloc] initWithPost:post];
                [self.dataSource removeAllObjects];
                [self.dataSource addObject:frame];
            }
            [self.tableView reloadData];
        }else{
            [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
        }
    }];
}

-(void)initFootRefreshData{
    
    if (!self.hasMore){
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return ;
    }
    __weak WYSubscribeVC *weakSelf = self;
    [YZPostListApi listSubscribePost:_page Block:^(NSArray *postArr,BOOL hasMore) {
        if (postArr) {
            if (postArr.count > 0) {
                _page += 1;
                weakSelf.hasMore = hasMore;
                [weakSelf.postArr addObjectsFromArray:postArr];
                for (WYPost *post in weakSelf.postArr){
                    WYCellPostFrame *frame = [[WYCellPostFrame alloc] initWithPost:post];
                    [self.dataSource addObject:frame];
                }
                [weakSelf.tableView endFooterRefresh];
                [self.tableView reloadData];
            }else{
                [weakSelf.tableView endRefreshWithNoMoreData];
            }
        }else{
            [weakSelf.tableView endFooterRefresh];
            [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
        }
    }];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
