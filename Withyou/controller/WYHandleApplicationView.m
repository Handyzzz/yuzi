//
//  WYHandleApplicationView.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/11.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYHandleApplicationView.h"

@implementation WYHandleApplicationView

-(UILabel *)msgLb{
    if (_msgLb == nil) {
        _msgLb = [UILabel new];
        _msgLb.textColor = kRGB(51, 51, 51);
        _msgLb.font = [UIFont systemFontOfSize:15];
        [self addSubview:_msgLb];
       
    }
    return _msgLb;
}

-(UIImageView *)statusIV{
    if (_statusIV == nil) {
        _statusIV = [UIImageView new];
        [self addSubview:_statusIV];
      
    }
    return _statusIV;
}

-(UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [UIView new];
        _lineView.backgroundColor = UIColorFromHex(0xf5f5f5);
        [self addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(0);
            make.left.equalTo(15);
            make.right.equalTo(-15);
            make.height.equalTo(1);
        }];
    }
    return _lineView;
}

-(void)setUpView:(WYApplicationType)type{
    switch (type) {
        case WYWrongViewApplicationHaveExpired:
        {
            self.msgLb.text = @"该申请已失效";
            self.statusIV.image = [UIImage imageNamed:@"groupapplicationExpired_20"];
            [self setUpFrameTypeOfHorizontal];
        }
            break;
        case WYWrongViewApplicationHaveRefused:
        {
            self.msgLb.text = @"你已拒绝该申请";
            self.statusIV.image = [UIImage imageNamed:@"groupapplicationDisagree_20"];
            [self setUpFrameTypeOfHorizontal];

        }
            break;
        case WYWrongViewApplicationHaveAccept:
        {
            self.msgLb.text = @"你已接受该申请";
            self.statusIV.image = [UIImage imageNamed:@"groupapplicationAgree_20"];
            [self setUpFrameTypeOfHorizontal];

        }
            break;
        case WYWrongViewApplicationMeNotInGroup:
        {
            
            self.msgLb.text = @"请确认此群组是否存在，并且自己是管理员";
            self.statusIV.image = [UIImage imageNamed:@"groupapplicationDisagree"];
            [self setUpFrameTypeOfVertical];
        }
            break;
        default:
            break;
    }
    [self lineView];
}

-(void)setUpFrameTypeOfHorizontal{
    [_msgLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.centerX.equalTo((20 + 8)/2);
    }];
    [_statusIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.msgLb.mas_left).equalTo(-8);
        make.centerY.equalTo(0);
    }];
}
-(void)setUpFrameTypeOfVertical{
    [_statusIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(35);
        make.centerX.equalTo(0);
    }];
    [_msgLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusIV.mas_bottom).equalTo(25);
        make.centerX.equalTo(0);
    }];
}
@end
