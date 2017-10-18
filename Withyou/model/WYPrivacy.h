//
//  WYPrivacy.h
//  Withyou
//
//  Created by Handyzzz on 2017/6/15.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYPrivacy : NSObject
@property (nonatomic, strong)NSString *uuid;
@property (nonatomic, assign)BOOL birth_day;
@property (nonatomic, assign)BOOL birth_month;//月暂时不用 现在用的是 年 日
@property (nonatomic, assign)BOOL birth_year;
@property (nonatomic, assign)BOOL check_friend_list;
@property (nonatomic, assign)BOOL city;
@property (nonatomic, strong)NSString *created_at;
@property (nonatomic, assign)BOOL current_work;
@property (nonatomic, strong)NSString *follower;
@property (nonatomic, strong)NSString *influencer;
@property (nonatomic, assign)BOOL primary_phone;
@property (nonatomic, assign)BOOL relationship_status;
@property (nonatomic, assign)BOOL work_experience;
@property (nonatomic, assign)BOOL study_experience;
@property (nonatomic, assign)BOOL blocked;


//请求状态
+(void)retrievePrivacy:(NSString *)userUuid block:(void(^)(WYPrivacy *privacy))block;
//修改状态
+(void)patchPrivacy:(NSString *)userUuid dic:(NSDictionary *)dic block:(void(^)(WYPrivacy *privacy))block;

@end
