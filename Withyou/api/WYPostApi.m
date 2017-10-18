//
//  WYPostApi.m
//  Withyou
//
//  Created by Tong Lu on 7/20/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import "WYPostApi.h"
#import "WYQiniuApi.h"
#import "WYHttpClient.h"
#import "WYPost.h"

@implementation WYPostApi

+ (void)saveDraft:(NSDictionary *)dict {
    NSString *contentStr = [dict objectForKey:@"content"];
    NSDate *datenow = [NSDate date];
    // 这个时间是格林
    NSString *dateString = [NSString stringWithFormat:@"%ld", (long) [datenow timeIntervalSince1970]];
    [WYPost saveDraftToDBContent:contentStr time:dateString];
}

+ (void)addPostFromDict:(NSDictionary *)dict WithBlock:(void (^)(WYPost *post))block {
    NSMutableDictionary *postDict = [NSMutableDictionary dictionaryWithDictionary:dict];

    if ([[dict objectForKey:@"type"] isEqual:@1]) {

        NSArray *photoItemsArray = [dict objectForKey:@"photos"];

        if (photoItemsArray && photoItemsArray.count > 0) {
            photoItemsArray = [WYPostApi updatePhotoItemsArrayBeforeUpload:photoItemsArray];
            [[WYUtility sharedAppDelegate] setNetworkActivityIndicatorVisible:YES];

            [WYQiniuApi getQiniuUpTokenWithBlock:^(NSString *token) {

                if (token) {
                    [self uploadMultiplePhotoAssets:photoItemsArray Token:token WithBlock:^(NSArray *photoItemsArrayChanged) {

                        NSArray *photoItemsToBePosted = [WYPostApi updatePhotoItemsArrayAfterUpload:photoItemsArrayChanged];
                        if (photoItemsToBePosted.count > 0) {
                            [postDict setObject:photoItemsToBePosted forKey:@"photos"];

                            [WYPostApi _addPostByDict:postDict WithBlock:^(WYPost *post) {
                                //block 一定要调 可能是post 可能是nil 可能有
                                if (block)
                                    block(post);
                                if (!post) {
                                    [self saveDraft:dict];
                                }
                            }];
                        } else {
                            [[WYUtility sharedAppDelegate] setNetworkActivityIndicatorVisible:NO];
                        }

                    }];
                } else {
                    [[WYUtility sharedAppDelegate] setNetworkActivityIndicatorVisible:NO];
                }

            }];
        } else {
            [WYPostApi _addPostByDict:postDict WithBlock:^(WYPost *post) {
                if (block)
                    block(post);
                if (!post) {
                    [self saveDraft:dict];
                }
            }];
        }
    } else if ([[dict objectForKey:@"type"] isEqual:@2]) {
        //single photo and text
        PHAsset *asset = [[dict objectForKey:@"photos"] firstObject];
        [[WYUtility sharedAppDelegate] setNetworkActivityIndicatorVisible:YES];

        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];

        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *_Nullable imageData, NSString *_Nullable dataUTI, UIImageOrientation orientation, NSDictionary *_Nullable info) {

            UIImage *image = [UIImage imageWithData:imageData];
            [WYQiniuApi uploadUIImage:image ForKey:nil WithBlock:^(NSString *key) {
                if (!key) {
                    [[WYUtility sharedAppDelegate] setNetworkActivityIndicatorVisible:NO];
                    [OMGToast showWithText:@"照片上传未成功，分享未成功，请稍后再试"];
                    return;
                }

                NSMutableDictionary *bDict = [NSMutableDictionary dictionaryWithDictionary:@{@"qiniu_key": key,
                        @"description": [postDict objectForKey:@"content"],
                        @"order": @1,
                        @"width": @(asset.pixelWidth),
                        @"height": @(asset.pixelHeight),
                        @"is_main_pic": @(true),
                }];

                [postDict setObject:@[[bDict copy]] forKey:@"photos"];
                [WYPostApi _addPostByDict:postDict WithBlock:^(WYPost *post) {
                    [[WYUtility sharedAppDelegate] setNetworkActivityIndicatorVisible:NO];
                    if (block)
                        block(post);
                }];
            }];

        }];
    } else if ([[dict objectForKey:@"type"] isEqual:@3]) {

        //album photo
        NSArray *photoItemsArray = [dict objectForKey:@"photos"];
        photoItemsArray = [WYPostApi updatePhotoItemsArrayBeforeUpload:photoItemsArray];

        [[WYUtility sharedAppDelegate] setNetworkActivityIndicatorVisible:YES];

        [WYQiniuApi getQiniuUpTokenWithBlock:^(NSString *token) {

            if (token) {
                [self uploadMultiplePhotoAssets:photoItemsArray Token:token WithBlock:^(NSArray *photoItemsArrayChanged) {

                    NSArray *photoItemsToBePosted = [WYPostApi updatePhotoItemsArrayAfterUpload:photoItemsArrayChanged];
                    if (photoItemsToBePosted.count > 0) {
                        [postDict setObject:photoItemsToBePosted forKey:@"photos"];

                        [WYPostApi _addPostByDict:postDict WithBlock:^(WYPost *post) {
                            [[WYUtility sharedAppDelegate] setNetworkActivityIndicatorVisible:NO];
                            if (block)
                                block(post);
                        }];
                    } else {
                        [[WYUtility sharedAppDelegate] setNetworkActivityIndicatorVisible:NO];
                    }

                }];
            } else {
                [[WYUtility sharedAppDelegate] setNetworkActivityIndicatorVisible:NO];
            }

        }];
    } else if ([[dict objectForKey:@"type"] isEqual:@4]) {
        //        dict = @{
        //                 @"link": @{},
        //                 @"type": @4,
        //                 @"content": NSString
        //                 };
        [[WYUtility sharedAppDelegate] setNetworkActivityIndicatorVisible:YES];
        [WYPostApi _addPostByDict:dict WithBlock:^(WYPost *post) {
            [[WYUtility sharedAppDelegate] setNetworkActivityIndicatorVisible:NO];
            if (block)
                block(post);
        }];
    } else if ([[dict objectForKey:@"type"] isEqual:@5]) {
        //        dict = @{
        //                 @"video": PHAsset,
        //                 @"type": @5,
        //                 @"content": NSString
        //                 };

        //single video and text
        PHAsset *asset = [dict objectForKey:@"video"];
        [[WYUtility sharedAppDelegate] setNetworkActivityIndicatorVisible:NO];
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];

        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *_Nullable imageData, NSString *_Nullable dataUTI, UIImageOrientation orientation, NSDictionary *_Nullable info) {
            UIImage *image = [UIImage imageWithData:imageData];
            [[WYUtility sharedAppDelegate] setNetworkActivityIndicatorVisible:YES];
            [WYQiniuApi uploadUIImage:image ForKey:nil WithBlock:^(NSString *key) {
                if (!key) {
                    [[WYUtility sharedAppDelegate] setNetworkActivityIndicatorVisible:NO];
                    [OMGToast showWithText:@"视频上传未成功，分享未成功，请稍后再试"];
                    return;
                }

                int duration = (int) asset.duration;
                NSMutableDictionary *bDict = [NSMutableDictionary dictionaryWithDictionary:@{@"qiniu_key": key,
                        @"description": [postDict objectForKey:@"content"],
                        @"duration": @(duration),
                        @"width": @(asset.pixelWidth),
                        @"height": @(asset.pixelHeight),
                }];
                [postDict setObject:@[[bDict copy]] forKey:@"video"];
                [WYPostApi _addPostByDict:postDict WithBlock:^(WYPost *post) {
                    [[WYUtility sharedAppDelegate] setNetworkActivityIndicatorVisible:NO];
                    if (block)
                        block(post);
                }];
            }];

        }];
    }
}

