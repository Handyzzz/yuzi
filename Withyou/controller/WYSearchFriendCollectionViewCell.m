//
//  WYSearchFriendCollectionViewCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/15.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYSearchFriendCollectionViewCell.h"

@implementation WYSearchFriendCollectionViewCell

#define imageWH (kAppScreenWidth - 15)/2.0


-(UIImageView *)iconIV{
    if (_iconIV == nil) {
        _iconIV = [UIImageView new];
        [self.contentView addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(0);
            make.width.equalTo(imageWH);
            make.height.equalTo(imageWH);
        }];
    }
    return _iconIV;
}

-(UILabel *)nameLb{
    if (_nameLb == nil) {
        _nameLb = [UILabel new];
        _nameLb.font = [UIFont systemFontOfSize:18];
        _nameLb.textColor = UIColorFromHex(0x333333);
        [self.contentView addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(5);
            make.centerY.equalTo(self.iconIV.mas_bottom).equalTo(18);
        }];
    }
    return _nameLb;
}

-(UILabel *)commonLb{
    if (_commonLb == nil) {
        _commonLb = [UILabel new];
        _commonLb.font = [UIFont systemFontOfSize:12];
        _commonLb.textColor = UIColorFromHex(0xc5c5c5);
        [self.contentView addSubview:_commonLb];
        [_commonLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(5);
            make.centerY.equalTo(self.nameLb.mas_centerY).equalTo(24);
        }];
    }
    return _commonLb;
}
-(UIImageView *)addIV{
    if (_addIV == nil) {
        _addIV = [UIImageView new];
        _addIV.userInteractionEnabled = YES;
        [self.contentView addSubview:_addIV];
        [_addIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(0);
            make.top.equalTo(self.iconIV.mas_bottom);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addClick)];
        [_addIV addGestureRecognizer:tap];
    }
    return _addIV;
}

-(void)addClick{
    self.addViewClick();
}
@end
