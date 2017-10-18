//
//  WYDBManager.m
//  Withyou
//
//  Created by Tong Lu on 16/8/17.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import "WYDBManager.h"
#import <sqlite3.h>


static WYDBManager *sharedInstance = nil;

@implementation WYDBManager
//只要用户是登录状态，在App启动后，就执行一次sql schema的更新，之后的请求就不用更新了
//此外，用户登录后，以及登出后，也要执行这种更新，因为只有用户登录了，才知道数据库建在哪里，也会有表
+(WYDBManager*)getSharedInstance
{
    if (!sharedInstance) {
        
        sharedInstance = [[super allocWithZone:NULL] init];
        
    }
    
    return sharedInstance;
}
-(void)createTablesAndUpdateToNewestVersion
{
    [self createTables];
    [self checkForUpdate2];
}
- (FMDatabaseQueue *)sharedQueue
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[WYDBManager getDatabasePath]];
    return queue;
    
}
+ (NSString *)getDatabasePath
{
    // so that every user will use his own database, after logout and login, data will be safe for shared users on the same phone
    NSString *dataBase = [[WYUIDTool sharedWYUIDTool].uid.uuid stringByAppendingString:kDatabaseFileName];
    NSString *dbPath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:dataBase];
//    debugLog(@"path is %@", dbPath);
    return dbPath;
}

- (void)createTables
{
    NSString *dbPath = [WYDBManager getDatabasePath];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:dbPath] == NO) {
        [self createTablesWithoutCheckFromDbPath:dbPath];
    }
}

//group_table: 群组的名称和基本信息， 其中memberNum和lastUpdatedAtFloat是会经常变动的，比如成员的增加和减少，里面是否发布了新的帖子。所以每次从后端获取了新的关于群组的信息，都要在本地数据库中及时更新
//follow: 关注关系
//global_sync_record: 有些资源的更新，需要本地存一些数字，表示更新到哪个时间，比如关注关系中，top_add和top_del
//profile:把用户的详细资料，以字符串的方式去存入，这样就避免了在本地建立多个表格来表达用户的详细个人资料，因为有学习经历，工作经历，爱读的书，电影，音乐，等等，非常多，太复杂，所以选择用字符串来做一种本地缓存
- (void)createTablesWithoutCheckFromDbPath:(NSString *)dbPath
{
    FMDatabase * db = [FMDatabase databaseWithPath:dbPath];
    
    if ([db open]) {
        
        //user table is binded to group, each row has a group_uuid
        //topic table is not, self topics have null group_uuid; photo table as well
        
        NSString * sql = @"CREATE TABLE IF NOT EXISTS 'group_table' ('uuid' TEXT PRIMARY KEY NOT NULL, 'name' TEXT, 'memberNum' INTEGER, 'createdAtFloat' REAL, 'lastUpdatedAtFloat' REAL);"
        "CREATE TABLE IF NOT EXISTS 'follow' ('uuid' TEXT PRIMARY KEY NOT NULL, 'follower' TEXT, 'influencer' TEXT, 'createdAtFloat' REAL);"
        "CREATE TABLE IF NOT EXISTS 'global_sync_record' ('name' TEXT PRIMARY KEY NOT NULL, 'top_add' REAL, 'top_del' REAL);"
        "CREATE TABLE IF NOT EXISTS 'profile' ('user' TEXT PRIMARY KEY NOT NULL, 'profileStr' TEXT);";
        
//         "CREATE TABLE IF NOT EXISTS 'user' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'group_uuid' TEXT, 'user_uuid' TEXT, 'firstName' TEXT, 'lastName' TEXT, 'accountName' TEXT, 'iconUrl' TEXT, 'sex' INTEGER);"
        
        
//        "CREATE TABLE IF NOT EXISTS 'info_permission' ('influencer' TEXT PRIMARY KEY NOT NULL, 'permissionStr' TEXT);"
//        "CREATE TABLE IF NOT EXISTS 'topic' ('uuid' TEXT PRIMARY KEY NOT NULL, 'title' TEXT, 'type' INTEGER, 'author' TEXT, 'content' TEXT, 'group_uuid' TEXT, 'createdAtFloat' REAL, 'lastUpdatedAtFloat' REAL);"
//        "CREATE TABLE IF NOT EXISTS 'photo' ('uuid' TEXT PRIMARY KEY NOT NULL, 'url' TEXT, 'content' TEXT, 'height' INTEGER, 'width' INTEGER, 'createdAtFloat' REAL, 'order_int' INTEGER, 'group_uuid' TEXT, 'uploader' TEXT, 'thumbnail' TEXT);"
//        "CREATE TABLE IF NOT EXISTS 'photo_sync_record' ('uuid' TEXT PRIMARY KEY NOT NULL, 'top_add' REAL, 'top_del' REAL, 'bottom' REAL);"
//        "CREATE TABLE IF NOT EXISTS 'topic_sync_record' ('uuid' TEXT PRIMARY KEY NOT NULL, 'top_add' REAL, 'top_del' REAL, 'bottom' REAL);"
//        "CREATE TABLE IF NOT EXISTS 'topic_comment' ('uuid' TEXT PRIMARY KEY NOT NULL, 'targetTopic' TEXT, 'author' TEXT, 'content' TEXT, 'createdAtFloat' REAL, 'type' INTEGER);"
//        "CREATE TABLE IF NOT EXISTS 'topic_comment_sync_record' ('topic' TEXT PRIMARY KEY NOT NULL, 'top_add' REAL, 'top_del' REAL);"
        
        // more than one line of SQL should use executeStatements
        BOOL res = [db executeStatements:sql];
        if (!res) {
            debugLog(@"error when creating db tables");
        } else {
          debugLog(@"succ to creating db tables");
        }
        [db close];
        
    } else {
        debugLog(@"error when open db when creating tables");
    }
}

