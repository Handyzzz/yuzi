//
//  WYGroup.m
//  Withyou
//
//  Created by Tong Lu on 7/20/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import "WYGroup.h"
#import "FMDB.h"
#import "WYDBManager.h"
#import "WYQiniuApi.h"

@implementation WYGroup

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"partial_member_list": [WYUser class]
             };
}


//通过管理员UUID字符串 本地获取管理员列表
-(NSMutableArray *)adminList{
    NSMutableArray *list = [NSMutableArray array];
    NSArray*array = [self.administrator componentsSeparatedByString:@","];
    for (NSString *str in array) {
        [list addObject:[WYUser queryUserWithUuid:str]];
    }
    return list;
}



- (BOOL)created_by_follow_bool
{
    return [self.created_by_follow isEqualToNumber:@1];
}
- (NSString *)groupName
{
    if(self.created_by_follow_bool)
    {
        //        debugLog(@"inside");
        for(WYUser *f in self.partial_member_list)
        {
            //            debugLog(@"group uuid is %@", self.uuid);
            //            debugLog(@"f name %@", f.fullName);
            if(![f.uuid isEqualToString:[WYUIDTool sharedWYUIDTool].uid.uuid])
            {
                return f.fullName;
            }
        }
        
        return self.name;
    }
    else
    {
        //        debugLog(@"outside");
        return self.name;
    }
    
    
}
- (NSMutableArray *)groupMates
{
    NSMutableArray *ma = [NSMutableArray array];
    
    for(WYUser *f in self.partial_member_list)
    {
        if([f.uuid isEqualToString:[WYUIDTool sharedWYUIDTool].uid.uuid])
        {
            
        }
        else
        {
            [ma addObject:f];
        }
    }
    
    return ma;
    
}
- (NSString *)groupPicUrl
{
    if(self.created_by_follow_bool)
    {
        for(WYUser *f in self.partial_member_list)
        {
            if(![f.uuid isEqualToString:[WYUIDTool sharedWYUIDTool].uid.uuid])
            {
                return f.icon_url;
            }
        }
        return self.group_icon;
    }
    else
    {
        return self.group_icon;
    }
}

-(NSString *)tagsString{
    
    NSMutableString *ms = [NSMutableString string];

    if (self.tags.length > 0) {
        NSArray*strArr = [self.tags componentsSeparatedByString:@","];
        [strArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [ms appendString:@"#"];
            [ms appendString:obj];
            [ms appendString:@"  "];
        }];
    }
    return [ms copy];
}

