//
//  YZNewGroupVC.m
//  Withyou
//
//  Created by ping on 2017/1/13.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZNewGroupVC.h"
#import "WYAccountApi.h"
#import <Masonry/Masonry.h>
#import "WYGroupsVC.h"
#import "WYGroup.h"
#import "WYGroupApi.h"
#import "WYGroupDetailVC.h"
#import "WYGroupListVC.h"
#import "WYGroupCategory.h"
#import "WYGroupIconVC.h"


@interface YZNewGroupVC () <UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollerView;
@property (nonatomic, strong) UIImageView *backView;
@property (nonatomic, strong) UIImageView *iconIV;
@property (nonatomic, strong) UITextField *input;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeHolder;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, copy) NSDictionary *dic;
@property (nonatomic, assign)select_group_icon_type type;
@end
@implementation YZNewGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建群组";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNaviItem];
    [self createUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)setNaviItem{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)createUI {
    
    _scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, kAppScreenHeight)];
    _scrollerView.bounces = YES;
    _scrollerView.scrollEnabled = YES;
    _scrollerView.contentSize = CGSizeMake(kAppScreenWidth,kAppScreenHeight - kStatusAndBarHeight + 1);
    _scrollerView.delegate = self;
    [self.view addSubview:_scrollerView];
    
    //自动布局影响 scrollerView contentSize
    UIView *fillView = [UIView new];
    [self.scrollerView addSubview:fillView];
    [fillView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(0);
        make.width.equalTo(kAppScreenWidth);
        make.height.equalTo(kAppScreenHeight - kStatusAndBarHeight);
        make.right.equalTo(fillView.superview.mas_right).offset(0);
        make.bottom.equalTo(fillView.superview.mas_bottom).offset(-1);
    }];
    
    //背景图片
    _backView = [UIImageView new];
    _backView.image = [UIImage imageNamed:@"creategroup_background_default"];
    [self.scrollerView addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(0);
        make.width.equalTo(kAppScreenWidth);
        make.height.equalTo(210);
    }];
    
    //背景圆
    UIView *backCircle = [UIView new];
    backCircle.layer.cornerRadius = 130/2.0;
    backCircle.clipsToBounds = YES;
    backCircle.backgroundColor = UIColorFromRGBA(0xe8f0f4, 0.6);
    [self.scrollerView addSubview:backCircle];
    [backCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(_backView).equalTo(40);
        make.width.height.equalTo(130);
    }];
    
    //头像
    _iconIV = [UIImageView new];
    _iconIV.userInteractionEnabled = YES;
    _iconIV.layer.cornerRadius = 60;
    _iconIV.clipsToBounds = YES;
    [self.scrollerView addSubview:_iconIV];
    UITapGestureRecognizer *contentGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentClick:)];
    [_iconIV addGestureRecognizer:contentGesture];
    [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backView).equalTo(45);
        make.centerX.equalTo(0);
        make.width.height.equalTo(120);
    }];
    _iconIV.image = [UIImage imageNamed:@"creatgroupUopload"];
    _iconIV.clipsToBounds = YES;
    _iconIV.contentMode = UIViewContentModeScaleAspectFill;
    
    self.input = [UITextField new];
    [self.scrollerView addSubview:_input];
    [self.input mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(_backView.mas_bottom).equalTo(20);
        make.width.equalTo(kAppScreenWidth - 30);
        make.height.equalTo(45);
    }];
    _input.backgroundColor = [UIColor whiteColor];
    _input.layer.cornerRadius = 5;
    _input.clipsToBounds = YES;
    _input.placeholder = @"群名称";
    _input.returnKeyType = UIReturnKeyDone;
    _input.delegate = self;
    _input.textColor = kRGB(51, 51, 51);
    _input.font = [UIFont systemFontOfSize:18 weight:0.4];
    [_input addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // 添加底边线
    UIView *line  = [[UIView alloc]initWithFrame:CGRectMake(0, 275, kAppScreenWidth, 2)];
    [self.scrollerView addSubview:line];
    [self drawDashLine:line lineLength:4 lineSpacing:4 lineColor:UIColorFromHex(0xf5f5f5)];
    
    self.textView = [UITextView new];
    [self.scrollerView addSubview:self.textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(line.mas_bottom).equalTo(15);
        make.width.equalTo(kAppScreenWidth - 30);
        make.height.equalTo(115);
    }];
    self.textView.delegate = self;
    self.textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.textColor = UIColorFromHex(0x333333);
    [self placeHolder];
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = UIColorFromHex(0xf5f5f5);
    [self.scrollerView addSubview:_bottomLine];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.top.equalTo(self.textView.mas_bottom);
        make.height.equalTo(1);
    }];
    
    //button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scrollerView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.width.equalTo(kAppScreenWidth - 30);
        make.height.equalTo(50);
        make.top.equalTo(_bottomLine.mas_bottom).equalTo(25);
    }];
    button.backgroundColor = kRGB(43, 161, 212);
    button.layer.cornerRadius = 4;
    button.clipsToBounds = YES;
    [button setTitle:@"创建" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(doneClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (UILabel *)placeHolder {
    if (_placeHolder == nil) {
        _placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, kAppScreenWidth - 30, 15)];
        [self.textView addSubview:_placeHolder];
        _placeHolder.numberOfLines = 0;
        _placeHolder.textColor = kRGB(230, 230, 230);
        _placeHolder.font = [UIFont systemFontOfSize:15];
        _placeHolder.text = @"简介";
    }
    return _placeHolder;
}

