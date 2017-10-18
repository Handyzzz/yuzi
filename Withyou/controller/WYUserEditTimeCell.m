//
//  WYUserEditTimeCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/3.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYUserEditTimeCell.h"

@implementation WYUserEditTimeCell

-(UILabel *)textLb{
    if (_textLb == nil) {
        _textLb = [UILabel new];
        _textLb.font = [UIFont systemFontOfSize:14];
        _textLb.textColor = UIColorFromHex(0x999999);
        [self.contentView addSubview:_textLb];
        [_textLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(0);
            make.bottom.equalTo(0);
        }];
    }
    return _textLb;
}

-(UILabel *)detailLb{
    if (_detailLb == nil) {
        _detailLb = [UILabel new];
        _detailLb.font = [UIFont systemFontOfSize:14];
        _detailLb.textColor = UIColorFromHex(0x333333);
        [self.contentView addSubview:_detailLb];
        [_detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(86);
            make.right.equalTo(-25);
            make.top.bottom.equalTo(0);
        }];
    }
    return _detailLb;
}

@end
