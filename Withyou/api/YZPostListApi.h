//
//  YZPublishPostApi.h
//  Withyou
//
//  Created by ping on 2016/12/30.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYPost.h"

@interface YZPostListApi : NSObject
//feeds页
+ (void)requestFeedsByParam:(NSDictionary *)param Handler:(void (^)(NSArray *postArray))handler;

// 请求一个用户对我可见的帖子列表
+ (void)requestVisiblePostToMe:(NSNumber *)t ForUser:(NSString *)userUuid WithCallBack:(void (^)(NSArray<WYPost *> *))callback;

// 群组页请求post数据
+ (void)postListForGroup:(NSString *)groupUuid lastTime:(NSNumber *)lastTime Block:(void (^)(NSArray *postList))block;

// 输入关键字 查找帖子
+ (void)selectPostForGroup:(NSString *)groupUuid text:(NSString *)text lastTime:(NSNumber *)lastTime Block:(void (^)(NSArray *postList))block;

// 请求post推荐的post流
+ (void)recommendPostListHandler:(void (^)(NSArray *eventArr, NSArray *groupArr, NSArray *postArr))handler;

// 请求更多推荐的帖子
+ (void)moreRecommendPostList:(NSArray *)UuidList Handler:(void (^)(NSArray *postArr))handler;

// 列出自己订阅的帖子
+ (void)listSubscribePost:(NSInteger)page Block:(void (^)(NSArray *postArr, BOOL hasMore))block;

//请求某条标签相关帖子列表
+ (void)listTagResultPostList:(NSString *)tagStr page:(NSInteger)page Block:(void (^)(NSArray *postArr, BOOL hasMore, NSInteger count))block;

//我关注的标签列表的 相关的帖子列表
+ (void)listMyfollowedTagsPostsWithPage:(NSInteger)page Block:(void (^)(NSArray *postArr, BOOL hasMore))block;

//阅读列表
+(void)listReadingPostByParam:(NSDictionary *)param Handler:(void (^)(NSArray *postArray))handler;
@end
