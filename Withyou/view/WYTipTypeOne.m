//
//  WYTipTypeOne.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/27.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYTipTypeOne.h"

static WYTipTypeOne *instance = nil;
static BOOL restart = NO;

@interface WYTipTypeOne()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *label;

@end

@implementation WYTipTypeOne

-(instancetype)initWithMsg:(NSString *)msg imageWith:(NSString *)image;{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        UIWindow *currentWindows = [UIApplication sharedApplication].keyWindow;
        [self setUpView:msg imageWith:(NSString *)image];
        [currentWindows addSubview:self];
    }
    return self;
}

-(void)setUpView:(NSString *)msg imageWith:(NSString *)image{
    
    self.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.7];

    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 2;
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.equalTo(240);
        make.height.equalTo(127);
    }];
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:image];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(25);
    }];
    self.imageView = imageView;
    
    UILabel *label = [UILabel new];
    [view addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = msg;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = kRGB(51, 51, 51);
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-40);
        make.centerX.equalTo(0);
        make.width.equalTo(200);
    }];
    self.label = label;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self addGestureRecognizer:tap];
}

-(void)handleTap{
    instance = nil;
    [self removeFromSuperview];
}

+ (void)showWithMsg:(NSString *)msg imageWith:(NSString *)image {
    [WYTipTypeOne showWithMsg:msg imageWith:image delay:2.0];
}
+ (void)showWithMsg:(NSString *)msg imageWith:(NSString *)image delay:(int)second {
    if(instance) {
        instance.label.text = msg;
        instance.imageView.image = [UIImage imageNamed:image];
        restart = YES;
    }else {
        instance = [[WYTipTypeOne alloc] initWithMsg:msg imageWith:image];
    }
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second *NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        if(restart) {
            restart = NO;
            return ;
        }
        [instance removeFromSuperview];
        instance = nil;
    });
}

@end
