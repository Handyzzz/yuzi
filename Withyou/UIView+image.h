//
//  UIView+image.h
//  Withyou
//
//  Created by Handyzzz on 2017/8/3.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (image)
//获得某个范围内的屏幕图像
- (UIImage *)WYImageAtFrame:(CGRect)rect;
@end
