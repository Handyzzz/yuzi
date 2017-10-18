//
//  WYPostTagView.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/18.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYPostTagView.h"

@implementation WYPostTagView

-(UITextView *)tagTextView{
    if (_tagTextView == nil) {
        _tagTextView = [UITextView new];
        _tagTextView.textColor = kRGB(153, 153, 153);
        _tagTextView.editable = NO;
        _tagTextView.scrollEnabled = NO;
        _tagTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
        _tagTextView.textContainer.lineFragmentPadding = 0;
        _tagTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self addSubview:_tagTextView];
        [_tagTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(25);
            make.right.equalTo(0);
            make.top.equalTo(0);
        }];
    }
    return _tagTextView;
}

-(UIImageView *)iconIV{
    if (_iconIV == nil) {
        _iconIV = [UIImageView new];
        _iconIV.image = [UIImage imageNamed:@"publish_share_tag"];
        [self addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(0);
        }];
    }
    return _iconIV;
}

@end
