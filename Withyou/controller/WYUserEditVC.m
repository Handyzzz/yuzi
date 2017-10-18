//
//  WYUserEditVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/3.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYUserEditVC.h"
#import "WYUserEditNormalCell.h"
#import "WYUserDetail.h"
#import "WYUserDetailApi.h"

@interface WYUserEditVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@end

@implementation WYUserEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self setUpNaviTitle];
}


-(void)setUpUI{
    _tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableview.backgroundColor = [UIColor whiteColor];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableview];
    [self setUpNaviTitle];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self.key isEqualToString:@"account_name"]) {
        return 50;
    }
    return 0.001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    if (![self.key isEqualToString:@"account_name"]) {
        return nil;
    }
    UIView *view = [UIView new];
    UILabel *label1 = [UILabel new];
    [view addSubview:label1];
    label1.textColor = UIColorFromHex(0xc5c5c5);
    label1.font = [UIFont systemFontOfSize:12];
    label1.text = @"允许字母、数字、下划线和点号，不少于4位！";
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(25);
        make.top.equalTo(8);
    }];
    
    UILabel *label2 = [UILabel new];
    [view addSubview:label2];
    label2.textColor = UIColorFromHex(0xc5c5c5);
    label2.font = [UIFont systemFontOfSize:12];
    label2.text = @"一个月内只能修改一次用户名";
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(25);
        make.top.equalTo(label1.mas_bottom).equalTo(8);
    }];

    
    UIView *pointView1 = [UIView new];
    pointView1.layer.cornerRadius = 2.5;
    pointView1.clipsToBounds = YES;
    pointView1.backgroundColor = UIColorFromHex(0xc5c5c5);
    [view addSubview:pointView1];
    [pointView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label1);
        make.left.equalTo(10);
        make.width.height.equalTo(5);
    }];

    UIView *pointView2 = [UIView new];
    pointView2.layer.cornerRadius = 2.5;
    pointView2.clipsToBounds = YES;
    pointView2.backgroundColor = UIColorFromHex(0xc5c5c5);
    [view addSubview:pointView2];
    [pointView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label2);
        make.left.equalTo(10);
        make.width.height.equalTo(5);
    }];
    
    UIView *lineView = [UIView new];
    [view addSubview:lineView];
    lineView.backgroundColor = UIColorFromHex(0xf5f5f5);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.bottom.equalTo(0);
        make.height.equalTo(1);
        make.width.equalTo(kAppScreenWidth - 15);
    }];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYUserEditNormalCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[WYUserEditNormalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLb.text = self.labelString;
    cell.detailTF.text = self.textFieldString;
    [cell.detailTF becomeFirstResponder];
    
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
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma actions
-(void)setUpNaviTitle{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    UIBarButtonItem *title = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(DoneClick)];
    self.navigationItem.rightBarButtonItem = title;
}
-(void)DoneClick{

    self.navigationController.navigationItem.rightBarButtonItem.enabled = NO;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    WYUserEditNormalCell *cell = (WYUserEditNormalCell*)[_tableview cellForRowAtIndexPath:indexPath];
    
    if ([self.key isEqualToString:@"last_name"] || [self.key isEqualToString:@"first_name"]) {
        if (cell.detailTF.text.length < 1) {
            [OMGToast showWithText:@"在与子使用真实姓名交流，请设置真实姓名"];
            return;
        }
    }
    
    __weak WYUserEditVC *weakSelf = self;
    [WYUserDetailApi patchUserDetailDic:@{self.key : cell.detailTF.text} Block:^(WYUser *user, NSInteger status) {
                
        if (user) {
            self.doneClick(cell.detailTF.text);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            if ([weakSelf.key isEqualToString:@"account_name"]) {
                if (status == 409) {
                    [OMGToast showWithText:@"此ID被占用!"];
                }else if (status == 400){
                    [OMGToast showWithText:@"允许字母、数字、下划线和点号，不少于4位！"];
                }else if (status == 455){
                    [OMGToast showWithText:@"一个月内只能修改一次用户名！"];
                }else{
                    [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
                }
            }else{
                [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
                self.navigationController.navigationItem.rightBarButtonItem.enabled = YES;
                
            }
        }

    }];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
@end