#pragma mark - Database Operations
//保存一个群组列表在本地数据库中
//这里不仅仅是存群组group的信息，也存入群组和用户的关系group_user
+ (void)saveNewGroupsToLocalDB:(NSArray *)groupArray
{
    for(WYGroup *group in groupArray){
        [[self class] delGroupToUserRelationshipsForGroup:group.uuid];
    }
    
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        //group is a special name, must be quoted, otherwise, it will be a error
        NSString * sql_group = @"insert or replace into 'group_table' (uuid, name, memberNum, createdAtFloat, lastUpdatedAtFloat, created_by_follow, group_icon, public_visible,content_visible, administrator, introduction, allow_member_invite, number, display, notif_new_post, notif_comment_to_self_related, notif_comment_to_self_not_related, applied_status,category, tags, starred, unread_post_num) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ";
        
        //        这条语句存入群组和用户的关系
        NSString * sql_group_user_rel = @"insert or replace into 'group_user' (id, group_uuid, user_uuid) values ( (select id from 'group_user' where group_uuid = ? and user_uuid = ?), ?, ?) ";
        
        //        保存user模型
        //        这里单独保存user模型是因为，不仅仅通过group能获得user，也能通过搜索用户，或者活动，帖子的评论列表，或者其他途径，也能够获得user模型，也应该保存下来，缓存好，之后可以方便后面使用
        //        但是，这种使用并不能够保证user的信息是最新的，需要注意使用的场景，很可能需要网络请求最新的信息
        
        //tony, 4.18 added
        //        所以现在都是在保存群组前，就把用户和群组的关系都删掉，以确保都是新数据
        //        但是这也意味着，用户和群组的关系不用保存，只需要把admin的字符串保存下来就可以了
        
        NSString * sql_user = @"insert or replace into 'user' (uuid, first_name, last_name, account_name, icon_url, sex, easemob_username, type) values ( ?, ?, ?, ?, ?, ?, ?, ?)";
        
        
        BOOL res;
        int errorCount = 0;
        
        for(WYGroup *group in groupArray){
            
            res = [db executeUpdate:sql_group, group.uuid, group.name, [NSNumber numberWithInt:group.member_num], group.created_at_float, group.last_updated_at_float, group.created_by_follow, group.group_icon, group.public_visible,group.content_visible, group.administrator, group.introduction, group.allow_member_invite, group.number, group.display, group.notif_new_post, group.notif_comment_to_self_related, group.notif_comment_to_self_not_related,group.applied_status,group.category,group.tags,group.starred, [NSNumber numberWithInt:group.unread_post_num]];
            
            if (!res) {
                debugLog(@"error to insert group");
                errorCount++;
                break;
            }
            else {
                //成功，就继续添加群组与用户的关系
                //这个partial member list中包含所有的管理员用户，添加这个即可
                //添加之前 先清空group_user表 可能别的机器上有做退群操作
                //[WYGroup delGroupToUserTableData:db :rollback];
                
                for(WYUser *member in group.partial_member_list){
                    res = [db executeUpdate:sql_group_user_rel, group.uuid, member.uuid, group.uuid, member.uuid];
                    if (!res) {
                        debugLog(@"error to insert user group rel");
                        errorCount++;
                        break;
                    }
                    else {
                        //debugLog(@"succ to insert data");
                    }
                    
                    res = [db executeUpdate:sql_user, member.uuid, member.first_name, member.last_name, member.account_name, member.icon_url, [NSNumber numberWithInt:member.sex], member.easemob_username,[NSNumber numberWithInt:member.type]];
                    if (!res) {
                        debugLog(@"error to insert user");
                        errorCount++;
                        break;
                    }
                    else {
                        //                        debugLog(@"succ to insert data");
                    }
                }
                if (errorCount != 0) {
                    break;
                }
            }
        }
        if (errorCount != 0) {
            *rollback = YES;
            return;
        }
    }];
    
}



//保存单个群组到本地数据中
+ (void)insertGroup:(WYGroup *)group{
    
    [WYGroup saveNewGroupsToLocalDB:@[group]];
}

//从本地数据库中删除某个群组 （ 并且删除用户和群组的关系）
+ (void)removeGroupInGroups:(NSString *)groupUuid{
    __block BOOL isSuccess = false;
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql = @"DELETE FROM 'group_table' WHERE uuid = ? ";
        BOOL res;
        res = [db executeUpdate:sql, groupUuid];
        if (!res) {
            debugLog(@"error to delete group in db");
            *rollback = YES;
            return;
        }
        else{
            isSuccess = true;
        }
    }];
    //删除群组的时候 将自己和群组的管系删除掉
    [WYGroup removeGroupToUser:groupUuid UserUuid:kuserUUID];
}

