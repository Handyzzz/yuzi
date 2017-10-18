//
//  WYUserDetail.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/8.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYUserDetail.h"
@implementation WYUserDetail

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

- (NSString *)sexStr
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

//local
+ (void)queryUserDetailFromCache:(NSString *)Uuid Block:(void (^)(NSArray *postArr,WYUserDetail *userInfo, NSArray *photoArr,WYUserExtra *userExtra ,BOOL hasDetail))block{
    
    __block NSString *user_detail_str;
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {

        NSString *query = [NSString stringWithFormat:@"select * from 'user_detail_cache' where uuid = '%@'", Uuid];
        FMResultSet * rs = [db executeQuery:query];
        while ([rs next]) {
            user_detail_str =  [rs stringForColumn:@"user_detail_str"];
        }
    }];
    
    if(user_detail_str.length > 0){
    
        NSData *jsonData = [user_detail_str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        
        if(error){
                if(block)
                    block(nil,nil,nil,nil,NO);
            return;
        }
        
        NSArray *postModelArr = [dic objectForKey:@"posts"];
        NSDictionary *user_infoDic = [dic objectForKey:@"user_info"];
        NSArray *photosModelArr = [dic objectForKey:@"photos"];
        NSDictionary *extraDic = [dic objectForKey:@"extra"];
        
        NSArray *postArr = [WYPost YYModelParse:postModelArr];
        WYUserDetail *userInfo = [WYUserDetail YYModelParse:user_infoDic];
        NSArray *photoArr = [WYPhoto YYModelParse:photosModelArr];
        WYUserExtra *userExtra = [WYUserExtra YYModelParse:extraDic];
        
        if(block)
            block(postArr,userInfo,photoArr,userExtra,YES);
    }
    else{
        if(block)
            block(nil,nil,nil,nil,NO);
    }
}

+ (BOOL)saveUserDetailToDB:(NSString *)userDetailStr UUid:(NSString *)userUuid;{
    NSString *user_detail_str = userDetailStr;
    __block BOOL isSuccess = false;
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql = @"insert or replace into 'user_detail_cache' (uuid, user_detail_str) values (?, ?)";
        BOOL res = [db executeUpdate:sql, userUuid, user_detail_str];
        if (!res) {
            debugLog(@"error to save post in db");
            *rollback = YES;
            return;
        }
        else{
            isSuccess = true;
        }
    }];
    return isSuccess;
}

+ (BOOL)deleteUserDetailFromDB:(NSString *)uuid{
    __block BOOL isSuccess = false;
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql = @"delete from 'user_detail_cache' where uuid = ? ";
        BOOL res = [db executeUpdate:sql, uuid];
        if (!res) {
            debugLog(@"error to save post in db");
            *rollback = YES;
            return;
        }
        else{
            isSuccess = true;
        }
    }];
    return isSuccess;
}

+ (BOOL)deleteAllUserDetailFromCache{
    __block BOOL isSuccess = false;
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql = @"delete from user_detail_cache";
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            debugLog(@"error to delete post in db");
            *rollback = YES;
            return;
        }
        else{
            isSuccess = true;
        }
    }];
    return isSuccess;

}

+ (BOOL)saveUserWhichInUserInfoToDB:(WYUserDetail *)userInfo{
    
    __block BOOL res;
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSString * sql_user = @"insert or replace into 'user' (uuid, first_name, last_name, account_name, icon_url, sex, easemob_username, type) values ( ?, ?, ?, ?, ?, ?, ?, ?)";
        
        int errorCount = 0;
        
        
        res = [db executeUpdate:sql_user, userInfo.uuid, userInfo.first_name, userInfo.last_name, userInfo.account_name, userInfo.icon_url, [NSNumber numberWithInt:userInfo.sex], userInfo.easemob_username,[NSNumber numberWithInt:userInfo.type]];
        
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

@end
