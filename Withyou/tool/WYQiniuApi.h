//
//  WYQiniuApi.h
//  Withyou
//
//  Created by Tong Lu on 2016/10/9.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QiniuSDK.h"


typedef void (^UploadCompleteHandler)(NSString *key);

@interface WYQiniuApi : NSObject


/**
 Upload a PHAsset, if failed, handler a nil string

 @param asset   PHAsset
 @param key     key if is provided, will be used, otherwise, a system generated uuid string be used
 @param handler ^(NSString *key)
 */
+ (void)uploadPHAsset:(PHAsset *)asset ForKey:(NSString *)key complete:(UploadCompleteHandler)handler;

/**
 Upload a PHAsset, to private qiniu bucket

 @param asset   asset description
 @param key     key description
 @param handler handler description
 */
+ (void)uploadPrivatePHAsset:(PHAsset *)asset ForKey:(NSString *)key complete:(UploadCompleteHandler)handler;

/**
 Upload a PHAsset, no matter public or private, depends on the token param

 @param asset   asset description
 @param key     key description
 @param token   token determines the endpoint of the photo bucket uploaded
 @param handler handler description
 */
+ (void)uploadPHAsset:(PHAsset *)asset ForKey:(NSString *)key Token:(NSString *)token complete:(UploadCompleteHandler)handler;

+ (void)getQiniuUpTokenWithBlock:(void (^)(NSString *token))block;

//私密仓库暂时不做，可以不用考虑
+ (void)getPrivateQiniuUpTokenWithBlock:(void (^)(NSString *token))block;

+ (void)uploadUIImage:(UIImage *)imageData ForKey:(NSString *)key WithBlock:(void (^)(NSString *key))block;

@end
