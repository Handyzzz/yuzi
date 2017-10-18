//
//  WYGroupIconsCellOfTypeOne.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/25.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYGroupIconsCellOfTypeOne.h"
#define cellWidth ((kAppScreenWidth - (3-1)*5)/3.0)
#define cellHeigth ((kAppScreenWidth - (3-1)*5)/3.0)

@implementation WYGroupIconsCellOfTypeOne

-(UIImageView *)iconIV{
    if (_iconIV == nil) {
        _iconIV = [UIImageView new];
        [self.contentView addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(37);
        }];
    }
    return _iconIV;
}

-(UILabel *)nameLb{
    if (_nameLb == nil) {
        _nameLb = [UILabel new];
        _nameLb.textAlignment = NSTextAlignmentCenter;
        _nameLb.textColor = kRGB(43, 161, 212);
        _nameLb.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(self.iconIV.mas_bottom).equalTo(7);
        }];
    }
    return _nameLb;
}
@end
