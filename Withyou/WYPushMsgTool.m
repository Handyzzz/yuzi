//
//  WYPushMsgTool.m
//  Withyou
//
//  Created by Handyzzz on 2017/3/18.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYPushMsgTool.h"
#import "WYAccountApi.h"
#import "RootPageVC.h"
#import "YZPostDetailVC.h"
#import "WYGroupDetailVC.h"
#import "WYGroup.h"
#import "WYAcceptInviteVC.h"
#import "WYFollow.h"
#import "WYUtility.h"
#import "RootPageVC.h"
#import "WYUserVC.h"
#import "WYMessageCategory.h"

@interface WYPushMsgTool()
@end

@implementation WYPushMsgTool

/*
 申请通知权限
 */
+(void)applyPushNotificationAuthorizationCenter:(UNUserNotificationCenter *)center Application:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
    if (IOS10_OR_LATER) {
        application.applicationIconBadgeNumber = 0;
        //iOS 10 later
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error && granted) {
                //用户点击允许
                NSLog(@"注册远程推送用户之前已经允许");
            }else{
                //用户点击不允许
                NSLog(@"注册远程推送失败，或用户之前已禁止");
            }
        }];
        
        /*
         可以通过 getNotificationSettingsWithCompletionHandler 获取权限设置
         之前注册推送服务，用户点击了同意还是不同意，以及用户之后又做了怎样的更改我们都无从得知，现在 apple 开放了这个 API，我们可以直接获取到用户的设定信息了注意
         UNNotificationSettings是只读对象不能直接修改
         */
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
            
            
            if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
                //用户没有做出选择的时候
                //TODO:
                [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    if (granted) {
                    } else {
                        
                    }
                }];
                
            } else if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
                //推送被用户拒绝了
                //TODO:
                
            } else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                //推送被用户接受了
                //TODO:
                
            }
        }];
    }else if (IOS8_OR_LATER){
        
        //iOS 8 - iOS 10系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
        application.applicationIconBadgeNumber = 0;
        
    }else{
        //iOS 8.0系统以下
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    
    //注册远端消息通知获取device token
    [application registerForRemoteNotifications];
    
    // 如果是从点击通知 启动app
//    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    if(userInfo) {
//        [WYPushMsgTool lowVersion:userInfo Application:application];
//    }
}

//iOS10 前台自动
+(void)tenVersionForegroundType:(UNNotification *)notification TabVC:(RootTabBarController *)tabVC{

    /*
     NSDictionary *apsDic = [content.userInfo objectForKey:@"aps"];
     NSDictionary *alert = [apsDic objectForKey:@"alert"];
     NSDictionary *sound = [apsDic objectForKey:@"sound"];
     NSString *title = [alert objectForKey:@"title"];
     NSString *body = [alert objectForKey:@"body"];
     int type = [[userInfo objectForKey:@"type"] intValue];
     NSString *target = [userInfo objectForKey:@"target"];
     */
    
    //刷新Msg表
    [self updateMsgCategory];
    
    //收到推送的请求
    UNNotificationRequest *request = notification.request;
    
    //收到推送的内容
    UNNotificationContent *content = request.content;
    
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    
    //收到推送消息body
    NSString *body = content.body;
    
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    
    // 推送消息的标题
    NSString *title = content.title;
    
    //推送的类型
    int pushType = [[userInfo objectForKey:@"type"] intValue];
    
    //收到的UUID
    //    NSString *target = [userInfo objectForKey:@"target"];
    
    
    // 有f 字段则为环信的推送消息
    if([WYPushMsgTool handledEasemobMessage:userInfo]) return;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //此处省略一万行需求代码。。。。。。
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
        switch (pushType) {
            case 1:
            {
                //当别人关注了我的时候更新一下follow 到数据库 如果在前台就算不点击也会更新
                [WYFollow listFollowBlock:^(NSArray *followList, NSArray *userList, NSArray *uuidList) {
                    //更新数据后 如果帮用户刷新是不是不太好  会强制性的闪一下
                }];
                break;
            }
            case 2:
            {
                break;
            }
            case 3:
            {
                break;
            }
            case 4:
                break;
            case 5:
                break;
            case 6:
                break;
            case 7:
                break;
                
            default:
                break;
        }
    }else {
        // 判断为本地通知
    }
}

