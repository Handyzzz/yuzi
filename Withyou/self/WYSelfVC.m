//
//  WYSelfVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/10/9.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYSelfVC.h"
#import "WYSelfSettingsVC.h"
#import "WYDisCoversCell.h"
#import "WYSelfFriendListsVC.h"
#import "WYUserVC.h"

@interface WYSelfVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,copy)NSArray *dataSource;
@end

@implementation WYSelfVC

#define imgkey @"imageName"
#define titlekey @"titleName"
#define actionkey @"actionName"

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我";
    [self setNaviItem];
    [self initData];
    [self setUpTableView];
}

-(void)setNaviItem{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}


-(void)initData{
    _dataSource = @[
                    @{imgkey:@"descover_self_friendslist",
                      titlekey:@"好友列表",
                      actionkey:@"friendsListAction"
                      },
                    @{imgkey:@"descover_self_space",
                      titlekey:@"个人主页",
                      actionkey:@"mySelfAction"
                      },
                    @{imgkey:@"descover_self_setting",
                      titlekey:@"设置",
                      actionkey:@"selfSetting"
                      },
                    ];
}

-(void)setUpTableView{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[WYDisCoversCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 12.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 12)];
    view.backgroundColor = UIColorFromHex(0xf5f5f5);
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 12)];
    view.backgroundColor = UIColorFromHex(0xf5f5f5);
    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYDisCoversCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *dic = _dataSource[indexPath.row];
    cell.iconIV.image = [UIImage imageNamed:[dic objectForKey:imgkey]];
    cell.titleLb.text = [dic objectForKey:titlekey];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = _dataSource[indexPath.row];
    NSString *action = [dic objectForKey:actionkey];
    if ([self respondsToSelector:NSSelectorFromString(action)]) {
        [self performSelector:NSSelectorFromString(action)];
    }
}

//我
- (void)mySelfAction{
    WYUserVC *vc = [[WYUserVC alloc] init];
    vc.user = kLocalSelf;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//设置
-(void)selfSetting{
    WYSelfSettingsVC *vc = [WYSelfSettingsVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//我的好友列表
-(void)friendsListAction{
    WYSelfFriendListsVC *vc = [WYSelfFriendListsVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
