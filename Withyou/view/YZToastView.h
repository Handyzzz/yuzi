//
//  YZToastView.h
//  Withyou
//
//  Created by ping on 2017/3/8.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZToastView : UIView

// 类似 Android的Toast 轻量提示
+(void)showToastWithTitle:(NSString *)title;
+(void)showToastWithTitle:(NSString *)title duration:(NSTimeInterval)time;

@end
