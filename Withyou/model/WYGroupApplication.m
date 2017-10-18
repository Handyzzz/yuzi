//
//  WYGroupApplication.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/11.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYGroupApplication.h"

@implementation WYGroupApplication
//获取处理群申请的详情
+(void)retrieveGroupApplication:(NSString *)targetUuid Block:(void (^)(WYGroupApplication *groupApplication,NSInteger status))block{
    NSString *s = [NSString stringWithFormat:@"api/v1/group_application/%@/",targetUuid];
    [[WYHttpClient sharedClient] GET:s parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        WYGroupApplication *groupApplication = [WYGroupApplication YYModelParse:responseObject];
        if (block) {
            block(groupApplication,httpResponse.statusCode);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (block) {
            block(nil,httpResponse.statusCode);
        }
    }];
}
//接受群申请
+(void)acceptGroupApplication:(NSString *)groupAcceptUuid Block:(void(^)(BOOL success))block{
    NSString *s = [NSString stringWithFormat:@"api/v1/group_application/%@/accept/",groupAcceptUuid];
    [[WYHttpClient sharedClient] GET:s parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (block) {
            block(YES);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(NO);
        }
    }];
}
//拒绝群申请
+(void)refuseGroupApplication:(NSString *)groupAcceptUuid Block:(void(^)(BOOL success))block{
    NSString *s = [NSString stringWithFormat:@"api/v1/group_application/%@/decline/",groupAcceptUuid];
    [[WYHttpClient sharedClient]GET:s parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (block) {
            block(YES);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(NO);
        }
    }];
}
@end
