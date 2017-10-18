//
//  YZPublishPostApi.m
//  Withyou
//
//  Created by ping on 2016/12/30.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import "YZPostListApi.h"
#import "WYHttpClient.h"
#import "WYGroup.h"

@implementation YZPostListApi
+ (void)requestFeedsByParam:(NSDictionary *)param Handler:(void (^)(NSArray *postArray))handler {
    // here we have a paginator
    [[WYHttpClient sharedClient] GET:@"api/v1/post/feeds/" parameters:param progress:nil
                             success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                                 
                                 NSArray *postsFromResponse = [responseObject valueForKeyPath:@"results"];
                                 
                                 NSArray *models = [NSArray yy_modelArrayWithClass:[WYPost class] json:postsFromResponse];
                                 if (handler) {
                                     handler(models);
                                 }
                             }
                             failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                                 
                                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) task.response;
                                 NSLog(@"status code: %li", (long) httpResponse.statusCode);
                                 NSLog(@"error is %@", error);
                                 
                                 if (handler) {
                                     handler([NSArray array]);
                                 }
                             }];
}

//阅读列表
+(void)listReadingPostByParam:(NSDictionary *)param Handler:(void (^)(NSArray *postArray))handler{
    // here we have a paginator
    [[WYHttpClient sharedClient] GET:@"api/v1/post/read/" parameters:param progress:nil
                             success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                                 
                                 NSArray *postsFromResponse = [responseObject valueForKeyPath:@"results"];
                                 
                                 NSArray *models = [NSArray yy_modelArrayWithClass:[WYPost class] json:postsFromResponse];
                                 if (handler) {
                                     handler(models);
                                 }
                             }
                             failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                                 
                                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) task.response;
                                 NSLog(@"status code: %li", (long) httpResponse.statusCode);
                                 NSLog(@"error is %@", error);
                                 
                                 if (handler) {
                                     handler([NSArray array]);
                                 }
                             }];
}

//以某个时间点获取数据 但是消息的creatTime并不是这个分享的creatTime
//获取一个用户的帖子列表中，我可以看到的内容
+ (void)requestVisiblePostToMe:(NSNumber *)t ForUser:(NSString *)userUuid WithCallBack:(void (^)(NSArray<WYPost *> *))callback {

    [[WYHttpClient sharedClient] GET:@"api/v1/post/visible_post/" parameters:@{@"author_uuid": userUuid, @"t": t} progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        NSArray *postsFromResponse = [responseObject valueForKeyPath:@"results"];

        NSArray *models = [NSArray yy_modelArrayWithClass:[WYPost class] json:postsFromResponse];
        if (callback) {
            callback(models);
        }

    }                        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"%@", error);
        if (callback) {
            callback(nil);
        }
    }];
}

+ (void)postListForGroup:(NSString *)groupUuid lastTime:(NSNumber *)lastTime Block:(void (^)(NSArray *postList))block {
    NSString *s;
    BOOL first;
    if (lastTime == nil) {
        first = YES;
        s = [NSString stringWithFormat:@"/api/v1/group/%@/", groupUuid];
    } else {
        first = NO;
        s = [NSString stringWithFormat:@"/api/v1/group/%@/more_group_post/?t=%@", groupUuid, lastTime];
    }
    [[WYHttpClient sharedClient] GET:s parameters:nil progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        //NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        NSArray *arr;
        if (first == YES) {
            arr = [NSArray yy_modelArrayWithClass:[WYPost class] json:[responseObject objectForKey:@"first_ten_post"]];
        } else {
            arr = [NSArray yy_modelArrayWithClass:[WYPost class] json:[responseObject objectForKey:@"results"]];
        }
        if (block) {
            block(arr);
        }
    }                        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        //NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        if (block) {
            block(nil);
        }
    }];
}

//输入关键字 查找帖子
+ (void)selectPostForGroup:(NSString *)groupUuid text:(NSString *)text lastTime:(NSNumber *)lastTime Block:(void (^)(NSArray *postList))block {

    //这里使用的时候 可能主动上拉的时候没有数据 这个时候传的是nil 做一下处理
    if (lastTime == nil) {
        lastTime = @0;
    }

    NSString *s = [NSString stringWithFormat:@"api/v1/group/%@/search_post/?keyword=?&t=?", groupUuid];
    NSMutableDictionary *md = [@{
            @"keyword": text,
            @"t": lastTime
    } mutableCopy];

    [[WYHttpClient sharedClient] GET:s parameters:md progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        NSArray *arr = [NSArray yy_modelArrayWithClass:[WYPost class] json:[responseObject objectForKey:@"results"]];
        if (block) {
            block(arr);
        }
    }                        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) task.response;
        if (block) {
            block(nil);
        }
    }];
}

