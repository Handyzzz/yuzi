//
//  WYUtility.m
//  Withyou
//
//  Created by jialei on 14-5-3.
//  Copyright (c) 2014年 Withyou Inc. All rights reserved.
//

#import "WYUtility.h"
#import "WYLoginVC.h"
#import "QBPickerWithGroup.h"
#import "WYAccountApi.h"
#import <UserNotifications/UserNotifications.h>
#import "RootPageVC.h"
#import <Hyphenate/EMSDK.h>
#import "YZChat.h"
#import "WYGroupDetailVC.h"
#import "WYUserVC.h"
#import "WYSelfDetailEditing.h"
#import "WYGroupApi.h"
#import "WYUserApi.h"


@implementation WYUtility

+ (AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

+ (RootPageVC *)rootPageVC {
    UIViewController *vc = [[WYUtility sharedAppDelegate].window rootViewController];
    if([vc isKindOfClass:[RootPageVC class]]) {
        return (RootPageVC *)vc;
    }else {
        WYLog(@"rootPageVC ======= is nil");
        return nil;
    }
}

+(RootTabBarController*)tabVC{
    return [WYUtility rootPageVC].tabBarVC;
}

+ (YZChatList *)chatList {
    RootTabBarController *tab = [WYUtility tabVC];
    UINavigationController *nav = [[tab viewControllers] objectAtIndex:2];
    if([nav isKindOfClass:[UINavigationController class]]) {
        if([nav.topViewController isKindOfClass:[YZChatList class]]) {
            return (YZChatList *)nav.topViewController;
        }
    }
    return nil;
}



/*iOS 获取当前屏幕活跃的视图控制器*/
+ (UIViewController *)getCurrentVC {
    
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    debugLog(@"%@",resultVC);
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    }else if ([vc isKindOfClass:[RootPageVC class]]){
        // 当前显示的索引  0 = left ; 1 = tabber ; 2 = right
        if (((RootPageVC *)vc).index == 0) {
             return [self _topViewController:((RootPageVC *)vc).publishVC];
        }else if (((RootPageVC *)vc).index == 1){
            return [self _topViewController:((RootPageVC *)vc).tabBarVC];
        }
    }else{
        return vc;
    }
    return nil;
}


+ (void)showAlertWithTitle:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:title delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
+ (void)showAlertWithTitle:(NSString *)title Msg:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}



+ (void)takeNewPictureWithDelegate:(UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate> *)vc{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = vc;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        
    } else {
        
        [self showAlertWithTitle:@"camara not available"];
        return;
    }
    
    [picker setCameraCaptureMode:UIImagePickerControllerCameraCaptureModePhoto];
    picker.showsCameraControls = YES;
    [[WYUtility sharedAppDelegate].window.rootViewController presentViewController:picker animated:YES completion:^{
    
    }];
    
}

+ (void)choosePhotoFromAlbumWithDelegate:(UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate> *)vc
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = vc;
    
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [[WYUtility sharedAppDelegate].window.rootViewController presentViewController:picker animated:YES completion:^{
        
    }];
}
+ (void)choosePhotoFromAlbumWithDelegateAllowsEditing:(UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate> *)vc
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = vc;
    picker.allowsEditing = YES;
    
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [[WYUtility sharedAppDelegate].window.rootViewController presentViewController:picker animated:YES completion:^{
        
    }];
}

+ (void)chooseVideoFromAlbumWithDelegate:(UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate> *)vc
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = vc;
    
    [picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    picker.mediaTypes = [NSArray arrayWithObjects:
                         (NSString *) kUTTypeMovie,
                         nil];
    picker.allowsEditing = YES;
    
    [[WYUtility sharedAppDelegate].window.rootViewController presentViewController:picker animated:YES completion:^{
        
    }];
}

