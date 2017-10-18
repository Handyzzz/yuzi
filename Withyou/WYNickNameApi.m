//
//  WYNickNameApi.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/9.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYNickNameApi.h"

@implementation WYNickNameApi
//展示我的所有昵称
+(void)getUserAllNickNameBlock:(void(^)(NSArray *nickNameArr))block{
    NSString *s = [NSString stringWithFormat:@"api/v1/nick_name/"];
    [[WYHttpClient sharedClient] GET:s parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *nickNameArr = [WYNickName YYModelParse:responseObject];
        if (block) {
            block(nickNameArr);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil);
        }
    }];
}


//创建昵称
+(void)postUserNickNameDetail:(NSDictionary *)dic Block:(void(^)(WYNickName *nickName))block{
    NSString *s = [NSString stringWithFormat:@"api/v1/nick_name/"];
    [[WYHttpClient sharedClient] POST:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WYNickName *nickName = [WYNickName YYModelParse:responseObject];
        if (block) {
            block(nickName);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil);
        }
    }];
}

//修改一条昵称
+(void)patchNickNameDetail:(NSString *)nickNameUuid Dic:(NSDictionary *)dic Block:(void(^)( WYNickName*nickName))block{        NSString *s = [NSString stringWithFormat:@"api/v1/nick_name/%@/",nickNameUuid];
    [[WYHttpClient sharedClient] PATCH:s parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WYNickName *nickName = [WYNickName YYModelParse:responseObject];
        if (block) {
            block(nickName);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil);
        }
    }];
    
}

//删除一条昵称
+(void)deleteNickNameDetail:(NSString *)nickNameUuid Block:(void(^)(BOOL haveDelete))block{
    NSString *s = [NSString stringWithFormat:@"api/v1/nick_name/%@/",nickNameUuid];
    [[WYHttpClient sharedClient]DELETE:s parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (block) {
            block(YES);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        debugLog(@"%lu",httpResponse.statusCode);
        
        if (block) {
            block(NO);
        }
    }];
}

@end
