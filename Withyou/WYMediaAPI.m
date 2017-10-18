//
//  WYMediaAPI.m
//  Withyou
//
//  Created by Handyzzz on 2017/9/28.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYMediaAPI.h"
#import "WYMediaFollow.h"
@implementation WYMediaAPI

+(void)listMediaTagCallback:(NSInteger)page callback:(void(^)(NSArray *tagList, BOOL hasMore))callback{
    NSString *s = @"api/v1/media_tag_list/";
    NSDictionary *dic = @{@"page":@(page)};
    [[WYHttpClient sharedClient]GET:s parameters:dic showToastError:YES callback:^(id responseObject) {
        NSArray *tagList = [WYMediaTag YYModelParse:[responseObject objectForKey:@"results"]];
        NSString *next = [responseObject objectForKey:@"next"];
        BOOL hasMore = [next isEqual:[NSNull null]] ? NO : YES;
        if (callback) callback(tagList, hasMore);
    }];
}

+(void)listMeidaWithTagNum:(int)tagNum page:(NSInteger)page callback:(void(^)(NSArray*mediaArr, BOOL hasMore))callback{
    NSString *s = @"api/v1/media/all_media_in_tag/";
    NSDictionary *dic = @{
                          @"tag_num":@(tagNum),
                          @"page":@(page)
                          };
    [[WYHttpClient sharedClient]GET:s parameters:dic showToastError:YES callback:^(id responseObject) {
        NSArray *mediaArr = [WYMedia YYModelParse:[responseObject objectForKey:@"results"]];
        NSString *next = [responseObject objectForKey:@"next"];
        BOOL hasMore = [next isEqual:[NSNull null]] ? NO : YES;
        if (callback) callback(mediaArr, hasMore);
    }];
}

//add follow to media
+(void)addFollowToMedia:(NSString *)mediaUuid callback:(void(^)(NSInteger status))callback{
    NSString *s = @"api/v1/follow_media/";
    NSDictionary *dic = @{
                          @"user_uuid":kuserUUID,
                          @"media_uuid":mediaUuid
                          };
    [[WYHttpClient sharedClient]POST:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        //201 success
        if (callback) {
            callback(httpResponse.statusCode);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (callback) {
            callback(httpResponse.statusCode);
        }
    }];
}

//cancel follow to media
+(void)cancelFollowToMedia:(NSString *)mediaUuid callback:(void(^)(NSInteger status))callback{
    NSString *s = [NSString stringWithFormat:@"api/v1/follow_media/%@/",mediaUuid];
    NSDictionary *dic = @{
                          @"media_uuid":mediaUuid
                          };
    [[WYHttpClient sharedClient] DELETE:s parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        //204 success
        if (callback) {
            callback(httpResponse.statusCode);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (callback) {
            callback(httpResponse.statusCode);
        }
    }];
}

//media list i have followed
+(void)listMediaFollowed:(NSInteger)page callback:(void(^)(NSArray *mediaFollowArr, BOOL hasMore))callback{
    NSString *s = @"api/v1/follow_media/";
    NSDictionary *dic = @{@"page":@(page)};
    [[WYHttpClient sharedClient]GET:s parameters:dic showToastError:YES callback:^(id responseObject) {
        NSDictionary *dic = [responseObject objectForKey:@"results"];
        NSArray *mediaFollowArr = [WYMediaFollow YYModelParse:dic];
        NSString *next = [responseObject objectForKey:@"next"];
        BOOL hasMore = [next isEqual:[NSNull null]] ? NO : YES;
        if (callback) callback(mediaFollowArr, hasMore);
    }];
}
@end
