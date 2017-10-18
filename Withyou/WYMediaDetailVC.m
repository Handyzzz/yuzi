//
//  WYMediaDetailVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/9/27.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYMediaDetailVC.h"
#import "WYArticle.h"
#import "WYArticleCell.h"
#import "WYArticleAPI.h"
#import "WYFollowedMediaVC.h"
#import "WYMediaHeaderView.h"

@interface WYMediaDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray <WYArticle*>*articleList;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)BOOL hasMore;
@end

@implementation WYMediaDetailVC

-(NSMutableArray *)articleList{
    if (_articleList == nil) {
        _articleList = [NSMutableArray array];
    }
    return _articleList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.media.name;
    [self setNaviBar];
    [self tableView];
    [self initData];
}

-(void)setNaviBar{
    UIImage *leftImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:leftImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

-(void)initData{
    _page = 1;
    MJWeakSelf
    [WYArticleAPI listArticleFromMedia:self.media.uuid page:_page callback:^(NSArray *articleList, BOOL hasMore) {
        if (articleList) {
            weakSelf.hasMore = hasMore;
            weakSelf.page += 1;
            [weakSelf.articleList addObjectsFromArray:articleList];
            [weakSelf.tableView reloadData];
        }
    }];
    
    [self.tableView addHeaderRefresh:^{
        [WYArticleAPI listArticleFromMedia:weakSelf.media.uuid page:1 callback:^(NSArray *articleList, BOOL hasMore) {
            [weakSelf.tableView endHeaderRefresh];
            if (articleList) {
                weakSelf.hasMore = hasMore;
                weakSelf.page += 1;
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
        [WYArticleAPI listArticleFromMedia:weakSelf.media.uuid page:weakSelf.page callback:^(NSArray *articleList, BOOL hasMore) {
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
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[WYArticleCell class] forCellReuseIdentifier:@"WYArticleCell"];
        [self.view addSubview:_tableView];
        WYMediaHeaderView *headerView = [[WYMediaHeaderView alloc]initWithFrame:CGRectMake(15, 0, kAppScreenWidth, 0)];
        [headerView setHeaderViewWithMedia:self.media];
        [self.tableView setTableHeaderView:headerView];
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
    WYArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WYArticleCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setUpCellDetail:self.articleList[indexPath.row]];
    return cell;
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
