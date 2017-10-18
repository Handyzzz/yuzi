
//
//  WYMsgCategoryListCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/5.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYMsgCategoryListCell.h"

@implementation WYMsgCategoryListCell
/*
 @property(nonatomic,strong)UIImageView *iconIV;
 @property(nonatomic,strong)UILabel *nameLb;
 @property(nonatomic,strong)UILabel *countLb;
 */
-(UIImageView *)iconIV{
    if (_iconIV == nil) {
        _iconIV = [UIImageView new];
        _iconIV.contentMode = UIViewContentModeScaleAspectFit;
        _iconIV.clipsToBounds = YES;
        _iconIV.layer.cornerRadius = 4.0;
        _iconIV.clipsToBounds = YES;
        [self.contentView addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.centerY.equalTo(0);
            make.width.height.equalTo(22);
        }];
    }
    return _iconIV;
}

-(UILabel *)nameLb{
    if (_nameLb == nil) {
        _nameLb = [UILabel new];
        _nameLb.textColor = kRGB(51, 51, 51);
        _nameLb.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).equalTo(10);
            make.centerY.equalTo(0);
        }];
    }
    return _nameLb;
}

-(UILabel *)countLb{
    if (_countLb == nil) {
        _countLb = [UILabel new];
        _countLb.textColor = kRGB(153, 153, 153);
        _countLb.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_countLb];
        [_countLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLb.mas_right).equalTo(5);
            make.centerY.equalTo(0);
        }];
    }
    return _countLb;
}

-(UIView*)lineView{
    if (_lineView == nil) {
        _lineView = [UIView new];
        _lineView.backgroundColor =  UIColorFromHex(0xf5f5f5);
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
