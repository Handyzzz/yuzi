//
//  WYGroupListApi.h
//  Withyou
//
//  Created by Handyzzz on 2017/8/9.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYGroupListApi : NSObject

//请求所有群组
+ (void)requestGroupListWithBlock:(void (^)(NSArray *groups))block;

//推荐群组
+(void)listRecommendGroupsBlock:(void(^)(NSArray *groupsArr,BOOL success))block;

//推荐更多群组 没有的时候返回的时候空数组 成功但是获得空数组 就是没有has more
+(void)listMoreRecommendGroups:(NSArray *)groupArr Block:(void(^)(NSArray *moreGroupArr,BOOL success))block;

//搜索群组
+(void)listSearchGroups:(NSString *)text time:(NSNumber *)time Block:(void(^)(NSArray *groupArr,BOOL success))block;
@end
