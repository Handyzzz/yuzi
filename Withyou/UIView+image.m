//
//  UIView+image.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/3.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "UIView+image.h"

@implementation UIView (image)
//获得某个范围内的屏幕图像
- (UIImage *)WYImageAtFrame:(CGRect)rect{
    
    /*
     不清晰
     UIGraphicsBeginImageContext(self.frame.size);
     */
    //scale 1也是不清晰的 0.0高清
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(rect);
    [self.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  theImage;
}

@end
