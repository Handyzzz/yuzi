//
//  WYUserEditEducationView.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/2.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYUserEditEducationVC.h"
#import "WYUserEditNormalCell.h"
#import "WYUserEditTimeCell.h"
#import "WYDatePickerView.h"
#import "WYStudyApi.h"

@interface WYUserEditEducationVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, copy)NSArray *titleArr;
@property (nonatomic, strong)UIPickerView *pickerView;

@property (nonatomic,copy)NSMutableArray *yearArr;

@property (nonatomic,copy)NSMutableArray *monthArr;

@property (nonatomic, assign)NSInteger minIndex;
@property (nonatomic, assign)NSInteger maxIndex;

@property (nonatomic, strong)NSString* startStr;
@property (nonatomic, strong)NSString* finshStr;

@end

@implementation WYUserEditEducationVC

-(NSMutableArray *)yearArr{
    if (!_yearArr) {
        _yearArr = [NSMutableArray array];
    }
    return _yearArr;
}
-(NSMutableArray *)monthArr{
    if (_monthArr == nil) {
        _monthArr = [NSMutableArray array];
    }
    return _monthArr;
}

-(void)initData{
    _titleArr = @[@"学校名称",@"入学时间",@"学业方向"];
    _minIndex = 1900;
    _maxIndex = 2100;
}
-(WYStudy *)study{
    if (_study == nil) {
        _study = [WYStudy new];
    }
    return _study;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNaviTitle];
    [self initData];
    [self setUpUI];
}


-(void)setUpUI{
    _tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableview.backgroundColor = [UIColor whiteColor];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableview];
}

-(void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUpNaviTitle{
    
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;

    UIBarButtonItem *title = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(DoneClick:)];
    self.navigationItem.rightBarButtonItem = title;
}

-(void)DoneClick:(UIBarButtonItem *)sender{
    
    
    //准备数据
    
    for (int i = 0; i< _titleArr.count; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        WYUserEditNormalCell *cell = (WYUserEditNormalCell*)[_tableview cellForRowAtIndexPath:indexPath];
        if (i == 1) {
            if (self.startStr.length > 0) {
                self.study.start_date = self.startStr;
            }
            if (self.finshStr.length > 0) {
                self.study.finish_date = self.finshStr;
            }
        }else{
            if (i == 0) {
                self.study.school = cell.detailTF.text;
            }else{
                self.study.direction = cell.detailTF.text;
            }
        }
    }
    
    
    
   //做检查 如果不完善 提示请先完善信息
    if (!(self.study.school.length > 0 && self.study.start_date > 0 && self.study.finish_date && self.study.direction)) {
        [WYUtility showAlertWithTitle:@"请完善信息"];
        return;
    }
    
    //按钮按下后 按钮失能 如果请求得到结果后才给解开 保证不能一直发请求
    sender.enabled = NO;
    
    NSDictionary *dic = @{
                          @"school":self.study.school,
                          @"start_date":self.study.start_date,
                          @"finish_date":self.study.finish_date,
                          @"direction":self.study.direction
                          };
    
    

    
    if (self.isAdd == YES) {
        //添加
        [WYStudyApi postUserStudyDetail:dic Block:^(WYStudy *study) {
            if (study) {
                self.doneClick(study);
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
            }
            sender.enabled = YES;

        }];
    }else{
        [WYStudyApi patchStudyDetail:self.study.uuid Dic:dic Block:^(WYStudy *study) {
            if (study) {
                self.doneClick(study);
                [self.navigationController popViewControllerAnimated:YES];

            }else{
                [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
            }
            sender.enabled = YES;
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
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
                timeCell.detailLb.text = [NSString stringWithFormat:@"%@ —— %@",self.study.start_year_month,self.study.finish_year_month];
            }
        }
        [self addLine:timeCell :indexPath];
        return timeCell;
    }
    if (!cell) {
        cell = [[WYUserEditNormalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [self addLine:cell :indexPath];
    cell.textLb.text = _titleArr[indexPath.row];
    cell.textLb.font = [UIFont systemFontOfSize:14 weight:0.4];
    if (self.isAdd == YES) {
        [cell detailTF];
    }else{
        if (indexPath.row == 0) {
            cell.detailTF.text = self.study.school;

        }else{
            cell.detailTF.text = self.study.direction;

        }
    }
    
    return cell;
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

    if (indexPath.row == 1) {
        [self.view endEditing:YES];
        [self showDataPicker];
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(void)showDataPicker{
    
    __weak WYUserEditEducationVC *weakSelf = self;
    
    WYDatePickerView *pickerView = [[WYDatePickerView alloc] initWithPickerViewWithCenterTitle:@"选择期限" LimitMaxIndex:50];
    
    [pickerView pickerViewDidSelectRowWith:100 :600 :100 :600];
    
    [pickerView pickerVIewClickCancelBtnBlock:^{
        
        NSLog(@"取消");
        
    } sureBtClcik:^(NSInteger leftYearIndex,NSInteger leftMonthIndex,NSInteger rightYearIndex,NSInteger rightMonthIndex) {
        
        NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:0];
        WYUserEditTimeCell *cell = [self.tableview cellForRowAtIndexPath:index];
        
        NSString *leftStr;
        NSString *rightStr;
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
        leftStr = [weakSelf.startStr substringToIndex:weakSelf.startStr.length - 3];
        rightStr = [weakSelf.finshStr substringToIndex:weakSelf.finshStr.length - 3];
        cell.detailLb.text = [NSString stringWithFormat:@"%@ —— %@",leftStr,rightStr];

    }];
}

@end
