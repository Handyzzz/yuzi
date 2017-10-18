//
//  YZPostComment.m
//  Withyou
//
//  Created by ping on 2017/2/20.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZPostComment.h"

@implementation YZPostComment


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"private_type": @"private"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"images" : [WYPhoto class],
             @"mention": [YZMarkText class],
             };
}


#pragma mark - Http Request
+ (void)addPostCommentFor:(NSString *)reply_uuid replyAuthor:(NSString *)reply_author_uuid content:(NSString *)content mention:(NSArray *)mention targetUUID:(NSString *)target_uuid private:(BOOL)isPrivate Block:(void (^)(YZPostComment *))block
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    if(reply_uuid && ![reply_uuid isEqualToString:@""])
    {
        [md setValue:reply_uuid forKey:@"reply_uuid"];
    }
    if(reply_author_uuid && ![reply_author_uuid isEqualToString:@""])
    {
        [md setValue:reply_author_uuid forKey:@"reply_author_uuid"];
    }
    if(content)
    {
        [md setValue:content forKey:@"content"];
    }
    if(mention) {
        [md setValue:mention forKey:@"mention"];
    }
    if(target_uuid)
    {
        [md setValue:target_uuid forKey:@"target_uuid"];
    }
    
    [md setValue:[NSNumber numberWithBool:isPrivate] forKey:@"private"];
    [md setValue:@1 forKey:@"target_type"];
    
    [[WYUtility sharedAppDelegate] setNetworkActivityIndicatorVisible:YES];

    [[WYHttpClient sharedClient] POST:@"api/v1/post_comment/" parameters:[md copy] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        YZPostComment *comment = [YZPostComment yy_modelWithDictionary:responseObject];
        if(block) {
            block(comment);
        }
        
        [[WYUtility sharedAppDelegate] setNetworkActivityIndicatorVisible:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[WYUtility sharedAppDelegate] setNetworkActivityIndicatorVisible:NO];
        NSData *errorData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] ;
        
        NSLog(@"error is %@",[[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding]);
        
        if(block)
            block(nil);
    }];
    
}
+ (void)deletePostComment:(NSString *)uuid Block:(void (^)( long status))block
{
    NSString *s = [NSString stringWithFormat:@"api/v1/post_comment/%@/", uuid];
    
    [[WYHttpClient sharedClient] DELETE:s parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        //204表示 请求成功没有返回值
        if(block)
            block(httpResponse.statusCode);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if(block)
            block(httpResponse.statusCode);
    }];
}

+ (void)publishCommentsTopFor:(NSString *)uuid t:(NSNumber *)t Block:(void (^)(NSArray *, BOOL))block {
    [YZPostComment listPostCommentTopFor:uuid t:t Block:block isPubulish:YES];
}

+ (void)privateCommentsTopFor:(NSString *)uuid t:(NSNumber *)t Block:(void (^)(NSArray *, BOOL))block {
    [YZPostComment listPostCommentTopFor:uuid t:t Block:block isPubulish:NO];
}

+ (void)listPostCommentTopFor:(NSString *)uuid t:(NSNumber *)t Block:(void (^)(NSArray *, BOOL))block isPubulish:(BOOL)publish
{
    //没有网络的时候 上拉的处理
    if(!t) return;
    
    NSString *url = nil;
    if(publish) {
        url = @"api/v1/post_comment/public_list/";
    }else {
        url = @"api/v1/post_comment/private_list/";
    }
    NSDictionary *param = @{
                            @"post": uuid,
                            @"t": t
                            };
    [[WYHttpClient sharedClient] GETModelArrayWithKey:@"results" forClass:[YZPostComment class] url:url parameters:param callback:^(NSArray *modelArray, id response) {
        BOOL hasMore = response[@"next"] != [NSNull null];
        if(block) {
            if(response == nil) {
                block(nil,NO);
            }else {
                block(modelArray,hasMore);
            }
        }
    }];
}



+ (BOOL)savePostCommentToDB:(YZPostComment *)comment
{
    __block BOOL isSuccess = false;
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql = @"insert or replace into 'post_comment' ('uuid', 'reply_uuid', 'reply_author_uuid', 'author_uuid', 'content', 'target_type', 'target_uuid', 'private', 'created_at_float', 'replied_author', 'author') values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ";
        NSString *replied_author_json = [comment.replied_author yy_modelToJSONString];
//        NSString *author_json = [comment.author yy_modelToJSONString];
        BOOL res = [db executeUpdate:sql, comment.uuid, comment.reply_uuid,comment.replied_author.uuid, comment.content, [NSNumber numberWithFloat:comment.target_type],comment.target_uuid, [NSNumber numberWithBool:comment.private_type],comment.created_at_float,replied_author_json,[comment.author yy_modelToJSONString]];
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
//举报评论
+ (void)reportPostComment:(NSString*)commentUuid type:(NSNumber *)type{
    NSString *s = [NSString stringWithFormat:@"api/v1/post_comment/%@/report/",commentUuid];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:type forKey:@"type"];
    [[WYHttpClient sharedClient] GET:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [WYUtility showAlertWithTitle:@"举报成功，感谢您对社区的贡献！"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [WYUtility showAlertWithTitle:@"举报未成功，可能因为网络原因，请稍后再试。"];
    }];
    
}

@end
