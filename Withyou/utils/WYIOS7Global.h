//
//  WYIOS7Global.h
//  Withyou
//
//  Created by jialei on 14-4-30.
//  Copyright (c) 2014年 Withyou Inc. All rights reserved.
//

#ifndef Withyou_WYIOS7Global_h
#define Withyou_WYIOS7Global_h

#define kStatusbarAddWhenCalling ([UIApplication sharedApplication].statusBarFrame.size.height == 40.f ? 20.f : 0.f)

#define kAppScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kMarginLeftWidth    22

#define kAppScreenHeight ([UIScreen mainScreen].bounds.size.height)

#define kAppScreenHeighAbsolute [UIScreen mainScreen].bounds.size.height

#define kHeadSelectViewBottom ([[UIDevice currentDevice].systemVersion floatValue] < 7.f ? kHeaderHeightWithoutBottom : 0.f)
#define kHeadSelectViewHeight ([[UIDevice currentDevice].systemVersion floatValue] >= 7.f ? kHeaderHeightWithoutBottom : 0.f)

#define kToolbarViewTop ([[UIDevice currentDevice].systemVersion floatValue] < 7.f ? kToolbarHeightWithoutShadow : 0.f)

#define kToolbarViewHeight ([[UIDevice currentDevice].systemVersion floatValue] >= 7.f ? kToolbarHeightWithoutShadow : 0.f)

#define kStatusHeight (20)
#define kStatusAndBarHeight ([[UIDevice currentDevice].systemVersion floatValue] >= 7.f ? 64 : 44)
#define kDefaultBarHeight 44

#define SINGLE_LINE_WIDTH  (1 / [UIScreen mainScreen].scale)

#define PlaceHolderImage [UIImage imageNamed:@"111111-0.png"]

#ifdef DEBUG
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define debugLog(...)
#define debugMethod()
#endif

#endif