#pragma mark - Sqlite migration
/*
- (void)checkForUpdate
{
//    这个使用了三个地方来存储版本号，逻辑略复杂，可以考虑下面的checkForUpdate2函数，那个用了简单些的方法，不过就是每次要去检查一次数据库
    id dbVersionFromUserDefaults = [[NSUserDefaults standardUserDefaults] objectForKey:kDatabaseVersionInUserDefaultsKey];
    
    if(dbVersionFromUserDefaults)
    {
        
        //app has set user defaults before, but old than expected version
        //need to migrate
        if([dbVersionFromUserDefaults intValue] < kExpectedDatabaseVersion)
        {
            //意味着数据库需要迁移，迁移后，数据库的内置版本号会增加到预期的版本号
            //如果迁移失败的话，数据库的内置版本号不会改变
            
            int cv = [sharedInstance databaseCurrentSchemaVersion];
            if(cv >= kExpectedDatabaseVersion)
            {
                //说明新版的code有问题，实际的当前版本要比目标版本更大
                //三个地方可能某个地方出了问题，1. NSUserDefaults  2. kExpectedDatabassVersion 3. sqlite内置的PRAGMA user_version
                [WYDBManager saveToUserDefaultsForDBVersion:cv];
                return;
            }
            
            //need migration
            [WYDBManager migrateDatabaseFromVersion:cv
                                          ToVersion:kExpectedDatabaseVersion
                                          WithBlock:^(BOOL res) {
                                              
                          if(res)
                          {
                              //if migration succeed, save the results
                              
                              //if save to database succeeded, save to UserDefaults as well
                              if([sharedInstance setDatabaseSchemaVersion:kExpectedDatabaseVersion])
                                  [WYDBManager saveToUserDefaultsForDBVersion:kExpectedDatabaseVersion];

                          }
                          else
                          {
                                //todo, http post error log to backend
                              //for details of why this migration will fail
                          }
            }];
        }
        else {
            //正常运行时，代码会到这里，意味着数据库不需要迁移，当前的状态是完好的
        }
    }
    else{
        //app is first downloaded, or have deleted and re-downloaded
        int cv = [sharedInstance databaseCurrentSchemaVersion];
        
        NSLog(@"dbv else, is %d", cv);

        [WYDBManager saveToUserDefaultsForDBVersion:cv];
    }
}
 */
