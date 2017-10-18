//
//  YZPostComment.h
//  Withyou
//
//  Created by ping on 2017/2/20.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <YYModel.h>
#import "WYUser.h"

@interface YZPostComment : NSObject <YYModel>
/*
 评论或者星标变化的时候 直接将self.post 中对应的post 的星标与评论数目修改 然后将post传到相关的页面 替换掉以前的post
 */
@property (strong, nonatomic) NSString* uuid;
@property (strong, nonatomic) NSString* reply_uuid;
@property (strong, nonatomic) NSString* reply_author_uuid;
@property (strong, nonatomic) NSString* author_uuid;
@property (strong, nonatomic) NSString* content;
@property (strong, nonatomic) NSString* replied_content;
@property (assign, nonatomic) int target_type;
@property (strong, nonatomic) NSString* target_uuid;
@property (strong, nonatomic) NSNumber* created_at_float;
@property (strong, nonatomic) WYUser* replied_author;
@property (strong, nonatomic) WYUser* author;
@property (assign, nonatomic) BOOL starred;
@property (assign, nonatomic) int star_num;
@property (assign, nonatomic) BOOL private_type;
// @高亮携带的信息
@property (strong, nonatomic) NSArray <YZMarkText *> *mention;


#pragma mark - Http Request
+ (void)addPostCommentFor:(NSString *)reply_uuid replyAuthor:(NSString *)reply_author_uuid content:(NSString *)content mention:(NSArray *)mention targetUUID:(NSString *)target_uuid private:(BOOL)isPrivate  Block:(void (^)(YZPostComment *frame))block;

+ (void)deletePostComment:(NSString *)uuid Block:(void (^)(long status))block;

+ (void)publishCommentsTopFor:(NSString *)uuid t:(NSNumber *)t Block:(void (^)(NSArray *arr,BOOL hasMore))block;
+ (void)privateCommentsTopFor:(NSString *)uuid t:(NSNumber *)t Block:(void (^)(NSArray *arr,BOOL hasMore))block;

//举报评论
+ (void)reportPostComment:(NSString*)commentUuid type:(NSNumber *)type;
@end
