//
//  YZMessageApi.m
//  Withyou
//
//  Created by ping on 2016/12/25.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import "YZMessageApi.h"
#import "WYHttpClient.h"

@implementation YZMessageApi


+ (void)requestMessageListWith:(void (^)(NSArray<YZMessage *> *))handler {
    
    [[WYHttpClient sharedClient] GET:@"api/v1/notif/" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray * results = responseObject[@"results"];
        if(handler && results){
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary * dic in results) {
                YZMessage *msg = [YZMessage yy_modelWithDictionary:dic];
                [list addObject:msg];
            }
            
            handler(list);
            
            // 最后才保存到数据库
            [YZMessage saveToDataBase:list withCallback:nil];
        }else {
            if(handler) {
                handler(nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        NSLog(@"cmd %@, status code: %li", NSStringFromSelector(_cmd), (long)httpResponse.statusCode);
        NSLog(@"cmd %@, error is %@, ", NSStringFromSelector(_cmd), error);
        if(handler) {
            handler(nil);
        }
    }];
}

+ (void)loadMoreMessages:(YZMessage *)msg Handler:(void (^)(NSArray<YZMessage *> *))handler {
    // 查询缓存
    [YZMessage queryDBCacheWith:msg Results:^(NSArray<YZMessage *> *result) {
        if(result) {
            handler(result);
        }else {
            // 从服务器获取
            NSString * url = [NSString stringWithFormat:@"api/v1/notif/bottom/?bottom=%@",msg.created_at_float];
            [[WYHttpClient sharedClient] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSArray * results = responseObject[@"results"];
                if(handler && results && results.count > 0){
                    NSMutableArray *list = [NSMutableArray array];
                    for (NSDictionary * dic in results) {
                        [list addObject:[YZMessage yy_modelWithDictionary:dic]];
                    }
                    [YZMessage saveToDataBase:list withCallback:nil];
                    if(handler) {
                        handler(list);
                    }
                }else {
                    if(handler) {
                        handler(nil);
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                NSLog(@"cmd %@, status code: %li", NSStringFromSelector(_cmd), (long)httpResponse.statusCode);
                NSLog(@"cmd %@, error is %@, ", NSStringFromSelector(_cmd), error);
                if(handler) {
                    handler(nil);
                }
            }];
        }
    }];
}

+ (void)removeMessage:(NSString *)uuid Handler:(void (^)(BOOL))handler {
    NSString *url = [NSString stringWithFormat:@"api/v1/notif/%@/",uuid];
    
    [[WYHttpClient sharedClient] DELETE:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [YZMessage deleteWith:uuid];
        if(handler) {
            handler(YES);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [OMGToast showWithText:@"删除失败"];
        if(handler) {
            handler(NO);
        }
    }];
}

+(void)listMsgList:(int)type oldTime:(NSNumber *)oldTime Block:(void(^)(NSArray *msgArr))block{
    NSString *s = @"api/v1/notif/cat_list/";
    NSDictionary *dic = @{
                          @"type":@(type),
                          @"t":oldTime
                          };
    [[WYHttpClient sharedClient] GET:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *msgList = [YZMessage YYModelParse:[responseObject objectForKey:@"results"]];
        
        if (block) {
            block(msgList);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse*res = (NSHTTPURLResponse*)(task.response);
        debugLog(@"%lu",res.statusCode);
        if (block) {
            block(nil);
        }
    }];
}

//更新时间戳
+(void)updateLastTime:(NSNumber*)time{
    NSString *s = @"api/v1/notif/cat_new_time/";
    NSDictionary *dic = @{@"t":time};
    
    [[WYHttpClient sharedClient]POST:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        debugLog(@"%@\n,%@",httpResponse.description,httpResponse.debugDescription);
        debugLog(@"Msg fail updateLastTime");
    }];
}

@end
