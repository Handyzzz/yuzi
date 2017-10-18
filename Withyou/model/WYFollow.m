//
//  WYFollow.m
//  Withyou
//
//  Created by Tong Lu on 2016/11/1.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import "WYFollow.h"
#import "WYGroup.h"

@implementation WYFollow

- (WYUser *)followerUser
{
    return [WYUser queryUserWithUuid:self.follower];
}
- (WYUser *)influencerUser
{
    return [WYUser queryUserWithUuid:self.influencer];
}
//每次刚进来的时候拉取follow 发送改动时间 获取上次改动时间 获取followList UserList,删除的uuidList
+ (void)listFollowBlock:(void(^)(NSArray*followList,NSArray*userList,NSArray*uuidList))block{
    
//    top_add和top_del需要用数据库直接查看，没有的话就是0，而且数据库对于查不到的对象，赋值也是0
//    tony added 03.17
    NSDictionary *dic = [NSDictionary dictionary];
    //第一次(0是get里边设置的)
    dic = @{@"top_add": [WYFollow getTopAdd],
            @"top_del": [WYFollow getTopDel],
           };
    NSString *s = @"api/v1/follow/change_list/";
    [[WYHttpClient sharedClient] GET:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                        
                                                        
                                                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
                                                            NSArray *addfollow = [responseObject valueForKeyPath:@"add_follow_list"];
                                                            NSArray *adduser = [responseObject valueForKeyPath:@"add_user_list"];
                                                            NSArray *del = [responseObject valueForKey:@"del_uuid_list"];
                                                            NSNumber *newTopAdd = [responseObject valueForKey:@"new_top_add"];
                                                            NSNumber *newTopDel = [responseObject valueForKey:@"new_top_del"];
                                                            
                                                            NSArray *followsModel = [NSArray yy_modelArrayWithClass:[WYFollow class] json:addfollow];
                                                            NSArray *usersModel = [NSArray yy_modelArrayWithClass:[WYUser class] json:adduser];
                                                            
                                                            if(followsModel.count > 0) {
                                                                if([WYFollow saveFollowListToDB:followsModel])
                                                                    [WYFollow saveTopAdd:newTopAdd];
                                                            }
                                                            
                                                            if (usersModel.count >0) {
                                                                for (WYUser *user in usersModel) {
                                                                    [WYUser saveUserToDB:user];
                                                                }
                                                            }
                                                            if(del.count > 0) {
                                                                if([WYFollow delFollowListFromDB:[del copy]])
                                                                    [WYFollow saveTopDel:newTopDel];
                                                            }
                                                            
                                                            if(block)
                                                                block(followsModel,usersModel,del);
                                                        });

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@", error);
                                         if(block)
                                             block(nil,nil,nil);
    }];
}



//查询双方的关注关系 返回存在的双向关注关系(最多两个) 以及解除的双向关注关系(可以有N个 关系成员固定但是follow的uuid不同)
+ (void)retrieveRelationship:(NSString *)uuid Block:(void(^)(NSArray *existFollowArr, NSArray *delFollowArr))block{
    
    NSString *s = [NSString stringWithFormat:@"api/v1/follow/user/"];
    NSDictionary *dic = @{@"user":uuid};
    [[WYHttpClient sharedClient] GET:s parameters:dic
                             progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 
                                 
                                 debugLog(@"%@",responseObject);
                                 NSArray *existFollowArr = [responseObject objectForKey:@"exist"];
                                 NSArray *delFollowArr = [responseObject objectForKey:@"del"];
                                 
                                 /*
                                  yymodel 是字典就用dicWithClass
                                          是数组就用arrWithClass
                                  */
                                 
                                 NSArray *existModel = [NSArray yy_modelArrayWithClass:[WYFollow class] json:existFollowArr];
                                 NSArray *delModel = [NSArray yy_modelArrayWithClass:[WYFollow class] json:delFollowArr];
                                 [WYFollow saveFollowListToDB:existModel];
                                 [WYFollow delFollowListFromDB:delModel];
                                 if(block)
                                     block(existFollowArr, delFollowArr);
                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 NSLog(@"error is %@", error);
                                    
                                 if(block)
                                     block(nil,nil);
                             }];

}

