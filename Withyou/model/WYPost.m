//
//  WYPost.m
//  Withyou
//
//  Created by Tong Lu on 7/16/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import "WYPost.h"
#import "WYGroup.h"
@implementation WYPost

//本来只有3种类型，但是为了预留，先放6种
NSString *REGEX_STRING = @"\\[mention\\](\\[[123456]{1}\\]\\[[0-9a-f]{8}\\-[0-9a-f]{4}\\-[0-9a-f]{4}\\-[0-9a-f]{4}\\-[0-9a-f]{12}\\]\\[.*?\\]\\[.*?\\])\\[\\/mention\\]";

// 旧jsonmodel 转换过大小写
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"createdAtFloat":@[@"createdAtFloat",@"created_at_float"],
             @"albumTitle":@[@"albumTitle",@"album_title"],
             @"targetType":@[@"targetType",@"target_type"],
             @"targetUuid":@[@"targetUuid",@"target_uuid"],
             @"targetName":@[@"targetName",@"target_name"],
             @"photoNum":@[@"photoNum",@"photo_num"],
             @"starNum":@[@"starNum",@"star_num"],
             @"commentNum":@[@"commentNum",@"comment_num"],
             @"mainPic":@[@"mainPic",@"main_pic"],
             };
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"images" : [WYPhoto class],
             @"mention": [YZMarkText class],
             @"comments": [YZPostComment class],
             @"starred_users": [WYUser class],
             @"with_people":[WYUser class],
             @"extension":[YZExtension class],
             @"tag_list":[WYTag class]
             };
}

- (NSString *)authorDisplayName
{
    if([self.author.fullName isEqualToString:@""])
    {
        return self.author.account_name;
    }
    else
    {
        return self.author.fullName;
    }
}


+ (NSArray *)queryPostsFromCache
{
    //    debugMethod();
    __block NSString *postStr;
    __block NSMutableArray *arr = [NSMutableArray array];
    __block WYPost *post;
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *query = @"select postStr from post_cache order by createdAtFloat desc";
        FMResultSet * rs = [db executeQuery:query];
        while ([rs next]) {
            postStr =  [rs stringForColumnIndex:0];
            //            NSLog(@"post str is %@", postStr);
            
            post = [WYPost yy_modelWithJSON:postStr];
            if(post) {
                [arr addObject:post];
            }
            
        }
    }];
    //    NSLog(@"arr in query all post from db is %@", arr);
    return [arr copy];
}



