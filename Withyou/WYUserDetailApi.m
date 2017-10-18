//
//  WYUserDetailApi.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/9.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYUserDetailApi.h"

@implementation WYUserDetailApi
+(void)retrieveUserInfo:(NSString *)Uuid Block:(void(^)(WYUserDetail *userInfo))block{
    NSString *s = [NSString stringWithFormat:@"api/v1/user/%@/",Uuid];
    
    [[WYHttpClient sharedClient] GET:s parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WYUserDetail *userInfo = [WYUserDetail YYModelParse:responseObject];
        if (block) {
            block(userInfo);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil);
        }
    }];
    
}

+ (void)retrieveUserDetail:(NSString *)Uuid Block:(void (^)(NSArray *postArr,WYUserDetail *userInfo, NSArray *photoArr,WYUserExtra *userExtra,BOOL hasDetail))block{
    
    NSString *s = [NSString stringWithFormat:@"api/v1/user_detail/%@/",Uuid];
    
    [[WYHttpClient sharedClient] GET:s parameters:nil
                            progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 //一起四个
                                 NSArray *postModelArr = [responseObject objectForKey:@"posts"];
                                 NSDictionary *user_infoDic = [responseObject objectForKey:@"user_info"];
                                 NSArray *photosModelArr = [responseObject objectForKey:@"photos"];
                                 NSDictionary *extraDic = [responseObject objectForKey:@"extra"];
                                 
                                 NSArray *postArr = [WYPost YYModelParse:postModelArr];
                                 WYUserDetail *userInfo = [WYUserDetail YYModelParse:user_infoDic];
                                 NSArray *photoArr = [WYPhoto YYModelParse:photosModelArr];
                                 WYUserExtra *userExtra = [WYUserExtra YYModelParse:extraDic];
                                 if(block)
                                     block(postArr,userInfo,photoArr,userExtra,YES);
                                 
                                 NSError *parseError = nil;
                                 
                                 NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&parseError];
                                 
                                 NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                                 
                                 [WYUserDetail saveUserDetailToDB:str UUid:userInfo.uuid];
                                 [WYUserDetail saveUserWhichInUserInfoToDB:userInfo];
                                 
                             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                 debugLog(@"%lu",httpResponse.statusCode);
                                 if(block)
                                     block(nil,nil,nil,nil,NO);
                             }];
}


+ (void)patchUserDetailDic:(NSDictionary *)dic Block:(void(^)(WYUser *user,NSInteger status))block{
    NSString *s = [NSString stringWithFormat:@"api/v1/user/self/"];
    [[WYHttpClient sharedClient] PATCH:s parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        WYUser *user = [WYUser YYModelParse:responseObject];
        [WYUser saveUserToDB:user];
        if (block) {
            block(user,httpResponse.statusCode);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (block) {
            block(nil,httpResponse.statusCode);
        }
    }];
}

//请求更多帖子
+(void)listMorePosts:(NSString *)uuid time:(NSNumber *)time Block:(void(^)(NSArray *morePostArr,BOOL success))block{
    
    NSString *s = [NSString stringWithFormat:@"api/v1/user_detail/%@/more_posts/",uuid];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:time forKey:@"t"];
    
    debugLog(@"dict is %@", dic);
    
    [[WYHttpClient sharedClient] GET:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //        debugLog(@"%@",responseObject);
        
        NSArray *modelArr = [responseObject objectForKey:@"posts"];
        
        NSArray *morePostArr = [WYPost YYModelParse:modelArr];
        if (block) {
            block(morePostArr,YES);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (block) {
            block(nil,NO);
        }
    }];
}

//我参与的帖子
+(void)listParticipateForMe:(NSString *)userUuid time:(NSNumber *)time Block:(void(^)(NSArray *postArr, BOOL success))block{
    NSString *s = [NSString stringWithFormat:@"api/v1/user_detail/%@/involved_posts/",userUuid];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:time forKey:@"t"];
    
    [[WYHttpClient sharedClient] GET:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *postArr = [WYPost YYModelParse:[responseObject objectForKey:@"posts"]];
        if (block) {
            block(postArr,YES);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,NO);
        }
    }];
}

//请求更多图片
+(void)listMorePhotos:(NSString *)uuid time:(NSNumber *)time Block:(void(^)(NSArray *photoArr,BOOL success))block{
    NSString *s = [NSString stringWithFormat:@"api/v1/user_detail/%@/more_photos/",uuid];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:time forKey:@"t"];
    
    debugLog(@"dict is %@", dic);
    
    [[WYHttpClient sharedClient] GET:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSArray *modelArr = [responseObject objectForKey:@"photos"];
        
        NSArray *photoArr = [WYPhoto YYModelParse:modelArr];
        if (block) {
            block(photoArr,YES);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,NO);
        }
    }];
}

+(void)listMorePublicGroup:(NSString *)userUuid Page:(NSInteger)page Block:(void(^)(NSArray *moreGroupArr,BOOL hasMore))block{
    
    NSString *s = [NSString stringWithFormat:@"api/v1/user_detail/%@/more_public_groups/?page=%ld",userUuid,(long)page];
    [[WYHttpClient sharedClient] GET:s parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *next = [responseObject objectForKey:@"next"];
        BOOL hasMore = [next isEqual:[NSNull null]] ? NO : YES;
        debugLog(@"%@",next);
        debugLog(@"%d",hasMore);
        NSArray *modelArr = [responseObject objectForKey:@"results"];
        NSArray *groupArr = [WYGroup YYModelParse:modelArr];
        if (block) {
            block(groupArr,hasMore);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,NO);
        }
    }];
    
}
//请求查看对方的朋友列表
+(void)listUserFriends:(NSString *)userUuid Page:(NSInteger)page Block:(void(^)(NSArray *moreFrdendsArr,BOOL hasMore))block{
    
    NSString *s = [NSString stringWithFormat:@"api/v1/user_detail/%@/all_friends_of_user/?page=%ld",userUuid,page];
    [[WYHttpClient sharedClient] GET:s parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *next = [responseObject objectForKey:@"next"];
        BOOL hasMore = [next isEqual:[NSNull null]] ? NO : YES;
        
        NSArray *firendsArr = [WYUser YYModelParse:[responseObject objectForKey:@"results"]];
        if (block) {
            block(firendsArr,hasMore);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,NO);
        }
    }];
}

//请求查看共同的好友
+(void)listCommonFriends:(NSString *)userUuid Page:(NSInteger)page Block:(void(^)(NSArray *moreFrdendsArr,BOOL hasMore))block{
    NSString *s = [NSString stringWithFormat:@"api/v1/user_detail/%@/common_friends_with_user/?page=%ld",userUuid,page];
    debugLog(@"%@",s);
    [[WYHttpClient sharedClient] GET:s parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        debugLog(@"%@",responseObject);
        
        NSString *next = [responseObject objectForKey:@"next"];
        BOOL hasMore = [next isEqual:[NSNull null]] ? NO : YES;
        
        NSArray *firendsArr = [WYUser YYModelParse:[responseObject objectForKey:@"results"]];
        if (block) {
            block(firendsArr,hasMore);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        debugLog(@"%lu",httpResponse.statusCode);
        if (block) {
            block(nil,NO);
        }
    }];
}

@end
