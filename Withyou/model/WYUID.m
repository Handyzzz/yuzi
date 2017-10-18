//
//  WYUID.m
//  Withyou
//
//  Created by hongfei on 14-5-28.
//  Copyright (c) 2014年 Withyou Inc. All rights reserved.
//

#import "WYUID.h"
#import "WYDBManager.h"

@implementation WYUID

- (id)init
{
    if (self = [super init]) {
        
        self.uuid = @"";
        self.token = @"";
        self.account_name = @"";
        self.primary_phone = @"";
        self.time_int_last_account_change = 0;
        self.icon_url = @"";
        self.first_name = @"";
        self.last_name = @"";
        self.sex = 3;
        self.easemob_username = @"";
        self.easemob_password = @"";
        self.type = 3;
    }
    
    return self;
}

-(WYUser *)user{
    
    WYUser *user = [WYUser new];
    user.uuid = self.uuid;
    user.first_name = self.first_name;
    user.last_name = self.last_name;
    user.account_name = self.account_name;
    user.icon_url = self.icon_url;
    user.easemob_username = self.easemob_username;
    user.sex = self.sex;
    user.type = self.type;

    
    return user;
}



- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }



- (NSString *)fullName
{
    if( (!self.last_name || [self.last_name isEqualToString:@""]) &&
       (!self.first_name || [self.first_name isEqualToString:@""])) {
        return self.account_name;
    }
    
    NSString *fullName = nil;
    
    if([NSString hasUnicodeCharacters:self.last_name] && [NSString hasUnicodeCharacters:self.first_name]) {
        fullName =  [NSString stringWithFormat:@"%@%@", self.last_name, self.first_name];
    }else {
        fullName = [NSString stringWithFormat:@"%@ %@", self.first_name, self.last_name];
    }
    
    return fullName;
}


//现在只用判断姓名 不用accountName
- (BOOL)hasNames
{
    if(!self.first_name || !self.last_name)
        return false;
    
    if(self.first_name.length == 0 || self.last_name.length == 0)
        return false;
    
    return true;
}

@end

