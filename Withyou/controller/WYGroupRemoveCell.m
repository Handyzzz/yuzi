//
//  WYGroupRemoveCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/4/7.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYGroupRemoveCell.h"

@implementation WYGroupRemoveCell

-(UIImageView*)iconIV{
    if (_iconIV == nil) {
        _iconIV = [UIImageView new];
        [self.contentView addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(10);
            make.centerX.equalTo(0);
            make.width.height.equalTo(40);
        }];
    }
    return _iconIV;
}


-(UILabel*)nameLb{
    if (_nameLb == nil) {
        _nameLb = [UILabel new];
        [self.contentView addSubview:_nameLb];
        _nameLb.numberOfLines = 2;
        _nameLb.font = [UIFont systemFontOfSize:13];
        _nameLb.textColor = [UIColor lightGrayColor];
        _nameLb.textAlignment = NSTextAlignmentCenter;
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconIV.mas_bottom).equalTo(5);
            make.centerX.equalTo(self.iconIV);
            make.width.equalTo(60);
        }];
    }
    return _nameLb;
}

@end