//iOS10 前台后台或者后台 点击
+(void)tenVersionForegroundAndBackgroundType:(UNNotificationResponse *)response TabVC:(RootTabBarController *)tabVC{
    
    //刷新Msg表
    [self updateMsgCategory];
    
    /*
     NSDictionary *apsDic = [content.userInfo objectForKey:@"aps"];
     NSDictionary *alert = [apsDic objectForKey:@"alert"];
     NSDictionary *sound = [apsDic objectForKey:@"sound"];
     NSString *title = [alert objectForKey:@"title"];
     NSString *body = [alert objectForKey:@"body"];
     int type = [[userInfo objectForKey:@"type"] intValue];
     NSString *target = [userInfo objectForKey:@"target"];
     
     */
    //收到推送的请求
    UNNotificationRequest *request = response.notification.request;
    
    //收到推送的内容
    UNNotificationContent *content = request.content;
    
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    
    //收到推送消息body
    NSString *body = content.body;
    
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    
    // 推送消息的标题
    NSString *title = content.title;
    
    //推送的类型
    int pushType = [[userInfo objectForKey:@"type"] intValue];
    
    //收到的UUID
    NSString *target = [userInfo objectForKey:@"target"];
    
    /*获取当前的 VC  然后跳转的时候通过当前的VC的导航跳转到对应的页面 这样就可以返回按钮回来*/
    //如果想从我们想跳转到的目标VC的栈的前一个VC跳转到这个页面 前一个可能还不存在
    
    
    // 有f 字段则为环信的推送消息
    if([WYPushMsgTool handledEasemobMessage:userInfo]) return;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //此处省略一万行需求代码。。。。。。
        
        /*
         #define kNotificationNewPostUpdateUser @"receivedNewPostUpdateUser"
         #define kNotificationNewPostUpdatePost @"receivedNewPostUpdatePost"
         #define kNotificationNewPostUpdateMsg @"receivedNewPostUpdateMsg"
         #define kNotificationNewPostUpdateGroup @"receivedNewPostUpdateGroup"
         */
        
        if (userInfo) {
            
            switch (pushType) {
                case 1:
                {
                    [self toUserAction:target];
                    break;
                }
                    
                case 2:
                {
                    [self toPostDetailAction:target];
                    break;
                    
                }
                case 3:
                {
                    [self toPostDetailAction:target];
                    break;
                }
                case 4:
                {
                    [self toPostDetailAction:target];
                    break;
                    
                }
                case 5:
                {
                    [self toUserAction:target];
                    break;
                }
                case 6:
                {
                    [self toPostDetailAction:target];
                    break;
                    
                }
                case 7:
                {
                    [self toMsgAction:target TabVC:tabVC];
                    break;
                }
                    
                case 8:
                {
                    //进入到群组
                    [self toGroupDetailAction:target];
                    break;
                }
                case 9:
                {
                    [self toGroupDetailAction:target];
                    break;
                }
                case 10:
                {
                    //do nothing
                }
                default:
                    break;
            }
            
        }else {
            // 判断为本地通知
            //此处省略一万行需求代码。。。。。。
        }
    }
}

+(void)toUserAction:(NSString *)target{
    //需要更新follo
    //这里判断 如果是在我们的目标页面 就刷新一下 否则跳转
    //请求到了目标用户，就刷新或者跳转，否则啥也不做

    WYUserVC *vc = [WYUserVC new];
    //判断两个对象是否是同一个类的实例
    if ([[WYUtility getCurrentVC] isMemberOfClass:[vc class]]) {
        //将UIDc传过去   然后通知他们刷新
        ((WYUserVC *)[WYUtility getCurrentVC]).userUuid = target;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewPushUpdateUser object:nil userInfo:nil];
    }else{
        //进入目标用户资料页
        vc.userUuid = target;
        vc.hidesBottomBarWhenPushed = YES;
        [[WYUtility getCurrentVC].navigationController pushViewController:vc animated:YES];
    }
}