//添加follow关系 并存在本地
//用在我要去关注别人的场景下
+ (void)addFollowToUuid:(NSString *)influencerUuid Block:(void (^)(WYFollow *follow,NSInteger status))block
{
    [[WYHttpClient sharedClient] POST:@"api/v1/follow/" parameters:@{@"influencer": influencerUuid}
                             progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 
                                 WYFollow *follow = [WYFollow yy_modelWithDictionary:responseObject];
                                 //被我关注的人，存下来
                                 NSDictionary *influencerDict = [responseObject objectForKey:@"influencer_user"];
                                 WYUser *influencer = [WYUser yy_modelWithDictionary:influencerDict];
                                 [WYUser saveUserToDB:influencer];
                                 
                                 //将follow关系存到本地数据库
                                 if (follow) {
                                     [WYFollow saveFollowToDB:follow];
                                 }
                     NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                 if(block)
                                     block(follow,httpResponse.statusCode);
                                 
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                 if(block)
                                     block(nil,httpResponse.statusCode);
    }];
    
}
//删除双方的关注关系 参数是follow本身的UUID
//本地与后台都删除
+ (void)delFollow:(NSString *)followUuid Block:(void (^)(BOOL res))block
{
    NSString *s = [NSString stringWithFormat:@"api/v1/follow/%@/", followUuid];
    
    [[WYHttpClient sharedClient] DELETE:s parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [WYFollow delFollowFromDB:followUuid];
        if(block)
            block(YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@", error);
        if(block)
            block(NO);
    }];
}


+ (BOOL)saveFollowToDB:(WYFollow *)follow{
    __block BOOL isSuccess = false;
    
    //涉及到写数据 用inTransaction 有一种安全机制
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql = @"insert or replace into 'follow' (uuid, follower, influencer, createdAtFloat) values (?, ?, ?, ?) ";
        BOOL res = [db executeUpdate:sql, follow.uuid, follow.follower, follow.influencer, follow.created_at_float];
        if (!res) {
            debugLog(@"error to save comment in db");
            *rollback = YES;
            return;
        }
        else{
            isSuccess = true;
        }
    }];
    return isSuccess;
}

+ (BOOL)saveFollowListToDB:(NSArray *)follows
{
    __block BOOL isSuccess = false;
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql = @"insert or replace into 'follow' (uuid, follower, influencer, createdAtFloat) values (?, ?, ?, ?) ";
        BOOL res;
        int errorCount = 0;
        for(WYFollow *follow in follows)
        {
            res = [db executeUpdate:sql, follow.uuid, follow.follower, follow.influencer, follow.created_at_float];
            
            if (!res) {
                debugLog(@"error to save comment in db");
                errorCount++;
                break;
            }
        }
        
        if (errorCount != 0) {
            *rollback = YES;
            return;
        }
        else{
            isSuccess = true;
        }
    }];
    return isSuccess;
}


+ (BOOL)delFollowFromDB:(NSString *)followUuid
{
    __block BOOL isSuccess = false;
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql = @"DELETE FROM 'follow' WHERE uuid = ? ";
        BOOL res;
        res = [db executeUpdate:sql, followUuid];
        if (!res) {
            debugLog(@"error to delete follow in db");
            *rollback = YES;
            return;
        }
        else{
            isSuccess = true;
        }
    }];
    return isSuccess;
}


+ (BOOL)delFollowListFromDB:(NSArray *)followUuids
{
    __block BOOL isSuccess = false;
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql = @"DELETE FROM 'follow' WHERE uuid = ? ";
        BOOL res;
        int errorCount = 0;
        for(NSString *uuid in followUuids)
        {
            res = [db executeUpdate:sql, uuid];
            if (!res) {
                debugLog(@"error to save comment in db");
                errorCount++;
                break;
            }
        }
        
        if (errorCount != 0) {
            *rollback = YES;
            return;
        }
        else{
            isSuccess = true;
        }
    }];
    return isSuccess;
}





