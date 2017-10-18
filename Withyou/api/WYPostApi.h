//
//  WYPostApi.h
//  Withyou
//
//  Created by Tong Lu on 7/20/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface WYPostApi : NSObject

+ (void)addPostFromDict:(NSDictionary *)dict WithBlock:(void (^)(WYPost *post))block;

+ (void)deletePost:(NSString *)postUuid WithBlock:(void (^)(NSDictionary *dict))block;

// add star to album or to link, is the same as to the post
+ (void)addStarToPost:(NSString *)postUuid WithBlock:(void (^)(NSDictionary *response))block;

+ (void)removeStarToPost:(NSString *)postUuid WithBlock:(void (^)(NSDictionary *response))block;

+ (void)newRemoveStarToPost:(NSString *)postUuid WithBlock:(void (^)(WYPost *post))block;

+ (void)reportPost:(NSString *)postUuid Reason:(int)num;

+ (void)uploadMultiplePhotoAssets:(NSArray *)assets Token:(NSString *)token WithBlock:(void (^)(NSArray *dict))block;

//输入Msg的target_uuid返回对应的postModel 对象
+ (void)retrievePost:(NSString *)uuid Block:(void(^)(WYPost *post,NSInteger status))block;

//创建订阅
+(void)addSubscribeForPost:(NSString *)postUuid Block:(void(^)(WYPost *post))block;

//取消订阅
+(void)cancelSubscribeForPost:(NSString *)postUuid Block:(void(^)(NSInteger status))block;

//给评论加星标
+(void)addStarToCommentUUid:(NSString *)comment_uuid author_uuid:(NSString *)author_uuid Block:(void(^)(NSInteger status))block;

//取消评论星标
+(void)cancelStarToCommentUUid:(NSString *)comment_uuid Block:(void(^)(NSInteger status))block;

@end