//推荐页的缓存 只需要缓存30条
+ (void)recommendPostListHandler:(void (^)(NSArray *eventArr, NSArray *groupArr, NSArray *postArr))handler; {


    NSString *s = @"/api/v1/recommend/";
    [[WYHttpClient sharedClient] GET:s parameters:nil progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

                //暂时没有
                //        NSArray * eventModels = [responseObject valueForKeyPath:@"event_list"];
                NSArray *eventArr;
                //eventArr = [NSArray yy_modelArrayWithClass:[*** class] json:eventModels];

                NSArray *groupModels = [responseObject valueForKeyPath:@"group_list"];
                NSArray *groupArr = [NSArray yy_modelArrayWithClass:[WYGroup class] json:groupModels];

                NSArray *postModels = [responseObject valueForKeyPath:@"post_list"];
                NSArray *postArr = [NSArray yy_modelArrayWithClass:[WYPost class] json:postModels];
                if (postArr.count > 0) {
                    for (WYPost *post in postArr) {
                        [WYPost saveRecommendPostToDB:post];
                    }
                }
                if (handler) {
                    handler(eventArr, groupArr, postArr);
                }
            }
                             failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {

                                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) task.response;
                                 NSLog(@"status code: %li", (long) httpResponse.statusCode);
                                 NSLog(@"error is %@", error);

                                 if (handler) {
                                     handler(nil, nil, nil);
                                 }
                             }];
}

//推荐页的缓存 只需要缓存30条 所以loadmore中不做缓存
+ (void)moreRecommendPostList:(NSArray *)UuidList Handler:(void (^)(NSArray *postArr))handler {

    NSString *s = @"/api/v1/post/recommend_more_post/";
    NSDictionary *dic = [NSDictionary dictionaryWithObject:UuidList forKey:@"post_list"];
    [[WYHttpClient sharedClient] POST:s parameters:dic progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

        NSArray *postArr = [NSArray yy_modelArrayWithClass:[WYPost class] json:responseObject];
        if (handler) {
            handler(postArr);
        }
    }                         failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) task.response;
        NSLog(@"status code: %li", (long) httpResponse.statusCode);
        NSLog(@"error is %@", error);

        if (handler) {
            handler(nil);
        }
    }];
}

//列出自己订阅的帖子
+ (void)listSubscribePost:(NSInteger)page Block:(void (^)(NSArray *postArr, BOOL hasMore))block {
    NSString *s = @"api/v1/subscribe_post/";
    NSDictionary *dic = @{
            @"page": @(page)
    };
    [[WYHttpClient sharedClient] GET:s parameters:dic progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

        NSString *next = [responseObject objectForKey:@"next"];
        BOOL hasMore = [next isEqual:[NSNull null]] ? NO : YES;

        NSArray *postArr = [WYPost YYModelParse:[responseObject objectForKey:@"results"]];
        if (block) {
            block(postArr, hasMore);
        }
    }                        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (block) {
            block(nil, NO);
        }
    }];
}

//请求标签相关帖子列表
+ (void)listTagResultPostList:(NSString *)tagStr page:(NSInteger)page Block:(void (^)(NSArray *postArr, BOOL hasMore, NSInteger count))block {
    NSString *s = @"api/v1/post/feeds_with_tag/";
    NSDictionary *dic = @{
            @"page": @(page),
            @"tag": tagStr
    };
    [[WYHttpClient sharedClient] GET:s parameters:dic progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

        NSString *next = [responseObject objectForKey:@"next"];
        BOOL hasMore = [next isEqual:[NSNull null]] ? NO : YES;
        NSInteger count = [[responseObject objectForKey:@"count"] integerValue];

        NSArray *postArr = [WYPost YYModelParse:[responseObject objectForKey:@"results"]];
        if (block) {
            block(postArr, hasMore, count);
        }
    }                        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (block) {
            block(nil, NO, 0);
        }
    }];
}

//我关注的标签列表的 相关的帖子列表
+ (void)listMyfollowedTagsPostsWithPage:(NSInteger)page Block:(void (^)(NSArray *postArr, BOOL hasMore))block {
    NSString *s = [NSString stringWithFormat:@"api/v1/followed_tags_posts/"];

    NSDictionary *dic = @{
            @"page": @(page)
    };
    //多封装了一层 responseObject 失败做的nil处理
    [[WYHttpClient sharedClient] GET:s parameters:dic showToastError:YES callback:^(id responseObject) {
        if (responseObject) {
            NSString *next = [responseObject objectForKey:@"next"];
            BOOL hasMore = [next isEqual:[NSNull null]] ? NO : YES;
            NSArray *postArr = [WYPost YYModelParse:[responseObject objectForKey:@"results"]];

            if (block) {
                block(postArr, hasMore);
            }
        } else {
            if (block) {
                block(nil, NO);
            }
        }
    }];
}
@end
