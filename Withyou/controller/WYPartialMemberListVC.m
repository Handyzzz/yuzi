//
//  WYPartialMemberListVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/13.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYPartialMemberListVC.h"
#import "WYUserVC.h"
#import "WYGroupMemberListCell.h"
#import "WYFollow.h"

@interface WYPartialMemberListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *userArr;
@property (nonatomic, strong)NSMutableArray *folArr;
@property (nonatomic, strong)NSMutableArray *infArr;
@property (nonatomic, strong) NSMutableArray *relationshipArrForResultList;

@end

@implementation WYPartialMemberListVC

-(NSMutableArray *)userArr{
    if (_userArr == nil) {
        _userArr = [NSMutableArray array];
    }
    return _userArr;
}
-(NSMutableArray *)relationshipArrForResultList{
    if (_relationshipArrForResultList == nil) {
        _relationshipArrForResultList = [@[@"",@"我关注了ta",@"ta关注了我",@"好友",@"自己"] mutableCopy];
    }
    return _relationshipArrForResultList;
}
-(void)initData{
    
    _folArr = [[WYFollow queryAllFollowListToMe] mutableCopy];
    _infArr = [[WYFollow queryAllFollowListFromMe] mutableCopy];
    [self.userArr addObjectsFromArray:self.group.partial_member_list];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviItem];
    [self initData];
    [self setUpTableView];
}

-(void)setUpTableView{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[WYGroupMemberListCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}
-(void)setNaviItem{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.userArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYGroupMemberListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    WYUser *user = self.userArr[indexPath.row];
    [cell.iconIV sd_setImageWithURL:[NSURL URLWithString:user.icon_url]];
    NSString *relation = [self calculateRelationLbText:user];
    if (relation.length > 0) {
        cell.nameLb.text = user.fullName;
        cell.TextLb.hidden = YES;
    }else{
        cell.nameLb.hidden = YES;
        cell.TextLb.text = user.fullName;
    }
    cell.relationLb.text = relation;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WYUser *user = self.userArr[indexPath.row];
    WYUserVC *vc = [WYUserVC new];
    vc.user = user;
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSString*)calculateRelationLbText:(WYUser*)user{
    NSInteger i =[WYFollow queryRelationShipWithMeFollowArr:user.uuid infArr:_infArr folArr:_folArr];
    return self.relationshipArrForResultList[i];
}
@end