+ (BOOL)savePostToDB:(WYPost *)post{
    
    //    debugMethod();
    NSString *postStr = [post yy_modelToJSONString];
    __block BOOL isSuccess = false;
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql = @"insert or replace into 'post_cache' (uuid, postStr, createdAtFloat) values (?, ?, ?) ";
        BOOL res = [db executeUpdate:sql, post.uuid, postStr, post.createdAtFloat];
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


//从数据库中删除某条post
+ (BOOL)deletePostFromDB:(NSString *)uuid
{
    //    debugMethod();
    __block BOOL isSuccess = false;
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql = @"delete from 'post_cache' where uuid = ? ";
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

//从数据库中删除所有的post
+ (BOOL)deleteAllPostFromCache
{
//    debugMethod();
    __block BOOL isSuccess = false;
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql = @"delete from post_cache";
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


//推荐页的缓存 只需要缓存30条

+ (NSArray *)queryRecommendPostsFromCache{
    __block NSString *postStr;
    __block NSMutableArray *arr = [NSMutableArray array];
    __block WYPost *post;
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *query = @"select postStr from 'recommend_post_cache' order by createdAtFloat desc";
        FMResultSet * rs = [db executeQuery:query];
        while ([rs next]) {
            postStr =  [rs stringForColumnIndex:0];
            //            NSLog(@"post str is %@", postStr);
            
            post = [WYPost yy_modelWithJSON:postStr];
            if(post) {
                [arr addObject:post];
            }
            
        }
    }];
    //    NSLog(@"arr in query all post from db is %@", arr);
    return [arr copy];
}


+ (BOOL)saveRecommendPostToDB:(WYPost *)post{
    NSString *postStr = [post yy_modelToJSONString];
    __block BOOL isSuccess = false;
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql = @"insert or replace into 'recommend_post_cache' (uuid, postStr, createdAtFloat) values (?, ?, ?) ";
        BOOL res = [db executeUpdate:sql, post.uuid, postStr, post.createdAtFloat];
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
+ (BOOL)deleteRecommendPostFromDB:(NSString *)uuid{
    __block BOOL isSuccess = false;
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql = @"delete from 'recommend_post_cache' where uuid = ? ";
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
+ (BOOL)deleteAllRecommendPostFromCache{
    __block BOOL isSuccess = false;
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql = @"delete from recommend_post_cache";
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

//草稿箱
+ (void)queryDraftFromCacheBlock:(void (^)(NSArray *contentArr,NSArray *timeArr))block{
    
    __block NSString *contentStr;
    __block NSString *createdAtFloat;

    __block NSMutableArray *contentArr = [NSMutableArray array];
    __block NSMutableArray *timeArr = [NSMutableArray array];

    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {

        NSString *queryContent = @"select draft_str from 'draft' order by createdAtFloat desc";
        FMResultSet * rsContent = [db executeQuery:queryContent];
        while ([rsContent next]) {
            contentStr =  [rsContent stringForColumn:@"draft_str"];
            
            [contentArr addObject:contentStr];
            
        }
        debugLog(@"%@",contentArr);

        
        NSString *queryTime = @"select createdAtFloat from 'draft' order by createdAtFloat desc";
        FMResultSet * rsTime = [db executeQuery:queryTime];
        
        while ([rsTime next]) {
            createdAtFloat =  [rsTime stringForColumn:@"createdAtFloat"];
            [timeArr addObject:createdAtFloat];
        }
    }];
    
    if (block) {
        block(contentArr,timeArr);
    }
}
+ (BOOL)saveDraftToDBContent:(NSString *)content time:(NSString *)creatTime{
    __block BOOL isSuccess = false;
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql = @"insert or replace into 'draft' (draft_str, createdAtFloat) values (?, ?)";
        BOOL res = [db executeUpdate:sql, content,creatTime];
        if (!res) {
            *rollback = YES;
            return;
        }
        else{
            isSuccess = true;
        }
    }];
    return isSuccess;
}
+ (BOOL)deleDraftFromDB:(NSString*)creatTime{
    __block BOOL isSuccess = false;
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql = @"delete from 'draft' where createdAtFloat = ? ";
        BOOL res = [db executeUpdate:sql, creatTime];
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
+ (BOOL)deleteAllDraftFromCache{
    __block BOOL isSuccess = false;
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql = @"delete from draft";
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


//@的特殊符号过滤器
//测试发现这个只能过滤at一条内容的，at多条的话会有问题
+(WYPost*)filter:(WYPost*)post{
    
    //将model中的[mention][编号][uuid][显示的名字][extra_string]过滤为@***
    NSMutableString *tempStr = [post.content mutableCopy];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:REGEX_STRING options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *resultArr = [regex matchesInString:tempStr options:0 range:NSMakeRange(0, [tempStr length])];

    if (resultArr.count >0) {
        for (NSTextCheckingResult *result in resultArr) {
            if (result) {
                //找出了整个的字符串
                //找出名字那一块 第三块
                NSString *subTemp = [tempStr substringWithRange:result.range];
                NSRegularExpression *subRegex = [NSRegularExpression regularExpressionWithPattern:@"\\[(.*?)\\]" options:NSRegularExpressionCaseInsensitive error:&error];
                NSArray *subResultArr = [subRegex matchesInString:subTemp options:0 range:NSMakeRange(0, [subTemp length])];
                //在post中将 字符过滤
                NSTextCheckingResult *myresult = subResultArr[3];
                NSRange range = NSMakeRange(myresult.range.location+1, myresult.range.length-2);
                NSString* str = [NSString stringWithFormat:@"@%@",[subTemp substringWithRange:range]];
                //将post对应的range替换为str
                [tempStr replaceCharactersInRange:result.range withString:str];
                post.content = tempStr;
                
            }
        }
    }
    return post;
}
// 依据handy的代码修改的，用来处理有多个mention的情况
// 返回一个去掉了所有的mention方括号的字符串
+(NSString *)filteredContentStringFrom:(WYPost*)post{
    
    //将model中的[mention][编号][uuid][显示的名字][extra_string]过滤为@***
    NSMutableString *tempStr = [post.content mutableCopy];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:REGEX_STRING options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *resultArr = [regex matchesInString:tempStr options:0 range:NSMakeRange(0, [tempStr length])];
    if (resultArr.count >0) {
        //从后往前替换字符串
        for (NSInteger i = resultArr.count -1; i >= 0; i--) {
            NSTextCheckingResult *result = resultArr[i];
            if (result) {
                
                //找出了整个的字符串
                NSString *subTemp = [tempStr substringWithRange:result.range];
                
                //找出名字那一块 第三块
                //获取要显示的名字
                NSRegularExpression *subRegex = [NSRegularExpression regularExpressionWithPattern:@"\\[(.*?)\\]" options:NSRegularExpressionCaseInsensitive error:&error];
                NSArray *subResultArr = [subRegex matchesInString:subTemp options:0 range:NSMakeRange(0, [subTemp length])];
                NSTextCheckingResult *myresult = subResultArr[3];
                NSRange range = NSMakeRange(myresult.range.location+1, myresult.range.length-2);
                NSString* strToShow = [NSString stringWithFormat:@"@%@",[subTemp substringWithRange:range]];
                
                //将post对应的range替换为str
//                debugLog(@"before, temp is %@", tempStr);
                [tempStr replaceCharactersInRange:result.range withString:strToShow];
//                debugLog(@"after, temp is %@", tempStr);
            }
        }
    }
    return tempStr;
}


- (NSAttributedString *)convertedAttributedString
{
    return  [YZMarkText convert:self.content abilityToTapStringWith:self.mention];
}

@end
