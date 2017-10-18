//
//  WYGroupCategroyApi.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/9.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYGroupCategroyApi.h"
#import "WYGroupCategory.h"

@implementation WYGroupCategroyApi
//请求所有的群组类型
+(void)listAllGroupCategoryBlock:(void(^)(NSArray*tagsArr,BOOL success))block{
    NSString *s = [NSString stringWithFormat:@"api/v1/all_group_cats/"];
    [[WYHttpClient sharedClient] GET:s parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *tagsArr = [WYGroupCategory YYModelParse:responseObject];
        if (block) {
            block(tagsArr,YES);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,NO);
        }
    }];
}

@end
