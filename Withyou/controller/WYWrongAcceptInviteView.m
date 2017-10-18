//
//  WYWrongAcceptInviteView.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/27.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYWrongAcceptInviteView.h"

@implementation WYWrongAcceptInviteView

//@property(nonatomic, strong)UIImageView *statusIV;
//@property(nonatomic, strong)UILabel *msgLb;
//@property(nonatomic, strong)UIImageView *goIV;
//@property(nonatomic, strong)UILabel*actionLb;

-(UIImageView*)statusIV{
    if (!_statusIV) {
        _statusIV = [UIImageView new];
        [self addSubview:_statusIV];
        [_statusIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(35);
            make.centerX.equalTo(0);
        }];
    }
    return _statusIV;
}

-(UILabel *)msgLb{
    if (!_msgLb) {
        _msgLb = [UILabel new];
        [self addSubview:_msgLb];
        _msgLb.font = [UIFont systemFontOfSize:14];
        _msgLb.textAlignment = NSTextAlignmentCenter;
        _msgLb.textColor = kRGB(51, 51, 51);
        [_msgLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.statusIV.mas_bottom).equalTo(25);
            make.centerX.equalTo(0);
        }];
    }
    return _msgLb;
}



-(UILabel *)actionLb{
    if (!_actionLb) {
        _actionLb = [UILabel new];
        [self addSubview:_actionLb];
        _actionLb.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goClick)];
        [_actionLb addGestureRecognizer:tap];
        _actionLb.textColor = UIColorFromHex(0x2BA1D4);
        _actionLb.font = [UIFont systemFontOfSize:16];
        [_actionLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.msgLb.mas_bottom).equalTo(25);
            make.centerX.equalTo(self.centerX).equalTo(15);
        }];
    }
    return _actionLb;
}

-(UIImageView *)goIV{
    if (!_goIV) {
        _goIV = [UIImageView new];
        [self addSubview:_goIV];
        _goIV.image = [UIImage imageNamed:@"page1"];
        [_goIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.msgLb.mas_bottom).equalTo(25);
            make.right.equalTo(self.actionLb.mas_left).equalTo(-8);
        }];
    }
    return _goIV;
}

-(void)setUpView:(WYInviteType)type groupInvitation:(WYGroupInvitation *)invitation{
    
    /*
     WYWrongViewHaveInGroup = 0,
     WYWrongViewHaveAccept = 1,
     WYWrongViewPrivacy = 2,
     WYWrongViewLoseToApply = 3,
     WYWrongViewLoseToConnection = 4
     */
    self.type = type;
    
    switch (type) {
        case WYWrongViewHaveInGroup:
        {
            self.statusIV.image = [UIImage imageNamed:@"groupapplicationAgree"];
            self.msgLb.text = @"你已是群成员";
            [self goIV];
            self.actionLb.text = @"进入群组";
        }
            break;
        case WYWrongViewHaveAccept:
        {
            self.statusIV.image = [UIImage imageNamed:@"groupapplicationAgree"];
            self.msgLb.text = @"你已接受该邀请";
            [self goIV];
            self.actionLb.text = @"进入群组";
        }
            break;
        case WYWrongViewLoseToApply:{
            self.statusIV.image = [UIImage imageNamed:@"groupapplicationDisagree"];
            self.msgLb.text = @"该邀请已失效";
            [self goIV];
            self.actionLb.text = @"申请加入";
        }
            break;
        case WYWrongViewLoseToConnection:{
            self.statusIV.image = [UIImage imageNamed:@"groupapplicationDisagree"];
            self.msgLb.text = @"该邀请已失效";
            [self goIV];
            self.actionLb.text = [NSString stringWithFormat:@"联系%@",invitation.from_user.fullName];
        }
            break;
            
        default:
            break;
    }
}

-(void)goClick{
    self.actionLbClick(self.type);
}

@end
