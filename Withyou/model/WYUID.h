//
//  WYUID.h
//  Withyou
//
//  Created by hongfei on 14-5-28.
//  Copyright (c) 2014年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYUser.h"
// This model save all the import personal information of Current User Self

@interface WYUID : NSObject <NSCoding>

@property (nonatomic, copy) NSString *uuid;
//前后端身份鉴权用的token，登录后需要保存在本地，每次以登录身份请求API时，需要带上
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *account_name;
@property (nonatomic, copy) NSString *icon_url;
//上次更改用户名的时间
@property (nonatomic, assign) int time_int_last_account_change;
@property (nonatomic, copy) NSString *primary_phone;

@property (nonatomic, copy) NSString *first_name;
@property (nonatomic, copy) NSString *last_name;
@property (nonatomic, assign) int sex;
@property (nonatomic, copy) NSString *easemob_username;
@property (nonatomic, copy) NSString *easemob_password;
@property (nonatomic, assign) int type;

-(WYUser *)user;
- (NSString *)fullName;
- (BOOL)hasNames;


@end
