//
//  LWTDatePickerView.m
//  LWTProgressView
//
//  Created by liaowentao on 17/2/23.
//  Copyright © 2017年 Haochuang. All rights reserved.
//

#import "WYDatePickerView.h"

#define TopViewHeight 40
#define BottomHeight 40
#define ContainerWidth SCREEN_WIDTH * 0.7
#define ContainerHeight SCREEN_WIDTH * 0.7
#define PickerViewBackGroundColor UIColorFromHex(0x318ce7)
#define LineWidth 0.5f

@interface WYDatePickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic)NSMutableArray *yearArr;
@property (nonatomic, strong)NSMutableArray *monthArr;

@property (nonatomic,strong)UIPickerView *datePickView;
@property (nonatomic,strong)UIView *topView;
//组合view
@property (nonatomic,strong) UIView *containerView;
//选择的左边和右边索引
@property (assign, nonatomic)NSInteger index1;
@property (assign, nonatomic)NSInteger index2;
@property (nonatomic, assign)NSInteger index3;
@property (nonatomic, assign)NSInteger index4;

//弹框标题
@property (copy,nonatomic)NSString *titleString;
@end

@implementation  WYDatePickerView

- (NSMutableArray *)yearArr {
    
    if (_yearArr == nil) {
        _yearArr = [NSMutableArray array];
        for (int i = 1900; i <= 2100; i ++) {
            [_yearArr addObject:@(i)];
        }
    }
    return _yearArr;
}

-(NSMutableArray *)monthArr{
    if (_monthArr == nil) {
        _monthArr = [NSMutableArray array];
        for (int i = 1; i <= 100; i++) {
            for (int i = 1; i <= 12; i ++) {
                [_monthArr addObject:@(i)];
            }
        }
    }
    return _monthArr;
}

- (UIPickerView *)pickerViewLoanLine {
    
    if (_datePickView == nil) {
        _datePickView = [[UIPickerView alloc] init];
        _datePickView.backgroundColor=[UIColor whiteColor];
        _datePickView.delegate = self;
        _datePickView.dataSource = self;
        _datePickView.frame = CGRectMake(0, TopViewHeight, ContainerWidth , ContainerHeight - TopViewHeight - BottomHeight);
        
    }
    return _datePickView;
}

- (UIView *)topView {
    
    if (_topView == nil) {
        
        _topView =[[UIView alloc] init];
        _topView.frame = CGRectMake(0, 0, ContainerWidth, TopViewHeight);
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,ContainerWidth, TopViewHeight)];
        lable.backgroundColor = PickerViewBackGroundColor;
        lable.text = _titleString;
        lable.textAlignment = 1;
        lable.textColor = [UIColor whiteColor];
        lable.numberOfLines = 1;
        lable.font = [UIFont systemFontOfSize:15];
        [_topView addSubview:lable];
        
    }
    
    return _topView;
}

- (UIView *)containerView {
    
    if (_containerView == nil) {
        
        _containerView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - ContainerWidth)/2.0, SCREEN_HEIGHT * 0.26, ContainerWidth,ContainerHeight)];
        _containerView.backgroundColor = [UIColor whiteColor];
        
        [_containerView addSubview:self.topView];
        [_containerView addSubview:self.pickerViewLoanLine];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0,ContainerHeight - BottomHeight - LineWidth,ContainerWidth, LineWidth)];
        lineView1.backgroundColor = PickerViewBackGroundColor;
        [_containerView addSubview:lineView1];
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(ContainerWidth * 0.5 - LineWidth,  ContainerHeight - BottomHeight, LineWidth, BottomHeight)];
        lineView2.backgroundColor = PickerViewBackGroundColor;
        [_containerView addSubview:lineView2];
        
        //取消按钮
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.backgroundColor = [UIColor clearColor];
        cancelBtn.frame = CGRectMake(0, ContainerHeight - BottomHeight, ContainerWidth * 0.5, BottomHeight);
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        cancelBtn.layer.cornerRadius = 2;
        cancelBtn.backgroundColor = [UIColor clearColor];
        cancelBtn.layer.masksToBounds = YES;
        [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:cancelBtn];
        
        //确定按钮
        UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseBtn.backgroundColor = [UIColor clearColor];
        chooseBtn.frame = CGRectMake(ContainerWidth * 0.5, ContainerHeight - BottomHeight, ContainerWidth * 0.5, BottomHeight);
        chooseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        chooseBtn.layer.cornerRadius = 2;
        chooseBtn.layer.masksToBounds = YES;
        [chooseBtn setTitleColor:PickerViewBackGroundColor forState:UIControlStateNormal];
        [chooseBtn setTitle:@"确定" forState:UIControlStateNormal];
        [chooseBtn addTarget:self action:@selector(doneItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:chooseBtn];
    }
    return _containerView;
    
}

- (instancetype)initWithPickerViewWithCenterTitle:(NSString *)title  LimitMaxIndex:(NSInteger)limitMaxIndex{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.titleString = title;
        [self addSubview:self.containerView];
        UIWindow *currentWindows = [UIApplication sharedApplication].keyWindow;
        self.backgroundColor = UIColorFromRGBA(0x111111, 0.7);
        [currentWindows addSubview:self];
    }
    
    return self;
}

