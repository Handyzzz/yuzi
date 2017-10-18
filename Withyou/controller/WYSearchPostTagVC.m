
//
//  WYSearchPostTagVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/24.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYSearchPostTagVC.h"
#import "WYPostTagApi.h"
#import "WYRecommendPostTagView.h"
#import "WYPublishTagListSimilarCell.h"
#import "WYTagsResultPostListVC.h"

@interface WYSearchPostTagVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)NSMutableArray *similarArr;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)BOOL isSearch;
@end

@implementation WYSearchPostTagVC

-(NSMutableArray *)similarArr{
    if (_similarArr == nil) {
        _similarArr = [NSMutableArray array];
    }
    return _similarArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNaviItem];
    [self setUpTableView];
}

-(void)setUpNaviItem{
    
    
    CGFloat searchBarHeight = 28;
    CGRect searchFrame = CGRectMake(42, 0, kAppScreenWidth - 100, searchBarHeight);
    UISearchBar *search = [[UISearchBar alloc] initWithFrame:searchFrame];
    search.placeholder = @"输入标签名";
    search.barTintColor = [UIColor whiteColor];
    search.delegate = self;
    search.showsCancelButton = NO;
    [search becomeFirstResponder];
    _searchBar = search;
    self.navigationItem.titleView = _searchBar;
    
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"取消" forState:UIControlStateNormal];
    [rightBtn setTitleColor:kRGB(153, 153, 153) forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)setUpTableView{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[WYPublishTagListSimilarCell class] forCellReuseIdentifier:@"WYPublishTagListSimilarCell"];
    [self.view addSubview:_tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.similarArr.count > 0) {
        return 1;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.similarArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self tagViewWithText:@"相关标签"];
}

-(UIView *)tagViewWithText:(NSString *)text{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 30)];
    UILabel *titleLb = [UILabel new];
    titleLb.font = [UIFont systemFontOfSize:14];
    titleLb.textColor = kRGB(153, 153, 153);
    [view addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(19);
    }];
    titleLb.text = text;
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColorFromHex(0xf5f5f5);
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(1);
        make.left.right.bottom.equalTo(0);
    }];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYPublishTagListSimilarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WYPublishTagListSimilarCell" forIndexPath:indexPath];
    NSDictionary *dic = self.similarArr[indexPath.row];
    NSString *tempStr = [dic objectForKey:@"name"];
    cell.iconIV.image = [UIImage imageNamed:@"post_search_recommend_tag"];
    cell.titleLb.text = tempStr;
    [cell lineView];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.similarArr[indexPath.row];
    NSString *tempStr = [dic objectForKey:@"name"];
    //去往推荐帖子页
    WYTagsResultPostListVC *vc = [WYTagsResultPostListVC new];
    vc.tagStr = tempStr;
    [self.searchBar resignFirstResponder];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark searchBar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    __weak WYSearchPostTagVC *weakSelf = self;
    if (searchText.length >=2) {
        [WYPostTagApi recommendPostTagOnSearch:searchText Block:^(NSArray *recommendStrArr) {
            weakSelf.isSearch = YES;
            //写空是无用的
            weakSelf.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 0.1f)];
            [weakSelf.similarArr removeAllObjects];
            if (recommendStrArr) {
                [weakSelf.similarArr addObjectsFromArray:recommendStrArr];
            }
            [weakSelf.tableView reloadData];

        }];
    }else{
        [weakSelf.similarArr removeAllObjects];
        [weakSelf.tableView reloadData];
    }
}

-(void)cancelAction{
    [_searchBar resignFirstResponder];
    [self.similarArr removeAllObjects];
    [self.tableView reloadData];
}

-(void)backAction{
    [_searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
