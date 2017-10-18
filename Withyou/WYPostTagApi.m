//
//  WYPostTagApi.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/19.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYPostTagApi.h"
#import "WYTag.h"
#import "WYUser.h"

@implementation WYPostTagApi
//添加标签
+(void)addPostTag:(NSString*)PostUuid tags:(NSArray *)addArr Block:(void(^)(NSArray *addedArr))block{
    NSString *s = [NSString stringWithFormat:@"api/v1/post/%@/add_tags/",PostUuid];
    NSDictionary *dic = @{
                          @"tags":addArr
                          };
    [[WYHttpClient sharedClient] POST:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *modelArr = [responseObject objectForKey:@"added_tags"];
        NSArray * addedArr = [WYTag YYModelParse:modelArr];
        if (block) {
            block(addedArr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil);
        }
    }];
}

//删除标签
+(void)removePostTag:(NSString*)PostUuid tags:(NSArray *)removeArr Block:(void(^)(NSArray *removedArr))block{
    NSString *s = [NSString stringWithFormat:@"api/v1/post/%@/remove_tags/",PostUuid];
    NSDictionary *dic = @{
                          @"tags":removeArr
                          };
    [[WYHttpClient sharedClient] POST:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *removedArr = [responseObject objectForKey:@"removed_tags"];
        if (block) {
            block(removedArr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil);
        }
    }];
}

//标签推荐
+(void)recommendPostTag:(NSString *)contentStr Block:(void(^)(NSArray *recommendStrArr))block{
    NSString *s = @"api/v1/tag_recommend/";
    NSDictionary *dic = @{
                          @"content":contentStr
                          };
    [[WYHttpClient sharedClient] POST:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *recommendStrArr = [responseObject objectForKey:@"recommended_tags"];
        if (block) {
            block(recommendStrArr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil);
        }
    }];
}

//搜索推荐
+(void)recommendPostTagOnSearch:(NSString *)tagStr Block:(void(^)(NSArray *recommendDicArr))block{
    NSString *s = @"api/v1/tag_search/";
    NSDictionary *dic = @{
                          @"tag":tagStr
                          };
    [[WYHttpClient sharedClient] GET:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *recommendDicArr = [responseObject objectForKey:@"results"];
        
        if (block) {
            block(recommendDicArr);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil);
        }
    }];
}

//热门标签
+(void)hotPostTagBlock:(void(^)(NSArray *hotTagArr))block{
    NSString *s = @"api/v1/tag_hot_list/";
    [[WYHttpClient sharedClient] GET:s parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSArray *recommendDicArr = [responseObject objectForKey:@"results"];
       
        if (block) {
            block(recommendDicArr);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil);
        }
    }];
}

//关注标签
+(void)addFollowToTagName:(NSString*)tagName Block:(void(^)(NSInteger status))block{
    NSString *s = @"api/v1/follow_tag/";
    NSDictionary *dic = @{
                          @"tag_name":tagName
                          };
    [[WYHttpClient sharedClient] POST:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (block) {
            block(httpResponse.statusCode);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (block) {
            block(httpResponse.statusCode);
        }
    }];
}

//取消关注标签
+(void)cancelFollowToTagName:(NSString*)tagName Block:(void(^)(NSInteger status))block{
    NSString *s = [NSString stringWithFormat:@"api/v1/follow_tag/%@/",kuserUUID];
    NSDictionary *dic = @{
                          @"tag_name":tagName
                          };
    [[WYHttpClient sharedClient] DELETE:s parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        
        if (block) {
            block(httpResponse.statusCode);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;

        if (block) {
            block(httpResponse.statusCode);
        }
    }];
}

//标签的关注者列表
+(void)listFollowerListOfTag:(NSString*)tagName Block:(void(^)(NSArray *userArr, BOOL isFollowing))block{
    NSString *s = @"api/v1/follow_tag/followers/";
    NSDictionary *dic = @{
                          @"tag_name":tagName
                          };
    [[WYHttpClient sharedClient] GET:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *userArr = [WYUser YYModelParse:[responseObject objectForKey:@"followers"]];
        BOOL isFollowing = [[responseObject objectForKey:@"following"] boolValue];
        
        if (block) {
            block(userArr,isFollowing);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,NO);
        }
    }];
}

//我的标签列表
+(void)listAllMyFollowedTags:(NSInteger)page Block:(void(^)(NSArray *tagDicList,BOOL hasMore))block{
    NSString *s = [NSString stringWithFormat:@"api/v1/followed_tags/"];
    NSDictionary *dic = @{
                          @"page":@(page)
                          };
    [[WYHttpClient sharedClient] GET:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *next = [responseObject objectForKey:@"next"];
        BOOL hasMore = [next isEqual:[NSNull null]] ? NO : YES;
        
        NSArray *tagDicList = [responseObject objectForKey:@"results"];
        if (block) {
            block(tagDicList,hasMore);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil,NO);
        }
    }];
}

@end