+ (void)chooseMultiplePhotoFromAlbumWithDelegateQB:(UIViewController<QBImagePickerControllerDelegate> *)vc{
    
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    imagePickerController.delegate = vc;
    imagePickerController.assetCollectionSubtypes = @[
                                                      @(PHAssetCollectionSubtypeSmartAlbumUserLibrary), // Camera Roll
                                                      @(PHAssetCollectionSubtypeAlbumMyPhotoStream), // My Photo Stream
                                                      @(PHAssetCollectionSubtypeSmartAlbumPanoramas), // Panoramas
//                                                      @(PHAssetCollectionSubtypeSmartAlbumVideos), // Videos
                                                      @(PHAssetCollectionSubtypeSmartAlbumBursts) // Bursts
                                                      ];
    
    imagePickerController.mediaType = QBImagePickerMediaTypeImage;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 30;

      [[WYUtility sharedAppDelegate].window.rootViewController presentViewController:imagePickerController animated:YES completion:^{}];

}

+ (void)chooseMultiplePhotoFromAlbumToGroup:(NSString *)group WithDelegateQB:(UIViewController<QBImagePickerControllerDelegate> *)vc
{
    QBPickerWithGroup *imagePickerController = [QBPickerWithGroup new];
    imagePickerController.group = group;
    imagePickerController.delegate = vc;
    imagePickerController.assetCollectionSubtypes = @[
                                                      @(PHAssetCollectionSubtypeSmartAlbumUserLibrary), // Camera Roll
                                                      @(PHAssetCollectionSubtypeAlbumMyPhotoStream), // My Photo Stream
                                                      @(PHAssetCollectionSubtypeSmartAlbumPanoramas), // Panoramas
                                                      //                                                      @(PHAssetCollectionSubtypeSmartAlbumVideos), // Videos
                                                      @(PHAssetCollectionSubtypeSmartAlbumBursts) // Bursts
                                                      ];
    
    imagePickerController.mediaType = QBImagePickerMediaTypeImage;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 30;
    
    [[WYUtility sharedAppDelegate].window.rootViewController presentViewController:imagePickerController animated:YES completion:^{}];
    
}

+ (void)chooseSinglePhotoFromAlbumWithDelegateQB:(UIViewController<QBImagePickerControllerDelegate> *)vc
{
    
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    imagePickerController.delegate = vc;
    imagePickerController.assetCollectionSubtypes = @[
                                                      @(PHAssetCollectionSubtypeSmartAlbumUserLibrary), // Camera Roll
                                                      @(PHAssetCollectionSubtypeAlbumMyPhotoStream), // My Photo Stream
                                                      @(PHAssetCollectionSubtypeSmartAlbumPanoramas), // Panoramas
                                                      //                                                      @(PHAssetCollectionSubtypeSmartAlbumVideos), // Videos
                                                      @(PHAssetCollectionSubtypeSmartAlbumBursts) // Bursts
                                                      ];
    
    imagePickerController.mediaType = QBImagePickerMediaTypeImage;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.showsNumberOfSelectedAssets = NO;
//    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 1;
    
    [[WYUtility sharedAppDelegate].window.rootViewController presentViewController:imagePickerController animated:YES completion:^{}];
    
}

+ (BOOL)checkPhoneNumber:(NSString *)phoneStr
{
    
    // 1. 是不是11位
    if([phoneStr length] != 11)
    {
        [OMGToast showWithText:@"手机号码位数不正确"];
        return false;
    }
    
    // 2. 是不是全都是数字
    // 3. 开头的三位要在某个区间 130 - 190，留给后端做精细验证
    // 4. 后端应该有诈骗号码库，疑似被盗号码库，登录异常的过滤等等
    
    return true;
}
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (void)removeImageFromFileSystem:(NSString *)fileName
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:fileName error:&error];
        if (success) {
        }
        else
        {
            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
        }
    });
}

+ (void)prepareForLogout
{
    //退出登录
    [[WYUIDTool sharedWYUIDTool] removeUID];
    [WYAccountApi logoutForCurrentDeviceBlock:nil];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kGroupListNewestLastUpdatedTime];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kGroupListIntervalRequestTime];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLocalContactsUpdatedTime];
    
//    这些即将删除
//    TODO
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSelfTopicListRequestTime];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kGroupTopicListRequestTime];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSelfPhotosListIntervalRequestTime];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSelfPhotosListBottomTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //环信的本地缓存删掉
    [[YZChat class] deleteChatList];
    
//    //用户退出后将短存清空 新用户注册通知后 将能继续向后端更新token
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPushDeviceTokenKeyHaveUpdate];
    
