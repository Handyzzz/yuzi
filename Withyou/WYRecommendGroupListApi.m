//
//  WYRecommendGroupListApi.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/9.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYRecommendGroupListApi.h"
#import "WYRecommendGroup.h"

@implementation WYRecommendGroupListApi
//获取具体分类下边的群组
+(void)listGroupArrForCategory:(NSInteger)category Page:(NSInteger)page :(void(^)(NSArray *recommentGroupArr,BOOL success))block{
    NSString *s = @"api/v1/rec_group/";
    NSDictionary *dic = @{
                          @"category":@(category),
                          @"page":@(page)
                          };
    
    [[WYHttpClient sharedClient] GET:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *groupArr = [WYRecommendGroup YYModelParse:[responseObject objectForKey:@"results"]];
        NSString *next = [responseObject objectForKey:@"next"];
        BOOL hasMore = [next isEqual:[NSNull null]] ? NO : YES;
        
        if (block) {
            block(groupArr,hasMore);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,NO);
        }
    }];
}


@end
