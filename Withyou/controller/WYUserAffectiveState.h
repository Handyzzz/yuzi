//
//  WYUserAffectiveState.h
//  Withyou
//
//  Created by Handyzzz on 2017/6/3.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYUserAffectiveState : UIViewController
@property (nonatomic,assign)NSString * str;
@property (nonatomic, copy)void(^doneClick)(NSString *str,NSInteger status);

@end
