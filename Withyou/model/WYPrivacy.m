//
//  WYPrivacy.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/15.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYPrivacy.h"

@implementation WYPrivacy
//请求状态
+(void)retrievePrivacy:(NSString *)userUuid block:(void(^)(WYPrivacy *privacy))block{
    
    NSString *s = [NSString stringWithFormat:@"/api/v1/info_permission/?follower=%@&influencer=%@",kuserUUID,userUuid];
    
    [[WYHttpClient sharedClient]GET:s parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        WYPrivacy *privacy = [WYPrivacy YYModelParse:responseObject];
        if (block) {
            block(privacy);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil);
        }
    }];
}


//修改状态
+(void)patchPrivacy:(NSString *)userUuid dic:(NSDictionary *)dic block:(void(^)(WYPrivacy *privacy))block{
    
    NSString *s = [NSString stringWithFormat:@"/api/v1/info_permission/?follower=%@&influencer=%@",kuserUUID,userUuid];
    
    [[WYHttpClient sharedClient] PATCH:s parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        debugLog(@"%@",responseObject);
        WYPrivacy *privacy = [WYPrivacy YYModelParse:responseObject];
        if (block) {
            block(privacy);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil);
        }
    }];
}

@end
