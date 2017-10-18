//
//  WYProfile.m
//  Withyou
//
//  Created by Tong Lu on 2016/10/19.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import "WYProfile.h"
#import "WYAccountApi.h"

@implementation WYProfile

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"relationship_status":@[@"relationship_status",@"relationshipStatus"],
             @"work_experience": @[@"work_experience",@"workExperience"],
             @"study_experience": @[@"study_experience",@"studyExperience"],
             
             @"current_work": @[@"current_work",@"currentWork"],
             };
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"nick_names" : [WYNickName class],
             @"work_experience": [WYJob class],
             @"study_experience": [WYStudy class],
             @"books": [WYBook class],
             @"movies": [WYMovie class],
             @"music": [WYMusic class],
             @"events": [WYEvent class]
             };
}

-(NSMutableArray *)interests{
    
    NSMutableArray *interests = [NSMutableArray array];
    if (self.books.count > 0)   [interests addObject:self.books];
    if (self.movies.count > 0)    [interests addObject:self.movies];
    if (self.music.count > 0)   [interests addObject:self.music];
    
    return interests;
}

- (NSString *)relationshipStr
{
    switch (self.relationship_status) {
        case 1:
            return @"单身";
            break;
        case 2:
            return @"恋爱";
            break;
        case 3:
            return  @"已婚";
        case 4:
            return @"保密";
            break;
}
    
    return @"";
}
+ (WYProfile *)queryProfileFromUuid:(NSString *)uuid{
    
    __block NSString *profileStr;
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *query = @"select profileStr from profile where user = ? ";
        FMResultSet * rs = [db executeQuery:query, uuid];
        while ([rs next]) {
            profileStr =  [rs stringForColumnIndex:0];
        }
    }];
    
    if(profileStr){
        WYProfile *profile = [WYProfile yy_modelWithJSON:profileStr];
        if(profile)
            return profile;
        else
        {
            return nil;
        }
    }
    else{
        return nil;
    }
}


+ (BOOL)saveProfileToDB:(WYProfile *)profile
{
    NSString *profileStr = [profile yy_modelToJSONString];
    
    __block BOOL isSuccess = false;
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql = @"insert or replace into 'profile' (user, profileStr) values (?, ?) ";
        BOOL res = [db executeUpdate:sql, profile.uuid, profileStr];
        if (!res) {
            debugLog(@"error to save profile in db");
            *rollback = YES;
            return;
        }
        else{
            isSuccess = true;
        }
    }];
    return isSuccess;
}

@end