-(void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor{
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

//点击头像可以进入换头像的页面
- (void)contentClick:(UITapGestureRecognizer *)gesture {
    __weak YZNewGroupVC *weakSelf = self;
    WYGroupIconVC *vc = [WYGroupIconVC new];
    vc.selectImgClick = ^(UIImage *chosenImage, PHAsset *aset, NSDictionary *dic, select_group_icon_type type) {
        if (type == select_group_icon_typeA) {
            //相机或者相册
            weakSelf.asset = aset;
            weakSelf.iconIV.image = chosenImage;
        }else{
            //后台相册
            [weakSelf.iconIV sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"url"]]];
            weakSelf.dic = [dic copy];
        }
        weakSelf.type = type;
         weakSelf.backView.image = [UIImage imageNamed:@"creategroup_background_highlight"];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSString *)tranArrToString:(NSArray *)arr{
    NSMutableString *ms = [NSMutableString string];
    if (arr && arr.count > 0) {
        for (NSString *s in arr) {
            NSString *temp = [NSString stringWithFormat:@"%@ ",s];
            [ms appendString:temp];
        }
        return ms;

    }else{
        return @"";
    }
}

-(NSString *)tranArrToStringWithComma:(NSArray *)arr{
    NSMutableString *ms = [NSMutableString string];
    if (arr && arr.count > 0) {
        for (int i = 0; i < arr.count; i++) {
            NSString *s = arr[i];
            NSString *temp;
            if (i < arr.count -1) {
                temp = [NSString stringWithFormat:@"%@,",s];
            }else{
                temp = [NSString stringWithFormat:@"%@",s];
            }
            [ms appendString:temp];
        }
        return ms;
        
    }else{
        return @"";
    }
}


- (void)doneClick:(id)sender {

    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    if (self.asset == nil && self.dic == nil) {
        [OMGToast showWithText:@"请选择添加群头像"];
        return;
    }
    
    if (self.input.text.length<1 ) {
        [OMGToast showWithText:@"请填写群名称"];
        return;
    }
    
    [self.view showHUDNoHide];
    __weak YZNewGroupVC *weakSelf = self;
    if (self.type == select_group_icon_typeA) {
        
        [WYGroupApi addNewGroupWith:self.input.text ImageWith:self.asset groupIntroduction:self.textView.text callback:^(WYGroup *group,NSInteger status) {
            [weakSelf creatGroupBack:group status:status];
        }];
    }else{
    
        [WYGroupApi addNewGroupWith:self.input.text dict:self.dic groupIntroduction:self.textView.text callback:^(WYGroup *group, NSInteger status) {
            [weakSelf creatGroupBack:group status:status];
        }];
    }
}

-(void)creatGroupBack:(WYGroup *)group status:(NSInteger)status{
    __weak YZNewGroupVC *weakSelf = self;
    [weakSelf.view hideAllHUD];
    if (status >= 200 && status < 300) {
        if(group) {
            
            weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
            [OMGToast showWithText:@"创建成功!"];
            //新建群组完成后通知 groupVC刷新数据
            [[NSNotificationCenter defaultCenter] postNotificationName:kNewGroupDataSource object:nil userInfo:@{@"group":group}];
            
            NSMutableArray *allVCs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            for (UIViewController *aViewController in allVCs){
                if ([aViewController isKindOfClass:[WYGroupListVC class]]) {
                    [weakSelf.navigationController popToViewController:aViewController animated:NO];
                    
                    WYGroupDetailVC *groupDetail = [WYGroupDetailVC new];
                    groupDetail.group = group;
                    [aViewController.navigationController pushViewController:groupDetail animated:YES];
                }
            }
        }
        
    }else if (status == 400){
        weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
        [OMGToast showWithText:@"创建群组未成功，该名称已经存在于你的群组中！"];
    }else if (status == 450){
        weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
        [WYUtility requireSetAccountNameOrAlreadyHasName:^{
            YZNewGroupVC *groupVC = [[YZNewGroupVC alloc] init];
            groupVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:groupVC animated:YES];
        } navigationController:self.navigationController];
    }else{
        weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
        [WYWYNetworkStatus showWrongText:status];
    }
}

#pragma 监听文本变化
- (BOOL)textFieldDidChange:(UITextField *)textField{
    if(textField.text.length > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text == nil || textView.text.length == 0) {
        [textView addSubview:self.placeHolder];
    }else {
        [self.placeHolder removeFromSuperview];
    }
    
    if (textView.text.length >=500) {
        textView.text = [textView.text substringToIndex:500];
    }
}

//收键盘
//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)keyBoardWillChangeFrame:(NSNotification*)notification{
    
    //获取高度
    // 键盘显示\隐藏完毕的frame
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 动画时间和键盘的动画时间是一样的 然后高度也是计算的一样的  所以工具条和键盘的动画会同步起来
    
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if (frame.origin.y == kAppScreenHeight) { // 没有弹出键盘
        
        [UIView animateWithDuration:duration animations:^{
            self.scrollerView.transform =  CGAffineTransformIdentity;
        }];
        
    }else{ // 弹出键盘
        
        [UIView animateWithDuration:duration animations:^{
            self.scrollerView.transform = CGAffineTransformMakeTranslation(0, -(frame.size.height - (kAppScreenHeight - kStatusAndBarHeight - CGRectGetMaxY(_bottomLine.frame))));
        }];
    }
}

//滑动收键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITextView class]]) {
        return;
    }
    [self.view endEditing:YES];
    
}


@end
