//
//  YZPostRemindView.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/24.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZPostRemindView.h"

@implementation YZPostRemindView

-(UITextView *)remindTV{
    if (_remindTV == nil) {
        _remindTV = [UITextView new];
        _remindTV.font = [UIFont systemFontOfSize:kPostWithWhomFont.pointSize];
                
        _remindTV.textColor = kRGB(67, 198, 172);
        _remindTV.editable = NO;
        _remindTV.scrollEnabled = NO;
        _remindTV.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
        _remindTV.textContainer.lineFragmentPadding = 0;
        _remindTV.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self addSubview:_remindTV];
        [_remindTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(25);
            make.right.equalTo(0);
            make.top.equalTo(0);
        }];
    }
    return _remindTV;
}

-(UIImageView *)iconIV{
    if (_iconIV == nil) {
        _iconIV = [UIImageView new];
        _iconIV.image = [UIImage imageNamed:@"shareWithwho"];
        [self addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(0);
        }];
    }
    return _iconIV;
}
@end
