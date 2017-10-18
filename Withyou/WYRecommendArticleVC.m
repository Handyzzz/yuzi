//
//  WYRecommendArticleVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/9/27.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYRecommendArticleVC.h"
#import "WYArticle.h"
#import "WYArticleCell.h"
#import "WYArticleAPI.h"
#import "WYFollowedMediaVC.h"
#import "WYMediaDetailVC.h"
#import "WYArticleDetailVC.h"
#import "WYArticleDetailVC.h"

@interface WYRecommendArticleVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray <WYArticle*>*articleList;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)BOOL hasMore;
@end

@implementation WYRecommendArticleVC

-(NSMutableArray *)articleList{
    if (!_articleList) {
        _articleList = [NSMutableArray array];
    }
    return _articleList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"媒体";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNaviBar];
    [self initData];
}

-(void)setNaviBar{
    UIImage *leftImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:leftImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIImage *rightImg = [[UIImage imageNamed:@"media_Followed_list"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithImage:rightImg style:UIBarButtonItemStylePlain target:self action:@selector(mediaListAction)];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
}

-(void)initData{
    MJWeakSelf
    _page = 1;
    [self.tableView showHUDNoHide];
    [WYArticleAPI listRecommendArticleList:1 Block:^(NSArray *articleList, BOOL hasMore) {
        [weakSelf.tableView hideAllHUD];
        if (articleList) {
            weakSelf.hasMore = hasMore;
            weakSelf.page = 2;
            [weakSelf.articleList addObjectsFromArray:articleList];
            [weakSelf.tableView reloadData];
        }
    }];
    
    [self.tableView addHeaderRefresh:^{
        [WYArticleAPI listRecommendArticleList:1 Block:^(NSArray *articleList, BOOL hasMore) {
            [weakSelf.tableView endHeaderRefresh];
            if (articleList) {
                weakSelf.hasMore = hasMore;
                weakSelf.page = 2;
                [weakSelf.articleList removeAllObjects];
                [weakSelf.articleList addObjectsFromArray:articleList];
                [weakSelf.tableView reloadData];
            }
        }];
    }];
    
    [self.tableView addFooterRefresh:^{
        if (!weakSelf.hasMore) {
            [weakSelf.tableView endRefreshWithNoMoreData];
            return ;
        }
        [WYArticleAPI listRecommendArticleList:weakSelf.page Block:^(NSArray *articleList, BOOL hasMore) {
            [weakSelf.tableView endFooterRefresh];
            if (articleList) {
                weakSelf.hasMore = hasMore;
                weakSelf.page += 1;
                [weakSelf.articleList addObjectsFromArray:articleList];
                [weakSelf.tableView reloadData];
            }
        }];
    }];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[WYArticleCell class] forCellReuseIdentifier:@"WYArticleCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.articleList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [WYArticleCell heightForCell:self.articleList[indexPath.row]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak WYRecommendArticleVC *weakSelf = self;
    WYArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WYArticleCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WYArticle *article = self.articleList[indexPath.row];
    [cell setUpCellDetail:article];
    cell.mediaClick = ^{
        WYMediaDetailVC *vc = [WYMediaDetailVC new];
        vc.media = article.media;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WYArticle *article = self.articleList[indexPath.row];
    WYArticleDetailVC *vc = [WYArticleDetailVC new];
    vc.article = article;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)mediaListAction{
    WYFollowedMediaVC *vc = [WYFollowedMediaVC new];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
