//
//  WYFollowerListVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/7.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYFollowerListVC.h"
#import "WYFollowListCell.h"
#import "WYFollow.h"
#import "WYUserVC.h"

@interface WYFollowerListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray *userArr;
@property (nonatomic, strong)NSMutableArray *statusArr;
@end
@implementation WYFollowerListVC


static NSString  *cellIdentifier = @"followCellIdentifier";

-(NSMutableArray *)userArr{
    if (_userArr == nil) {
        _userArr = [NSMutableArray array];
    }
    return _userArr;
}

-(NSMutableArray *)statusArr{
    if (_statusArr == nil) {
        _statusArr = [NSMutableArray array];
    }
    return _statusArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //我关注的人
    self.title = @"我的关注者";
    [self setNavigationBar];
    [self setUpTableView];
    [self loadUser];
    [self loadNewData];
    
}


-(void)setUpTableView{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

-(void)setNavigationBar{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
}

- (void)loadNewData
{
    //这个方法会请求follow 并将follow中的user列表保存到数据库中
    [WYFollow listFollowBlock:^(NSArray *followList, NSArray *userList, NSArray *uuidList) {
        if (followList.count > 0) {
            [self loadUser];
        }
    }];
}

-(void)loadUser{
    
    [self.userArr removeAllObjects];
    
    NSArray * folArr = [[WYFollow queryAllFollowListToMe] mutableCopy];
    NSArray * infArr = [[WYFollow queryAllFollowListFromMe] mutableCopy];
    
    _userArr = [folArr mutableCopy];
    
    //将所有关系查出来 放到数据中
    /*这个判断是互斥的    0没有关系  1 仅我关注的人 2仅关注我的人 3朋友 4 自己*/
    for (int i = 0; i < _userArr.count; i ++) {
        WYUser *user = _userArr[i];
        NSInteger i = [WYFollow queryRelationShipWithMeFollowArr:user.uuid infArr:infArr folArr:folArr];
        [self.statusArr addObject:@(i)];
    }
    [_tableView reloadData];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _userArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WYFollowListCell *cell = (WYFollowListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[WYFollowListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    WYUser *user = [_userArr objectAtIndex:indexPath.row];
    [cell setCellData:user relationShip:[self.statusArr[indexPath.row] integerValue]];
    return cell;
}


#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WYUser *user = [_userArr objectAtIndex:indexPath.row];
    WYUserVC *vc = [WYUserVC new];
    vc.user = user;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