//    03.21 tony added
//    现在用户登出账号之后，存在userDefaults中的pushToken并不被销毁，而是等着新的账号的用户去向后端更新
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPushDeviceTokenKey];


    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserLoggedOut object:self userInfo:@{}];
    
    
    WYLoginVC *vc = [[WYLoginVC alloc] init];
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = vc;
    
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        WYLog(@"环信退出成功");
    }
}

+ (void)hxLogin:(NSString *)name withPassword:(NSString *)password {
    
    
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    if (!isAutoLogin) {
        debugLog(@"hx start to login");
        [[EMClient sharedClient] loginWithUsername:name password:password completion:^(NSString *aUsername, EMError *aError) {
            if (!aError) {
                WYLog(@"环信登录成功");
                [[EMClient sharedClient] setApnsNickname:[WYUIDTool sharedWYUIDTool].uid.fullName];
                [[EMClient sharedClient].options setIsAutoLogin:YES];
            }else{
                debugLog(@"环信登录失败");
            }
            
        }];
    }else {
        debugLog(@"hx auto login");
    }
}

+ (void)printInfo:(id)res
{
    NSString *s = [NSString stringWithFormat:@"resp info %@", res];
    printf("%s\n", [s UTF8String]);
}
+ (NSArray *)fakedPhotoList
{
    return [NSArray array];
}


+ (void)registerForRemoteNotification {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        UNUserNotificationCenter *uncenter = [UNUserNotificationCenter currentNotificationCenter];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];

        [uncenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
            //NSLog(@"%s\nline:%@\n-----\n%@\n\n", __func__, @(__LINE__), settings);
            
            if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
                
                //TODO:
                [uncenter requestAuthorizationWithOptions:(UNAuthorizationOptionAlert+UNAuthorizationOptionBadge+UNAuthorizationOptionSound)
                                        completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                            
                                        }];
                
            } else if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
                //TODO:
            } else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                //TODO:
            }
        }];
    }
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIUserNotificationType types = UIUserNotificationTypeAlert |
        UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType types = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
#pragma clang diagnostic pop
}

+ (void)openURL:(NSURL *)url {
    [[[UIAlertView alloc] initWithTitle:@"是否用浏览器打开？"
                                message:[url absoluteString]
                       cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^(){
        return;
    }]
                       otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^(){
        
        [[UIApplication sharedApplication] openURL:url];
    }],
      nil] show];
}

+ (void)handleAddFriendQrcodeUrl:(NSURL *)url {
    if(!url){
        [WYUtility showAlertWithTitle:@"未能处理此类二维码中的网址信息"];
        return;
    }
    NSString *username;
    
    if([url.pathComponents count]  > 3) {
        username = [url.pathComponents objectAtIndex:3];
        debugLog(@"%@",username);
    }else {
        [OMGToast showWithText:@"未找到匹配的用户" duration:1.3];
        return;
    }
    
    //        might need to convert from unicode
    if([username isEqualToString:kLocalSelf.account_name]){
        //            NSLog(@"same");
        [OMGToast showWithText:@"用户是自己" duration:2.2];
        return;
    }
    
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [MBProgressHUD showHUDAddedTo:root.view animated:YES];
    [WYUserApi searchUserByUserName:username Callback:^(WYUser *user) {
        [MBProgressHUD hideHUDForView:root.view animated:YES];
        if(user) {
            
            WYUserVC *vc = [[WYUserVC alloc] init];
            vc.user = user;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            vc.isPresent = YES;
            
            [root presentViewController:nav animated:YES completion:^{}];
        }else {
            debugLog(@"未找到匹配的用户");
            [OMGToast showWithText:@"未找到匹配的用户" duration:1.3];
        }
    }];
}

