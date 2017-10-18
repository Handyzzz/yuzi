//
//  WYUserDetailGroupCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/13.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYUserDetailGroupCell.h"

@implementation WYUserDetailGroupCell



-(UIImageView *)iconIV{
    if (_iconIV == nil) {
        _iconIV = [UIImageView new];
        _iconIV.layer.cornerRadius = 2;
        _iconIV.clipsToBounds = YES;
        [self.contentView addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(14);
            make.width.height.equalTo(44);
        }];
    }
    return _iconIV;
}

-(UILabel *)textLb{
    if (_textLb == nil) {
        _textLb = [UILabel new];
        _textLb.textColor = UIColorFromHex(0x333333);
        _textLb.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_textLb];
        [_textLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).equalTo(10);
            make.centerY.equalTo(0);
            make.right.equalTo(-40);
        }];
    }
    return _textLb;
}
@end
