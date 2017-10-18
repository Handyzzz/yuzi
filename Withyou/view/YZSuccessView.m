//
//  YZSuccessView.m
//  Withyou
//
//  Created by CH on 2017/6/24.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZSuccessView.h"

@implementation YZSuccessView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.5];
        
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 2;
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.width.equalTo(145);
            make.height.equalTo(87);
        }];
        
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"oval2"];
        [view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.equalTo(32);
            make.width.equalTo(16);
            make.height.equalTo(16);
        }];
        
        UILabel *label = [UILabel new];
        [view addSubview:label];
        label.text = @"发送成功";
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = kRGB(51, 51, 51);
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(54);
            make.top.equalTo(0);
            make.bottom.equalTo(0);
            make.right.equalTo(0);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

-(void)handleTap{
    [self removeFromSuperview];
}

@end
