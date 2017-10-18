//
//  WYUser.m
//  Withyou
//
//  Created by Tong Lu on 2016/10/18.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import "WYUser.h"
#import "WYDBManager.h"
#import "WYFollow.h"
#import "WYHttpClient.h"
#import "WYUserDetail.h"

@implementation WYUser

// 缓存聊天列表
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }

- (NSString *)description { return [self yy_modelDescription]; }

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


- (NSString *)sexString
{
    if(self.sex == 1)
    {
        return @"男";
    }
    else if(self.sex == 2){
        return @"女";
    }
    else
    {
        return @"";
    }
    
}
- (BOOL)isFollowedByMe
{
    BOOL a = [WYFollow queryExistFollowFrom:[WYUIDTool sharedWYUIDTool].uid.uuid
                                       To:self.uuid];
    return a;
}

- (NSDictionary *)permissionDictByMe
{
    if(self.isFollowedByMe)
    {
        return nil;
    }
    else{
        return @{};
    }
}

#pragma mark - Database Operations
//保存单个用户到本地数据库中
+ (BOOL)saveUserToDB:(WYUser *)user {
    
    __block BOOL res;
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSString * sql_user = @"insert or replace into 'user' (uuid, first_name, last_name, account_name, icon_url, sex, easemob_username, type) values ( ?, ?, ?, ?, ?, ?, ?, ?) ";
        
        int errorCount = 0;
        
        res = [db executeUpdate:sql_user, user.uuid, user.first_name, user.last_name, user.account_name, user.icon_url, [NSNumber numberWithInt:user.sex], user.easemob_username,[NSNumber numberWithInt:user.type]];
        
        if (!res) {
            debugLog(@"error to insert user");
            errorCount++;
        }
        else {
            //debugLog(@"succ to insert data");
        }
        
        if (errorCount != 0) {
            *rollback = YES;
            return;
        }
        else {
            return;
        }
        
    }];
    
    return res;
}

+ (void)getUserByEasemobName:(NSString *)name blcok:(void (^)(WYUser *))callback {
    WYUser *user = [WYUser queryUserWithEasemobName:name];
    if(user) {
        if(callback) {
            callback(user);
        }
    }else {
        [[WYHttpClient sharedClient] GETModelArrayWithKey:@"results" forClass:[WYUser class] url:[NSString stringWithFormat:@"/api/v1/user/search/?easemob_username=%@",name] parameters:nil callback:^(NSArray * models, id response) {
            if(models && models.count > 0) {
                [WYUser saveUserToDB:models[0]];
                if(callback) {
                    callback(models[0]);
                }
            }else {
                if(callback) {
                    callback(nil);
                }
            }
            
        }];
    }
}

+ (WYUser *)queryUserWithEasemobName:(NSString *)name {
    __block WYUser *user;
    
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        
        NSString *queryUser = [NSString stringWithFormat:@"select * from 'user' where easemob_username= '%@'", name];
        FMResultSet * rsUser = [db executeQuery:queryUser];
        while ([rsUser next]) {
            user = [[WYUser alloc] init];
            user.uuid = [rsUser stringForColumn:@"uuid"];
            user.first_name = [rsUser stringForColumn:@"first_name"];
            user.last_name = [rsUser stringForColumn:@"last_name"];
            user.account_name = [rsUser stringForColumn:@"account_name"];
            user.icon_url = [rsUser stringForColumn:@"icon_url"];
            user.sex = [rsUser intForColumn:@"sex"];
            user.easemob_username = [rsUser stringForColumn:@"easemob_username"];
            user.type = [rsUser intForColumn:@"type"];
        }
        
    }];
    return user;
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


+ (WYUser *)queryUserWithUuid:(NSString *)uuid
{
    //this method does not guarrantee for the most updated name of a user
//    因为这里仅仅是从本地数据库读取的缓存，需要最新的，还得靠网络请求
    __block WYUser *user = nil;
    
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
            
            NSString *queryUser = [NSString stringWithFormat:@"select * from 'user' where uuid= '%@'", uuid];
            FMResultSet * rsUser = [db executeQuery:queryUser];
            while ([rsUser next]) {
                user = [[WYUser alloc] init];
                user.uuid = [rsUser stringForColumn:@"uuid"];
                user.first_name = [rsUser stringForColumn:@"first_name"];
                user.last_name = [rsUser stringForColumn:@"last_name"];
                user.account_name = [rsUser stringForColumn:@"account_name"];
                user.icon_url = [rsUser stringForColumn:@"icon_url"];
                user.sex = [rsUser intForColumn:@"sex"];
                user.easemob_username = [rsUser stringForColumn:@"easemob_username"];
                user.type = [rsUser intForColumn:@"type"];
            }
    }];
    return user;
}

+ (WYUser *)userFromSelf
{
    WYUser *user = [WYUser new];
    user.uuid = [WYUIDTool sharedWYUIDTool].uid.uuid;
    user.last_name = [WYUIDTool sharedWYUIDTool].uid.last_name;
    user.first_name = [WYUIDTool sharedWYUIDTool].uid.first_name;
    user.account_name = [WYUIDTool sharedWYUIDTool].uid.account_name;
    user.sex = [WYUIDTool sharedWYUIDTool].uid.sex;
    user.icon_url = [WYUIDTool sharedWYUIDTool].uid.icon_url;
    user.easemob_username = [WYUIDTool sharedWYUIDTool].uid.easemob_username;
    user.type = [WYUIDTool sharedWYUIDTool].uid.type;

    return user;
}

@end