+(void)toPostDetailAction:(NSString *)target{
    //跳转到我的分享详情页
    //要想拿到数据然后刷新 因为是异步的所以还是要拿到对象然后在block中刷新
    //因为有对象也可以自己手动
    YZPostDetailVC *vc = [YZPostDetailVC new];
    if ([[WYUtility getCurrentVC] isMemberOfClass:[vc class]]) {
        //刷新就可以了 注意拿注意拿当前对象本身
        ((YZPostDetailVC*)[WYUtility getCurrentVC]).postUuid = target;
        //发通知给PostDetailVC
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewPushUpdatePost object:nil userInfo:nil];
    }else{
        //进入目标用户资料页
        vc.postUuid = target;
        vc.hidesBottomBarWhenPushed = YES;
        [[WYUtility getCurrentVC].navigationController pushViewController:vc animated:YES];
    }
}

+(void)toGroupDetailAction:(NSString *)target{
    //进入目标群组
    WYGroupDetailVC *vc = [WYGroupDetailVC new];
    if ([[WYUtility getCurrentVC] isMemberOfClass:[vc class]]) {
        //传UID过去 然后异步请求
        ((WYGroupDetailVC*)[WYUtility getCurrentVC]).groupUuid = target;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewPushUpdateGroup object:nil userInfo:nil];
    }else{
        vc.hidesBottomBarWhenPushed = YES;
        vc.groupUuid = target;
        [[WYUtility getCurrentVC].navigationController pushViewController:vc animated:YES];
    }
}

