//
//  WYAcceptInviteCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/11.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYAcceptInviteCell.h"

@implementation WYAcceptInviteCell

-(UIImageView *)iconIV{
    if (_iconIV == nil) {
        _iconIV = [UIImageView new];
        _iconIV.layer.cornerRadius = 21;
        _iconIV.clipsToBounds = YES;
        [self.contentView addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(15);
            make.left.equalTo(15);
            make.width.height.equalTo(42);
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
            make.top.equalTo(21);
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
            make.top.equalTo(self.nameLb.mas_bottom).equalTo(6);
            make.right.equalTo(-50);
        }];
    }
    return _accountNameLb;
}

-(UILabel *)timeLb{
    if (_timeLb == nil) {
        _timeLb = [UILabel new];
        _timeLb.textAlignment = NSTextAlignmentRight;
        _timeLb.textColor = kRGB(153, 153, 153);
        _timeLb.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeLb];
        [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.right.equalTo(-15);
        }];
    }
    return _timeLb;
}

@end
