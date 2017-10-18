//
//  WYMediaListCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/9/27.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYMediaListCell.h"

@implementation WYMediaListCell

-(UIImageView *)iconIV{
    if (_iconIV == nil) {
        _iconIV = [UIImageView new];
        _iconIV.layer.cornerRadius = 21;
        _iconIV.clipsToBounds = YES;
        [self.contentView addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(8);
            make.width.height.equalTo(42);
        }];
    }
    return _iconIV;
}

-(UILabel *)nameLb{
    if (_nameLb == nil) {
        _nameLb = [UILabel new];
        _nameLb.textColor = UIColorFromHex(0x333333);
        _nameLb.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).equalTo(10);
            make.centerY.equalTo(self.iconIV.mas_centerY);
        }];
    }
    return _nameLb;
}

@end
