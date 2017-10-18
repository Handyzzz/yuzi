//
//  WYRecommendUserApi.h
//  Withyou
//
//  Created by Handyzzz on 2017/8/9.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYRecommendUserApi : NSObject
+(void)listRecommendFriendsPage:(NSInteger)page Block:(void(^)(NSArray *recommendArr, BOOL hasMore))block;


@end
