//
//  WYArticleAPI.m
//  Withyou
//
//  Created by Handyzzz on 2017/9/28.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYArticleAPI.h"
#import "WYArticle.h"
#import "YZPostComment.h"

@implementation WYArticleAPI
+(void)listRecommendArticleList:(NSInteger)page Block:(void(^)(NSArray *articleList, BOOL hasMore))block{
    NSString *s = @"api/v1/media_article/recommend_articles/";
    NSDictionary *dic = @{@"page":@(page)};
       [[WYHttpClient sharedClient] GET:s parameters:dic showToastError:YES callback:^(id responseObject) {
           NSArray *articleList = [WYArticle YYModelParse:[responseObject objectForKey:@"results"]];
           NSString *next = [responseObject objectForKey:@"next"];
           BOOL hasMore = [next isEqual:[NSNull null]] ? NO : YES;
           if (block) block(articleList, hasMore);
    }];
}

//article list from media
+(void)listArticleFromMedia:(NSString *)mediaUuid page:(NSInteger)page callback:(void(^)(NSArray *articleList, BOOL hasMore))callback{
    NSString *s = @"api/v1/media_article/";
    NSDictionary *dic = @{
                          @"page":@(page),
                          @"media_uuid":mediaUuid
                          };
    [[WYHttpClient sharedClient] GET:s parameters:dic showToastError:YES callback:^(id responseObject) {
        NSArray *articleList = [WYArticle YYModelParse:[responseObject objectForKey:@"results"]];
        NSString *next = [responseObject objectForKey:@"next"];
        BOOL hasMore = [next isEqual:[NSNull null]] ? NO : YES;
        if (callback) callback(articleList, hasMore);
    }];
}

+(void)requestArticleDetail:(NSString *)uuid callBack:(void(^)(NSArray *starList, NSArray *commentList))callBack{
    NSString *s = [NSString stringWithFormat:@"api/v1/media_article/%@/article_detail/",uuid];
    [[WYHttpClient sharedClient]GET:s parameters:nil showToastError:YES callback:^(id responseObject) {
        NSArray *starList = [WYUser YYModelParse:[responseObject objectForKey:@"article_star_list"]];
        NSArray *commentList = [YZPostComment YYModelParse:[responseObject objectForKey:@"article_comment_list"]];
        if (callBack) {
            callBack(starList,commentList);
        }
    }];
}

//add star to article
+(void)addStarToArticle:(NSString *)uuid callback:(void(^)(NSInteger status))callback{
    NSString *s = @"api/v1/article_star/";
    NSDictionary *dic = @{
                          @"target_uuid":uuid,
                          @"user_uuid":kuserUUID
                          };
    [[WYHttpClient sharedClient]POST:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (callback) {
            callback(httpResponse.statusCode);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (callback) {
            callback(httpResponse.statusCode);
        }
    }];
}

//cancel star to article
+(void)cancelStarToArticle:(NSString *)uuid callback:(void(^)(NSInteger status))callback{
    NSString *s = [NSString stringWithFormat:@"api/v1/article_star/%@/", uuid];
    
    [[WYHttpClient sharedClient] DELETE:s parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (callback) {
            callback(httpResponse.statusCode);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (callback) {
            callback(httpResponse.statusCode);
        }
    }];
}


+(void)addCommentToArticle:(NSString *)articleUuid content:(NSString *)content reply:(NSString *)replyUuid replyAuthorUuid:(NSString *)replyAuthorUuid  callback:(void(^)(YZPostComment *comment))callback{
    NSString *s = [NSString stringWithFormat:@"api/v1/post_comment/"];
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    if(replyUuid) [md setObject:replyUuid forKey:@"reply_uuid"];
    if(replyAuthorUuid) [md setObject:replyAuthorUuid forKey:@"reply_author_uuid"];
    if(content) [md setObject:content forKey:@"content"];
    [md setObject:@(6) forKey:@"target_type"];
    if(articleUuid) [md setObject:articleUuid forKey:@"target_uuid"];
    
    [[WYHttpClient sharedClient] POST:s parameters:md showToastError:YES callback:^(id responseObject) {
        debugLog(@"%@",responseObject);
        YZPostComment *comment = [YZPostComment YYModelParse:responseObject];
        if (callback) {
            callback(comment);
        }
    }];
}

+(void)listStarListWithArticle:(NSString *)articleUuid page:(NSInteger)page callback:(void(^)(NSArray *starList, BOOL hasMore))callback{
    NSString *s = @"api/v1/article_star/all_stars_in_article/";
    NSDictionary *dic = @{
                          @"page":@(page),
                          @"target_uuid":articleUuid
                          };
    [[WYHttpClient sharedClient] GET:s parameters:dic showToastError:YES callback:^(id responseObject) {
        NSArray *starList = [WYUser YYModelParse:[responseObject objectForKey:@"results"]];
        NSString *next = [responseObject objectForKey:@"next"];
        BOOL hasMore = [next isEqual:[NSNull null]] ? NO : YES;
        if (callback) callback(starList, hasMore);
    }];
}

+(void)listCommentListWithArticle:(NSString *)articleUuid time:(NSNumber *)time callback:(void(^)(NSArray *commentList, BOOL hasMore))callback{
    NSString *s = @"api/v1/post_comment/media_article_comments/";
    NSDictionary *dic = @{
                          @"media_article_uuid":articleUuid,
                          @"t":time
                          };
    [[WYHttpClient sharedClient]GET:s parameters:dic showToastError:YES callback:^(id responseObject) {

        NSArray *commentList = [YZPostComment YYModelParse:[responseObject objectForKey:@"results"]];
        NSString *next = [responseObject objectForKey:@"next"];
        BOOL hasMore = [next isEqual:[NSNull null]] ? NO : YES;
        if (callback) {
            callback(commentList, hasMore);
        }
    }];
}

@end