//我关注的人
+ (NSArray *)queryAllFollowListFromMe
{
    __block NSMutableArray *arr = [NSMutableArray array];
    __block WYFollow *follow;
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *query = @"select * from follow where follower = ? order by createdAtFloat desc";
        FMResultSet * rs = [db executeQuery:query, kuserUUID];
        while ([rs next]) {
            follow = [WYFollow new];
            follow.uuid = [rs stringForColumn:@"uuid"];
            follow.follower = [rs stringForColumn:@"follower"];
            follow.influencer = [rs stringForColumn:@"influencer"];
            follow.created_at_float =  [NSNumber numberWithDouble:[rs doubleForColumn:@"createdAtFloat"]];
            if (follow.influencerUser) {
                [arr addObject:follow.influencerUser];
            }
        }
    }];

    return ([arr copy]);
}


//关注我的人
+ (NSArray *)queryAllFollowListToMe
{
    __block NSMutableArray *arr = [NSMutableArray array];
    __block WYFollow *follow;
    //查找 读 可以用inDatabase
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *query = @"select * from follow where influencer = ? order by createdAtFloat desc";
        FMResultSet * rs = [db executeQuery:query, kuserUUID];
        while ([rs next]) {
            follow = [WYFollow new];
            follow.uuid = [rs stringForColumn:@"uuid"];
            follow.follower = [rs stringForColumn:@"follower"];
            follow.influencer = [rs stringForColumn:@"influencer"];
            follow.created_at_float =  [NSNumber numberWithDouble:[rs doubleForColumn:@"createdAtFloat"]];
            if (follow.followerUser) {
                [arr addObject:follow.followerUser];
            }
        }
    }];

    return ([arr copy]);
}

//我单向关注的人
+ (NSArray *)queryAllSingleFollowListFromMe{
   
    
    //我关注的人
    NSArray *infArr = [WYFollow queryAllFollowListFromMe];
    //在我关注的人的列表中排除掉
    NSMutableArray *onlyMe = [infArr mutableCopy];
    
    //关注我的人
    NSArray *folArr = [WYFollow queryAllFollowListToMe];
    
    for (WYUser *inf in infArr) {
        for (WYUser *fol in folArr) {
            if ([inf.uuid isEqualToString:fol.uuid]) {
                [onlyMe removeObject:inf];
            }
        }
    }
    return onlyMe;
}



//添加关注我的人 排除掉在当前群内的
+ (void)listFollowListToMeNotInGroup:(NSString*)groupUuid Block:(void(^)(NSArray *removeArr,BOOL success))block{
    
    NSString *s = [NSString stringWithFormat:@"api/v1/group/%@/remove_list_before_invite/",groupUuid];
    [[WYHttpClient sharedClient] GET:s parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *removeArr = [responseObject objectForKey:@"remove_list"];
        if (block) {
            block(removeArr,YES);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,NO);
        }
    }];
}


//邀请我关注人人 排除掉在当前群内的
+ (void)listFollowListFromMeNotInGroup:(NSString*)groupUuid Block:(void(^)(NSArray *removeArr,BOOL success))block{
    
    NSString *s = [NSString stringWithFormat:@"api/v1/group/%@/remove_list_before_add/",groupUuid];
    [[WYHttpClient sharedClient] GET:s parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *removeArr = [responseObject objectForKey:@"remove_list"];
        if (block) {
            block(removeArr,YES);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,NO);
        }

    }];
}

//通过双放的关注关系查找followUuid
+(WYFollow *)selectFollowUuidFollowerUuid:(NSString *)followerUuid influcerUuid:(NSString *)influcerUuid{
    
    __block WYFollow *follow;
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *query = @"select * from 'follow' where follower = ? and influencer = ?";
        FMResultSet * rs = [db executeQuery:query, followerUuid,influcerUuid];
        while ([rs next]) {
            follow = [WYFollow new];
            follow.uuid = [rs stringForColumn:@"uuid"];
            follow.follower = [rs stringForColumn:@"follower"];
            follow.influencer = [rs stringForColumn:@"influencer"];
            follow.created_at_float =  [NSNumber numberWithDouble:[rs doubleForColumn:@"createdAtFloat"]];
        }

    }];
    return follow;
}

