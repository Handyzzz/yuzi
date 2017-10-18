//
//  YZNetBadView.m
//  Withyou
//
//  Created by CH on 2017/6/24.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZNetBadView.h"

@implementation YZNetBadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.5];
        
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 4;
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.equalTo(122);
            make.width.equalTo(285);
            make.height.equalTo(318);
        }];
        
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"searchpageAdresslistNowifi"];
        [view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.equalTo(0);
            make.width.equalTo(285);
            make.height.equalTo(178);
        }];
        
        UILabel *label = [UILabel new];
        [view addSubview:label];
        label.text = @"网络似乎开了小差哦~";
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = kRGB(51, 51, 51);
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.height.equalTo(55);
            make.top.equalTo(imageView.mas_bottom).equalTo(0);;
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"检查网络状况" forState:UIControlStateNormal];
        button.layer.cornerRadius = 2;
        button.clipsToBounds = YES;
        [button addTarget:self action:@selector(handleCheck) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = UIColorFromHex(0x2BA1D4);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(42);
            make.right.equalTo(-42);
            make.height.equalTo(50);
            make.top.equalTo(label.mas_bottom).equalTo(0);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

-(void)handleTap{
    [self removeFromSuperview];
}

-(void)handleCheck{
    NSURL *url = [NSURL URLWithString:@"App-Prefs:root=WIFI"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