+ (void)handleAddGroupQrcodeUrl:(NSURL *)url {
    
    //https://yuziapp.com/add/g/100200333/？token=dfdfddfdf
    //打开这个链接后， 会向后端请求，token是否失效
    
    if(!url) return;
    NSString *groupNumber;
    if([url.pathComponents count]  > 3) {
        groupNumber = [url.pathComponents objectAtIndex:3];
    }else {
        [OMGToast showWithText:@"未找到匹配的群组" duration:1.3];
        return;
    }
    
    NSString *query = [url query]; // replace this with [url query];
    NSArray *components = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    for (NSString *component in components) {
        NSArray *subcomponents = [component componentsSeparatedByString:@"="];
        [parameters setObject:[[subcomponents objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                       forKey:[[subcomponents objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //todo
    NSArray *numbersOfMineGroup = [WYGroup queryAllMyGroupNumbers];
    
    NSString *token = [parameters objectForKey:@"token"];
    debugLog(@"%@",token);
    BOOL use_token;
    if(token && token.length > 0){
        use_token = true;
    }else{
//        token为空，说明不是要加入群
        token = @"";
        use_token = false;
    }
    
    BOOL before_is_member;
    if([numbersOfMineGroup containsObject:@(groupNumber.integerValue)]){
        //       如果是自己已经加入的群组， 直接进入那个群组
        debugLog(@"self joined group");
        before_is_member = true;
    }else{
        debugLog(@"not self joind group");
//        之前自己不是这个群的成员，但是自己带了token去请求了
        before_is_member = false;
    }
    
    debugLog(@"token is %@",token);
    
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [MBProgressHUD showHUDAddedTo:root.view animated:YES];
    [WYGroupApi searchGroupFromNumer:groupNumber Token:token Block:^(WYGroup *group) {
        [MBProgressHUD hideHUDForView:root.view animated:YES];
        if(group) {
            [WYGroup saveNewGroupsToLocalDB:@[group]];
            
            BOOL after_is_ember = [group meIsMemberOfGroupFromLocalDBRecords];
            
            
            BOOL first_enter_as_new_member = false;
            if(use_token && !before_is_member && after_is_ember)
                first_enter_as_new_member = true;
        
            WYGroupDetailVC *vc = [[WYGroupDetailVC alloc] init];
            vc.group = group;
            //用来弹窗提示， 欢迎新加入群组的用户的
            vc.first_enter_as_new_member = first_enter_as_new_member;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            vc.isPresent = YES;
            [root presentViewController:nav animated:YES completion:^{}];
        }else {
            debugLog(@"未找到匹配的群组");
            [OMGToast showWithText:@"未找到匹配的群组" duration:2.0];
        }
    }];
}

//在登录的时候 有将UID里边的user更新到 数据库 所以判断数据库就可以了
+ (void)requireSetAccountNameOrAlreadyHasName:(void (^)())block navigationController:(UINavigationController *)nav{
    WYUser *user = kLocalSelf;
    if(!user.hasNames){
        [[[UIAlertView alloc] initWithTitle:@"姓名未设定"
                                    message:@"你需要完整的姓名，立即去设置？"
                           cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
            // Handle "Cancel"
            return;
        }]
                           otherButtonItems:[RIButtonItem itemWithLabel:@"立即完善" action:^{
            //去往个人资料编辑页面
            WYSelfDetailEditing *vc = [WYSelfDetailEditing new];
            vc.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:vc animated:YES];
            
        }], nil] show];
        
    }else {
        if(block){
            block();
        }
    }
}

+ (NSString *)stripQiniuImageUrl:(NSString *)smallUrl
{
    NSURL *url = [NSURL URLWithString:smallUrl];
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    NSString *scheme = [components scheme];
    NSString *host = [components host];
    NSString *path = [components path];
    return [NSString stringWithFormat:@"%@://%@%@", scheme, host, path];
}

+ (void)saveImageToLocal:(NSString *)imageUrl
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:imageUrl]];
    UIImage *image = [UIImage imageWithData:data]; // 取得图片
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
    }];
}

+ (void)downloadFullResolutionImagesFromQiniuThumbnails:(NSArray <NSString *> *)array
{
    [[WYUtility sharedAppDelegate] setNetworkActivityIndicatorVisible:YES];
    for(NSString *s in array){
        NSString *fu = [[self class] stripQiniuImageUrl:s];
        [[self class] saveImageToLocal:fu];
    }
    [[WYUtility sharedAppDelegate] setNetworkActivityIndicatorVisible:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        [OMGToast showWithText:@"照片已经全部保存在本地"];
    });

}
@end
