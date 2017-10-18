//
//  WYTipTypeOne.h
//  Withyou
//
//  Created by Handyzzz on 2017/6/27.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


#define WYTipTypeOneImageSuccess @"groupapplicationAgree"
#define WYTipTypeOneImageFail @"groupapplicationDisagree"

@interface WYTipTypeOne : UIView

//上边图片 下边title

+ (void)showWithMsg:(NSString *)msg imageWith:(NSString *)image;
+ (void)showWithMsg:(NSString *)msg imageWith:(NSString *)image delay:(int)second;

@end