+ (void)queryAllGroupsWithBlock:(void (^)(NSArray *groups))block
{
    NSMutableArray *groupArray = [NSMutableArray array];
    
    __block WYGroup *group;
    __block WYUser *user;
    
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        
        // 第一层循环， 查询group
        NSString *query = [NSString stringWithFormat:@"select * from 'group_table' where created_by_follow = 0 order by lastUpdatedAtFloat desc"];
        FMResultSet * rs = [db executeQuery:query];
        while ([rs next]) {
            group = [[WYGroup alloc] init];
            
            group.uuid = [rs stringForColumn:@"uuid"];
            group.name = [rs stringForColumn:@"name"];
            group.member_num = [rs intForColumn:@"memberNum"];
            group.created_at_float =  [NSNumber numberWithDouble:[rs doubleForColumn:@"createdAtFloat"]];
            group.last_updated_at_float = [NSNumber numberWithDouble:[rs doubleForColumn:@"lastUpdatedAtFloat"]];
            group.created_by_follow = [NSNumber numberWithInt:[rs intForColumn:@"created_by_follow"]];
            group.group_icon = [rs stringForColumn:@"group_icon"];
            group.public_visible = [NSNumber numberWithInt:[rs intForColumn:@"public_visible"]];
            group.content_visible = [NSNumber numberWithInt:[rs intForColumn:@"content_visible"]];
            group.administrator = [rs stringForColumn:@"administrator"];
            group.introduction = [rs stringForColumn:@"introduction"];
            group.allow_member_invite = [NSNumber numberWithInt:[rs intForColumn:@"allow_member_invite"]];
            group.number = [NSNumber numberWithInt:[rs intForColumn:@"number"]];
            group.display = [NSNumber numberWithInt:[rs intForColumn:@"display"]];
            group.notif_new_post = [NSNumber numberWithInt:[rs intForColumn:@"notif_new_post"]];
            group.notif_comment_to_self_related = [NSNumber numberWithInt:[rs intForColumn:@"notif_comment_to_self_related"]];
            group.notif_comment_to_self_not_related = [NSNumber numberWithInt:[rs intForColumn:@"notif_comment_to_self_not_related"]];
            group.applied_status = [NSNumber numberWithInt:[rs intForColumn:@"applied_status"]];
            group.category = [NSNumber numberWithInt:[rs intForColumn:@"category"]];
            group.tags = [rs stringForColumn:@"tags"];
            group.starred = [NSNumber numberWithInt:[rs intForColumn:@"starred"]];
            group.unread_post_num = [rs intForColumn:@"unread_post_num"];
            //            第二层循环，查询群组和用户的关系
            NSString *queryGroupUserRelationship = [NSString stringWithFormat:@"select id, user_uuid from 'group_user' where group_uuid= '%@'", group.uuid];
            FMResultSet * rsGroupUserRel = [db executeQuery:queryGroupUserRelationship];
            
            NSString *userUuid;
            NSMutableArray *userArray = [NSMutableArray array];
            while ([rsGroupUserRel next]) {
                userUuid = [rsGroupUserRel stringForColumn:@"user_uuid"];
                
                
                //每查到一个user， 就把这个user找出来
                //                但是这种方法的效率可能有问题，最好去使用uuid__in的方式，当时调试时有些问题，就暂且以这种方式代替
                //                todo
                NSString *queryUser = [NSString stringWithFormat:@"select * from 'user' where uuid= '%@'", userUuid];
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

                    
                    [userArray addObject:user];
                }
            }
            
            group.partial_member_list = [userArray copy];
            //          debugLog(@"partial member list count is %ld", userArray.count);
            [groupArray addObject:group];
        }
    }];
    
    if(block)
        block([groupArray copy]);
}

//我的所有星标群组
+ (void)queryAllStarredGroupsWithBlock:(void(^)(NSArray *groupArr))block{
    
    NSMutableArray *ma = [NSMutableArray array];
    [WYGroup queryAllGroupsWithBlock:^(NSArray *groups) {
        for (int i = 0; i < groups.count; i ++) {
            WYGroup *group = groups[i];
            if ([group.starred boolValue] == YES) {
                [ma addObject:group];
            }
        }
        block([ma copy]);
    }];
}

