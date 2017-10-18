
//
//  WYPublishTagListSimilarCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/19.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYPublishTagListSimilarCell.h"

@implementation WYPublishTagListSimilarCell


-(UIImageView *)iconIV{
    if (_iconIV == nil) {
        _iconIV = [UIImageView new];
        [self.contentView addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(18);
            make.width.equalTo(16);
            make.height.equalTo(16);
        }];
    }
    return _iconIV;
}

-(UILabel *)titleLb{
    if (_titleLb == nil) {
        _titleLb = [UILabel new];
        _titleLb.font = [UIFont systemFontOfSize:14];
        _titleLb.textColor = kRGB(51, 51, 51);
        [self.contentView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).equalTo(10);
            make.centerY.equalTo(self.iconIV);
            make.right.equalTo(-20);
        }];
    }
    return _titleLb;
}

-(UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [UIView new];
        _lineView.backgroundColor = UIColorFromHex(0xf5f5f5);
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(1);
        }];
    }
    return _lineView;
}


@end
