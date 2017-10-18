//
//  WYPhoto.m
//  Withyou
//
//  Created by Tong Lu on 8/8/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import "WYPhoto.h"
#import "FMDB.h"
#import "WYDBManager.h"

@implementation WYPhoto

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"content": @"description",
             @"groud_uuid": @"group",
             @"createdAtFloat":@"created_at_float",
             };
}

/**
 * Creates a JSONKeyMapper based on a built-in JSONKeyMapper, with specific exceptions.
 * Use your JSONModel property names as keys, and the JSON key names as values.
 */
+ (void)savePhotosToLocalDB:(NSArray *)photoArray Block:(void (^)(BOOL result))block
{
    __block BOOL isSuccess = false;
    
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql_photo = @"insert or replace into 'photo' (uuid, url, content, height, width, createdAtFloat, order_int, group_uuid, uploader, thumbnail) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ";
        
        BOOL res;
        int errorCount = 0;
        
        for(WYPhoto *photo in photoArray)
        {
            res = [db executeUpdate:sql_photo, photo.uuid, photo.url, photo.content, [NSNumber numberWithFloat:photo.height], [NSNumber numberWithFloat:photo.width], photo.createdAtFloat, photo.order, photo.groud_uuid, photo.uploader, photo.thumbnail];
            
            if (!res) {
                debugLog(@"error to save photo in db");
                errorCount++;
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
    
    if(block)
        block(isSuccess);
    
//    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
//        
//        printf("%s\n", [@"baa" UTF8String]);
//        
//        FMResultSet * rs = [db executeQueryWithFormat:@"select url from photo where uuid = %@", @"2baa87eb-c5ca-4239-a4dd-27210c168b58"];
//        while ([rs next]) {
//            NSString *top_add = [rs stringForColumnIndex:0];
////            NSNumber *top_del = [NSNumber numberWithDouble:[rs doubleForColumnIndex:1]];
////            NSNumber *bottom = [NSNumber numberWithDouble:[rs doubleForColumnIndex:2]];
//            
//            NSString *s = [NSString stringWithFormat:@"s is %@", top_add];
//            printf("%s\n", [s UTF8String]);
//
//        }
//    }];
//    
//    printf("%s\n", [@"caa" UTF8String]);
//    
//    __block NSNumber *top_add = @0.0;
//    __block NSNumber *top_del = @0.0;
//    __block NSNumber *bottom = @0.0;
//    
//    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
//        
//        printf("%s\n", [@"kkaa" UTF8String]);
//        
//        FMResultSet * rs = [db executeQueryWithFormat:@"select top_add, top_del, bottom from photo_sync_record where uuid = %@", [WYUIDTool sharedWYUIDTool].uid.uuid];
//        while ([rs next]) {
//            printf("%s\n", [@"kkkk" UTF8String]);
//
//            top_add = [NSNumber numberWithDouble:[rs doubleForColumnIndex:0]];
//            top_del = [NSNumber numberWithDouble:[rs doubleForColumnIndex:1]];
//            bottom = [NSNumber numberWithDouble:[rs doubleForColumnIndex:2]];
//        }
//        
//        printf("%s\n", [@"kkbb" UTF8String]);
//    }];
//    
//    printf("%s\n", [@"kkmm" UTF8String]);

}
+ (void)deletePhotosFromUuidList:(NSArray *)uuidList Block:(void (^)(BOOL result))block
{
    __block BOOL isSuccess = false;
    
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql_photo = @"delete from 'photo' where uuid = ? ";
        BOOL res;
        int errorCount = 0;
        
        printf("%s\n", [@"in delete photos" UTF8String]);

        for(NSString *uuid in uuidList)
        {
            res = [db executeUpdate:sql_photo, uuid];
            
            if (!res) {
                debugLog(@"error to delete photo, uuid %@", uuid);
                errorCount++;
                break;
            }
            
        }
        
        printf("%s\n", [@"after for in delete photos" UTF8String]);

        
        
        if (errorCount != 0) {
            //do not need to rollback, anyhow, it will be deleted
            *rollback = YES;
            return;
        }
        else
        {
            
            isSuccess = true;
        }
    }];
    
    if(block)
        block(isSuccess);
}
+ (void)savePhotoToLocalDB:(WYPhoto *)photo
{
//    "CREATE TABLE IF NOT EXISTS 'photo' ('uuid' TEXT PRIMARY KEY NOT NULL, 'url' TEXT, 'content' TEXT, 'height' INTEGER, 'width' INTEGER, 'createdAtFloat' REAL, 'order' INTEGER, 'group_uuid' TEXT, 'uploader' TEXT, );"
    
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql_photo = @"insert or replace into 'photo' (uuid, url, content, height, width, createdAtFloat, order_int, group_uuid, uploader, thumbnail) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ";
        BOOL res;
        int errorCount = 0;
        res = [db executeUpdate:sql_photo, photo.uuid, photo.url, photo.content, [NSNumber numberWithFloat:photo.height], [NSNumber numberWithFloat:photo.width], photo.createdAtFloat, photo.order, photo.groud_uuid, photo.uploader, photo.thumbnail];
        
        if (!res) {
            debugLog(@"error to insert data");
            errorCount++;
        } else {
            //            debugLog(@"succ to insert data");
        }
        
        if (errorCount != 0) {
            *rollback = YES;
            return;
        }
    }];
}

