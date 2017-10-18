
//
//  WYGroupInviterCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/11.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYGroupInviterCell.h"

@implementation WYGroupInviterCell
//h = 90
-(UIImageView *)iconIV{
    if (_iconIV == nil) {
        _iconIV = [UIImageView new];
        _iconIV.layer.cornerRadius = 30;
        _iconIV.clipsToBounds = YES;
        [self.contentView addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(15);
            make.left.equalTo(15);
            make.width.height.equalTo(60);
        }];
    }
    return _iconIV;
}

-(UILabel *)nameLb{
    if (_nameLb == nil) {
        _nameLb = [UILabel new];
        _nameLb.font = [UIFont systemFontOfSize:14];
        _nameLb.textColor = kRGB(51, 51, 51);
        [self.contentView addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).equalTo(8);
            make.top.equalTo(30);
            make.right.equalTo(-50);
        }];
    }
    return _nameLb;
}

-(UILabel *)accountNameLb{
    if (_accountNameLb == nil) {
        _accountNameLb = [UILabel new];
        _accountNameLb.font = [UIFont systemFontOfSize:12];
        _accountNameLb.textColor = kRGB(153, 153, 153);
        [self.contentView addSubview:_accountNameLb];
        [_accountNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).equalTo(8);
            make.top.equalTo(self.nameLb.mas_bottom).equalTo(7);
            make.right.equalTo(-50);
        }];
    }
    return _accountNameLb;
}
@end
