//
//  WYUserApi.h
//  Withyou
//
//  Created by Handyzzz on 2017/8/9.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYSelfPrivacy.h"

@interface WYUserApi : NSObject
+ (void)retrieveMyPermissionListToUser:(NSString *)uuid Block:(void (^)(NSDictionary *permission))block;

+ (void)updateMyPermissionListToUser:(NSString *)uuid WithDict:(NSDictionary *)dict Block:(void (^)(NSDictionary *permission))block;

//能否通过手机号搜索到我
+ (void)updateSelfGlobalPrivacyWithDict:(NSDictionary *)dict Block:(void (^)(NSDictionary *response))block;

+ (void)retrieveSelfGlobalPrivacyWithDict:(NSDictionary *)dict Block:(void (^)(WYSelfPrivacy *privacy))block;

//更换头像
+(void)changeUser:(NSString *)userUuid ImageWith:(PHAsset *)asset callback:(void (^)(WYUser *user))cb;

//查找的关键字，可能是用户名，也可能是手机号，后端会做一个简单的判断
+ (void)searchUserByKeyword:(NSString *)keyword Handler:(void (^)(NSArray *array))handler;

// 参数是用户名， 返回的虽然是一个数组，但是里面只可能有一个结果
+ (void)searchUserByUserName:(NSString *)userName Callback:(void (^)(WYUser *user))callback;

@end
