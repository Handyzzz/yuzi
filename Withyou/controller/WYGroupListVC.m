//
//  WYGroupListVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/28.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYGroupListVC.h"
#import "WYgroup.h"
#import "WYGroupClasses.h"
#import "WYGroupListHeaderView.h"
#import "WYStarredGroupCell.h"
#import "WYGroupDetailVC.h"
#import "WYGroupsVC.h"
#import "WYGroupCategoryListVC.h"
#import "WYGroupCategoryVC.h"
#import "YZNewGroupVC.h"
#import "WYSearchGroupVC.h"
#import "WYGroupListApi.h"

#define itemWH ((kAppScreenWidth - (15 * 2 + 3 *6))/4.0)
#define HeaderH (itemWH + 42 + 10 + 50)

@interface WYGroupListVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *starredArr;
@property(nonatomic, copy)NSMutableArray *groupClassesArr;

@end

@implementation WYGroupListVC

-(NSMutableArray *)starredArr{
    if (_starredArr == nil) {
        _starredArr = [NSMutableArray array];
    }
    return _starredArr;
}

-(NSMutableArray *)groupClassesArr{
    if (_groupClassesArr == nil) {
        _groupClassesArr = [NSMutableArray array];
    }
    return _groupClassesArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群组";
    [self setUpNaviBar];
    [self setUpTableView];
    [self setUpHeader];
    [self setUpFooterView];
    [self initDataFromCache];
    [self initDataFromNet];
    [self addHeaderRefresh];
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

#pragma groupsDatasourceChanged
//如果退的群是星标群组 将其移除
-(void)quitGroup:(NSNotification *)noti{
    WYGroup *newGroup = [noti.userInfo objectForKey:@"group"];
    for (int i = 0; i < self.starredArr.count; i ++) {
        WYGroup *group = self.starredArr[i];
        if ([group.uuid isEqualToString:newGroup.uuid]) {
            [self.starredArr removeObjectAtIndex:i];
            [self reloadTableViewAndFooter];
            break;
        }
    }
}
//新群组 是星标群组 不过还是可以再判断一下
-(void)newGroupDatasource:(NSNotification*)noti{
    WYGroup *group = [noti.userInfo objectForKey:@"group"];
    if ([group.starred boolValue] == YES) {
        [self.starredArr insertObject:group atIndex:0];
        [self reloadTableViewAndFooter];
    }
}
/*发生改变的群组
 如果这个群组是 可能需要添加到星标群组中 可能需要从星标群组中移除 可能是替换
 */
-(void)updateGroupDatasource:(NSNotification *)noti{
    WYGroup *notiGroup = [noti.userInfo objectForKey:@"group"];
    if ([notiGroup.starred boolValue] == YES) {
        //如果在我的星标群组中替换 如果不在星标群组中添加
        BOOL isInStarredArr = NO;
        for (int i =0; i < self.starredArr.count; i++) {
            WYGroup *group = self.starredArr[i];
            if ([group.uuid isEqualToString:notiGroup.uuid]) {
                isInStarredArr = YES;
                [self.starredArr replaceObjectAtIndex:i withObject:notiGroup];
                [self reloadTableViewAndFooter];
                break;
            }
        }
        if (isInStarredArr == NO) {
            //添加进来
            [self.starredArr insertObject:notiGroup atIndex:0];
            [self reloadTableViewAndFooter];
        }

    }else{
        //如果在我的星标群组中移除 如果不在我的星标群组 内存中是不用处理的
        BOOL isInStarredArr = NO;
        for (int i =0; i < self.starredArr.count; i++) {
            WYGroup *group = self.starredArr[i];
            if ([group.uuid isEqualToString:notiGroup.uuid]) {
                isInStarredArr = YES;
                [self.starredArr removeObjectAtIndex:i];
                [self reloadTableViewAndFooter];
                break;
            }
        }
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)reloadTableViewAndFooter{
    [self.tableView reloadData];
    [self setUpFooterView];
}

-(void)initDataFromCache{
    
    __weak WYGroupListVC *weakSelf = self;
    
    [WYGroupClasses queryAllGroupCategoryWithBlock:^(NSArray *groupCategoryArr) {
        if (groupCategoryArr) {
            [weakSelf.groupClassesArr addObjectsFromArray:groupCategoryArr];
            [weakSelf setUpHeader];
        }
    }];
    
    [WYGroup queryAllStarredGroupsWithBlock:^(NSArray *groupArr) {
        if (groupArr) {
            [weakSelf.starredArr addObjectsFromArray:groupArr];
            [weakSelf reloadTableViewAndFooter];
        }
    }];
}

-(void)initDataFromNet{
    __weak WYGroupListVC *weakSelf = self;
    [WYGroupClasses listRecommentGroupCategory:4 Block:^(NSArray *groupsCateArr, BOOL success) {
        //通知第二个tab刷新头部
        if (groupsCateArr) {
            [weakSelf.groupClassesArr removeAllObjects];
            [weakSelf.groupClassesArr addObjectsFromArray:groupsCateArr];
            [weakSelf setUpHeader];
        }
    }];
    
    [WYGroupListApi requestGroupListWithBlock:^(NSArray *groups) {
        //查库
        [WYGroup queryAllStarredGroupsWithBlock:^(NSArray *groupArr) {
            if (groupArr) {
                [weakSelf.starredArr removeAllObjects];
                [weakSelf.starredArr addObjectsFromArray:groupArr];
                [weakSelf reloadTableViewAndFooter];
            }
        }];
    }];
}

-(void)addHeaderRefresh{
    __weak WYGroupListVC *weakSelf = self;
    [self.tableView addHeaderRefresh:^{
        [WYGroupClasses listRecommentGroupCategory:4 Block:^(NSArray *groupsCateArr, BOOL success) {
            [weakSelf.tableView endHeaderRefresh];
            //通知第二个tab刷新头部
            if (groupsCateArr) {
                [weakSelf.groupClassesArr removeAllObjects];
                [weakSelf.groupClassesArr addObjectsFromArray:groupsCateArr];
                [weakSelf setUpHeader];
            }
        }];
        
        [WYGroupListApi requestGroupListWithBlock:^(NSArray *groups) {
            [WYGroup queryAllStarredGroupsWithBlock:^(NSArray *groupArr) {
                [weakSelf.tableView endHeaderRefresh];
                if (groupArr) {
                    [weakSelf.starredArr removeAllObjects];
                    [weakSelf.starredArr addObjectsFromArray:groupArr];
                    [weakSelf reloadTableViewAndFooter];
                }
            }];
        }];
    }];
}

-(void)setUpNaviBar{
    UIImage *leftImage = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"创建" style:UIBarButtonItemStylePlain target:self action:@selector(newGroupAction)];
    [rightButtonItem setTintColor:kRGB(43, 161, 212)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

-(void)setUpTableView{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

-(void)setUpFooterView{
    
    CGFloat height = 144.f;
    if (self.starredArr.count < 1) {
        height = kAppScreenHeight - 50 - 144;
    }
    
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, height)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    if (self.starredArr.count < 1) {
        //需要占位图
        UIImageView *backIV = [UIImageView new];
        backIV.image = [UIImage imageNamed:@"groupNostarredgroup"];
        [footerView addSubview:backIV];
        [backIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.centerY.equalTo(-(50+34 + (64 - 44) + 50)/2.0);
        }];
        
        UILabel *msgLb = [UILabel new];
        msgLb.text = @"你还没有星标群组哦！";
        msgLb.textColor = kRGB(223, 223, 223);
        msgLb.font = [UIFont systemFontOfSize:12];
        [footerView addSubview:msgLb];
        [msgLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(backIV.mas_bottom).equalTo(12);
        }];
    }
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button setTitle:@"我所在的群组" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"groupMygroup"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"groupMygroupHighlight"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(allMyGroupsAction) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        //如果没有星标群组
        if (self.starredArr.count < 1) {
            make.bottom.equalTo(-34);
        }else{
            make.top.equalTo(34);
        }
        make.height.equalTo(75);
        make.right.equalTo(-15);
    }];
    
    
    self.tableView.tableFooterView = footerView;
}

