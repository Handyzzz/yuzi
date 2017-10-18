//
//  AppDelegate.m
//  Withyou
//
//  Created by Tony on 14-3-22.
//  Copyright (c) 2014年 Withyou Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "WYAccountApi.h"
#import "BaiduMobStat.h"
//推送的工具类
//注册的头文件, 防止低版本的找不到头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max

#import <UserNotifications/UserNotifications.h>

#endif

#import "WYPushMsgTool.h"
#import <Hyphenate/EMSDK.h>
#import "EaseUI.h"
#import "RootPageVC.h"
#import "WYLoginVC.h"

@interface AppDelegate () <UNUserNotificationCenterDelegate, EMClientDelegate>

@end

@implementation AppDelegate
//这个函数调用的时机，是在app冷启动时，关于其他的函数的调用时机
//http://stackoverflow.com/questions/11334678/does-didfinishlaunchingwithoptions-happens-after-certain-application-exits
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //数据库迁移
    [self handleDatabaseAfterLogin];

    self.requestGroupLock = false; //not locking

    NSString *appkey = @"linwo#yuzi";
    NSString *certName = @"prod";

//#if DEBUG
#if defined(DEBUG) || defined(_DEBUG)
    certName = @"dev";
#endif

    NSLog(@"cert Name is %@", certName);

    EMOptions *options = [EMOptions optionsWithAppkey:appkey];
    options.apnsCertName = certName;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    [[EaseSDKHelper shareHelper] hyphenateApplication:application
                        didFinishLaunchingWithOptions:launchOptions
                                               appkey:appkey
                                         apnsCertName:certName
                                          otherConfig:@{kSDKConfigEnableConsoleLogger: @YES}];
    //6 months
    [SDImageCache sharedImageCache].maxCacheAge = 60 * 60 * 24 * 30 * 6;

    NSString *key = (NSString *) kCFBundleVersionKey;
    NSString *lastVersionCode = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSString *currentVersionCode = [[[NSBundle mainBundle] infoDictionary] objectForKey:key];

    if ([lastVersionCode isEqualToString:currentVersionCode]) {
        // 某个新版本不是第一次进入程序时

    } else {
        //  某个新版本第一次进入程序，保存版本号
        [[NSUserDefaults standardUserDefaults] setObject:currentVersionCode forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    UIViewController *root = nil;
    if ([[WYUIDTool sharedWYUIDTool] isLoggedIn]) {
        WYUID *uid = [WYUIDTool sharedWYUIDTool].uid;
        [WYUtility hxLogin:uid.easemob_username withPassword:uid.easemob_password];
        debugLog(@"在utility的hxLogin后面");
        root = [[RootPageVC alloc] init];
    } else {
        root = [[WYLoginVC alloc] init];
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    self.window.rootViewController = root;
    [self.window makeKeyAndVisible];

    //register notification
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];

    //必须写代理，不然无法监听通知的接收与点击事件
    center.delegate = self;
    [WYPushMsgTool applyPushNotificationAuthorizationCenter:center Application:application launchOptions:launchOptions];

    return YES;
}

/*================== EMClientDelegate ==================*/

// 当前登录账号在其它设备登录时
- (void)userAccountDidLoginFromOtherDevice {
    [WYUtility showAlertWithTitle:@"当前账号已在其他设备登录"];
    // 跳转到登录页面
    [WYUtility prepareForLogout];
}

// 当前登录账号已经被从服务器端删除时会收到该回调
- (void)userAccountDidRemoveFromServer {
    [WYUtility showAlertWithTitle:@"当前账号已被系统删除"];
    // 跳转到登录页面
    [WYUtility prepareForLogout];
}

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {

    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

#pragma mark - 获取推送的deviceToken
/*
 获取DeviceToken成功
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    [[EMClient sharedClient] bindDeviceToken:deviceToken];
    [[EMClient sharedClient] registerForRemoteNotificationsWithDeviceToken:deviceToken completion:^(EMError *aError) {
        NSLog(@"huanxin bind token error %@", aError);
    }];

    //    debugLog(@"newtoken is: %@", deviceToken);
    NSString *deviceString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceString = [deviceString stringByReplacingOccurrencesOfString:@" " withString:@""];

    [[NSUserDefaults standardUserDefaults] setValue:deviceString forKey:kPushDeviceTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//get DeviceToken failed
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"[DeviceToken Error]:%@\n", error.description);
}

#pragma mark - iOS10 收到通知（本地和远端）UNUserNotificationCenterDelegate

/*ios10
 App处于前台接收通知时 只会是app处于前台状态 前台状态 and 前台状态下才会走，后台模式下是不会走这里的
 前台并且不需要点击推送消息本身就自动做什么写在这里
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge |
            UNNotificationPresentationOptionSound |
            UNNotificationPresentationOptionAlert);

    [WYPushMsgTool tenVersionForegroundType:notification TabVC:[WYUtility tabVC]];
}

/* ios10
 前台或者后台点击消息体 然后要做的事情
 App通知的点击事件只会是用户点击消息才会触发，如果使用户长按（3DTouch）、弹出Action页面等并不会触发。点击Action的时候会触发！
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    [WYPushMsgTool tenVersionForegroundAndBackgroundType:response TabVC:[WYUtility tabVC]];
    // 系统要求执行这个方法
    completionHandler();
}

#pragma mark -iOS 10之前收到远程通知

/*
 ios 10之前
 */

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [WYPushMsgTool lowVersion:userInfo Application:application];
    [[EMClient sharedClient] application:application didReceiveRemoteNotification:userInfo];
}

/*
 ios10之前
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    completionHandler(UIBackgroundFetchResultNewData);
    [WYPushMsgTool lowVersion:userInfo Application:application];
    [[EMClient sharedClient] application:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [WYPushMsgTool onOpenLocalNotification:application notification:notification];
}

#pragma mark - 系统内注册的url自动跳转

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *_Nullable))restorationHandler {

    NSURL *webUrl = userActivity.webpageURL;
    //NSLog(@"web url is %@, path is %@, host is %@", webUrl, webUrl.path, webUrl.host);

    if (![userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        return YES;
    }

    //读取url地址
    //todo, 需要测试！！！！尚未检验absoluteString是什么
    //tony 03.22 added
    if (![webUrl.absoluteString hasPrefix:kBaseURL]) {
        [[UIApplication sharedApplication] openURL:webUrl];
        return YES;
    }

    if ([webUrl.path hasPrefix:@"/add/u/"]) {
        [WYUtility handleAddFriendQrcodeUrl:webUrl];
        return YES;
    } else if ([webUrl.path hasPrefix:@"/add/g/"]) {
        //加群组的操作
        //debugMethod();
        [WYUtility handleAddGroupQrcodeUrl:webUrl];
        return YES;
    } else {
        [[UIApplication sharedApplication] openURL:webUrl];
        return YES;
    }

    //跳转并显示内容
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"notify" object:@"hello world"];

    return YES;
}

#pragma mark - 数据库检测版本和迁移

- (void)handleDatabaseAfterLogin {
    if ([WYUIDTool sharedWYUIDTool].isLoggedIn) {
        [[WYDBManager getSharedInstance] createTablesAndUpdateToNewestVersion];
    }
}

#pragma mark - 网络请求的小菊花

- (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible {
    static NSInteger NumberOfCallsToSetVisible = 0;
    if (setVisible)
        NumberOfCallsToSetVisible++;
    else
        NumberOfCallsToSetVisible--;

    // The assertion helps to find programmer errors in activity indicator management.
    // Since a negative NumberOfCallsToSetVisible is not a fatal error,
    // it should probably be removed from production code.
    NSAssert(NumberOfCallsToSetVisible >= 0, @"Network Activity Indicator was asked to hide more often than shown");

    // Display the indicator as long as our static counter is > 0.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(NumberOfCallsToSetVisible > 0)];
}

+ (UIViewController *)topMostController {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;

    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }

    return topController;
}


@end

