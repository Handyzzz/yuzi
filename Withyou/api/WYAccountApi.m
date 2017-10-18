//
//  WYAccountApi.m
//  Withyou
//
//  Created by Tong Lu on 7/20/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import "WYAccountApi.h"
#import "WYHttpClient.h"
#import "WYQiniuApi.h"

@implementation WYAccountApi

+ (NSString *)getTokenForVCodeFromPhone:(NSString *)phone
{
    return @"abc";
}

+ (NSURLSessionDataTask *)getVCodeByParam:(NSDictionary *)param WithBlock:(void (^)(NSDictionary *dict, NSError *error,NSInteger status))block
{
    //不需要auth token, 所以新建立一个class
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    NSString *url = [NSString stringWithFormat:@"%@%@", kApiVersion, kApiSendVCodeAddress];
    
    return [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;

        if (block) {
            block(responseObject, nil,httpResponse.statusCode);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"nsurl error is %@", error);
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;

        if (block) {
            block(nil, error,httpResponse.statusCode);
        }
    }];
}

+ (NSURLSessionDataTask *)postLoginByParam:(NSDictionary *)param WithBlock:(void (^)(WYUID *uid, NSError *error))block{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    
    NSString *url = [NSString stringWithFormat:@"%@%@", kApiVersion, kApiLoginAddress];
    
    return [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSDictionary *response = JSON;
//        debugLog(@"resp in login is %@", JSON);
        
        //有可能后端给出的字典发生了变化，接口发生改变
        WYUID *uid = [WYUID yy_modelWithDictionary:response];
        NSLog(@"token is %@", uid.token);
        
        if (uid != nil) {
            [[WYUIDTool sharedWYUIDTool] addUID:uid];
            [[WYUtility sharedAppDelegate] handleDatabaseAfterLogin];
            [WYUser saveUserToDB:uid.user];

             [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserLoggedIn object:nil userInfo:@{@"uid": uid}];
            
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:uid.icon_url] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
            }];
            
            if (block) {
                block(uid, nil);
            }
        }
        else
        {
            [WYUtility showAlertWithTitle:@"应用并非最新版本，请升级后再登录使用"];
            if (block) {
                block(nil, nil);
            }
        }

    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)task.response;
        debugLog(@"=====%@",httpResponse.description);
        debugLog(@"=====%@",httpResponse.debugDescription);

        NSLog(@"failed login");
        if (block) {
            block(nil, nil);
        }
    }];
}

+ (void)reportErrorLogBy:(NSString *)description
{
    [[WYHttpClient sharedClient] POST:@"api/v1/error_log/" parameters:@{@"description": description} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        NSLog(@"cmd %@, status code: %li", NSStringFromSelector(_cmd), (long)httpResponse.statusCode);
        

        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        NSLog(@"cmd %@, status code: %li", NSStringFromSelector(_cmd), (long)httpResponse.statusCode);
        NSLog(@"cmd %@, error is %@, ", NSStringFromSelector(_cmd), error);
    }];
}

+ (BOOL)shouldUpdatePushToken
{
    //5秒之内不请求第二次
    //弱网条件下，因为超时时间远大于5秒，会请求多次
    NSDate *oldDate = [[NSUserDefaults standardUserDefaults] objectForKey:kPushDeviceTokenKeyLastUpdatedTime];
    if(!oldDate) return YES;
    
    NSDate *now = [NSDate date];
    double interval = [now timeIntervalSinceDate:oldDate];
    
    if(interval > 5)
        return YES;
    else
        return NO;
}

+ (void)setTimeStampForLastUpdatePushTokenToBackend
{
//    kPushDeviceTokenKeyLastUpdatedTime
    NSDate *now = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:now forKey:kPushDeviceTokenKeyLastUpdatedTime];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+ (void)logoutForCurrentDeviceBlock:(void (^)(BOOL res))block{
    
    NSUUID *s = [[UIDevice currentDevice] identifierForVendor];
    [[WYHttpClient sharedClient] POST:@"api/v1/device_token_logout/" parameters:@{@"device_id": [s UUIDString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        NSLog(@"cmd %@, status code: %li", NSStringFromSelector(_cmd), (long)httpResponse.statusCode);
        if(block)
            block(YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        NSLog(@"cmd %@, status code: %li", NSStringFromSelector(_cmd), (long)httpResponse.statusCode);
        NSLog(@"cmd %@, error is %@, ", NSStringFromSelector(_cmd), error);
        if(block)
            block(NO);
    }];
}

//跳过版本更新
+ (void)skipVersionTeptOfiPhoneBlock:(void (^)(BOOL haveSkip))block{
    
    NSString *s = [NSString stringWithFormat:@"api/v1/skip_upgrade_version/"];
    /*# iOS传1，android传2*/
    NSDictionary *dic = @{@"type_of_device":@(1)};
    [[WYHttpClient sharedClient] GET:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        BOOL haveSkip = httpResponse.statusCode == 200 ? YES : NO;
        if (block) {
            block(haveSkip);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(NO);
        }
    }];
}

+(void)versionShouldUapdate:(NSString *)token Block:(void (^)(BOOL ignored, NSString * versionCode,NSArray *versionDesc,NSString *downloadUrl))block{
    
    NSUUID *s = [[UIDevice currentDevice] identifierForVendor];
    
    if(![[self class] shouldUpdatePushToken]) return;
    
    [[self class] setTimeStampForLastUpdatePushTokenToBackend];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSDictionary *params = @{
                             @"token": token,
                             @"type": @1,
                             @"device_id": [s UUIDString],
                             @"app_version": appVersion,
                             };
    
    [[WYHttpClient sharedClient] POST:@"api/v1/device_token/" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        BOOL ignored = [[responseObject objectForKey:@"ignored"] boolValue];
        NSString *versionCode = [responseObject objectForKey:@"newest_version"];
        NSArray *versionDesc = [responseObject objectForKey:@"version_desc"];
        NSString *downloadUrl = [responseObject objectForKey:@"download_url"];
        if (block) {
            block(ignored,versionCode,versionDesc,downloadUrl);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        NSLog(@"0000000000000");

        if (block) {
            block(YES,nil,nil,nil);
        }
    }];

}

@end
