//
//  WYProfileApi.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/9.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYProfileApi.h"
#import "WYAccountApi.h"

@implementation WYProfileApi

+ (void)retrieveSelfProfileBlock:(void (^)(WYProfile *profile))block
{
    [[WYHttpClient sharedClient] GET:@"api/v1/user/self/" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //有可能后端给出的字典发生了变化，接口发生改变，所以要做错误判断
        WYUID *uid = [WYUID yy_modelWithDictionary:responseObject];
        if (uid != nil) {
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:uid.icon_url] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {}];
            //设备没有网络的时候 不会被另一台设备挤下来 可以在这个时间更新一下 UID
            [[WYUIDTool sharedWYUIDTool] addUID:uid];
        }
        
        NSDictionary *profileDict = [responseObject objectForKey:@"profile"];
        WYProfile *profile = [WYProfile yy_modelWithDictionary:profileDict];
        if(profile){
            [WYProfile saveProfileToDB:profile];
            if(block)
                block(profile);
        }else{
            if(block)
                block(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(block)
            block(nil);
    }];
}

+ (void)retrieveProfileFromUuid:(NSString *)uuid Block:(void (^)(WYProfile *profile))block{
    
    NSString *s = [NSString stringWithFormat:@"api/v1/user/%@/", uuid];
    [[WYHttpClient sharedClient] GET:s parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if (responseObject != nil) {
            NSDictionary *profileDict = [responseObject objectForKey:@"profile"];
            WYProfile *profile = [WYProfile yy_modelWithDictionary:profileDict];
            if(profile)
            {
                [WYProfile saveProfileToDB:profile];
                if(block)
                    block(profile);
            }else{
                if(block)
                    block(nil);
            }
        }else{
            if(block)
                block(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(block)
            block(nil);
    }];
}

+ (void)patchProfireDic:(NSDictionary *)dic Block:(void(^)(WYProfile *profile))block{
    NSString *s = [NSString stringWithFormat:@"api/v1/profile/self/"];
    [[WYHttpClient sharedClient] PATCH:s parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WYProfile *profile = [WYProfile YYModelParse:responseObject];
        if (block) {
            block(profile);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil);
        }
    }];
}


@end
