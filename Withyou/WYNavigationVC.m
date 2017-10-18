//
//  WYNavigatiojnVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/23.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYNavigationVC.h"

@interface WYNavigationVC ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@end

@implementation WYNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak WYNavigationVC *weakSelf = self;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
}

#pragma UIGestureRecognizerDelegate
//导航栏的底层第一个是不用边缘侧滑的
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.childViewControllers count] == 1) {
        return NO;
    }
    return YES;
}

// 手势冲突的问题 让 ViewController 同时接受多个手势吧。
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
//被 pop 的 ViewController 中的 UIScrollView 会跟着一起滚动
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}



@end
