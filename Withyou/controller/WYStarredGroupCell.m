//
//  WYStarredGroupCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/28.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYStarredGroupCell.h"
#define iconWH 40
@implementation WYStarredGroupCell

-(UIImageView *)backIV{
    if (_backIV == nil) {
        _backIV = [UIImageView new];
        _backIV.image = [UIImage imageNamed:@"groupHeadbackground"];
        [self.contentView addSubview:_backIV];
        [_backIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(11);
            make.top.equalTo(4);
            make.width.height.equalTo(50);
        }];
    }
   
    return _backIV;
}

-(UIImageView *)iconIV{
    if (_iconIV == nil) {
        _iconIV = [UIImageView new];
        _iconIV.layer.cornerRadius = iconWH/2.0;
        _iconIV.clipsToBounds = YES;
        [self.backIV addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(0);
            make.width.height.equalTo(iconWH);
        }];
    }
    return _iconIV;
}

-(UILabel *)nameLb{
    if (_nameLb == nil) {
        _nameLb = [UILabel new];
        _nameLb.font = [UIFont systemFontOfSize:14 weight:0.4];
        _nameLb.textColor = kRGB(51, 51, 51);
        [self.contentView addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(67);
            make.right.equalTo(-150);
            make.top.equalTo(12);
        }];
    }
    return _nameLb;
}

-(UILabel *)desLb{
    if (_desLb == nil) {
        _desLb = [UILabel new];
        _desLb.font = [UIFont systemFontOfSize:13];
        _desLb.textColor = kRGB(153, 153, 153);
        [self.contentView addSubview:_desLb];
        [_desLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(67);
            make.right.equalTo(-150);
            make.bottom.equalTo(-12);
        }];
    }
    return _desLb;
}

-(UILabel *)unReadLb{
    if (_unReadLb == nil) {
        _unReadLb = [UILabel new];
        _unReadLb.font = [UIFont systemFontOfSize:12];
        _unReadLb.textColor = kRGB(43, 161, 212);
        [self.contentView addSubview:_unReadLb];
        [_unReadLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.right.equalTo(-15);
        }];
    }
    return _unReadLb;
}

-(UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [UIView new];
        _lineView.backgroundColor = UIColorFromHex(0xf5f5f5);
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.width.equalTo(kAppScreenWidth - 15);
            make.height.equalTo(1);
            make.bottom.equalTo(0);
        }];
    }
    return _lineView;
}

@end
