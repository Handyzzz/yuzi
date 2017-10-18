//
//  WYPlaceholderView.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/16.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYPlaceholderView.h"

@implementation WYPlaceholderView
-(instancetype)initWithImage:(NSString*)imageName msg:(NSString*)msg imgW:(CGFloat)imgW imgH:(CGFloat)imgH{
    if (self = [super initWithFrame:CGRectMake(0, kStatusAndBarHeight, kAppScreenWidth, kAppScreenHeight - kStatusAndBarHeight)]) {
        self.backgroundColor = [UIColor whiteColor];
        _iconIV = [UIImageView new];
        _iconIV.image = [UIImage imageNamed:imageName];
        [self addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(imgW);
            make.height.equalTo(imgH);
            make.centerX.equalTo(0);
            make.bottom.equalTo(self.mas_centerY);
        }];
        
        _msgLb = [UILabel new];
        _msgLb.text = msg;
        _msgLb.numberOfLines = 0;
        _msgLb.textAlignment = NSTextAlignmentCenter;
        _msgLb.font = [UIFont systemFontOfSize:12];
        _msgLb.textColor = kRGB(197, 197, 197);
        [self addSubview:_msgLb];
        [_msgLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_iconIV.mas_bottom).equalTo(10);
            make.left.equalTo(100);
            make.right.equalTo(-100);
        }];
    }
    return self;
}

@end
