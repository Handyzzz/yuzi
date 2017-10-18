
//
//  WYArticleCommentStarVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/9/30.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYArticleCommentStarVC.h"
#import "WYArticleStarCell.h"
#import "WYArticleAPI.h"
@interface WYArticleCommentStarVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *starList;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)BOOL hasMore;
@end

@implementation WYArticleCommentStarVC

-(NSMutableArray *)starList{
    if (_starList == nil) {
        _starList = [NSMutableArray array];
    }
    return _starList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self setUpUI];
    [self initData];
}

-(void)initData{
    if (self.tempList) {
        [self.starList addObjectsFromArray:self.tempList];
        [self.tableView reloadData];
    }
    
    //加载更多
    _page = 1;
    MJWeakSelf;
    [WYArticleAPI listStarListWithArticle:self.article.uuid page:1 callback:^(NSArray *starList, BOOL hasMore) {
        if (starList) {
            weakSelf.page += 1;
            weakSelf.hasMore = hasMore;
            [weakSelf.starList removeAllObjects];
            [weakSelf.starList addObjectsFromArray:starList];
            [weakSelf.tableView reloadData];
        }
    }];
    
    [self.tableView addFooterRefresh:^{
        if (!weakSelf.hasMore) {
            [weakSelf.tableView endRefreshWithNoMoreData];
            return ;
        }
        [WYArticleAPI listStarListWithArticle:weakSelf.article.uuid page:weakSelf.page callback:^(NSArray *starList, BOOL hasMore) {
            [weakSelf.tableView endFooterRefresh];
            if (starList) {
                weakSelf.page += 1;
                weakSelf.hasMore = hasMore;
                [weakSelf.starList addObjectsFromArray:starList];
                [weakSelf.tableView reloadData];
            }
        }];
        
    }];
    
}

-(void)setNavigationBar{
    self.title = @"星标列表";
    
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

-(void)setUpUI{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.sectionIndexColor = [UIColor blueColor];
    _tableView.sectionIndexTrackingBackgroundColor = UIColorFromHex(0xf5f5f5);
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.starList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYArticleStarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[WYArticleStarCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    WYUser *user = self.starList[indexPath.row];
    [cell.iconIV sd_setImageWithURL:[NSURL URLWithString:user.icon_url]];
    cell.nameLb.text = user.fullName;
    [cell lineView];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
