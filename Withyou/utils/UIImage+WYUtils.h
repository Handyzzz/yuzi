//
//  UIImage+WYUtils.h
//  Withyou
//
//  Created by Tong Lu on 7/22/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPost.h"

@interface UIImage (WYUtils)

+ (CGFloat)getHeightOfImageViewFromPost:(WYPost *)post;
+ (CGFloat)getHeightOfImageViewFromPostWithNoLimit:(WYPost *)post;

+ (CGFloat)getHeightOfImageViewFromPost:(WYPost *)post WithInWidth:(CGFloat)width;
+ (CGFloat)getHeightOfImageViewFromOriginalHeight:(CGFloat)height Width:(CGFloat)width WithInWidth:(CGFloat)widthLimit;
//+ (CGFloat)getLinkImageViewHeightFromPost:(WYPost *)post withinWidth:(CGFloat)width;
+ (void)removeImage:(NSString *)fileName;
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (BOOL)compareFirstimage:(UIImage *)image1 isEqualTo:(UIImage *)image2;

+ (CGFloat)getHeightOfWidth:(CGFloat)width Height:(CGFloat)height inWidth:(CGFloat)scaleWidth;
+ (CGFloat)getHeightOfImageViewForVideoFromPost:(WYPost *)post;
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

@end
