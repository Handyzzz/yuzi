//
//  WYrecommendGroupVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/4/12.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYSearchGroupVC.h"
#import "WYGroup.h"
#import "WYGroupListApi.h"
#import "YZGroupListTableViewCell.h"
#import "YZSearchBar.h"
#import "WYGroupDetailVC.h"

@interface WYSearchGroupVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *groupsArr;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, weak) YZSearchBar *searchBar;
@end
#define searchBarHeight 30

@implementation WYSearchGroupVC

-(NSMutableArray *)groupsArr{
    if (_groupsArr == nil) {
        _groupsArr = [NSMutableArray array];
    }
    return _groupsArr;
}

-(void)initData{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索群组";
    [self setNaviItem];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSearchView];
    [self setUpTableView];
}

-(void)setNaviItem{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

- (void)setupSearchView {
    
    self.searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth, searchBarHeight + 20)];
    self.searchView.backgroundColor = [UIColor whiteColor];
    
    YZSearchBar *searchBar = [[YZSearchBar alloc] initWithFrame:CGRectMake(10, 10, kAppScreenWidth - 20, searchBarHeight)];
    searchBar.placeholder = @"搜索公开群组";
    searchBar.backgroundColor = UIColorFromHex(0xf5f5f5);
    [searchBar addTarget:self action:@selector(onSearchBarReturenKeyClick:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [searchBar becomeFirstResponder];
    [self.searchView addSubview:searchBar];
    self.searchBar = searchBar;
}

-(void)setUpTableView{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groupsArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.searchView.frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.searchView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YZGroupListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[YZGroupListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    WYGroup *group = self.groupsArr[indexPath.row];
    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:group.group_icon]];
    cell.myTextLabel.text = group.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WYGroupDetailVC *vc = [WYGroupDetailVC new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.group = self.groupsArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onSearchBarReturenKeyClick:(UITextField *)textField {
    //刷新数据
    //后端暂时限制 最少两个字
    if (self.searchBar.text.length <= 1) {
        [OMGToast showWithText:@"关键字至少为两个"];
        return;
    }
    
        [textField resignFirstResponder];
        [self.view showHUDNoHide];
        __weak WYSearchGroupVC *weakSelf = self;
        [WYGroupListApi listSearchGroups:self.searchBar.text time:@(0) Block:^(NSArray *groupArr, BOOL success) {
            [weakSelf.view hideAllHUD];
            if (success) {
                if (groupArr.count > 0) {
                    [self.groupsArr removeAllObjects];
                    [self.groupsArr addObjectsFromArray:groupArr];
                    [weakSelf.tableView reloadData];
                }else{
                    [OMGToast showWithText:@"暂未搜索到结果!"];
                }
            }else{
                [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
            }
        }];
        //这个add footRefresh 实际上是替换的
        [self.tableView addFooterRefresh:^{
            NSNumber *t;
            if (weakSelf.groupsArr.count > 0) {
                WYGroup *group = weakSelf.groupsArr.lastObject;
               t = group.created_at_float;
            }else{
                return ;
            }
           [WYGroupListApi listSearchGroups:weakSelf.searchBar.text time:t Block:^(NSArray *groupArr, BOOL success) {
               if (success) {
                   if (groupArr.count > 0) {
                       [weakSelf.groupsArr addObjectsFromArray:groupArr];
                       [weakSelf.tableView reloadData];
                   }
               }else{
                   [OMGToast showWithText:@"暂未搜索到群组!"];
               }
               [weakSelf.tableView endFooterRefresh];
           }];
        }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma Navi actions
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
