//
//  WYGroupApplication.h
//  Withyou
//
//  Created by Handyzzz on 2017/7/11.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYApplicantUser.h"

@interface WYGroupApplication : NSObject

@property(nonatomic, strong)NSString *uuid;
@property(nonatomic, strong)NSString *applicant_uuid;
@property(nonatomic, strong)NSString *created_at;
@property(nonatomic, strong)NSString *group_name;
@property(nonatomic, strong)NSString *group_uuid;
@property(nonatomic, strong)WYApplicantUser *applicant_user;
@property(nonatomic, assign)BOOL refused;
@property(nonatomic, assign)BOOL accepted;
@property(nonatomic, assign)BOOL calculated_expired;//用这个判断申请是否是过期
@property(nonatomic, assign)BOOL expired;
@property(nonatomic, assign)float created_at_float;


//群申请的详情
+(void)retrieveGroupApplication:(NSString *)targetUuid Block:(void (^)(WYGroupApplication *groupApplication,NSInteger status))block;
//接受群申请
+(void)acceptGroupApplication:(NSString *)groupAcceptUuid Block:(void(^)(BOOL success))block;
//拒绝群申请
+(void)refuseGroupApplication:(NSString *)groupAcceptUuid Block:(void(^)(BOOL success))block;

@end
