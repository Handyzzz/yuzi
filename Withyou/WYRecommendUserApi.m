//
//  WYRecommendUserApi.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/9.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYRecommendUserApi.h"
#import "WYReccomendUser.h"

@implementation WYRecommendUserApi
+(void)listRecommendFriendsPage:(NSInteger)page Block:(void(^)(NSArray *recommendArr,BOOL hasMore))block{
    
    NSString *s = [NSString stringWithFormat:@"api/v1/follow/possible_friends/?page=%ld",page];
    
    [[WYHttpClient sharedClient]GET:s parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *next = [responseObject objectForKey:@"next"];
        BOOL hasMore = [next isEqual:[NSNull null]] ? NO : YES;
        NSArray* friendArr = [WYReccomendUser YYModelParse:[responseObject objectForKey:@"results"]];
        if (block) {
            block(friendArr,hasMore);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,NO);
        }
    }];
}

@end