+ (void)deletePhotoFromLocalDB:(NSString *)photoUuid
{
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql_photo = @"DELETE FROM 'photo' WHERE uuid = ? ";
        BOOL res;
        int errorCount = 0;
        res = [db executeUpdate:sql_photo, photoUuid];
        
        if (!res) {
            debugLog(@"error to insert data");
            errorCount++;
        }
        
        if (errorCount != 0) {
            *rollback = YES;
            return;
        }
    }];
}

+ (void)queryAllSelfPhotosWithBlock:(void (^)(NSArray *photos))block
{
    __block NSMutableArray *photoArray = [NSMutableArray array];
    __block WYPhoto *photo;
    
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *query = [NSString stringWithFormat:@"select * from 'photo' where ( group_uuid IS NULL OR group_uuid = '' ) AND uploader = ? order by createdAtFloat desc"];
        FMResultSet * rs = [db executeQuery:query, [WYUIDTool sharedWYUIDTool].uid.uuid];
        while ([rs next]) {
            photo = [[WYPhoto alloc] init];
            photo.uuid = [rs stringForColumn:@"uuid"];
            photo.url = [rs stringForColumn:@"url"];
            photo.content = [rs stringForColumn:@"content"];
            photo.height = [rs intForColumn:@"height"];
            photo.width = [rs intForColumn:@"width"];
            photo.createdAtFloat =  [NSNumber numberWithDouble:[rs doubleForColumn:@"createdAtFloat"]];
            photo.order = [NSNumber numberWithDouble:[rs intForColumn:@"order_int"]];
            photo.groud_uuid = [rs stringForColumn:@"group_uuid"];
            photo.uploader = [rs stringForColumn:@"uploader"];
            photo.thumbnail = [rs stringForColumn:@"thumbnail"];
            [photoArray addObject:photo];
        }
    }];
    
//    printf("%s\n", [@"after query photos" UTF8String]);

    if(block)
        block([photoArray copy]);
}
+ (NSNumber *)queryNewestSelfAlbumCreatedTimeInPhotoDB
{
    __block NSNumber *num = @0;
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *query = [NSString stringWithFormat:@"select createdAtFloat from 'photo' WHERE ( group_uuid IS NULL or group_uuid = '' ) AND uploader = ? order by createdAtFloat desc"];
        FMResultSet * rs = [db executeQuery:query, kuserUUID];
        while ([rs next]) {
            num = [NSNumber numberWithDouble:[rs doubleForColumn:@"createdAtFloat"]];
        }
        
    }];
    return num;
}
+ (NSNumber *)queryNewestGroupAlbumCreatedTimeInPhotoDB:(NSString *)groupUuid
{
    __block NSNumber *num = @0;
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *query = [NSString stringWithFormat:@"select createdAtFloat from 'photo' WHERE group_uuid = ? order by createdAtFloat desc"];
        FMResultSet * rs = [db executeQuery:query, groupUuid];
        while ([rs next]) {
            num = [NSNumber numberWithDouble:[rs doubleForColumn:@"createdAtFloat"]];
        }
        
    }];
    return num;
}
+ (void)queryAllGroup:(NSString *)groupUuid PhotosWithBlock:(void (^)(NSArray *photos))block
{
    __block NSMutableArray *photoArray = [NSMutableArray array];
    __block WYPhoto *photo;
    
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *query = [NSString stringWithFormat:@"select * from 'photo' where group_uuid = ? order by createdAtFloat desc"];
        FMResultSet * rs = [db executeQuery:query, groupUuid];
        while ([rs next]) {
            photo = [[WYPhoto alloc] init];
            photo.uuid = [rs stringForColumn:@"uuid"];
            photo.url = [rs stringForColumn:@"url"];
            photo.content = [rs stringForColumn:@"content"];
            photo.height = [rs intForColumn:@"height"];
            photo.width = [rs intForColumn:@"width"];
            photo.createdAtFloat =  [NSNumber numberWithDouble:[rs doubleForColumn:@"createdAtFloat"]];
            photo.order = [NSNumber numberWithDouble:[rs intForColumn:@"order_int"]];
            photo.groud_uuid = [rs stringForColumn:@"group_uuid"];
            photo.uploader = [rs stringForColumn:@"uploader"];
            photo.thumbnail = [rs stringForColumn:@"thumbnail"];
            [photoArray addObject:photo];
        }
    }];
    
    if(block)
        block([photoArray copy]);
}

//both self and group photos
+ (void)deletePhotoTableInDB
{
    FMDatabase * db = [FMDatabase databaseWithPath:[WYDBManager getDatabasePath]];
    if ([db open]) {
        NSString * sql = @"DROP TABLE 'photo';";
        
        BOOL res = [db executeStatements:sql];
        if (!res) {
            debugLog(@"error to delete db table");
        } else {
            debugLog(@"succ to deleta db table");
        }
        [db close];
    }
}

@end
