//
//  WYStudyApi.m
//  
//
//  Created by Handyzzz on 2017/8/9.
//
//

#import "WYStudyApi.h"

@implementation WYStudyApi
//展示我的所有学习经历
+(void)getUserAllStudy:(NSString *)userUuid page:(NSInteger)page Block:(void(^)(NSArray *studyArr,BOOL hasMore))block{
    
    NSString *s = [NSString stringWithFormat:@"api/v1/user_detail/%@/more_studies/?page=%ld",userUuid,page];
    
    
    [[WYHttpClient sharedClient] GET:s parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *next = [responseObject objectForKey:@"next"];
        BOOL hasMore = [next isEqual:[NSNull null]] ? NO : YES;
        NSArray *studyArr = [WYStudy YYModelParse:[responseObject objectForKey:@"results"]];
        if (block) {
            block(studyArr,hasMore);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,NO);
        }
    }];
}
//创建一条学习经历
+(void)postUserStudyDetail:(NSDictionary *)dic Block:(void(^)(WYStudy *study))block{
    NSString *s = [NSString stringWithFormat:@"api/v1/study/"];
    [[WYHttpClient sharedClient] POST:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WYStudy *study = [WYStudy yy_modelWithJSON:responseObject];
        if (block) {
            block(study);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil);
        }
    }];
}

//修改一条具体的学习经历的详情
+(void)patchStudyDetail:(NSString *)jobUuid Dic:(NSDictionary *)dic Block:(void(^)( WYStudy*study))block{    NSString *s = [NSString stringWithFormat:@"api/v1/study/%@/",jobUuid];
    [[WYHttpClient sharedClient] PATCH:s parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WYStudy * study = [WYStudy YYModelParse:responseObject];
        if (block) {
            block(study);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil);
        }
    }];
    
}
//删除一条具体的学习经历的详情
+(void)deleteStudyDetail:(NSString *)jobUuid Block:(void(^)(BOOL haveDelete))block{
    NSString *s = [NSString stringWithFormat:@"api/v1/study/%@/",jobUuid];
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
