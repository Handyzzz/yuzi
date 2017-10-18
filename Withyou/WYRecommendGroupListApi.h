//
//  WYRecommendGroupListApi.h
//  Withyou
//
//  Created by Handyzzz on 2017/8/9.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYRecommendGroupListApi : NSObject
//获取具体分类下边的群组
+(void)listGroupArrForCategory:(NSInteger)category Page:(NSInteger)page :(void(^)(NSArray *recommentGroupArr,BOOL hasMore))block;

@end
