//
//  WYAcceptInviteVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/27.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYAcceptInviteVC.h"
#import "WYWrongAcceptInviteView.h"
#import "WYGroupDetailVC.h"
#import "WYUserVC.h"
#import "WYBasicGroupHeaderView.h"
#import "WYAcceptInviteCell.h"
#import "WYPartialMemberListVC.h"
@interface WYAcceptInviteVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)WYGroupInvitation *groupInvitation;
@property(nonatomic, strong)UITableView *tableView;
@end

@implementation WYAcceptInviteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"群组邀请";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNaviBar];
    [self initData];
}

-(void)setNaviBar{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;

}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initData{
    __weak WYAcceptInviteVC *weakSelf = self;
    [self.view showHUDNoHide];
    [WYGroupInvitation retrieveGroupInvitation:self.targetUuid Block:^(WYGroupInvitation *groupInvitation, BOOL isExpired, BOOL inGroup, long status) {
        [self.view hideAllHUD];
        if (groupInvitation) {
            weakSelf.groupInvitation = groupInvitation;
            
            if (inGroup) {
                //你已是群成员
                [weakSelf setUpWrongView:WYWrongViewHaveInGroup];
            }else{
                if (groupInvitation.accepted == YES) {
                    if ([groupInvitation.group.public_visible intValue] == 1) {
                        //给出申请入群的入口
                        [weakSelf setUpWrongView:WYWrongViewLoseToApply];
                        
                    }else{
                        //给出该邀请已过期 并给出联系 谁的入口
                        [weakSelf setUpWrongView:WYWrongViewLoseToConnection];
                    }
                }else{
                    //该邀请是否已经过期
                    if (isExpired) {
                        //该群组是公开群 还是私密群
                        if ([groupInvitation.group.public_visible intValue] == 1) {
                            //给出申请入群的入口
                            [weakSelf setUpWrongView:WYWrongViewLoseToApply];
                            
                        }else{
                            //给出该邀请已过期 并给出联系 谁的入口
                            [weakSelf setUpWrongView:WYWrongViewLoseToConnection];
                        }
                    }else{
                        //展示邀请详情页
                        [weakSelf setUpUI];
                    }
                }
            }
            
        }else{
            [OMGToast showWithText:@"网络不畅"];
        }
    }];
}


-(void)setUpUI{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:_tableView];
    [self setUpHeader];
    [self setUpFooterView];
}

-(void)setUpHeader{
    CGFloat height = [WYBasicGroupHeaderView calculateHeaderHeight:self.groupInvitation.group];
     WYBasicGroupHeaderView *headerView = [[WYBasicGroupHeaderView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, height)];
    __weak WYAcceptInviteVC *weakSelf = self;
    headerView.memberViewClick = ^{
        WYPartialMemberListVC *vc = [WYPartialMemberListVC new];
        vc.group = self.groupInvitation.group;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [headerView setUpView:self.groupInvitation.group];
    self.tableView.tableHeaderView = headerView;
}

-(void)setUpFooterView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 153)];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 8)];
    lineView.backgroundColor = UIColorFromHex(0xf5f5f5);
    [view addSubview:lineView];
    
    UIButton *buttonDone = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonDone.frame = CGRectMake(0, 53, kAppScreenWidth, 50);
    [view addSubview:buttonDone];
    buttonDone.backgroundColor = UIColorFromHex(0x2BA1D4);
    [buttonDone setTitle:@"接受邀请" forState:UIControlStateNormal];
    buttonDone.titleLabel.font = [UIFont systemFontOfSize:15];
    [buttonDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonDone addTarget:self action:@selector(buttonDoneClick) forControlEvents:UIControlEventTouchUpInside];

    UIButton *buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonCancel.backgroundColor = [UIColor whiteColor];
    [view addSubview:buttonCancel];
    [buttonCancel setTitle:@"稍后决定" forState:UIControlStateNormal];
    buttonCancel.titleLabel.font = [UIFont systemFontOfSize:15];
    [buttonCancel setTitleColor:kRGB(197, 197, 197) forState:UIControlStateNormal];
    buttonCancel.frame = CGRectMake(0, 103, kAppScreenWidth, 53);
    [buttonCancel addTarget:self action:@selector(buttonCancelClick) forControlEvents:UIControlEventTouchUpInside];

    self.tableView.tableFooterView = view;
}

