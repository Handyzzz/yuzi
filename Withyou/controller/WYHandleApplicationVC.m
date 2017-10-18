//
//  WYHandleApplicationVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/28.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYHandleApplicationVC.h"
#import "WYGroupApplication.h"
#import "WYGroupDetailVC.h"
#import "WYUserVC.h"
#import "WYHandleApplicationView.h"
#import "WYGroupInviterCell.h"
#import "WYTipTypeOne.h"

@interface WYHandleApplicationVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)WYGroupApplication *groupApplication;
@property(nonatomic, strong)UIButton *acceptBtn;
@property(nonatomic, strong)UIButton *refusedBtn;
@property(nonatomic, strong)UIButton *cancelBtn;
@end

@implementation WYHandleApplicationVC

-(void)initData{
    __weak WYHandleApplicationVC *weakSelf = self;
    [self.view showHUDNoHide];
    [WYGroupApplication retrieveGroupApplication:self.targetUuid Block:^(WYGroupApplication *groupApplication,NSInteger status) {
        [weakSelf.view hideAllHUD];
        
        if (groupApplication) {
            weakSelf.groupApplication = groupApplication;
            [weakSelf setUpTableView];
            [weakSelf setUpHeaderView];
            [weakSelf.tableView reloadData];
        }else if (status == 404){
            [weakSelf setUpHeaderView];
        }else{
            [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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

-(void)setUpTableView{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

-(void)setUpHeaderView{
   
    if (self.groupApplication) {
        if (self.groupApplication.calculated_expired) {
            //该申请已失效
            WYHandleApplicationView *headView = [[WYHandleApplicationView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 90)];
            [headView setUpView:WYWrongViewApplicationHaveExpired];
            self.tableView.tableHeaderView = headView;
            self.tableView.tableFooterView = [UIView new];
        }else{
            if (self.groupApplication.refused) {
                //你已经拒绝该申请
                WYHandleApplicationView *headView = [[WYHandleApplicationView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 90)];
                [headView setUpView:WYWrongViewApplicationHaveRefused];
                self.tableView.tableHeaderView = headView;
                self.tableView.tableFooterView = [UIView new];
            }else{
                if (self.groupApplication.accepted) {
                    //你已经接受该申请
                    WYHandleApplicationView *headView = [[WYHandleApplicationView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 90)];
                    [headView setUpView:WYWrongViewApplicationHaveAccept];
                    self.tableView.tableHeaderView = headView;
                    self.tableView.tableFooterView = [UIView new];
                }else{
                    //展示tableFooterView
                    [self setUpTableFooterView];
                }
            }
        }

    }else{
        //请确认此群组是否存在，并且自己是管理员
        WYHandleApplicationView *headView = [[WYHandleApplicationView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, kAppScreenHeight - kStatusHeight)];
        [headView setUpView:WYWrongViewApplicationMeNotInGroup];
        [self.view addSubview:headView];
    }
}




-(void)setUpTableFooterView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 203)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 8)];
    lineView.backgroundColor = kRGB(245, 245, 245);
    [view addSubview:lineView];
    
    _acceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _acceptBtn.frame = CGRectMake(0, 53, kAppScreenWidth, 50);
    _acceptBtn.backgroundColor = UIColorFromHex(0x2BA1D4);
    [_acceptBtn setTitle:@"接受申请" forState:UIControlStateNormal];
    _acceptBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_acceptBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_acceptBtn addTarget:self action:@selector(acceptApplication) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_acceptBtn];
    
    _refusedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _refusedBtn.frame = CGRectMake(0, 53 + 50, kAppScreenWidth, 50);
    [_refusedBtn setTitle:@"拒绝申请" forState:UIControlStateNormal];
    _refusedBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_refusedBtn setTitleColor:kRGB(51, 51, 51) forState:UIControlStateNormal];

    [_refusedBtn addTarget:self action:@selector(refusedApplication) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_refusedBtn];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake(0, 53 + 100, kAppScreenWidth, 50);
    [_cancelBtn setTitle:@"稍后决定" forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_cancelBtn setTitleColor:kRGB(197, 197, 197) forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelApplicaton) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_cancelBtn];
    
    self.tableView.tableFooterView = view;
}
//接受群组申请
-(void)acceptApplication{
    __weak WYHandleApplicationVC *weakSelf = self;
    _acceptBtn.enabled = NO;
    _refusedBtn.enabled = NO;
    [WYGroupApplication acceptGroupApplication:self.groupApplication.uuid Block:^(BOOL success){
        _acceptBtn.enabled = YES;
        _refusedBtn.enabled = YES;
        if (success) {
            NSString *s = [NSString stringWithFormat:@"%@已经加入群组%@",weakSelf.groupApplication.applicant_user.fullName,weakSelf.groupApplication.group_name];
            [WYTipTypeOne showWithMsg:s imageWith:@"groupapplicationAgree"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [OMGToast showWithText:@"网络不给力,请检查网络设置！"];
        }
    }];
}
//拒绝群组申请
-(void)refusedApplication{
    __weak WYHandleApplicationVC *weakSelf = self;
    NSString *s = [NSString stringWithFormat:@"确定要拒绝%@加入群组%@",weakSelf.groupApplication.applicant_user.fullName,weakSelf.groupApplication.group_name];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:s preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionDone = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _acceptBtn.enabled = NO;
        _refusedBtn.enabled = NO;
        [WYGroupApplication refuseGroupApplication:self.groupApplication.uuid Block:^(BOOL success){
            _acceptBtn.enabled = YES;
            _refusedBtn.enabled = YES;
            if (success) {
                NSString *s = [NSString stringWithFormat:@"你已拒绝%@加入群组%@",weakSelf.groupApplication.applicant_user.fullName,weakSelf.groupApplication.group_name];
                [WYTipTypeOne showWithMsg:s imageWith:@"groupapplicationDisagree_28"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [OMGToast showWithText:@"网络不给力,请检查网络设置！"];
            }
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:actionDone];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
//稍后决定
-(void)cancelApplicaton{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 45;
    }else{
        return 90;
    }
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell1 = [tableView cellForRowAtIndexPath:indexPath];
    WYGroupInviterCell *cell2 = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        if (cell1 == nil) {
            cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
        }
        cell1.textLabel.text = [NSString stringWithFormat:@"来自%@群组的申请",self.groupApplication.group_name];
        cell1.textLabel.font = [UIFont systemFontOfSize:14];
        cell1.textLabel.textColor = kRGB(51, 51, 51);
        
        cell1.detailTextLabel.text = [NSString stringWithCreatedAt:self.groupApplication.created_at_float];
        cell1.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell1.detailTextLabel.textColor = kRGB(153, 153, 153);
        
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self addLine:cell1 :indexPath];
        return cell1;
    }
    if (cell2 == nil) {
        cell2 = [[WYGroupInviterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
    }
    [cell2.iconIV sd_setImageWithURL:[NSURL URLWithString:self.groupApplication.applicant_user.icon_url]];
    cell2.nameLb.text = self.groupApplication.applicant_user.fullName;
    cell2.accountNameLb.text = self.groupApplication.applicant_user.account_name;
    cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self addLine:cell2 :indexPath];

    return cell2;
}

-(void)addLine:(UITableViewCell*)cell :(NSIndexPath*)indexPath{
    UIView *line = [cell.contentView viewWithTag:999];
    if (line == nil) {
        line = [UIView new];
        line.tag = 999;
        line.backgroundColor = UIColorFromHex(0xf5f5f5);
        [cell.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.bottom.equalTo(0);
            make.width.equalTo(kAppScreenWidth - 15);
            make.height.equalTo(1);
        }];
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        WYGroupDetailVC *vc = [WYGroupDetailVC new];
        vc.groupUuid = self.groupApplication.group_uuid;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        WYUserVC *vc = [WYUserVC new];
        vc.userUuid = self.groupApplication.applicant_user.uuid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
