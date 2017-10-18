//
//  WYArticleStarCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/9/29.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYArticleStarCell.h"

@implementation WYArticleStarCell

-(UIImageView *)iconIV{
    if (_iconIV == nil) {
        _iconIV = [UIImageView new];
        _iconIV.layer.cornerRadius = 17;
        _iconIV.clipsToBounds = YES;
        [self.contentView addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(13);
            make.top.equalTo(11);
            make.width.equalTo(34);
            make.height.equalTo(34);
        }];
    }
    return _iconIV;
}

-(UILabel *)nameLb{
    if (_nameLb == nil) {
        _nameLb = [UILabel new];
        _nameLb.font = [UIFont systemFontOfSize:14];
        _nameLb.textColor = UIColorFromHex(0x333333);
        [self.contentView addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).equalTo(9);
            make.centerY.equalTo(self.iconIV);
        }];
    }
    return _nameLb;
}

-(UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [UIView new];
        _lineView.backgroundColor = UIColorFromHex(0xf5f5f5);
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.width.equalTo(kAppScreenWidth);
            make.height.equalTo(1);
            make.bottom.equalTo(0);
        }];
    }
    return _lineView;
}
@end
