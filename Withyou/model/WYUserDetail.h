//
//  WYUserDetail.h
//  Withyou
//
//  Created by Handyzzz on 2017/6/8.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYUserExtra.h"

@interface WYUserDetail : NSObject

@property (strong, nonatomic) NSString* uuid;
@property (strong, nonatomic) NSString* first_name;
@property (strong, nonatomic) NSString* last_name;
@property (strong, nonatomic) NSString* account_name;
@property (strong, nonatomic) NSString* icon_url;
//环信用户名
@property (strong, nonatomic) NSString* easemob_username;
@property (assign, nonatomic) int sex;
@property (nonatomic, assign) int rel_to_me;
@property (nonatomic, assign) int type;
/*************************************计算属性*********************************************/
/***后台给的是 上边的7个字段 虽然相当于user 但是并没有给user 个人页的与别的页面联系的时候 有很多种情况下需要用到user 添加一个计算属性 user***/
-(WYUser *)user;

-(NSString *)sexStr;

- (NSString *)fullName;

/*************************************中间是计算属性*********************************************/

@property (nonatomic, strong) WYProfile *profile;

//local
+ (void)queryUserDetailFromCache:(NSString *)Uuid Block:(void (^)(NSArray *postArr,WYUserDetail *userInfo, NSArray *photoArr,WYUserExtra *userExtra,BOOL hasDetail))block;
+ (BOOL)saveUserDetailToDB:(NSString *)userDetailStr UUid:(NSString *)userUuid;
+ (BOOL)deleteUserDetailFromDB:(NSString *)uuid;
+ (BOOL)deleteAllUserDetailFromCache;

//本地保存 只存了 userDetail 中的user模型
+ (BOOL)saveUserWhichInUserInfoToDB:(WYUserDetail *)userInfo;

@end
