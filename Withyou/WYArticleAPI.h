//
//  WYArticleAPI.h
//  Withyou
//
//  Created by Handyzzz on 2017/9/28.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZPostComment.h"

@interface WYArticleAPI : NSObject
//get recommend article list
+(void)listRecommendArticleList:(NSInteger)page Block:(void(^)(NSArray *articleList, BOOL hasMore))block;

//article list from media
+(void)listArticleFromMedia:(NSString *)mediaUuid page:(NSInteger)page callback:(void(^)(NSArray *articleList, BOOL hasMore))callback;

//article detail
+(void)requestArticleDetail:(NSString *)uuid callBack:(void(^)(NSArray *starList, NSArray *commentList))callBack;

//add star to article
+(void)addStarToArticle:(NSString *)uuid callback:(void(^)(NSInteger status))callback;

//cancel star to article
+(void)cancelStarToArticle:(NSString *)uuid callback:(void(^)(NSInteger status))callback;

//comment to article
+(void)addCommentToArticle:(NSString *)articleUuid content:(NSString *)content reply:(NSString *)reply_uuid replyAuthorUuid:(NSString *)replyAuthorUuid  callback:(void(^)(YZPostComment *comment))callback;

+(void)listStarListWithArticle:(NSString *)articleUuid page:(NSInteger)page callback:(void(^)(NSArray *starList, BOOL hasMore))callback;

+(void)listCommentListWithArticle:(NSString *)articleUuid time:(NSNumber *)time callback:(void(^)(NSArray *commentList, BOOL hasMore))callback;
@end
