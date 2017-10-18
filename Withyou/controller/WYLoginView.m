//
//  WYLoginView.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/14.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYLoginView.h"

@implementation WYLoginView
#define imageH kAppScreenWidth *0.832
-(UITextField *)IDTextFiled{
    if (_IDTextFiled == nil) {
        _IDTextFiled = [UITextField new];
        _IDTextFiled.placeholder = @"输入手机号";
        _IDTextFiled.textColor = [UIColor whiteColor];
        _IDTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        [_IDTextFiled setValue:[UIColor colorWithWhite:1 alpha:0.6] forKeyPath:@"_placeholderLabel.textColor"];
        [self addSubview:_IDTextFiled];
        [_IDTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(115);
            make.left.equalTo(35);
            make.height.equalTo(50);
            make.right.equalTo(-100);
        }];
    }
    return _IDTextFiled;
}
-(UIView *)lineOne{
    if (_lineOne == nil) {
        _lineOne = [UIView new];
        _lineOne.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6] ;
        [self addSubview:_lineOne];
        [_lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(35);
            make.height.equalTo(1);
            make.right.equalTo(-35);
            make.top.equalTo(self.IDTextFiled.mas_bottom);
        }];
    }
    return _lineOne;
}
-(UITextField *)passWordTextFiled{
    if (_passWordTextFiled == nil) {
        _passWordTextFiled = [UITextField new];
        _passWordTextFiled.placeholder = @"输入验证码";
        _passWordTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        _passWordTextFiled.textColor = [UIColor whiteColor];
        [_passWordTextFiled setValue:[UIColor colorWithWhite:1 alpha:0.6] forKeyPath:@"_placeholderLabel.textColor"];
        [self addSubview:_passWordTextFiled];
        [_passWordTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(35);
            make.top.equalTo(self.IDTextFiled.mas_bottom).equalTo(5);
            make.height.equalTo(50);
            make.right.equalTo(-100);
        }];
    }
    return _passWordTextFiled;
}
-(UIView *)lineTwo{
    if (_lineTwo == nil) {
        _lineTwo = [UIView new];
        _lineTwo.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6] ;
        [self addSubview:_lineTwo];
        [_lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(35);
            make.right.equalTo(-35);
            make.height.equalTo(1);
            make.top.equalTo(self.passWordTextFiled.mas_bottom);
        }];
    }
    return _lineTwo;
}

-(UIView *)lineThree{
    if (_lineThree == nil) {
        _lineThree = [UIView new];
        _lineThree.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6] ;
        [self addSubview:_lineThree];
        [_lineThree mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.lineTwo).equalTo(-16);
            make.centerX.equalTo(self.lineTwo).equalTo((375 - 35*2)*0.08);
            make.width.equalTo(2);
            make.height.equalTo(14);
        }];
    }
    return _lineThree;
}

-(UIButton *)verifyBtn{
    if (_verifyBtn == nil) {
        _verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _verifyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_verifyBtn setTitleColor:kRGB(255, 196, 98) forState:UIControlStateNormal];
        [self addSubview:_verifyBtn];
        [_verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.passWordTextFiled);
            make.right.equalTo(-57);
        }];
    }
    return _verifyBtn;
}

- (UILabel *)verifyCDLb{
    if (_verifyCDLb == nil) {
        _verifyCDLb = [UILabel new];
        _verifyCDLb.font = [UIFont systemFontOfSize:15];
        _verifyCDLb.textAlignment = NSTextAlignmentCenter;
        _verifyCDLb.textColor = [UIColor whiteColor];
        [self addSubview:_verifyCDLb];
        [_verifyCDLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.passWordTextFiled);
            make.right.equalTo(-44);
        }];
    }
    return _verifyCDLb;
}


-(UIButton *)loginBtn{
    if (_loginBtn == nil) {
        
        UIImageView *shadow = [UIImageView  new];
        shadow.image = [UIImage imageNamed:@"invalidName"];
        [self addSubview:shadow];
        [shadow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(30);
            make.right.equalTo(-30);
            make.top.equalTo(self.passWordTextFiled.mas_bottom).equalTo(35);
            make.height.equalTo(88);
        }];
        
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:kRGB(51, 51, 51) forState:UIControlStateNormal];
        [_loginBtn setBackgroundColor:kRGB(255, 196, 98)];
        _loginBtn.layer.cornerRadius = 4;
        _loginBtn.clipsToBounds = YES;
        [self addSubview:_loginBtn];
        [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(35);
            make.right.equalTo(-35);
            make.top.equalTo(self.passWordTextFiled.mas_bottom).equalTo(35);
            make.height.equalTo(46);
        }];
    }
    return _loginBtn;
}
-(UIImageView *)groundIV{
    if (_groundIV == nil) {
        _groundIV = [UIImageView new];
        _groundIV.image = [UIImage imageNamed:@"loginpage_background"];
        [self addSubview:_groundIV];
        [_groundIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.bottom.equalTo(0);
            make.top.equalTo(0);
        }];
    }
    return _groundIV;
}
@end
