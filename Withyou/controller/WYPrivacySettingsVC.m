//
//  WYPrivacySettingsVC.m
//  Withyou
//
//  Created by Tong Lu on 16/8/18.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import "WYPrivacySettingsVC.h"
#import "WYPrivacy.h"

@interface WYPrivacySettingsVC() <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *titleArr;
@property(nonatomic, strong)WYPrivacy *privacy;
@property(nonatomic, strong)NSMutableArray *statusArr;
@end

@implementation WYPrivacySettingsVC


-(NSMutableArray *)statusArr{
    if (_statusArr == nil) {
        _statusArr = [@[
                        [@[@(0),@(0),@(0)]mutableCopy],
                        [@[@(0),@(0)]mutableCopy],
                        [@[@(0),@(0),@(0)]mutableCopy],
                        [@[@(0)]mutableCopy],
                        [@[@(0)]mutableCopy]
                        ] mutableCopy];
    }
    return _statusArr;
}


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"隐私设置";
    [self setNavigationBar];
    [self setUpUI];
    [self initData];
}

-(void)setNavigationBar{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
}

-(void)initData{
    _titleArr = @[
                  @[@"情感状态",@"常住地",@"手机号码"],
                  @[@"年份",@"月/日"],
                  @[@"工作经历",@"当前工作",@"学习经历"],
                  @[@"可以查看我的好友列表"],
                  @[@"拉黑"]
                  ];
    
    __weak WYPrivacySettingsVC *weakSelf = self;
    [WYPrivacy retrievePrivacy:self.userUuid block:^(WYPrivacy *privacy) {
        if (privacy) {
            weakSelf.privacy = privacy;
            weakSelf.statusArr = [@[
                                   [@[@(weakSelf.privacy.relationship_status),@(weakSelf.privacy.city),@(weakSelf.privacy.primary_phone)]mutableCopy],
                                   [@[@(weakSelf.privacy.birth_year),@(weakSelf.privacy.birth_day)]mutableCopy],
                                   [@[@(weakSelf.privacy.work_experience),@(weakSelf.privacy.current_work),@(weakSelf.privacy.work_experience)]mutableCopy],
                                   [@[@(weakSelf.privacy.check_friend_list)]mutableCopy],
                                   [@[@(weakSelf.privacy.blocked)] mutableCopy]
                               ] mutableCopy];
            [weakSelf.tableView reloadData];
        }
    }];
    
    
}

-(void)setUpUI{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick:)];
    self.navigationItem.rightBarButtonItem = button;
}

-(void)doneClick:(UIBarButtonItem *)button{
    button.enabled = NO;
    
    NSDictionary *dic = @{
                          @"relationship_status":self.statusArr[0][0],
                          @"city":self.statusArr[0][1],
                          @"primary_phone":self.statusArr[0][2],
                          @"birth_year":self.statusArr[1][0],
                          @"birth_day":self.statusArr[1][1],
                          @"work_experience":self.statusArr[2][0],
                          @"current_work":self.statusArr[2][1],
                          @"study_experience":self.statusArr[2][2],
                          @"check_friend_list":self.statusArr[3][0],
                          @"blocked":self.statusArr[4][0]
                          };
    
    [WYPrivacy patchPrivacy:self.userUuid dic:dic block:^(WYPrivacy *privacy) {
        
        button.enabled = YES;

        if (privacy) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [OMGToast showWithText:@"未能成功设置"];
        }
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArr[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 30;
    }else{
        return 12;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 30)];
        view.backgroundColor = UIColorFromHex(0xf5f5f5);
        
        UIView *markView = [UIView new];
        markView.backgroundColor = UIColorFromHex(0xc5c5c5);
        [view addSubview:markView];
        markView.layer.cornerRadius = 4;
        markView.clipsToBounds = YES;
        [markView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(8);
            make.centerY.equalTo(0);
            make.width.height.equalTo(8);
        }];
        
        UILabel *label = [UILabel new];
        [view addSubview:label];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UIColorFromHex(0xc5c5c5);
        label.text = @"对他可见的资料";
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(markView.mas_right).equalTo(8);
            make.centerY.equalTo(0);
        }];
        return view;
    }
    if (section == 1) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 30)];
        view.backgroundColor = UIColorFromHex(0xf5f5f5);
        UILabel *label = [UILabel new];
        [view addSubview:label];
        label.text = @"生日";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UIColorFromHex(0xc5c5c5);
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.centerY.equalTo(0);
        }];
        return view;
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 12)];
    view.backgroundColor = UIColorFromHex(0xf5f5f5);
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell)  cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //添加分割线
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = UIColorFromHex(0x333333);
    cell.textLabel.text = _titleArr[indexPath.section][indexPath.row];
    
    
    NSInteger tag = 1000 + 100 *indexPath.section + indexPath.row;
    UISwitch *sw = [cell.contentView viewWithTag:tag];
    if (sw == nil) {
        sw = [UISwitch new];
        sw.onTintColor = UIColorFromHex(0x2BA1D4);
        sw.tag = tag;
    }
    [sw addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    if (self.statusArr.count > 0) {
        sw.on = [self.statusArr[indexPath.section][indexPath.row] boolValue];
    }
    cell.accessoryView = sw;
    
    //第二个cell开始 top
    UIView *line = [cell.contentView viewWithTag:999];
    if (indexPath.row == 0) {
        if (line) {
            [line removeFromSuperview];
        }
    }else{
        if (line == nil) {
            line = [[UIView alloc]initWithFrame:CGRectMake(15, 0, kAppScreenWidth - 15, 1)];
            line.tag = 999;
            line.backgroundColor = UIColorFromHex(0xf5f5f5);
            [cell.contentView addSubview:line];
        }
    }

    //最后一个分区的最后一个cell
    UIView *lastLine = [cell.contentView viewWithTag:998];
    if (indexPath.section == 3 && indexPath.row == 0) {
        if (lastLine == nil) {
            lastLine = [UIView new];
            lastLine.tag = 999;
            lastLine.backgroundColor = UIColorFromHex(0xf5f5f5);
            [cell.contentView addSubview:lastLine];
            [lastLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(15);
                make.bottom.equalTo(0);
                make.height.equalTo(1);
                make.width.equalTo(kAppScreenWidth - 15);
            }];
        }
    }else{
        if (lastLine) {
            [lastLine removeFromSuperview];
        }
    }
    
    return cell;
}

-(void)switchChange:(UISwitch *)sender{
    
    //将数组中的状态改变
    NSInteger section = (sender.tag -1000)/100;
    NSInteger row = sender.tag % 100;
    
    [self.statusArr[section] replaceObjectAtIndex:row withObject:@(sender.on)];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