-(void)setUpHeader{
    __weak WYGroupListVC *weakSelf = self;

    if (self.groupClassesArr.count > 0) {
        WYGroupListHeaderView *headerView = [[WYGroupListHeaderView alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth, HeaderH)];
        headerView.showMoreClick = ^{
            WYGroupCategoryListVC *vc = [WYGroupCategoryListVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        headerView.categoryClick = ^(NSInteger tag) {
            WYGroupClasses *groupClasses = self.groupClassesArr[tag];
            WYGroupCategoryVC *vc = [WYGroupCategoryVC new];
            vc.name = groupClasses.name;
            vc.categoryType  =groupClasses.category;
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        headerView.searchClick = ^{
            WYSearchGroupVC *vc = [WYSearchGroupVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        
        headerView.backgroundColor = [UIColor whiteColor];
        
        [headerView setUpHeaderView:[self.groupClassesArr copy]];
        
        self.tableView.tableHeaderView = headerView;
    }else{
        //只要searchView
        WYGroupListHeaderView *headerView = [[WYGroupListHeaderView alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 50)];
        headerView.searchClick = ^{
            WYSearchGroupVC *vc = [WYSearchGroupVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        [headerView setUpSearchView];
        self.tableView.tableHeaderView = headerView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.starredArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 34)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLb = [UILabel new];
    titleLb.font = [UIFont systemFontOfSize:12];
    titleLb.textColor = kRGB(153, 153, 153);
    titleLb.text = @"星 标 群 组";
    [view addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.left.equalTo(15);
    }];
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYStarredGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[WYStarredGroupCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    WYGroup *group = self.starredArr[indexPath.row];
    [cell.iconIV sd_setImageWithURL:[NSURL URLWithString:group.group_icon]];
    cell.nameLb.text = group.name;
    cell.desLb.text = group.introduction;
    if (group.unread_post_num > 0) {
        cell.unReadLb.text = [NSString stringWithFormat:@"%d条更新",group.unread_post_num];
    }else{
        cell.unReadLb.text = @"";
    }
    [cell lineView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WYGroup *group = self.starredArr[indexPath.row];
    group.unread_post_num = 0;
    //将数据库更新
    [WYGroup insertGroup:group];
    [self.starredArr replaceObjectAtIndex:indexPath.row withObject:group];
    [self.tableView reloadData];
    
    WYGroupDetailVC *vc = [[WYGroupDetailVC alloc] init];
    vc.group = group;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)allMyGroupsAction{
    WYGroupsVC *vc = [WYGroupsVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)newGroupAction{
    __weak WYGroupListVC *weakSelf = self;
    [WYUtility requireSetAccountNameOrAlreadyHasName:^{
        YZNewGroupVC *groupVC = [[YZNewGroupVC alloc] init];
        groupVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:groupVC animated:YES];
    } navigationController:self.navigationController];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
