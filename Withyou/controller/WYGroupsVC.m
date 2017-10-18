//
//  WYGroupsVC.m
//  Withyou
//
//  Created by Tong Lu on 2017/3/4.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYGroupsVC.h"
#import "YZNewGroupVC.h"
#import "WYGroup.h"
#import "WYGroupListApi.h"
#import "WYStarredGroupCell.h"
#import "WYGroupDetailVC.h"
#import "YZSearchBar.h"
#import "WYSearchGroupVC.h"

static NSString *cellIdentifier = @"groupCellIdentifier";
#define searchBarHeight 30

@interface WYGroupsVC ()<UISearchBarDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_groups;
}

@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *searchArray;
@end

@implementation WYGroupsVC
/*
 新建群组 只用通知 groups VC 所以和群组资料改变可以用一个通知 
 只需要在这个通知的 noti.object 的发出者是不是WYNewGroupVC
 */


//获取本地数据库的群组
- (void)reloadLocalGroups
{
    //用户登录时，会一次性拉取所有的朋友列表，但是只请求一次
    //要是用户中途添加了朋友，或者被添加了，那就通过推送获得新的朋友信息
    //    或者是通过某个接口，在某种条件下触发请求
    //只从本地拉取不是通过关注关系产生的群组
//    [WYGroup queryAllMultiplePersonGroupsWithBlock:^(NSArray *groups) {
    [WYGroup queryAllGroupsWithBlock:^(NSArray *groups) {
        if (groups) {
            _groups = [groups mutableCopy];
            [_tableView reloadData];
        }
    }];
}

//请求如果有新的群组 就更新reloadLocalGroups
- (void)requestForNewGroups{
    [WYGroupListApi requestGroupListWithBlock:^(NSArray *groups) {
        //第一次会拉去所有的群组 后边会拉去变更的群组
        //这里的group只要新添加的Group 就会有在内部做了本地保存 然后从本地拿groups就可以了
        [self  reloadLocalGroups];
        [_tableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviTitle];
    _groups = [NSMutableArray new];
    [self setupUI];
    [self setupSearchView];
    [self createTableView];
    [self createNavigationView];
    //进入后先本地数据库拿数据
    [self reloadLocalGroups];
    //如果有新的群组就把新的加进来
    [self requestForNewGroups];
    
    //add refresh
    [self addPullRefresh];
    
    [self resignNoti];
}

-(void)resignNoti{
    //新建群组
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newGroupDatasource:) name:kNewGroupDataSource object:nil];
    //群组改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGroupDatasource:) name:kUpdateGroupDataSource object:nil];
    //退出群组
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitGroup:) name:kQuitGroup object:nil];
}

- (void)onPullToRefresh {
    [self requestForNewGroups];
    [_tableView.mj_header endRefreshing];

}
- (void)addPullRefresh
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(onPullToRefresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    //    [header setTitle:@"" forState:MJRefreshStateIdle];
    //    [header setTitle:@"" forState:MJRefreshStatePulling];
    _tableView.mj_header = header;
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(onLoadMore)];
    
    _tableView.mj_footer.hidden = YES;
}


#pragma groupsDatasourceChanged
-(void)quitGroup:(NSNotification *)noti{
    WYGroup *newGroup = [noti.userInfo objectForKey:@"group"];
    for (int i = 0; i < _groups.count; i ++) {
        WYGroup *group = _groups[i];
        if ([group.uuid isEqualToString:newGroup.uuid]) {
            [_groups removeObjectAtIndex:i];
            break;
        }
    }
    [_tableView reloadData];
}
-(void)newGroupDatasource:(NSNotification*)noti{
    WYGroup *newGroup = [noti.userInfo objectForKey:@"group"];
     [_groups insertObject:newGroup atIndex:0];
    [_tableView reloadData];
}
-(void)updateGroupDatasource:(NSNotification *)noti{
    WYGroup *newGroup = [noti.userInfo objectForKey:@"group"];
    //将新的group更新到对应的位置
    for (int i =0; i < _groups.count; i++) {
        WYGroup *group = _groups[i];
        if ([group.uuid isEqualToString:newGroup.uuid]) {
            [_groups replaceObjectAtIndex:i withObject:newGroup];
        }
    }

    [_tableView reloadData];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNewGroupDataSource object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpdateGroupDataSource object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kQuitGroup object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)setupSearchView {
    
    self.searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth, searchBarHeight + 20)];
    self.searchView.backgroundColor = [UIColor whiteColor];
   
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 10, kAppScreenWidth, searchBarHeight)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"查找我的群组";
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.backgroundImage = [[UIImage alloc] init];
    _searchBar.barTintColor = [UIColor clearColor];
    
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    searchField.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:0.66];
    
    [self.searchView addSubview:_searchBar];
}


- (void)createNavigationView{
    //如果是在导航栏的第一层 吐过导航栏后边再有vc的话 这个方法已经过去了
    if (self.navigationController.viewControllers.count > 1) {
        UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        self.navigationItem.leftBarButtonItem = leftBtnItem;

    }
}
- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[WYStarredGroupCell class] forCellReuseIdentifier:@"WYStarredGroupCell"];
    [self.view addSubview:_tableView];
}

-(void)setNaviTitle{
    if (self.navigationController.viewControllers.count > 1) {
        self.title = @"我的群组";
    }else{
        self.title = @"群组";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _groups.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.searchView.frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WYStarredGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WYStarredGroupCell" forIndexPath:indexPath];
    WYGroup *group = _groups[indexPath.row];
    [cell.iconIV sd_setImageWithURL:[NSURL URLWithString:group.group_icon]];
    cell.nameLb.text = group.groupName;
    cell.desLb.text = group.introduction;
    if (group.unread_post_num > 0) {
        cell.unReadLb.text = [NSString stringWithFormat:@"%d条更新",group.unread_post_num];
    }else{
        cell.unReadLb.text = @"";
    }
    [cell lineView];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.searchView;                   
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WYGroup *group = _groups[indexPath.row];
    group.unread_post_num = 0;
    
    WYGroupDetailVC *vc = [[WYGroupDetailVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.group = group;
    //将数据库更新
    [WYGroup insertGroup:group];
    [_groups replaceObjectAtIndex:indexPath.row withObject:group];
    [_tableView reloadData];

    [self.navigationController pushViewController:vc animated:YES];

}


#pragma mark- UISearchBarDelagete

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    // 先缓存所有数据
    if(self.searchArray == nil) {
        self.searchArray = [NSArray arrayWithArray:_groups];
    }
    // 清空数据源
    [_groups removeAllObjects];
    // 都转为小写 去匹配大小写
    NSString *lowerText = [_searchBar.text lowercaseString];
    NSString *text = [lowerText chChangePin];
    
    if(text.length > 0) {
        NSMutableArray *tmp = [NSMutableArray array];
        // 遍历缓存的所有数据
        for (WYGroup *group in self.searchArray) {
            
            if([[[group.name lowercaseString] chChangePin] containsString:text]) {
                [tmp addObject:group];
            }
        }
        [_groups addObjectsFromArray:tmp];
    }else {
        // 从缓存中恢复所有数据
        [_groups addObjectsFromArray:self.searchArray];
        self.searchArray = nil;
    }
    [_tableView reloadData];

}


-(void)backAction{
    //返回按钮也要隐藏掉
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

@end
