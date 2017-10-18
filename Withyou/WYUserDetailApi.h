//
//  WYUserDetailApi.h
//  Withyou
//
//  Created by Handyzzz on 2017/8/9.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYUserDetail.h"

@interface WYUserDetailApi : NSObject
//请求userDetail(userInfo)模型 user+Profire + rel_to_me
+(void)retrieveUserInfo:(NSString *)Uuid Block:(void(^)(WYUserDetail *userInfo))block;

//请求个人详情 请求后调用了 下边的两个保存的方法
+ (void)retrieveUserDetail:(NSString *)Uuid Block:(void (^)(NSArray *postArr,WYUserDetail *userInfo, NSArray *photoArr,WYUserExtra *userExtra,BOOL hasDetail))block;

//网络上传
+ (void)patchUserDetailDic:(NSDictionary *)dic Block:(void(^)(WYUser *user,NSInteger status))block;

//个人页请求更多帖子
+(void)listMorePosts:(NSString *)uuid time:(NSNumber *)time Block:(void(^)(NSArray *morePostArr,BOOL success))block;

//我参与的帖子
+(void)listParticipateForMe:(NSString *)userUuid time:(NSNumber *)time Block:(void(^)(NSArray *postArr, BOOL success))block;

+(void)listMorePhotos:(NSString *)uuid time:(NSNumber *)time Block:(void(^)(NSArray *photoArr,BOOL success))block;

+(void)listMorePublicGroup:(NSString *)userUuid Page:(NSInteger)page Block:(void(^)(NSArray *moreGroupArr,BOOL hasMore))block;

//请求查看对方的朋友列表
+(void)listUserFriends:(NSString *)userUuid Page:(NSInteger)page Block:(void(^)(NSArray *moreFrdendsArr,BOOL hasMore))block;

//请求查看共同的好友
+(void)listCommonFriends:(NSString *)userUuid Page:(NSInteger)page Block:(void(^)(NSArray *moreFrdendsArr,BOOL hasMore))block;


@end
