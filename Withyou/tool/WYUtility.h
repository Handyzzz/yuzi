//
//  WYUtility.h
//  Withyou
//
//  Created by jialei on 14-5-3.
//  Copyright (c) 2014年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "WYPost.h"
#import "RootTabBarController.h"
//#import "GMImagePickerController.h"
#import <QBImagePickerController/QBImagePickerController.h>
@class RootPageVC;
@class YZChatList;
@interface WYUtility : NSObject

+ (AppDelegate *)sharedAppDelegate;
+ (RootPageVC *)rootPageVC;
+ (RootTabBarController*)tabVC;
+ (YZChatList *)chatList;
/*iOS 获取当前屏幕活跃的视图控制器*/
+ (UIViewController *)getCurrentVC;

//弹出提示， 只有消息体，虽然是叫做title，但是并不是标题，而是msg，消息体
+ (void)showAlertWithTitle:(NSString *)title;

//弹出提示，显示消息的标题和消息体
+ (void)showAlertWithTitle:(NSString *)title Msg:(NSString *)msg;


+ (void)takeNewPictureWithDelegate:(UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate> *)vc;

+ (void)choosePhotoFromAlbumWithDelegate:(UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate> *)vc;
+ (void)choosePhotoFromAlbumWithDelegateAllowsEditing:(UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate> *)vc;

+ (void)chooseVideoFromAlbumWithDelegate:(UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate> *)vc;

//+ (void)chooseMultiplePhotoFromAlbumWithDelegateGMDeprecated:(UIViewController<GMImagePickerControllerDelegate> *)vc;
+ (void)chooseMultiplePhotoFromAlbumWithDelegateQB:(UIViewController<QBImagePickerControllerDelegate> *)vc;
+ (void)chooseMultiplePhotoFromAlbumToGroup:(NSString *)group WithDelegateQB:(UIViewController<QBImagePickerControllerDelegate> *)vc;

+ (void)chooseSinglePhotoFromAlbumWithDelegateQB:(UIViewController<QBImagePickerControllerDelegate> *)vc;

+ (BOOL)checkPhoneNumber:(NSString *)phoneStr;
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (void)removeImageFromFileSystem:(NSString *)fileName;
+ (void)printInfo:(id)res;

+ (void)openURL:(NSURL *)url;

//扫描二维码，或者点击了链接，或者打开safari的页面后，再用app打开添加用户的页面
//需要处理这个url，因为使用app来处理的
+ (void)handleAddFriendQrcodeUrl:(NSURL *)url;
//这个是添加群组用的，附带了token的，否则token为空也可以，就看登录的身份是谁了
+ (void)handleAddGroupQrcodeUrl:(NSURL *)url;

+ (NSArray *)fakedPhotoList;

// 登出前的一系列的清理动作
+ (void)prepareForLogout;

// 环信登录
+ (void)hxLogin:(NSString *)name withPassword:(NSString *)password;
+ (void)registerForRemoteNotification;

+ (void)requireSetAccountNameOrAlreadyHasName:(void(^)())block navigationController:(UINavigationController *)nav;

//将一组七牛的缩略图的url背后的原图保存在本地
+ (void)downloadFullResolutionImagesFromQiniuThumbnails:(NSArray <NSString *> *)array;
+ (NSString *)stripQiniuImageUrl:(NSString *)smallUrl;
+ (void)saveImageToLocal:(NSString *)imageUrl;

@end