//查找某个User的所有朋友
//先查找单向 再从中查找双向关注 通过朋友的UUID数组再获取朋友的user数组
+ (NSArray *)queryMutualFollowingFriends{
    
    //    "CREATE TABLE IF NOT EXISTS 'follow' ('uuid' TEXT PRIMARY KEY NOT NULL, 'follower' TEXT, 'influencer' TEXT, 'createdAtFloat' REAL);"
    //    1. 筛选出我关注的人的uuid列表 listA
    //    2. 筛选关注我的人的列表，同时他们也在我关注的列表listA内
    //
    __block NSMutableArray *arrf = [NSMutableArray array];
    __block NSMutableArray *arr = [NSMutableArray array];
    __block WYFollow *follow;
    __block WYFollow *followi;
//    debugLog(@"check point");
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *queryf = [NSString stringWithFormat:@"select * from 'follow' where  follower = ? "];
        FMResultSet *rsf = [db executeQuery:queryf ,kuserUUID];
        while ([rsf next]) {
//            debugLog(@"check point 2");

            follow = [WYFollow new];
            follow.uuid = [rsf stringForColumn:@"uuid"];
            follow.follower = [rsf stringForColumn:@"follower"];
            follow.influencer = [rsf stringForColumn:@"influencer"];
            follow.created_at_float =  [NSNumber numberWithDouble:[rsf doubleForColumn:@"createdAtFloat"]];
            [arrf addObject:follow.influencer];
            
            if (follow.influencer) {
                NSString *queryi = [NSString stringWithFormat:@"select * from 'follow' where follower = ? and influencer = ?"];
                FMResultSet *rsi = [db executeQuery:queryi, follow.influencer, kuserUUID];
                while ([rsi next]){
//                    debugLog(@"check point 3");

                    followi = [WYFollow new];
                    followi.uuid = [rsi stringForColumn:@"uuid"];
                    followi.follower = [rsi stringForColumn:@"follower"];
                    followi.influencer = [rsi stringForColumn:@"influencer"];
                    followi.created_at_float =  [NSNumber numberWithDouble:[rsi doubleForColumn:@"createdAtFloat"]];
                    [arr addObject:followi.followerUser];
                }
            }
        }
    }];
        
    return arr;
}

