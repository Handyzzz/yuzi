//
//  WYUserAffectiveState.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/3.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYUserAffectiveState.h"
#import "WYProfile.h"
#import "WYProfileApi.h"

@interface WYUserAffectiveState ()
{
    UIButton *_button1;
    UIButton *_button2;
    UIButton *_button3;
    UIButton *_button4;
}
@end

@implementation WYUserAffectiveState


-(void)cleanColor{
    _button1.backgroundColor = [UIColor whiteColor];
    _button2.backgroundColor = [UIColor whiteColor];
    _button3.backgroundColor = [UIColor whiteColor];
    _button4.backgroundColor = [UIColor whiteColor];
}

-(void)changeColor{
    if ([self.str isEqualToString:@"保密"]) {
        _button1.backgroundColor = UIColorFromHex(0xf2f2f2);
    }else if ([self.str isEqualToString:@"单身"]){
        _button2.backgroundColor = UIColorFromHex(0xf2f2f2);

    }else if ([self.str isEqualToString:@"恋爱"]){
        _button3.backgroundColor = UIColorFromHex(0xf2f2f2);

    }else if ([self.str isEqualToString:@"已婚"]){
        _button4.backgroundColor = UIColorFromHex(0xf2f2f2);

    }
}

-(void)setUpUI{

    
    _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_button1];
    [_button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(kStatusAndBarHeight);
        make.height.equalTo(50);
        make.width.equalTo(kAppScreenWidth/2);
    }];
    _button1.titleLabel.font = [UIFont systemFontOfSize:14];
    [_button1 setTitle:@"保密" forState:UIControlStateNormal];
    [_button1 setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
    _button1.layer.borderWidth = 0.5;
    _button1.layer.borderColor = UIColorFromHex(0xf2f2f2).CGColor;
    _button1.tag = 1;
    [self addBtnClick:_button1];
    
    
    _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_button2];
    [_button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.top.equalTo(kStatusAndBarHeight);
        make.height.equalTo(50);
        make.width.equalTo(kAppScreenWidth/2);
    }];
    _button2.titleLabel.font = [UIFont systemFontOfSize:14];
    [_button2 setTitle:@"单身" forState:UIControlStateNormal];
    [_button2 setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
    _button2.layer.borderWidth = 0.5;
    _button2.layer.borderColor = UIColorFromHex(0xf2f2f2).CGColor;
    _button2.tag = 2;
    [self addBtnClick:_button2];

    
    _button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_button3];
    [_button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(_button1.mas_bottom);
        make.height.equalTo(50);
        make.width.equalTo(kAppScreenWidth/2);

    }];
    _button3.titleLabel.font = [UIFont systemFontOfSize:14];
    [_button3 setTitle:@"恋爱" forState:UIControlStateNormal];
    [_button3 setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
    _button3.layer.borderWidth = 0.5;
    _button3.layer.borderColor = UIColorFromHex(0xf2f2f2).CGColor;
    _button3.tag = 3;
    [self addBtnClick:_button3];

    
    _button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_button4];
    [_button4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.top.equalTo(_button2.mas_bottom);
        make.height.equalTo(50);
        make.width.equalTo(kAppScreenWidth/2);

    }];
    _button4.titleLabel.font = [UIFont systemFontOfSize:14];
    [_button4 setTitle:@"已婚" forState:UIControlStateNormal];
    [_button4 setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
    _button4.layer.borderWidth = 0.5;
    _button4.layer.borderColor = UIColorFromHex(0xf2f2f2).CGColor;
    _button4.tag = 4;
    [self addBtnClick:_button4];

}

-(void)addBtnClick:(UIButton *)button{
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)buttonClick:(UIButton *)button{
    NSString *str;
    switch (button.tag) {
        case 1:
            str = @"保密";
            break;
        case 2:
            str = @"单身";
            break;
        case 3:
            str = @"恋爱";
            break;
        case 4:
            str = @"已婚";
            break;
            
        default:
            break;
    }
    [self PatchUserDetail:button str:str];
}


-(NSNumber *)caculateNum:(NSInteger)tag{
    NSNumber * result;
    switch (tag) {
        case 1:
            result = @(4);
            break;
        case 2:
            result = @(1);
            break;
        case 3:
            result = @(2);
            break;
        case 4:
            result = @(3);
            break;
        default:
            break;
    }
    return result;
}

-(void)PatchUserDetail:(UIButton *)button str:(NSString*)str{
    
    __weak WYUserAffectiveState *weakSelf = self;
    NSNumber *num = [self caculateNum:button.tag];
    [WYProfileApi patchProfireDic:@{@"relationship_status":num} Block:^(WYProfile *profile) {
        if (profile) {
            [weakSelf cleanColor];
            [button setBackgroundColor:UIColorFromHex(0xf2f2f2)];
            weakSelf.doneClick(str,[num integerValue]);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
            weakSelf.navigationController.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBar];
    [self setUpUI];
    [self changeColor];
}
-(void)setNavigationBar{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