+ (NSArray *)queryAllMyGroupNumbers
{
    __block NSMutableArray *groups;
    [WYGroup queryAllGroupsWithBlock:^(NSArray *_groups) {
        groups = [NSMutableArray arrayWithArray:_groups];
    }];
    
    NSMutableArray *numbers = [[NSMutableArray alloc] init];
    for(WYGroup *g in groups)
    {
        [numbers addObject:g.number];
    }
    return numbers;
}
+ (WYGroup *)selectGroupDetail:(NSString *)uuid{
    
    __block WYGroup *group;
    __block WYUser *user;
    
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        
        NSString *query = [NSString stringWithFormat:@"select * from 'group_table' where uuid= '%@'",uuid];
        FMResultSet * rs = [db executeQuery:query];
        while ([rs next]) {
            group = [[WYGroup alloc] init];
            group.uuid = [rs stringForColumn:@"uuid"];
            group.name = [rs stringForColumn:@"name"];
            group.member_num = [rs intForColumn:@"memberNum"];
            group.created_at_float =  [NSNumber numberWithDouble:[rs doubleForColumn:@"createdAtFloat"]];
            group.last_updated_at_float = [NSNumber numberWithDouble:[rs doubleForColumn:@"lastUpdatedAtFloat"]];
            group.created_by_follow = [NSNumber numberWithInt:[rs intForColumn:@"created_by_follow"]];
            group.group_icon = [rs stringForColumn:@"group_icon"];
            group.public_visible = [NSNumber numberWithInt:[rs intForColumn:@"public_visible"]];
            group.content_visible = [NSNumber numberWithInt:[rs intForColumn:@"content_visible"]];
            group.administrator = [rs stringForColumn:@"administrator"];
            group.introduction = [rs stringForColumn:@"introduction"];
            group.allow_member_invite = [NSNumber numberWithInt:[rs intForColumn:@"allow_member_invite"]];
            group.number = [NSNumber numberWithInt:[rs intForColumn:@"number"]];
            group.display = [NSNumber numberWithInt:[rs intForColumn:@"display"]];
            group.notif_new_post = [NSNumber numberWithInt:[rs intForColumn:@"notif_new_post"]];
            group.notif_comment_to_self_related = [NSNumber numberWithInt:[rs intForColumn:@"notif_comment_to_self_related"]];
            group.notif_comment_to_self_not_related = [NSNumber numberWithInt:[rs intForColumn:@"notif_comment_to_self_not_related"]];
            group.applied_status = [NSNumber numberWithInt:[rs intForColumn:@"applied_status"]];
            group.category = [NSNumber numberWithInt:[rs intForColumn:@"category"]];
            group.tags = [rs stringForColumn:@"tags"];
            group.starred = [NSNumber numberWithInt:[rs intForColumn:@"starred"]];
            group.unread_post_num = [rs intForColumn:@"unread_post_num"];

            //            第二层循环，查询群组和用户的关系
            NSString *queryGroupUserRelationship = [NSString stringWithFormat:@"select id, user_uuid from 'group_user' where group_uuid= '%@'", group.uuid];
            FMResultSet * rsGroupUserRel = [db executeQuery:queryGroupUserRelationship];
            
            NSString *userUuid;
            NSMutableArray *userArray = [NSMutableArray array];
            while ([rsGroupUserRel next]) {
                userUuid = [rsGroupUserRel stringForColumn:@"user_uuid"];
                
                
                //每查到一个user， 就把这个user找出来
                //                但是这种方法的效率可能有问题，最好去使用uuid__in的方式，当时调试时有些问题，就暂且以这种方式代替
                //                todo
                NSString *queryUser = [NSString stringWithFormat:@"select * from 'user' where uuid= '%@'", userUuid];
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

                    [userArray addObject:user];
                }
            }
            
            group.partial_member_list = [userArray copy];
        }
    }];
    
    return group;
}