+ (NSArray *)updatePhotoItemsArrayAfterUpload:(NSArray *)photoItemsArray {
    NSMutableArray *photosItemArrayToBePosted = [NSMutableArray array];
    NSMutableArray *failedMa = [NSMutableArray array];

    for (NSMutableDictionary *item in photoItemsArray) {
        if ([[item objectForKey:@"finished"] boolValue]) {
            [item removeObjectForKey:@"finished"];
            [item removeObjectForKey:@"asset"];
            [photosItemArrayToBePosted addObject:item];
        } else {
            NSLog(@"failed %@", [item objectForKey:@"qiniu_key"]);
            [failedMa addObject:item];
        }
    }

    //todo, do something
//    NSLog(@"failed photos count %ld", failedMa.count);

    return [photosItemArrayToBePosted copy];
}

+ (NSArray *)updatePhotoItemsArrayBeforeUpload:(NSArray *)photoItemsArray {
    for (int i = 0; i < photoItemsArray.count; i++) {
        NSMutableDictionary *photoItem = [photoItemsArray objectAtIndex:i];

        PHAsset *as = [photoItem objectForKey:@"asset"];

        NSString *uuid = [[NSUUID UUID] UUIDString];
        uuid = [uuid lowercaseString];
        NSString *key = [@"p-" stringByAppendingString:uuid];

        [photoItem removeObjectForKey:@"image"];

        [photoItem setObject:key forKey:@"qiniu_key"];
        [photoItem setObject:@(i + 1) forKey:@"order"];
        [photoItem setObject:@(as.pixelWidth) forKey:@"width"];
        [photoItem setObject:@(as.pixelHeight) forKey:@"height"];
    }

    return photoItemsArray;

}


