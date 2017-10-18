//
//  WYInviteUserJoinGroupCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/14.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYInviteUserJoinGroupCell.h"
@implementation WYInviteUserJoinGroupCell

-(UIImageView *)iconIV{
    if (_iconIV == nil) {
        _iconIV = [UIImageView new];
        _iconIV.layer.cornerRadius = 4;
        _iconIV.clipsToBounds = YES;
        _iconIV.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(10);
            make.width.height.equalTo(50);
        }];
    }
    return _iconIV;
}
-(UILabel *)nameLb{
    if (_nameLb == nil) {
        _nameLb = [UILabel new];
        _nameLb.font = [UIFont systemFontOfSize:16];
        _nameLb.textColor = [UIColor colorWithWhite:0 alpha:0.75];
        _nameLb.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(10);
            make.left.equalTo(self.iconIV.mas_right).equalTo(10);
        }];
    }
    return _nameLb;
}

-(UILabel *)relationLb{
    if (_relationLb == nil) {
        _relationLb = [UILabel new];
        _relationLb.font = [UIFont systemFontOfSize:12];
        _relationLb.textColor = kRGB(197, 197, 197);
        [self.contentView addSubview:_relationLb];
        [_relationLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).equalTo(10);
            make.top.equalTo(self.nameLb.mas_bottom).equalTo(10);
        }];
    }
    return _relationLb;
}

-(UIButton *)controlBTN{
    if (_controlBTN == nil) {
        _controlBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_controlBTN];
        _controlBTN.layer.borderWidth = 1;
        _controlBTN.layer.borderColor = kRGB(49,140,231).CGColor;
        _controlBTN.layer.cornerRadius = 2;
        _controlBTN.clipsToBounds = YES;
        _controlBTN.titleLabel.font = [UIFont systemFontOfSize:14];
        [_controlBTN addTarget:self action:@selector(handleControl:) forControlEvents:UIControlEventTouchUpInside];
        [_controlBTN mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.width.equalTo(60);
            make.height.equalTo(30);
            make.right.equalTo(-25);
        }];
    }
    return _controlBTN;
}

-(void)setCellData:(WYUser *)user IsInGroup:(BOOL)isInGroup relation:(NSInteger)status{
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:user.icon_url]];
    self.nameLb.text = user.fullName;
    if (status == 3) {
        self.relationLb.hidden = NO;
        self.relationLb.text = @"朋友";
    }else{
        self.relationLb.hidden = YES;
    }
    if (isInGroup) {
        [self.controlBTN setTitle:@"群成员" forState:UIControlStateNormal];
        self.controlBTN.enabled = NO;
        [self.controlBTN setTitleColor:kRGB(197, 197, 197) forState:UIControlStateNormal];
        self.controlBTN.layer.borderColor = kRGB(197, 197, 197).CGColor;

    }else{
        if (status == 3) {
            [self.controlBTN setTitle:@"添加" forState:UIControlStateNormal];
            [self.controlBTN setTitleColor:UIColorFromHex(0x2BA1D4) forState:UIControlStateNormal];
            self.controlBTN.layer.borderColor = UIColorFromHex(0x2BA1D4).CGColor;

            self.controlBTN.enabled = YES;
            self.controlBTN.tag = 1;
        }else{
            [self.controlBTN setTitle:@"邀请" forState:UIControlStateNormal];
            [self.controlBTN setTitleColor:UIColorFromHex(0x2BA1D4) forState:UIControlStateNormal];
            self.controlBTN.layer.borderColor = UIColorFromHex(0x2BA1D4).CGColor;

            self.controlBTN.enabled = YES;
            self.controlBTN.tag = 2;
        }
    }
}


- (void)handleControl:(UIButton *)button{
    button.enabled = NO;
    [button setTitleColor:kRGB(197, 197, 197) forState:UIControlStateNormal];
    button.layer.borderColor = kRGB(197, 197, 197).CGColor;

    if (button.tag == 1) {
        self.controlBlcok(WYInviteTypeAdd);
    }else{
        self.controlBlcok(WYinviteTypeInvite);
    }
}
@end