- (BOOL)meIsMemberOfGroupFromLocalDBRecords
{
    __block BOOL exists;
    exists = false;
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *queryGroupUserRelationship = [NSString stringWithFormat:@"select id from 'group_user' where group_uuid= '%@' and user_uuid= '%@'", self.uuid, kuserUUID];
        FMResultSet * rsGroupUserRel = [db executeQuery:queryGroupUserRelationship];
        while ([rsGroupUserRel next]) {
            exists = true;
        };
    }];
    return exists;
}
- (BOOL)meIsMemberOfGroupFromPartialMemberList{
    
    BOOL isMember = false;
    for(WYUser *user in self.partial_member_list){
        if([user.uuid isEqualToString:kuserUUID]){
            isMember = true;
            break;
        }
    }
    //不是群成员的时候把群组删掉
    if (isMember == false) {
        [WYGroup removeGroupInGroups:self.uuid];
    }
    return isMember;
}
//判断某个用户是否在某个群组内
+ (BOOL)user:(NSString*)userUuid IsMemberOfGroup:(NSString*)groupUuid{
    __block BOOL exists;
    exists = false;
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *queryGroupUserRelationship = [NSString stringWithFormat:@"select id from 'group_user' where group_uuid= '%@' and user_uuid= '%@'", groupUuid, userUuid];
        FMResultSet * rsGroupUserRel = [db executeQuery:queryGroupUserRelationship];
        while ([rsGroupUserRel next]) {
            exists = true;
        };
    }];
    return exists;
}

- (BOOL)checkUserIsAdminFromUserUuid:(NSString *)uuid{
    if(self.administrator.length == 0){
        return false;
    }
    
    NSArray*adminArray = [self.administrator componentsSeparatedByString:@","];
    
    BOOL isAdmin = false;
    for (NSString *str in adminArray) {
        if ([kuserUUID isEqualToString:str]) {
            isAdmin = true;
            break;
        }
    }
    return isAdmin;
}


- (BOOL)meIsAdmin{
    return [self checkUserIsAdminFromUserUuid:kuserUUID];
}


#pragma mark -
//添加群组与用户的关系
+(void)addGroupToUser:(NSString*)groupUuid UserUuid:(NSString*)userUuid{
    
    
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSString * sql_group_user_rel = @"insert or replace into 'group_user' (id, group_uuid, user_uuid) values ( (select id from 'group_user' where group_uuid = ? and user_uuid = ?), ?, ?) ";
        BOOL res;
        //保存用户与群组的关系
        res = [db executeUpdate:sql_group_user_rel, groupUuid, userUuid, groupUuid, userUuid];
        if (!res) {
            debugLog(@"error to insert user group rel");
        } else {
            //                debugLog(@"succ to insert data");
        }
    }];
    
    
}

//删除用户与群组的关系
+(void)removeGroupToUser:(NSString*)groupUuid UserUuid:(NSString*)userUuid{
    __block BOOL isSuccess = false;
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql = @"DELETE FROM 'group_user' where group_uuid = ? and user_uuid = ? ";
        BOOL res;
        res = [db executeUpdate:sql, groupUuid,userUuid];
        if (!res) {
            debugLog(@"error to delete group in db");
            *rollback = YES;
            return;
        }
        else{
            isSuccess = true;
        }
    }];
    
}
+(void)delGroupToUserTableData:(FMDatabase *)db :(BOOL*)rollback{
    __block BOOL isSuccess = false;
    NSString * sql = @"DELETE FROM 'group_user'";
    BOOL res;
    res = [db executeUpdate:sql];
    if (!res) {
        debugLog(@"error to delete group_user in db");
        *rollback = YES;
        return;
    }
    else{
        isSuccess = true;
    }
}
+(void)delGroupToUserRelationshipsForGroup:(NSString *)groupUuid{
    __block BOOL isSuccess = false;
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql = @"DELETE FROM 'group_user' where group_uuid = ?";
        BOOL res;
        res = [db executeUpdate:sql, groupUuid];
        if (!res) {
            debugLog(@"error to delete group_user table in db");
            *rollback = YES;
            return;
        }
        else{
//            debugLog(@"success to delete group_user table in db");
            isSuccess = true;
        }
    }];
    
}

@end
