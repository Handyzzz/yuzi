//
//  WYPostTagApi.h
//  Withyou
//
//  Created by Handyzzz on 2017/8/19.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYPostTagApi : NSObject
//添加标签
+(void)addPostTag:(NSString *)PostUuid tags:(NSArray *)addArr Block:(void(^)(NSArray *addedArr))block;

//删除标签
+(void)removePostTag:(NSString *)PostUuid tags:(NSArray *)removeArr Block:(void(^)(NSArray *removedArr))block;

//标签推荐 字符串
+(void)recommendPostTag:(NSString *)contentStr Block:(void(^)(NSArray *recommendStrArr))block;

//搜索推荐 有重要与普通的区分
+(void)recommendPostTagOnSearch:(NSString *)tagStr Block:(void(^)(NSArray *recommendDicArr))block;

//热门标签 有重要与普通的区分
+(void)hotPostTagBlock:(void(^)(NSArray *hotDicArr))block;

//关注标签
+(void)addFollowToTagName:(NSString*)tagName Block:(void(^)(NSInteger status))block;

//取消关注标签
+(void)cancelFollowToTagName:(NSString*)tagName Block:(void(^)(NSInteger status))block;

//标签的关注者列表
+(void)listFollowerListOfTag:(NSString*)tagName Block:(void(^)(NSArray *tempArr, BOOL isFollowing))block;

//我的标签列表
+(void)listAllMyFollowedTags:(NSInteger)page Block:(void(^)(NSArray *tagDicList,BOOL hasMore))block;

@end
