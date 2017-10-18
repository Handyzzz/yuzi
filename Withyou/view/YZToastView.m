//
//  YZToastView.m
//  Withyou
//
//  Created by ping on 2017/3/8.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZToastView.h"




@implementation YZToastView

+ (void)showToastWithTitle:(NSString *)title {
    [YZToastView showToastWithTitle:title duration:2];
}

+ (void)showToastWithTitle:(NSString *)title duration:(NSTimeInterval)time {
    
    CGFloat margin = 50;
    CGSize size = [title boundingRectWithSize:CGSizeMake(kAppScreenWidth - 2 * margin, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                   attributes:@{
                                                NSFontAttributeName : [UIFont systemFontOfSize:12]
                                                } context:nil].size;
    // 加点padding
    size.height = size.height + 10;
    size.width = size.width + 20;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake((kAppScreenWidth - size.width) / 2, kAppScreenHeight, size.width,size.height)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    label.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8];
    label.layer.cornerRadius = 5;
    label.layer.masksToBounds = YES;
    
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    
    [UIView animateWithDuration:.2 animations:^{
        // 从底部 往上弹出的动画
        CGRect frame = label.frame;
        frame.origin.y = kAppScreenHeight - frame.size.height - 2 * margin;
        label.frame = frame;
    } completion:^(BOOL finished) {
        
        double delayInSeconds = time;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        // 逐渐透明消失
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [UIView animateWithDuration:.5 animations:^{
                label.alpha = 0;
            } completion:^(BOOL finished) {
                [label removeFromSuperview];
            }];
        });
    }];
}


@end
