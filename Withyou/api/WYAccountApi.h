//
//  WYAccountApi.h
//  Withyou
//
//  Created by Tong Lu on 7/20/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYGroup.h"

@interface WYAccountApi : NSObject

+ (NSString *)getTokenForVCodeFromPhone:(NSString *)phone;

+ (NSURLSessionDataTask *)getVCodeByParam:(NSDictionary *)param WithBlock:(void (^)(NSDictionary *dict, NSError *error,NSInteger status))block;

+ (NSURLSessionDataTask *)postLoginByParam:(NSDictionary *)param WithBlock:(void (^)(WYUID *uid, NSError *error))block;

//report frontend error log
+ (void)reportErrorLogBy:(NSString *)description;

+ (void)logoutForCurrentDeviceBlock:(void (^)(BOOL res))block;

//跳过版本更新
+ (void)skipVersionTeptOfiPhoneBlock:(void (^)(BOOL haveSkip))block;

//弹出版本更新提示
+(void)versionShouldUapdate:(NSString *)token Block:(void (^)(BOOL ignored, NSString* versionCode,NSArray *versionDesc,NSString *downloadUrl))block;

@end
