//
//  WYFollowListCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/21.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYFollowListCell.h"
#import "WYFollow.h"

@implementation WYFollowListCell

-(UIImageView *)iconIV{
    if (_iconIV == nil) {
        _iconIV = [UIImageView new];
        _iconIV.layer.cornerRadius = 21;
        _iconIV.clipsToBounds = YES;
        [self.contentView addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(10);
            make.width.height.equalTo(42);
        }];
    }
    return _iconIV;
}

-(UILabel *)nameLb{
    if (_nameLb == nil) {
        _nameLb = [UILabel new];
        _nameLb.textColor = UIColorFromHex(0x333333);
        _nameLb.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).equalTo(10);
            make.centerY.equalTo(self.iconIV.mas_centerY);
        }];
    }
    return _nameLb;
}

-(UILabel *)friendLb{
    if (_friendLb == nil) {
        _friendLb = [UILabel new];
        _friendLb.textColor = UIColorFromHex(0x333333);
        _friendLb.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_friendLb];
        [_friendLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).equalTo(10);
            make.bottom.equalTo(self.iconIV.mas_centerY).equalTo(-2.5);
        }];
    }
    return _friendLb;
}

-(UILabel *)relationLb{
    if (_relationLb == nil) {
        _relationLb = [UILabel new];
        _relationLb.font = [UIFont systemFontOfSize:12];
        _relationLb.textColor = UIColorFromHex(0x999999);
        [self.contentView addSubview:_relationLb];
        [_relationLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).equalTo(10);
            make.top.equalTo(self.iconIV.mas_centerY).equalTo(2.5);
        }];
    }
    return _relationLb;
}




/*
 用mas布局替换掉的时候不能用不同的约束
 */

-(void)setCellData:(WYUser *)user relationShip:(NSInteger )statu{
    //如果是我的朋友
    if (statu == 3) {
        self.friendLb.hidden = NO;
        self.relationLb.hidden = NO;
        self.nameLb.hidden = YES;
        
        [self.iconIV sd_setImageWithURL:[NSURL URLWithString:user.icon_url]];
        self.friendLb.text = user.fullName;
        self.relationLb.text = @"好友";
        
    }else{
        self.friendLb.hidden = YES;
        self.relationLb.hidden = YES;
        self.nameLb.hidden = NO;
        
        [self.iconIV sd_setImageWithURL:[NSURL URLWithString:user.icon_url]];
        self.nameLb.text = user.fullName;
    }
}
-(void)setCellData:(WYUser *)user{
    self.friendLb.hidden = NO;
    self.relationLb.hidden = NO;
    self.nameLb.hidden = YES;
    
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:user.icon_url]];
    self.friendLb.text = user.fullName;
    self.relationLb.text = user.account_name;
}

@end