+ (void)uploadMultiplePhotoAssets:(NSArray *)assets Token:(NSString *)token WithBlock:(void (^)(NSArray *array))block {

    dispatch_group_t group = dispatch_group_create();

    for (int i = 0; i < assets.count; i++) {
        dispatch_group_enter(group);
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            __block NSMutableDictionary *md = [assets objectAtIndex:i];

            PHAsset *asset = [md objectForKey:@"asset"];
            NSString *key = [md objectForKey:@"qiniu_key"];


            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];

            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *_Nullable imageData, NSString *_Nullable dataUTI, UIImageOrientation orientation, NSDictionary *_Nullable info) {

                UIImage *image = [UIImage imageWithData:imageData];
                [WYQiniuApi uploadUIImage:image ForKey:key WithBlock:^(NSString *key) {

                    dispatch_async(dispatch_get_main_queue(), ^(void) {

                        if (key) {
                            [md setObject:@(true) forKey:@"finished"];
                        } else {
                            [md setObject:@(false) forKey:@"finished"];
                        }
                    });

                    dispatch_group_leave(group);

                }];


            }];
        });
    }

    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

        dispatch_async(dispatch_get_main_queue(), ^{

            if (block)
                block(assets);

        });

    });
}

+ (void)_addPostByDict:(NSDictionary *)dict WithBlock:(void (^)(WYPost *post))block {

    [[WYHttpClient sharedClient] POST:@"api/v1/post/" parameters:dict progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

        WYPost *post = [WYPost yy_modelWithDictionary:responseObject];
        if (block) {
            block(post);
        }

    }                         failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (block)
            block(nil);
        NSHTTPURLResponse *r = (NSHTTPURLResponse *) task.response;
        debugLog(@"%lu", r.statusCode);

        [OMGToast showWithText:@"分享发布未成功, 请稍后再试"];
    }];
}

+ (void)deletePost:(NSString *)postUuid WithBlock:(void (^)(NSDictionary *dict))block {
    NSString *s = [NSString stringWithFormat:@"api/v1/post/%@/", postUuid];
    [[WYHttpClient sharedClient] DELETE:s parameters:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

        if (block)
            block(@{});

    }                           failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) task.response;
        NSLog(@"cmd %@, status code: %li", NSStringFromSelector(_cmd), (long) httpResponse.statusCode);
        NSLog(@"error is %@", error);

        if (block)
            block(nil);
        [OMGToast showWithText:@"删除未成功，请稍后再试"];
    }];

}

+ (void)addStarToPost:(NSString *)postUuid WithBlock:(void (^)(NSDictionary *response))block {
    [[WYHttpClient sharedClient] POST:@"api/v1/star/" parameters:@{@"post_uuid": postUuid} progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

        if (block)
            block(responseObject);

    }                         failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) task.response;
        NSLog(@"cmd %@, resp %@, status code: %li", NSStringFromSelector(_cmd), httpResponse, (long) httpResponse.statusCode);
        NSLog(@"cmd %@, error is %@, ", NSStringFromSelector(_cmd), error);

        if (block)
            block(nil);
        [OMGToast showWithText:@"星标未成功，请稍后再试"];
    }];

}

+ (void)removeStarToPost:(NSString *)postUuid WithBlock:(void (^)(NSDictionary *response))block {
    NSString *s = [NSString stringWithFormat:@"api/v1/star/%@/", postUuid];

    [[WYHttpClient sharedClient] DELETE:s parameters:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

        /**
         如果后端返回空值，responseObject也可能为空 null
         */


        if (block)
            block(@{});

    }                           failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) task.response;
        NSLog(@"status code: %li", (long) httpResponse.statusCode);
        NSLog(@"error is %@", error);

        if (block)
            block(nil);
        [OMGToast showWithText:@"取消星标未成功，请稍后再试"];
    }];

}


