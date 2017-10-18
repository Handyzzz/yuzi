//
//  WYDescoverUserCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/5/25.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYDescoverUserCell.h"

@implementation WYDescoverUserCell

-(UIImageView *)iconIV{
    if (_iconIV == nil) {
        
        _iconIV = [UIImageView new];
        _iconIV.layer.cornerRadius = 40;
        _iconIV.clipsToBounds = YES;
        [self.contentView addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(15);
            make.left.equalTo(15);
            make.width.height.equalTo(80);
        }];
    }
    return _iconIV;
}
-(UILabel *)titleLb{
    if (_titleLb == nil) {
        _titleLb = [UILabel new];
        _titleLb.numberOfLines = 1;
        _titleLb.font = [UIFont systemFontOfSize:22];
        _titleLb.textColor = UIColorFromHex(0x333333);
        [self.contentView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(105);
            make.top.equalTo(16);
            make.right.equalTo(-50);
            make.height.equalTo(80);
        }];
    }
    return _titleLb;
}

@end