- (void)checkForUpdate2
{
    //每次改动了数据库的表结构，kExpectedDatabaseVersion在代码中要增加1，最初的版本号是0
    int currentVersion = [sharedInstance databaseCurrentSchemaVersion];
    debugLog(@"current %d, exp %d", currentVersion, kExpectedDatabaseVersion);
    
    //app has set user defaults before, but old than expected version
    //need to migrate
    if(currentVersion < kExpectedDatabaseVersion)
    {
        //意味着数据库需要迁移，迁移后，数据库的内置版本号会增加到预期的版本号
        //如果迁移失败的话，数据库的内置版本号不会改变
        

        //need migration
        [WYDBManager migrateDatabaseFromVersion:currentVersion
                                      ToVersion:kExpectedDatabaseVersion
                                      WithBlock:^(BOOL res) {
                                          
                                          if(res)
                                          {
                                              //if migration succeed
                                              //if save to database succeeded, save to UserDefaults as well
                                              [sharedInstance setDatabaseSchemaVersion:kExpectedDatabaseVersion];
                                          }
                                          else
                                          {
                                              //todo, http post error log to backend
                                              //for details of why this migration will fail
                                              debugLog(@"mig fail");

                                          }
                                      }];
    }
    else if (currentVersion > kExpectedDatabaseVersion){
//        可能在一个新版本的app安装在手机上之后，在旧版本的代码用xcode给装了一下，会导致这个情况,预期的版本竟比手机里面的版本小
        debugLog(@"current more than should");
        
    }
    else {
//        两个版本是相同的
        //正常运行时，代码会到这里，意味着数据库不需要迁移，当前的状态是完好的
    }
    
}
+ (void)saveToUserDefaultsForDBVersion:(int)version
{
    [[NSUserDefaults standardUserDefaults] setObject:@(version) forKey:kDatabaseVersionInUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (int)databaseCurrentSchemaVersion {
    NSString *dbPath = [WYDBManager getDatabasePath];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    int version = 0;
    
    if ([fileManager fileExistsAtPath:dbPath] == YES) {

        FMDatabase * db = [FMDatabase databaseWithPath:dbPath];
        
        if ([db open]) {
            FMResultSet *resultSet = [db executeQuery:@"PRAGMA user_version;"];
            
            if ([resultSet next]) {
                version = [resultSet intForColumnIndex:0];
            }
            else
            {
                debugLog(@"error in query user_version");
            }
            
            [db close];
            
        } else {
            debugLog(@"error when open db when query version");
        }
    }
    
//    debugLog(@"version is %d", version);
    return version;
}

- (BOOL)setDatabaseSchemaVersion:(int)version {
    // FMDB cannot execute this query because FMDB tries to use prepared statements
    
    NSString *databasePath = [WYDBManager getDatabasePath];
    BOOL isSuccess = YES;
    sqlite3 *database = nil;
    NSFileManager *filemgr = [NSFileManager defaultManager];

    if ([filemgr fileExistsAtPath: databasePath] == YES) {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = [[NSString stringWithFormat:@"PRAGMA user_version = %d", version] UTF8String];
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                isSuccess = NO;
                debugLog(@"Failed to set db internal version");
            }
            else{
                debugLog(@"succeed to set db internal version");
            }
            sqlite3_close(database);
            return isSuccess;
        }
        else
        {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    
    NSLog(@"s is %d", isSuccess);
    return isSuccess;
}

/**
 This method will change for a new app release if schema is changed

 @param fromVersion fromVersion description
 @param toVersion   toVersion description
 */
+ (void)migrateDatabaseFromVersion:(int)fromVersion ToVersion:(int)toVersion WithBlock:(void (^)(BOOL result))block{
    
    
    //可以实现从0版本直接变到3，或者2到4，或者1到5
//    因为case里面没有break，会一直运行下去
//    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
    
    NSString *dbPath = [WYDBManager getDatabasePath];
    FMDatabase * db = [FMDatabase databaseWithPath:dbPath];
    __block BOOL res = NO;

    if ([db open]) {
        
        switch (fromVersion + 1) {
            case 1:
            {
                
                NSString *sql_migration_0_1 =
                @"CREATE TABLE IF NOT EXISTS 'post_cache' ('uuid' TEXT PRIMARY KEY NOT NULL, 'postStr' TEXT, 'createdAtFloat' REAL);"
                "CREATE TABLE IF NOT EXISTS 'message' ('uuid' TEXT PRIMARY KEY NOT NULL, 'created_at_float' REAL, 'user_uuid' TEXT, 'message_type' INTEGER, 'message_content' TEXT, 'author_uuid' TEXT,'author_icon' TEXT, 'author_name' TEXT, 'target_type' INTEGER, 'target_uuid' TEXT,'target_pic' TEXT, 'target_content' TEXT);";
                
                [db beginTransaction];
                @try
                {
//                    debugLog(@"in try 0-1");
                    if (![db executeStatements:sql_migration_0_1])
                    {
                        // report error
                        debugLog(@"failed to migrate 0-1");
                        @throw NSGenericException;
                    }
                    
                    if([db commit]){
                        res = YES;
                        debugLog(@"succeeded to migrate from 0-1");
                    }
                }
                @catch(NSException* e)
                {
                    [db rollback];
                    res = NO;
                }
                
                if (fromVersion + 1 == toVersion)
                    break;
                
            }
                
            case 2:
            {
                //todo, 现在还没有改 db的version，这段代码还没有执行
//                以后建立数据库的表格时，后端给什么字段，就原封不动的用那个字段的形式，后端一般会给出下划线式的字段名称
//                只有在一种情况下需要改变字段名称，那就是字段名和sql的关键字冲突时，比如说group这样的名字
                
                NSString *sql_migration_1_2 = @"ALTER TABLE 'group_table' ADD COLUMN created_by_follow INTEGER;"
                                               "ALTER TABLE 'group_table' ADD COLUMN group_icon TEXT;"
                                               "ALTER TABLE 'group_table' ADD COLUMN public_visible INTEGER;"
                                                "ALTER TABLE 'group_table' ADD COLUMN content_visible INTEGER;"

                                               "ALTER TABLE 'group_table' ADD COLUMN administrator TEXT;"
                                               "ALTER TABLE 'group_table' ADD COLUMN introduction TEXT;"
                                                "ALTER TABLE 'group_table' ADD COLUMN allow_member_invite INTEGER;"
                                                "ALTER TABLE 'group_table' ADD COLUMN number INTEGER;"
                "CREATE TABLE IF NOT EXISTS 'post_comment' ('uuid' TEXT PRIMARY KEY NOT NULL, 'reply_uuid' TEXT, 'reply_author_uuid' TEXT, 'author_uuid' TEXT, 'content' TEXT, 'target_type' INTEGER , 'target_uuid' TEXT , 'private'  INTEGER, 'created_at_float' REAL, 'replied_author' TEXT , 'author' TEXT );"
                "DROP TABLE IF EXISTS 'user';"
                "CREATE TABLE IF NOT EXISTS 'user' ('uuid' TEXT PRIMARY KEY, 'first_name' TEXT, 'last_name' TEXT, 'account_name' TEXT, 'icon_url' TEXT, 'sex' INTEGER, 'easemob_username' TEXT);"
                "CREATE TABLE IF NOT EXISTS 'group_user' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'group_uuid' TEXT NOT NULL, 'user_uuid' TEXT NOT NULL);";
                
                [db beginTransaction];
                @try
                {
//                    debugLog(@"in try 1-2");
                    if (![db executeStatements:sql_migration_1_2])
                    {
                        // report error
                        debugLog(@"failed to migrate 1-2");
                        @throw NSGenericException;
                    }
                    
                    if([db commit]){
                        res = YES;
                        debugLog(@"succeeded to migrate 1-2");
                    }
                }
                @catch(NSException* e)
                {
                    [db rollback];
                    res = NO;
                }
                
                if (fromVersion + 1 == toVersion)
                    break;
            }
            case 3:
            {
                // tony 2017.5.23 added
                // 这次的更新会涉及到消息的更新，新增了一些字段, 删掉了message_type字段
                
                NSString *sql_migration_2_3 = @"DROP TABLE IF EXISTS 'message';"
                "CREATE TABLE IF NOT EXISTS 'message' ('uuid' TEXT PRIMARY KEY NOT NULL, 'created_at_float' REAL, 'user_uuid' TEXT, 'message_type_str' TEXT, 'message_content_pic' TEXT, 'message_content' TEXT, 'author_uuid' TEXT, 'author_icon' TEXT, 'author_name' TEXT, 'action_text' TEXT, 'target_type_str' TEXT, 'target_uuid' TEXT, 'target_pic' TEXT, 'target_content' TEXT, 'target_url' TEXT, 'reply_content' TEXT);"
                "CREATE TABLE IF NOT EXISTS 'recommend_post_cache' ('uuid' TEXT PRIMARY KEY NOT NULL, 'postStr' TEXT, 'createdAtFloat' REAL);"
                "ALTER TABLE 'group_table' ADD COLUMN display INTEGER;"
                "ALTER TABLE 'group_table' ADD COLUMN notif_new_post TEXT;"
                "ALTER TABLE 'group_table' ADD COLUMN notif_comment_to_self_related INTEGER;"
                "ALTER TABLE 'group_table' ADD COLUMN notif_comment_to_self_not_related INTEGER;"
                "CREATE TABLE IF NOT EXISTS 'user_detail_cache' ('uuid' TEXT PRIMARY KEY NOT NULL, 'user_detail_str' TEXT);"
                "CREATE TABLE IF NOT EXISTS 'draft' ('draft_str' TEXT, 'createdAtFloat' TEXT);"
                ;
                
                [db beginTransaction];
                @try
                {
                    debugLog(@"in try 2-3");
                    if (![db executeStatements:sql_migration_2_3])
                    {
                        // report error
                        debugLog(@"failed to migrate 2-3");
                        @throw NSGenericException;
                    }
                    
                    if([db commit]){
                        res = YES;
                        debugLog(@"succeeded to migrate 2-3");
                    }
                }
                @catch(NSException* e)
                {
                    [db rollback];
                    res = NO;
                }
                
                if (fromVersion + 1 == toVersion)
                    break;
            }
            case 4:
            {
                NSString *sql_migration_3_4 = @"CREATE TABLE IF NOT EXISTS 'rec_group_category' ('category' INTEGER PRIMARY KEY NOT NULL,'name' TEXT, 'count' INTEGER ,'image' TEXT);"
                "ALTER TABLE 'group_table' ADD COLUMN applied_status INTEGER;"
                "ALTER TABLE 'group_table' ADD COLUMN category INTEGER;"
                "ALTER TABLE 'group_table' ADD COLUMN tags TEXT;"
                "ALTER TABLE 'group_table' ADD COLUMN starred INTEGER;"
                ;
                
                [db beginTransaction];
                @try
                {
                    debugLog(@"in try 3-4");
                    if (![db executeStatements:sql_migration_3_4])
                    {
                        // report error
                        debugLog(@"failed to migrate 3-4");
                        @throw NSGenericException;
                    }
                    
                    if([db commit]){
                        res = YES;
                        debugLog(@"succeeded to migrate 3-4");
                    }
                }
                @catch(NSException* e)
                {
                    [db rollback];
                    res = NO;
                }
                
                if (fromVersion + 1 == toVersion)
                    break;

            }
            case 5:
            {
                NSString *sql_migration_4_5 = @"ALTER TABLE 'user' ADD COLUMN type INTEGER;";
                
                [db beginTransaction];
                @try
                {
                    debugLog(@"in try 4-5");
                    if (![db executeStatements:sql_migration_4_5])
                    {
                        // report error
                        debugLog(@"failed to migrate 4-5");
                        @throw NSGenericException;
                    }
                    
                    if([db commit]){
                        res = YES;
                        debugLog(@"succeeded to migrate 4-5");
                    }
                }
                @catch(NSException* e)
                {
                    [db rollback];
                    res = NO;
                }
                
                if (fromVersion + 1 == toVersion)
                    break;
                
            }
            case 6:
            {
                NSString *sql_migration_5_6 = @"ALTER TABLE 'group_table' ADD COLUMN unread_post_num INTEGER;";
                
                [db beginTransaction];
                @try
                {
                    debugLog(@"in try 5-6");
                    if (![db executeStatements:sql_migration_5_6])
                    {
                        // report error
                        debugLog(@"failed to migrate 5-6");
                        @throw NSGenericException;
                    }
                    
                    if([db commit]){
                        res = YES;
                        debugLog(@"succeeded to migrate 5-6");
                    }
                }
                @catch(NSException* e)
                {
                    [db rollback];
                    res = NO;
                }
                
                if (fromVersion + 1 == toVersion)
                    break;
                
            }
        }
    }
    else{
        //not able to open db
        NSLog(@"error in open db for migrations");
    }
    
    if(block)
        block(res);
}

#pragma mark - Used with Caution

+ (void)removeDatabase
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:[WYDBManager getDatabasePath] error:&error];
        if (success) {
            NSLog(@"deleted file -:%@ ", [WYDBManager getDatabasePath]);
        }
        else
        {
            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
        }
        
    });
}

+ (BOOL)executeTransactionWith:(NSString *)sql Arguments:(NSArray *)array
{   __block BOOL result = YES;
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL res = [db executeQuery:sql withArgumentsInArray:array];
        if (!res) {
            debugLog(@"error in execute transaction");
            *rollback = YES;
            result = NO;
            return;
        }
    }];
    return result;
}

@end
