//
//  WYJobApi.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/9.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYJobApi.h"

@implementation WYJobApi

//展示我的所有工作经历
+(void)getUserAllJob:(NSString *)userUuid page:(NSInteger)page Block:(void(^)(NSArray *jobArr,BOOL hasMore))block{
    NSString *s = [NSString stringWithFormat:@"api/v1/user_detail/%@/more_jobs/?page=%ld",userUuid,page];
    [[WYHttpClient sharedClient] GET:s parameters:nil
                            progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 NSString *next = [responseObject objectForKey:@"next"];
                                 BOOL hasMore = [next isEqual:[NSNull null]] ? NO : YES;
                                 NSArray *jobArr = [WYJob YYModelParse:[responseObject objectForKey:@"results"]];
                                 if (block) {
                                     block(jobArr ,hasMore);
                                 }
                                 
                             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                 debugLog(@"%lu",httpResponse.statusCode);
                                 if(block)
                                     block(nil,NO);
                             }];
    
}

//创建一条工作经历
+(void)postJobDetailDic:(NSDictionary *)dic Block:(void(^)(WYJob *job))block{
    
    
    NSString *s = [NSString stringWithFormat:@"api/v1/job/"];
    [[WYHttpClient sharedClient] POST:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        debugLog(@"%@",responseObject);
        WYJob *job = [WYJob YYModelParse:responseObject];
        if (block) {
            block(job);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(block)
            block(nil);
    }];
}

//获取一条具体的工作经历的详情
+(void)getJobDetail:(NSString *)jobUuid Block:(void(^)(WYJob *job))block{
    NSString *s = [NSString stringWithFormat:@"api/v1/job/%@/",jobUuid];
    [[WYHttpClient sharedClient] GET:s parameters:nil
                            progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 
                                 WYJob *job = [WYJob YYModelParse:responseObject];
                                 if (block) {
                                     block(job);
                                 }
                                 
                             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                 debugLog(@"%lu",httpResponse.statusCode);
                                 if(block)
                                     block(nil);
                             }];
    
}

//修改一条具体的工作经历的详情
+(void)patchJobDetail:(NSString *)jobUuid Dic:(NSDictionary *)dic Block:(void(^)(WYJob *job))block{
    NSString *s = [NSString stringWithFormat:@"api/v1/job/%@/",jobUuid];
    
    [[WYHttpClient sharedClient] PATCH:s parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WYJob * job = [WYJob YYModelParse:responseObject];
        if (block) {
            block(job);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil);
        }
    }];
    
}
//删除一条具体的工作经历的详情
+(void)deleteJobDetail:(NSString *)jobUuid Block:(void(^)(BOOL haveDelete))block{
    NSString *s = [NSString stringWithFormat:@"api/v1/job/%@/",jobUuid];
    [[WYHttpClient sharedClient] DELETE:s parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
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
