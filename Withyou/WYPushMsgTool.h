//
//  WYPushMsgTool.h
//  Withyou
//
//  Created by Handyzzz on 2017/3/18.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Hyphenate/Hyphenate.h>
#import "RootTabBarController.h"
//推送的工具类
//注册的头文件 写成这样的好处是 防止低版本的找不到头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "YZChatViewController.h"

@interface WYPushMsgTool : NSObject


//申请通知权限
+(void)applyPushNotificationAuthorizationCenter:(UNUserNotificationCenter*)center Application:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions;

+(void)tenVersionForegroundType:(UNNotification *)notification TabVC:(RootTabBarController *)tabVC;
+(void)tenVersionForegroundAndBackgroundType:(UNNotificationResponse *)response TabVC:(RootTabBarController *)tabVC;
+(void)lowVersion:(NSDictionary *)userInfo Application:(UIApplication *)application;


+(void)handleActionOnReceiveMessage:(EMMessage *)message;
+(void)onOpenLocalNotification:(UIApplication *)application notification:(UILocalNotification *)notification;

@end