+(void)toMsgAction:(NSString *)target TabVC:(RootTabBarController *)tabVC{
    //应该是要进到群组邀请的详情页面
    //但是邀请的详情页 需要 msgModel中的一些内容 而给出的UID 是邀请groupInvition的UID
    //目前给出的解决方案是 让用户去第二个tap 用户可以自己点击进入邀请的详情页
    
    WYAcceptInviteVC *vc = [WYAcceptInviteVC new];
    if ([[WYUtility getCurrentVC] isMemberOfClass:[WYAcceptInviteVC class]]){
        //通知刷新页面
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewPushUpdateMsg object:nil userInfo:nil];
    }else{
        vc.hidesBottomBarWhenPushed = YES;
        vc.targetUuid = target;
        [[WYUtility getCurrentVC].navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -iOS 10之前收到远程通知
//ios 10一下
+(void)lowVersion:(NSDictionary *)userInfo Application:(UIApplication *)application{
    
    //此处省略一万行需求代码。。。。。。
    NSDictionary *apsDic = [userInfo objectForKey:@"aps"];
    NSDictionary *alert = [apsDic objectForKey:@"alert"];
    NSDictionary *sound = [apsDic objectForKey:@"sound"];
    NSString *title = [alert objectForKey:@"title"];
    NSString *body = [alert objectForKey:@"body"];
    int pushType = [[userInfo objectForKey:@"type"] intValue];
    NSString *target = [userInfo objectForKey:@"target"];
    
    // 有f 字段则为环信的推送消息
    if([WYPushMsgTool handledEasemobMessage:userInfo]) return;
    
    switch (pushType){
        case 1:
        {
            NSLog(@"private mail received");
            //在foreground时，应该给alertview， 同时tab显示东西
            //background时，tabbar也应该显示橙色
            
            if ( application.applicationState == UIApplicationStateActive ){
                
            }else
            {
                [self toUserAction:target];
            }
                break;
        }
        case 2:
        {
            if ( application.applicationState == UIApplicationStateActive ){
                
            }else
            {
                [self toPostDetailAction:target];
            }
            
            break;
            
        }
        case 3:
            if ( application.applicationState == UIApplicationStateActive ){
                
            }else
            {
                [self toPostDetailAction:target];
            }
            
            
            break;
        case 4:
            if ( application.applicationState == UIApplicationStateActive ){
                // app is in the foreground
                
            }else
            {
                [self toPostDetailAction:target];
                
            }
            
            break;
        case 5:
            if ( application.applicationState == UIApplicationStateActive ){
                // app is in the foreground
                
            }else
            {
                [self toUserAction:target];
            }
            
            
            break;
        case 6:
            if ( application.applicationState == UIApplicationStateActive ){
                // app is in the foreground
                //跳转到我的分享详情页
                
            }else
            {
                [self toPostDetailAction:target];
            }
            
            
            break;
        case 7:
            if ( application.applicationState == UIApplicationStateActive ){
                // app is in the foreground
               
                
            }else
            {
                //接受到邀请
            }
            break;
        case 8:
            if ( application.applicationState == UIApplicationStateActive ){
                // app is in the foreground
                //进入到群组
                
            }else
            {
                [self toGroupDetailAction:target];

            }
            break;
        case 9:
            if ( application.applicationState == UIApplicationStateActive ){
                // app is in the foreground
                //进入到群组
                
            }else
            {
                [self toGroupDetailAction:target];

            }
            break;
        case 10:
            if ( application.applicationState == UIApplicationStateActive ){
                                
            }else
            {
                
            }
            break;
        default:
            break;
    }
 
}


+(void)updateMsgCategory{
    
    [WYMessageCategory listMsgCategory:0 Block:^(NSInteger total_unread_num, NSArray *categoryArr) {
        if (categoryArr) {
            //不能存自定义数据类型，也不能存可变数组
            UITabBarItem * item = [[WYUtility tabVC].tabBar.items objectAtIndex:2];
            if(total_unread_num > 0) {
                item.badgeValue = [NSString stringWithFormat:@"%ld", total_unread_num];
            }
            else{
                [item setBadgeValue:nil];
            }
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:categoryArr];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:kMsgCategoryListKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kMsgCategoryList object:nil userInfo:@{@"cateArr":categoryArr}];
        }else{
            [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
        }
    }];
}

/*
 更多本地推送
 */


+ (void)handleActionOnReceiveMessage:(EMMessage *)message {
    UIApplicationState state =[UIApplication sharedApplication].applicationState;
    // 后台情况  发送本地通知
    if(state == UIApplicationStateBackground) {
        UILocalNotification *noti = [[UILocalNotification alloc] init];
        noti.alertBody = @"您有一条新的消息";
        noti.repeatInterval = 0;
        noti.userInfo = @{
                           @"type": @0,
                           @"f": message.from,
                           @"to": message.to,
                           @"conversationId": message.conversationId,
                           };
        [[UIApplication sharedApplication] presentLocalNotificationNow:noti];
        
    }
    // 震动提醒
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

+ (void)onOpenLocalNotification:(UIApplication *)application notification:(UILocalNotification *)notification {
    
    /*
        0 : message 
        ...
     */
    NSNumber *type = notification.userInfo[@"type"];
    switch ([type integerValue]) {
        case 0:
            [WYPushMsgTool _openChatView:notification.userInfo[@"f"]];
            break;
        default:
            break;
    }
    
}

+ (BOOL)handledEasemobMessage:(NSDictionary *)userInfo {
    // 有f 或者from 字段则为环信的推送消息
    NSString *from = nil;
    if(userInfo[@"f"]) {
        from = userInfo[@"f"];
    }
//    if(userInfo[@"from"]) {
//        from = userInfo[@"from"];
//    }
    if(from) {
        [WYPushMsgTool _openChatView:from];
        return YES;
    }
    return NO;
}

+ (void)_openChatView:(NSString *)from {
    
    [WYUser getUserByEasemobName:from blcok:^(WYUser *user) {
        // 在发布页面 使用publishvc的navigation
        if([WYUtility rootPageVC].index == 0) {
            [[WYUtility chatList] startChatWithUser:user  pushBy:[WYUtility rootPageVC].publishVC.navigationController];
        }else {
            // 使用tabbar当前的navigation
            UIViewController *currentVC = [WYUtility tabVC].selectedViewController;
            if([currentVC isKindOfClass:[UINavigationController class]]) {
                UINavigationController *nav = (UINavigationController *)currentVC;
                [[WYUtility chatList] startChatWithUser:user  pushBy:nav];
            }
        }
    }];
}


@end
