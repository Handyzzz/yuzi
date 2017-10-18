//
//  LocalContactCell.m
//  Withyou
//
//  Created by CH on 2017/6/24.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "LocalContactCell.h"

@implementation LocalContactCell

-(UIImageView*)headIV{
    if (_headIV == nil) {
        _headIV = [UIImageView new];
        _headIV.clipsToBounds = YES;
        _headIV.layer.cornerRadius = 21;
        [self.contentView addSubview:_headIV];
        [_headIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(10);
            make.width.height.equalTo(42);
        }];
    }
    return _headIV;
}


-(UILabel*)nameLb{
    if (_nameLb == nil) {
        _nameLb = [UILabel new];
        [self.contentView addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(0);
            make.left.equalTo(67);
            make.right.equalTo(-100);
        }];
        _nameLb.numberOfLines = 1;
        _nameLb.font = [UIFont systemFontOfSize:15];
        _nameLb.textColor = kGrayColor85;
    }
    return _nameLb;
}

-(UIButton *)controlBTN{
    if (_controlBTN == nil) {
        _controlBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_controlBTN];
        _controlBTN.layer.borderWidth = 1;
        _controlBTN.layer.borderColor = kRGB(49,140,231).CGColor;
        _controlBTN.layer.cornerRadius = 2;
        _controlBTN.clipsToBounds = YES;
        _controlBTN.titleLabel.font = [UIFont systemFontOfSize:14];
        [_controlBTN addTarget:self action:@selector(handleControl) forControlEvents:UIControlEventTouchUpInside];
        [_controlBTN mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.width.equalTo(60);
            make.height.equalTo(30);
            make.right.equalTo(-25);
        }];
    }
    return _controlBTN;
}

- (void)handleControl{
    if (self.controlBlcok && self.user) {
        self.controlBlcok(self.user);
    }
}

-(UIView *)headView{
    if (_headView == nil) {
        _headView = [UIView new];
        _headView.backgroundColor = kRGB(245, 245, 245);
        [self.contentView addSubview:_headView];
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.top.bottom.equalTo(0);
        }];
        
        _headTitleLb = [UILabel new];
        _headTitleLb.textAlignment = NSTextAlignmentCenter;
        _headTitleLb.textColor = kRGB(197, 197, 197);
        _headTitleLb.font = [UIFont systemFontOfSize:12];
        [_headView addSubview:_headTitleLb];
        [_headTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.top.bottom.equalTo(0);
        }];
        
        UIView *leftView = [UIView new];
        leftView.backgroundColor = kRGB(197, 197, 197);
        [_headView addSubview:leftView];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(108);
            make.width.equalTo(20);
            make.height.equalTo(1);
            make.centerY.equalTo(0);
        }];
        
        UIView *rightView = [UIView new];
        rightView.backgroundColor = kRGB(197, 197, 197);
        [_headView addSubview:rightView];
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-108);
            make.width.equalTo(20);
            make.height.equalTo(1);
            make.centerY.equalTo(0);
        }];
        
    }
    return _headView;
}

@end
