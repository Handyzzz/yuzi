//
//  WYUserEditWorkVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/2.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYUserEditWorkVC.h"
#import "WYUserEditNormalCell.h"
#import "WYUserEditTimeCell.h"
#import "WYDatePickerView.h"
#import "WYJobApi.h"

@interface WYUserEditWorkVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, copy)NSArray *titleArr;

@property (nonatomic, strong)NSString* startStr;
@property (nonatomic, strong)NSString* finshStr;

@end

@implementation WYUserEditWorkVC



-(void)initData{
    _titleArr = @[@"公司名",@"工作时间",@"设为当前工作"];
}
-(WYJob *)job{
    if (_job == nil) {
        _job = [WYJob new];
    }
    return _job;
}

-(void)setUpUI{
    _tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableview.backgroundColor = [UIColor whiteColor];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.view addSubview:_tableview];

}

-(void)setUpNaviTitle{
   
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIBarButtonItem *title = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(DoneClick:)];
    self.navigationItem.rightBarButtonItem = title;
}

-(void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)DoneClick:(UIBarButtonItem *)sender{
    
    //准备数据
    for (int i = 0; i< _titleArr.count; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        WYUserEditNormalCell *cell = (WYUserEditNormalCell*)[_tableview cellForRowAtIndexPath:indexPath];
        if (i == 0) {
            self.job.org = cell.detailTF.text;
        }else if (i == 1){
            if (self.startStr.length > 0) {
                self.job.start_date = self.startStr;
            }
            if (self.finshStr.length > 0) {
                self.job.finish_date = self.finshStr;
            }
        }else{
            BOOL isOn = ((UISwitch *)(cell.accessoryView)).on;
            self.job.current_work = isOn;
        }
    }
    //做检查 如果不完善 提示请先完善信息
    if (!(self.job.org.length > 0 && self.job.start_date > 0 && self.job.finish_date.length > 0)) {
        [WYUtility showAlertWithTitle:@"请完善信息"];
        return;
    }
    
    //按钮按下后 按钮失能 如果请求得到结果后才给解开 保证不能一直发请求
    sender.enabled = NO;
    
    //发送请求
    NSDictionary *dic = @{
                          @"org":self.job.org,
                          @"start_date":self.job.start_date,
                          @"finish_date":self.job.finish_date,
                          @"current_work":@(self.job.current_work)
                          };
    
    
    if (self.isAdd == YES) {
        //添加
        [WYJobApi postJobDetailDic:dic Block:^(WYJob *job) {
            if (job) {
                self.doneClick(job);
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
            }
            sender.enabled = YES;
        }];
    }else{
        [WYJobApi patchJobDetail:self.job.uuid Dic:dic Block:^(WYJob *job) {
            if (job) {
                self.doneClick(job);
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
            }
            sender.enabled = YES;
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNaviTitle];
    [self initData];
    [self setUpUI];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYUserEditNormalCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    WYUserEditTimeCell *timeCell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 1) {
        if (!timeCell) {
            timeCell = [[WYUserEditTimeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"timeCell"];
            timeCell.textLb.text = _titleArr[indexPath.row];
            timeCell.textLb.font = [UIFont systemFontOfSize:14 weight:0.4];
            if (self.isAdd == YES) {
                timeCell.detailLb.text = @"";
            }else{
                timeCell.detailLb.text = [NSString stringWithFormat:@"%@ —— %@",self.job.start_year_month,self.job.finish_year_month];
            }
        }
        return timeCell;
    }

    
    if (!cell) {
        cell = [[WYUserEditNormalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLb.text = _titleArr[indexPath.row];
    cell.textLb.font = [UIFont systemFontOfSize:14 weight:0.4];

    if (indexPath.row == 0) {
        if (_isAdd == YES) {
            [cell detailTF];
        }else{
            cell.detailTF.text = self.job.org;
        }
    }else{
        UISwitch *aSwitch = [cell.contentView viewWithTag:1000];
        if (!aSwitch) {
            aSwitch = [UISwitch new];
            aSwitch.tag = 1000;
            aSwitch.onTintColor = UIColorFromHex(0x2BA1D4);
            cell.accessoryView = aSwitch;
        }
        if (_isAdd == YES) {
            aSwitch.on = YES;
        }else{
            aSwitch.on = self.job.current_work;
        }

    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        [self.view endEditing:YES];
        [self showDataPicker];
    }
}
-(void)showDataPicker{
    
    __weak WYUserEditWorkVC *weakSelf = self;
    
    WYDatePickerView *pickerView = [[WYDatePickerView alloc] initWithPickerViewWithCenterTitle:@"选择期限" LimitMaxIndex:50];
    
    [pickerView pickerViewDidSelectRowWith:100 :600 :100 :600];
    
    [pickerView pickerVIewClickCancelBtnBlock:^{
        
        NSLog(@"取消");
        
    } sureBtClcik:^(NSInteger leftYearIndex,NSInteger leftMonthIndex,NSInteger rightYearIndex,NSInteger rightMonthIndex) {
        
        NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:0];
        WYUserEditTimeCell *cell = [self.tableview cellForRowAtIndexPath:index];
        cell.detailLb.text = [NSString stringWithFormat:@"%ld-%ld  ——  %ld-%ld",leftYearIndex,leftMonthIndex,rightYearIndex,rightMonthIndex];
        
        if (leftMonthIndex <= 9) {
            weakSelf.startStr = [NSString stringWithFormat:@"%ld-0%ld-01",leftYearIndex,leftMonthIndex];
            
        }else{
            weakSelf.startStr = [NSString stringWithFormat:@"%ld-%ld-01",leftYearIndex,leftMonthIndex];
            
        }
        if (rightMonthIndex <= 9) {
            weakSelf.finshStr = [NSString stringWithFormat:@"%ld-0%ld-01",rightYearIndex,rightMonthIndex];
            
        }else{
            weakSelf.finshStr = [NSString stringWithFormat:@"%ld-%ld-01",rightYearIndex,rightMonthIndex];
            
        }
    }];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

@end
