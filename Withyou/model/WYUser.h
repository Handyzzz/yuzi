//
//  WYUser.h
//  Withyou
//
//  Created by Tong Lu on 2016/10/18.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>
#import "WYProfile.h"
#import "WYQiniuApi.h"

@interface WYUser : NSObject<NSCoding>
//user 模型共8个字段
@property (strong, nonatomic) NSString* uuid;
@property (strong, nonatomic) NSString* first_name;
@property (strong, nonatomic) NSString* last_name;
@property (strong, nonatomic) NSString* account_name;
@property (strong, nonatomic) NSString* icon_url;
@property (strong, nonatomic) NSString* easemob_username;
@property (assign, nonatomic) int sex;
@property (assign, nonatomic) int type;

/*******不属于基础的user模型 放到此行以下或者另建模型 保证以上字段任何时候都是有值的 并且在数据库中有存储********/
@property (strong, nonatomic) NSString* phone;
@property (strong, nonatomic) NSNumber *rel_to_me;

- (NSString *)fullName;
- (NSString *)sexString;
- (BOOL)isFollowedByMe;
- (NSDictionary *)permissionDictByMe;

//现在只用判断姓名 不用accountName
- (BOOL)hasNames;
+ (BOOL)saveUserToDB:(WYUser *)user;
+ (void)getUserByEasemobName:(NSString *)name blcok:(void (^)(WYUser *))callback;
+ (WYUser *)queryUserWithUuid:(NSString *)uuid;
+ (WYUser *)queryUserWithEasemobName:(NSString *)name;
+ (WYUser *)userFromSelf;

@end
