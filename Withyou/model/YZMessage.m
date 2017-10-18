//
//  Message.m
//  Withyou
//
//  Created by ping on 2016/12/17.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import "YZMessage.h"

@implementation YZMessage

+ (void)saveToDataBase:(NSArray<YZMessage *> *)arr withCallback:(void (^)(BOOL))cb {    
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql = @"insert or replace into 'message' (uuid, created_at_float, user_uuid, message_type_str, message_content_pic, message_content, author_uuid, author_icon, author_name, action_text, target_type_str, target_uuid, target_pic, target_content, target_url, reply_content) values (?, ?, ?, ?, ?, ?, ?, ?, ? ,? ,? ,?, ?, ?, ?, ?) ";

        for (YZMessage *msg in arr) {
            BOOL res = [db executeUpdate:sql,
                        msg.uuid,
                        msg.created_at_float,
                        msg.user_uuid,
                        msg.message_type_str,
                        msg.message_content_pic,
                        msg.message_content,
                        msg.author_uuid,
                        msg.author_icon,
                        msg.author_name,
                        msg.action_text,
                        msg.target_type_str,
                        msg.target_uuid,
                        msg.target_pic,
                        msg.target_content,
                        msg.target_url,
                        msg.reply_content
                        ];
            if(!res) {
                *rollback = YES;
                if(cb) cb(NO);
                return ;
            }
            else{
                // 不需要存入本地关于user的信息
                // 因为新的后端结构会把author_uuid, author_name，author_icon给出来，而点击头像也只需要用author_uuid即可
                // 这样的话， message存入本地的模型只需要一些基本的字段即可， 不再需要嵌套WYUser模型
                // tony, 2017.5.23 added
                
//                    WYUser *u = msg.author;
//                    res = [db executeUpdate:sql_user,u.uuid, u.first_name, u.last_name, u.account_name, u.icon_url, [NSNumber numberWithInt:u.sex], u.easemob_username];
//                    if(!res) {
//                        *rollback = YES;
//                        if(cb) cb(NO);
//                        return ;
//                    }
            }
        }
        if(cb) cb(YES);
    }];
}

+ (void)queryDBCacheWith:(YZMessage *)msg Results:(void (^)(NSArray<YZMessage *> *list))cb {
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        if(msg == nil) {
            NSString *query = [NSString stringWithFormat:@"select * from message ORDER BY created_at_float DESC LIMIT 50" ];
            FMResultSet * rs = [db executeQuery:query, msg.created_at_float];
            NSMutableArray *arr = [NSMutableArray array];
            while ([rs next]) {
                
                [arr addObject:[[self class] messageFromFMResultSet:rs]];

            }
            if(arr.count > 0) {
                cb(arr);
            }else {
                cb(nil);
            }
            [rs close];
        }else {
            FMResultSet *lastMsg = [db executeQuery:@"select * from message where uuid = ?", msg.uuid];
            // 如果数据库已经缓存过该条数据
            if([lastMsg next]) {
                // 查询比这条数据的timestamp小的 消息
                NSString *query = [NSString stringWithFormat:@"select * from message where created_at_float < ?  ORDER BY created_at_float DESC LIMIT 50" ];
                FMResultSet * rs = [db executeQuery:query, msg.created_at_float];
                NSMutableArray *arr = [NSMutableArray array];
                while ([rs next]) {
                    
                    [arr addObject:[[self class] messageFromFMResultSet:rs]];
                }
                if(arr.count > 0) {
                    cb(arr);
                }else {
                    cb(nil);
                }
                [rs close];
            }else {
                // 从服务器获取
                cb(nil);
            }
            
            [lastMsg close];
        }
    }];
    
}
+ (YZMessage *)messageFromFMResultSet:(FMResultSet *)rs{
    
    YZMessage *msg = [[YZMessage alloc] init];
    
    msg.uuid = [rs stringForColumn:@"uuid"];
    msg.created_at_float = [NSNumber numberWithDouble:[rs doubleForColumn:@"created_at_float"]];
    msg.user_uuid = [rs stringForColumn:@"user_uuid"];
    msg.message_type_str = [rs stringForColumn:@"message_type_str"];
    msg.message_content_pic = [rs stringForColumn:@"message_content_pic"];
    msg.message_content = [rs stringForColumn:@"message_content"];
    msg.author_uuid = [rs stringForColumn:@"author_uuid"];
    msg.author_icon = [rs stringForColumn:@"author_icon"];
    msg.author_name = [rs stringForColumn:@"author_name"];
    msg.action_text = [rs stringForColumn:@"action_text"];
    msg.target_type_str = [rs stringForColumn:@"target_type_str"];
    msg.target_uuid = [rs stringForColumn:@"target_uuid"];
    msg.target_pic = [rs stringForColumn:@"target_pic"];
    msg.target_content = [rs stringForColumn:@"target_content"];
    msg.target_url = [rs stringForColumn:@"target_url"];
    msg.reply_content = [rs stringForColumn:@"reply_content"];
    
    return msg;
    
}

+ (void)deleteWith:(NSString *)uuid {
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM message WHERE uuid = '%@'",uuid]];
        if(result == NO) {
            NSLog(@"database remove action fail  uuid= %@ ",uuid);
        }
    }];
}

+ (void)isExist:(NSArray *)messags callback:(void (^)(int))cb {
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        int count = 0;
        for (YZMessage *msg in messags) {
            FMResultSet *lastMsg = [db executeQuery:@"select * from message where uuid = ?", msg.uuid];
            if([lastMsg next]) {
                count = count + 1;
            }
            [lastMsg close];
        }
        cb(count);
    }];
}

+ (void)removeAll {
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql = @"delete from message";
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            debugLog(@"error to delete message in db");
            *rollback = YES;
            return;
        }
    }];
}

@end
