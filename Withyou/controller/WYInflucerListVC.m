//
//  WYInflucerListVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/7.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYInflucerListVC.h"
#import "WYFollowListCell.h"
#import "WYFollow.h"
#import "WYUserVC.h"


@interface WYInflucerListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *userArr;
@property (nonatomic, strong) NSMutableArray *teamArr;
@property (nonatomic, strong) NSMutableArray *teamStatusArr;
@property (nonatomic, strong) NSMutableArray *userStatusArr;
@end

@implementation WYInflucerListVC

static NSString  *cellIdentifier = @"followCellIdentifier";

-(NSMutableArray *)teamArr{
    if (_teamArr == nil) {
        _teamArr = [NSMutableArray array];
    }
    return _teamArr;
}
-(NSMutableArray *)userArr{
    if (_userArr == nil) {
        _userArr = [NSMutableArray array];
    }
    return _userArr;
}

-(NSMutableArray *)teamStatusArr{
    if (_teamStatusArr == nil) {
        _teamStatusArr = [NSMutableArray array];
    }
    return _teamStatusArr;
}

-(NSMutableArray *)userStatusArr{
    if (_userStatusArr == nil) {
        _userStatusArr = [NSMutableArray array];
    }
    return _userStatusArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我关注的人";
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
    
    NSArray * folArr = [[WYFollow queryAllFollowListToMe] mutableCopy];
    NSArray * infArr = [[WYFollow queryAllFollowListFromMe] mutableCopy];
    
    NSMutableArray *tempArr = [infArr mutableCopy];
    
    /*这个判断是互斥的    0没有关系  1 仅我关注的人 2仅关注我的人 3朋友 4 自己*/
    
    [self.teamArr removeAllObjects];
    [self.teamStatusArr removeAllObjects];
    [self.userArr removeAllObjects];
    [self.userStatusArr removeAllObjects];
    
    for (int i = 0; i < tempArr.count; i ++) {
        WYUser *user = tempArr[i];
        NSInteger i = [WYFollow queryRelationShipWithMeFollowArr:user.uuid infArr:infArr folArr:folArr];
        if (user.type == 2) {
            //团队账户
            [self.teamArr addObject:user];
            [self.teamStatusArr addObject:@(i)];
        }else{
            //个人账户
            [self.userArr addObject:user];
            [self.userStatusArr addObject:@(i)];
        }
    }
    [_tableView reloadData];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.teamArr.count > 0) {
            return 30;
        }else{
            return 0.001;
        }
    }else{
        //要求有对应的类型就显示对应的header 没有就不显示  另外没有团队账户的情况下 任何一个header都不要
        if (self.teamArr.count > 0 && self.userArr.count > 0) {
            return 30;
        }else{
            return 0.001;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return self.teamArr.count > 0 ? @"团队账户":@"";
    }
    //要求有对应的类型就显示对应的header 没有就不显示  另外没有团队账户的情况下 任何一个header都不要
    return self.teamArr.count > 0 && self.userArr.count > 0 ? @"个人账户":@"";
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.teamArr.count;
    }
    return self.userArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WYFollowListCell *cell = (WYFollowListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[WYFollowListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    if (indexPath.section == 0) {
        WYUser *user = [self.teamArr objectAtIndex:indexPath.row];
        [cell setCellData:user relationShip:[self.teamStatusArr[indexPath.row] integerValue]];
    }else{
        WYUser *user = [self.userArr objectAtIndex:indexPath.row];
        [cell setCellData:user relationShip:[self.userStatusArr[indexPath.row] integerValue]];
    }
    return cell;
}


#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WYUser *user = nil;
    if (indexPath.section == 0) {
        user = [self.teamArr objectAtIndex:indexPath.row];
    }else{
        user = [self.userArr objectAtIndex:indexPath.row];
    }
    WYUserVC *vc = [WYUserVC new];
    vc.user = user;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