//通过一个人的Uuid来判断某个人和我的关系 本地查找
/*这个判断是互斥的    0没有关系  1 仅我关注的人 2仅关注我的人 3朋友 4 自己*/ 
+ (NSInteger)queryRelationShipWithMeFollowArr:(NSString*)Uuid infArr:(NSArray *)infArr folArr:(NSArray *)folArr{
    if([Uuid isEqualToString:kuserUUID]){
        return 4;
    }
    BOOL isInf = false;
    BOOL isFol = false;
    for (WYUser *user in infArr) {
        if ([user.uuid isEqualToString:Uuid]) {
            //是我关注的人
            isInf = YES;
        }
    }
    for (WYUser *user in folArr) {
        if ([user.uuid isEqualToString:Uuid]) {
            //是关注我的人的人
            isFol = YES;
        }
    }
    if (isInf && isFol) {
        return 3;
    }else if (isInf){
        return 1;
    }else if (isFol){
        return 2;
    }
    return 0;
}
 + (BOOL)queryExistFollowFrom:(NSString *)follower To:(NSString *)influencer
{
    __block int num = 0;
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        
        NSString *queryUser = [NSString stringWithFormat:@"select count(*) from 'follow' where follower = '%@' AND influencer = '%@' ", follower , influencer];
        FMResultSet * rsUser = [db executeQuery:queryUser];
        while ([rsUser next]) {
            num = [rsUser intForColumnIndex:0];
        }
    }];
    
    if(num > 0)
        return true;
    else
        return false;
}
#pragma mark - Local Database value
+ (NSNumber *)getTopAdd
{
    __block NSNumber *num = @0;
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *query = [NSString stringWithFormat:@"select top_add from 'global_sync_record' where name = 'follow' "];
        FMResultSet * rs = [db executeQuery:query];
        while ([rs next]) {
            num = [NSNumber numberWithDouble:[rs doubleForColumnIndex:0]];
        }
    }];
    return num;
}
+ (NSNumber *)getTopDel
{
    //其他用户最近删除了哪些内容，以及什么时候删除的，这些都一无所知，所以需要与后端保持一致，在前端建立好这个备份
    __block NSNumber *num = @0;
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *query = [NSString stringWithFormat:@"select top_del from 'global_sync_record' where name = 'follow' "];
        FMResultSet * rs = [db executeQuery:query];
        while ([rs next]) {
            num = [NSNumber numberWithDouble:[rs doubleForColumnIndex:0]];
        }
    }];
    return num;
}
+ (void)saveTopAdd:(NSNumber *)num
{
    __block NSNumber *top_del = [WYFollow getTopDel];
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql_photo = @"insert or replace into 'global_sync_record' (name, top_add, top_del) values ( 'follow', ?, ?) ";
        BOOL res = [db executeUpdate:sql_photo, num, top_del];
        if (!res) {
            debugLog(@"error to insert top num");
            *rollback = YES;
            return;
        }
    }];
}
+ (void)saveTopDel:(NSNumber *)num
{
    __block NSNumber *top_add = [WYFollow getTopAdd];
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql_photo = @"insert or replace into 'global_sync_record' (name, top_add, top_del) values ( 'follow', ?, ?) ";
        BOOL res = [db executeUpdate:sql_photo, top_add, num];
        if (!res) {
            debugLog(@"error to insert data");
            *rollback = YES;
            return;
        }
    }];
}
#pragma mark -
+ (NSNumber *)getTopAddOfOthersFollowingMe
{
    __block NSNumber *num = @0;
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *query = [NSString stringWithFormat:@"select top_add from 'global_sync_record' where name = 'othersFollowingMe' "];
        FMResultSet * rs = [db executeQuery:query];
        while ([rs next]) {
            num = [NSNumber numberWithDouble:[rs doubleForColumnIndex:0]];
        }
    }];
    return num;
}
+ (NSNumber *)getTopDelOfOthersFollowingMe
{
    //其他用户最近删除了哪些内容，以及什么时候删除的，这些都一无所知，所以需要与后端保持一致，在前端建立好这个备份
    __block NSNumber *num = @0;
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *query = [NSString stringWithFormat:@"select top_del from 'global_sync_record' where name = 'othersFollowingMe' "];
        FMResultSet * rs = [db executeQuery:query];
        while ([rs next]) {
            num = [NSNumber numberWithDouble:[rs doubleForColumnIndex:0]];
        }
    }];
    return num;
}

//把别人关注我的信息的增加和删除的时间戳保存在前端，以便请求时只需要部分请求，而不再需要请求全部的列表
+ (void)saveTopAddOfOthersFollowingMe:(NSNumber *)num
{
    __block NSNumber *top_del = [WYFollow getTopDelOfOthersFollowingMe];
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql_photo = @"insert or replace into 'global_sync_record' (name, top_add, top_del) values ( 'othersFollowingMe', ?, ?) ";
        BOOL res = [db executeUpdate:sql_photo, num, top_del];
        if (!res) {
            debugLog(@"error to insert top num");
            *rollback = YES;
            return;
        }
    }];
}
//把别人对我的各种取消关注的最新的时间保存在前端
+ (void)saveTopDelOfOthersFollowingMe:(NSNumber *)num
{
    __block NSNumber *top_add = [WYFollow getTopAddOfOthersFollowingMe];
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql_photo = @"insert or replace into 'global_sync_record' (name, top_add, top_del) values ( 'othersFollowingMe', ?, ?) ";
        BOOL res = [db executeUpdate:sql_photo, top_add, num];
        if (!res) {
            debugLog(@"error to insert data");
            *rollback = YES;
            return;
        }
    }];
}
+ (void)requestFollowingAndFollower
{
    
    //    请求后端发给我所有关于我关注他人的信息的更新
//    [WYFollow listFollowTopBlock:^(NSArray *res){}];
    //    关于别人关注我的更新
//    [WYFollow listFollowerOfMineTopBlock:^(NSArray *res){}];
    
    //    更新包括新加的，也包括删除的
}

@end