- (void)pickerVIewClickCancelBtnBlock:(clickCancelBtn)cancelBlock
                          sureBtClcik:(clickSureBtn)sureBlock {
    
    self.clickCancelBtn = cancelBlock;
    
    self.clickSureBtn = sureBlock;
    
}

//滚动到特定行数
- (void)pickerViewDidSelectRowWith:(NSInteger)index1 :(NSInteger)index2 :(NSInteger)index3 :(NSInteger)index4{
    
    self.index1 = index1;
    self.index2 = index2;
    self.index3 = index3;
    self.index4 = index4;
    [self.pickerViewLoanLine selectRow:self.index1 inComponent:0 animated:YES];
    [self.pickerViewLoanLine selectRow:self.index2 inComponent:1 animated:YES];
    [self.pickerViewLoanLine selectRow:self.index3 inComponent:2 animated:YES];
    [self.pickerViewLoanLine selectRow:self.index4 inComponent:3 animated:YES];

}

//点击取消按钮
- (void)remove:(UIButton *) btn {
    
    if (self.clickCancelBtn) {
        
        self.clickCancelBtn();
        
    }
    [self dissMissView];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dissMissView];
}
- (void)dissMissView{
    
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.containerView.frame = CGRectMake((SCREEN_WIDTH - SCREEN_WIDTH * 0.7)/2.0, SCREEN_HEIGHT, SCREEN_WIDTH * 0.7,  SCREEN_WIDTH * 0.7);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//点击确定按钮
- (void)doneItemClick:(UIButton *) btn {
    
    if (self.clickSureBtn) {
        
        self.clickSureBtn([self.yearArr[self.index1] integerValue],[self.monthArr[self.index2] integerValue],[self.yearArr[self.index3] integerValue],[self.monthArr[self.index4] integerValue]);
    }
    
    [self dissMissView];
}



#pragma pickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 4;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
            return self.yearArr.count;
            break;
        case 1:
            return self.monthArr.count;
            break;
        case 2:
            return self.yearArr.count;
            break;
        case 3:
            return self.monthArr.count;
            break;
            
        default:
            break;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            NSString *str = [NSString stringWithFormat:@"%d",[self.yearArr[row] intValue]];
            return str;
        }
            
            break;
            
        case 1:
        {
            NSString *str = [NSString stringWithFormat:@"%d",[self.monthArr[row] intValue]];
            return str;
        }
            
            break;
        case 2:
        {
            NSString *str = [NSString stringWithFormat:@"%d",[self.yearArr[row] intValue]];
            return str;
        }
            
            break;
        case 3:
        {
            NSString *str = [NSString stringWithFormat:@"%d",[self.monthArr[row] intValue]];
            return str;
        }
            
            break;
            
        default:
            return nil;
    }
    
}

//如果 后边的 年月

// 选中某一组中的某一行时调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.index1 = [pickerView selectedRowInComponent:0];
    self.index2 = [pickerView selectedRowInComponent:1];
    self.index3 = [pickerView selectedRowInComponent:2];
    self.index4 = [pickerView selectedRowInComponent:3];

    switch(component) {
        case 0:
        {
            if (100*_index1 + _index2 > 100 * _index3 + _index4 ) {
                [self.pickerViewLoanLine selectRow:_index1 inComponent:2 animated:YES];
                [self.pickerViewLoanLine selectRow:_index2 inComponent:3 animated:YES];
                _index3 = _index1;
                _index4 = _index2;
            }
        }
            break;
            
        case 1:
        {
            if (100*_index1 + _index2 > 100 * _index3 + _index4 ) {
                [self.pickerViewLoanLine selectRow:_index1 inComponent:2 animated:YES];
                [self.pickerViewLoanLine selectRow:_index2 inComponent:3 animated:YES];
                _index3 = _index1;
                _index4 = _index2;
            }
            
        }
            break;

        case 2:
        {
            if (100*_index1 + _index2 > 100 * _index3 + _index4 ) {
                [self.pickerViewLoanLine selectRow:_index3 inComponent:0 animated:YES];
                [self.pickerViewLoanLine selectRow:_index4 inComponent:1 animated:YES];
                _index1 = _index3;
                _index2 = _index4;
            }
        }
            break;

        case 3:
        {
            if (100*_index1 + _index2 > 100 * _index3 + _index4 ) {
                [self.pickerViewLoanLine selectRow:_index3 inComponent:0 animated:YES];
                [self.pickerViewLoanLine selectRow:_index4 inComponent:1 animated:YES];
                _index1 = _index3;
                _index2 = _index4;
            }
        }
            break;

        default:
            break;
    }
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    //隐藏中间的上下两条线
//    if (_datePickView.subviews.count >= 2) {
//        ((UIView *)[_pickerViewLoanLine.subviews objectAtIndex:1]).hidden = YES;
//        ((UIView *)[_pickerViewLoanLine.subviews objectAtIndex:2]).hidden = YES;
//    }
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.font = [UIFont systemFontOfSize:16];
        pickerLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
    }
    switch (component) {
        case 0:
            [pickerLabel setTextAlignment:NSTextAlignmentCenter];
            break;
        case 1:
            [pickerLabel setTextAlignment:NSTextAlignmentCenter];
            break;
        case 2:
            [pickerLabel setTextAlignment:NSTextAlignmentCenter];
            break;
        case 3:
            [pickerLabel setTextAlignment:NSTextAlignmentCenter];
            break;
        default:
            break;
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


@end
