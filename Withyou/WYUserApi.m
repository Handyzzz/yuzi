//
//  WYUserApi.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/9.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYUserApi.h"
#import "WYUserDetailApi.h"

@implementation WYUserApi
+ (void)retrieveMyPermissionListToUser:(NSString *)uuid Block:(void (^)(NSDictionary *permission))block
{
    [[WYHttpClient sharedClient] GET:@"api/v1/info_permission/" parameters:@{@"follower":kuserUUID, @"influencer":uuid} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responseObject)
        {
            if(block)
                block(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(block)
            block(nil);
    }];
}
+ (void)updateMyPermissionListToUser:(NSString *)uuid WithDict:(NSDictionary *)dict Block:(void (^)(NSDictionary *permission))block
{
    NSString *s = [NSString stringWithFormat:@"api/v1/info_permission/?follower=%@&influencer=%@", kuserUUID, uuid];
    [[WYHttpClient sharedClient] PATCH:s parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responseObject)
        {
            if(block)
                block(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(block)
            block(nil);
    }];
}

+ (void)retrieveSelfGlobalPrivacyWithDict:(NSDictionary *)dict Block:(void (^)(WYSelfPrivacy *privacy))block{
    NSString *s = [NSString stringWithFormat:@"/api/v1/privacy/"];
    [[WYHttpClient sharedClient] GET:s parameters:dict
                            progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 WYSelfPrivacy *privacy = [WYSelfPrivacy YYModelParse:responseObject];
                                 if(block)
                                     block(privacy);
                             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                 debugLog(@"%lu",httpResponse.statusCode);
                                 if(block)
                                     block(nil);
                             }];
}

+ (void)updateSelfGlobalPrivacyWithDict:(NSDictionary *)dict Block:(void (^)(NSDictionary *response))block{
    NSString *s = [NSString stringWithFormat:@"/api/v1/privacy/"];
    [[WYHttpClient sharedClient] PATCH:s parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(block)
            block(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        debugLog(@"%lu",httpResponse.statusCode);
        if(block)
            block(nil);
    }];
}

//更换头像
+(void)changeUser:(NSString *)userUuid ImageWith:(PHAsset *)asset callback:(void (^)(WYUser *user))cb{
    NSString *uuid = [[NSUUID UUID] UUIDString];
    uuid = [uuid lowercaseString];
    NSString *qiniuKey = [@"u-icon-" stringByAppendingString:uuid];

    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        UIImage *image = [UIImage imageWithData:imageData];
        [WYQiniuApi uploadUIImage:image ForKey:qiniuKey WithBlock:^(NSString *key) {
            if(key)
            {
                NSDictionary *parameters = @{@"icon_url_key": key};
                [WYUserDetailApi patchUserDetailDic:parameters Block:^(WYUser *user, NSInteger status) {
                    if (cb) {
                        cb(user);
                    }
                }];
            }
            else
            {
                if(cb) {
                    cb(nil);
                }
            }
        }];
    }];
}

//search, WYUser array
+ (void)searchUserByKeyword:(NSString *)keyword Handler:(void (^)(NSArray *))handler
{
    NSDictionary *param = @{@"keyword": keyword};
    [[WYHttpClient sharedClient] GET:@"api/v1/user/search/" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *results = [responseObject valueForKeyPath:@"results"];
        NSArray *models = [NSArray yy_modelArrayWithClass:[WYUser class] json:results];
        if(handler)
            handler(models);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        NSLog(@"cmd %@, status code: %li", NSStringFromSelector(_cmd), (long)httpResponse.statusCode);
        NSLog(@"cmd %@, error is %@, ", NSStringFromSelector(_cmd), error);
        if(handler)
            handler(@[]);
        
    }];
}

+ (void)searchUserByUserName:(NSString *)userName Callback:(void (^)(WYUser *))callback {
    
    [[WYHttpClient sharedClient] GET:@"api/v1/user/search/" parameters:@{@"username":userName} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *results = [responseObject valueForKeyPath:@"results"];
        NSArray *models = [NSArray yy_modelArrayWithClass:[WYUser class] json:results];
        
        if(models.count > 0){
            WYUser *targetUser = models[0];
            if(callback)
                callback(targetUser);
        }
        else{
            if(callback)
                callback(nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        NSLog(@"cmd %@, status code: %li", NSStringFromSelector(_cmd), (long)httpResponse.statusCode);
        NSLog(@"cmd %@, error is %@, ", NSStringFromSelector(_cmd), error);
        if(callback)
            callback(nil);
        
    }];
}

@end