+ (void)newRemoveStarToPost:(NSString *)postUuid WithBlock:(void (^)(WYPost *post))block {
    NSString *s = [NSString stringWithFormat:@"api/v1/star/%@/ios_remove_star/", postUuid];
    [[WYHttpClient sharedClient] POST:s parameters:nil showToastError:YES callback:^(id responseObject) {
        if (responseObject) {
            WYPost *post = [WYPost yy_modelWithDictionary:responseObject];
            if (block) {
                block(post);
            };
        } else {
            if (block) {
                block(nil);
            };
        }
    }];
}

+ (void)reportPost:(NSString *)postUuid Reason:(int)num {
    [[WYHttpClient sharedClient] POST:@"api/v1/report_post/" parameters:@{@"post_uuid": postUuid, @"type": [NSNumber numberWithInt:num]} progress:nil
                              success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

                                  [WYUtility showAlertWithTitle:@"举报成功，感谢您对社区的贡献！"];

                              } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                [WYUtility showAlertWithTitle:@"举报未成功，可能因为网络原因，请稍后再试。"];
            }];
}

//通过target_uid从网络中获取对应的Post
+ (void)retrievePost:(NSString *)uuid Block:(void (^)(WYPost *post, NSInteger status))block; {
    NSString *s = [NSString stringWithFormat:@"api/v1/post/%@/", uuid];

    [[WYHttpClient sharedClient] GET:s parameters:nil progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) task.response;
        WYPost *post = [WYPost yy_modelWithDictionary:responseObject];
        if (block) {
            block(post, httpResponse.statusCode);
        }
    }                        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) task.response;
        if (block) {
            block(nil, httpResponse.statusCode);
        }
    }];
}

//创建订阅
+ (void)addSubscribeForPost:(NSString *)postUuid Block:(void (^)(WYPost *post))block {
    NSString *s = @"api/v1/subscribe_post/";
    NSDictionary *dic = @{
            @"post_uuid": postUuid
    };
    [[WYHttpClient sharedClient] POST:s parameters:dic progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        WYPost *post = [WYPost YYModelParse:responseObject];
        if (block) {
            block(post);
        }
    }                         failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (block) {
            block(nil);
        }
    }];
}

//取消订阅
+ (void)cancelSubscribeForPost:(NSString *)postUuid Block:(void (^)(NSInteger status))block {

    NSString *s = [NSString stringWithFormat:@"api/v1/subscribe_post/%@/", postUuid];

    [[WYHttpClient sharedClient] DELETE:s parameters:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) task.response;
        debugLog(@"%lu取消订阅成功", httpResponse.statusCode);
        if (block) {
            block(httpResponse.statusCode);
        }
    }                           failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) task.response;
        debugLog(@"%lu取消订阅失败", httpResponse.statusCode);
        if (block) {
            block(httpResponse.statusCode);
        }
    }];
}

//给评论加星标
+ (void)addStarToCommentUUid:(NSString *)comment_uuid author_uuid:(NSString *)author_uuid Block:(void (^)(NSInteger status))block {
    NSString *s = @"api/v1/star_to_comment/";
    NSDictionary *dic = @{
            @"comment_uuid": comment_uuid,
            @"author_uuid": author_uuid
    };
    [[WYHttpClient sharedClient] POST:s parameters:dic progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) task.response;
        debugLog(@"添加%lu", httpResponse.statusCode);
        if (block) {
            block(httpResponse.statusCode);
        }
    }                         failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) task.response;
        debugLog(@"添加%lu", httpResponse.statusCode);

        if (block) {
            block(httpResponse.statusCode);
        }
    }];
}

//取消评论星标
+ (void)cancelStarToCommentUUid:(NSString *)comment_uuid Block:(void (^)(NSInteger status))block {
    NSString *s = [NSString stringWithFormat:@"api/v1/star_to_comment/%@/", comment_uuid];
    debugLog(@"取消%@", s);
    [[WYHttpClient sharedClient] DELETE:s parameters:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) task.response;
        debugLog(@"取消%lu", httpResponse.statusCode);

        if (block) {
            block(httpResponse.statusCode);
        }
    }                           failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) task.response;
        debugLog(@"取消%lu", httpResponse.statusCode);

        if (block) {
            block(httpResponse.statusCode);
        }
    }];
}

@end