#pragma buttonClick
-(void)buttonDoneClick{
    //发送请求
    __weak WYAcceptInviteVC *weakSelf = self;
    [self.tableView showHUDDelayHide];
    [WYGroupInvitation submitAcceptInvitation:self.groupInvitation.uuid Block:^(WYGroup *group, long status) {
        [weakSelf.tableView hideAllHUD];

        if (status == 200) {
            weakSelf.tableView.tableFooterView = [UIView new];
            
            WYGroupDetailVC *vc = [WYGroupDetailVC new];
            vc.group = group;
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else if (status == 203){
            
        }else if (status == 204){
            
        }else if (status == 412){
            
        }else{
            [WYWYNetworkStatus showWrongText:status];
        }
    }];
}

-(void)buttonCancelClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUpWrongView:(WYInviteType )type{
    
    __weak WYAcceptInviteVC *weakSelf = self;
    WYWrongAcceptInviteView *wrongView = [[WYWrongAcceptInviteView alloc]initWithFrame:CGRectMake(0, 64, kAppScreenWidth, kAppScreenHeight - kStatusAndBarHeight)];
    [wrongView setUpView:type groupInvitation:self.groupInvitation];
    
    debugLog(@"****%lu",type);
    
    wrongView.actionLbClick = ^(WYInviteType type) {
        switch (type) {
            case WYWrongViewHaveInGroup:
            {
                WYGroupDetailVC *vc = [WYGroupDetailVC new];
                vc.group = weakSelf.groupInvitation.group;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
                break;
            case WYWrongViewHaveAccept:
            {
                WYGroupDetailVC *vc = [WYGroupDetailVC new];
                vc.group = weakSelf.groupInvitation.group;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
                break;
            case WYWrongViewLoseToApply:
            {
                //先跳转到群组页 然后进行申请入群
                WYGroupDetailVC *vc = [WYGroupDetailVC new];
                vc.group = weakSelf.groupInvitation.group;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
                break;
            case WYWrongViewLoseToConnection:
            {
                WYUserVC *vc = [WYUserVC new];
                vc.user = weakSelf.groupInvitation.from_user;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
    };
    [self.view addSubview:wrongView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 44;
    }else{
        return 72;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    WYAcceptInviteCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
    
    //最后一个分区
    if (indexPath.row == 0) {
        if (cell1 == nil) {
            cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.textLabel.text = @"邀请人";
        cell1.textLabel.font = [UIFont systemFontOfSize:14];
        cell1.textLabel.textColor = kRGB(153, 153, 153);
    
        UIView *lineView = [cell1.contentView viewWithTag:501];
        if (lineView == nil) {
            lineView = [UIView new];
            lineView.tag = 501;
            [cell1.contentView addSubview:lineView];
            lineView.backgroundColor = kRGB(43, 161, 212);
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(7);
                make.top.equalTo(14);
                make.width.equalTo(2);
                make.height.equalTo(14);
            }];
        }
        
        UIView *line = [cell1.contentView viewWithTag:502];
        if (line == nil) {
            line = [UIView new];
            line.tag = 502;
            line.backgroundColor = UIColorFromHex(0xf5f5f5);
            [cell1.contentView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(15);
                make.bottom.equalTo(0);
                make.width.equalTo(kAppScreenWidth - 15);
                make.height.equalTo(1);
            }];
        }
        return cell1;
    }
    if (cell2 == nil) {
        cell2 = [[WYAcceptInviteCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell2"];
    }
    
    [cell2.iconIV sd_setImageWithURL:[NSURL URLWithString:self.groupInvitation.from_user.icon_url]];
    cell2.nameLb.text = self.groupInvitation.from_user.fullName;
    cell2.accountNameLb.text = self.groupInvitation.from_user.account_name;
    cell2.timeLb.text = [NSString stringWithCreatedAt:self.groupInvitation.created_at_float];
    return cell2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        WYUserVC *vc = [WYUserVC new];
        vc.user = self.groupInvitation.from_user;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
