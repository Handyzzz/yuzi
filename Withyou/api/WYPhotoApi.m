//
//  WYPhotoApi.m
//  Withyou
//
//  Created by Tong Lu on 2016/10/25.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import "WYPhotoApi.h"
#import "WYAccountApi.h"
#import "WYDBManager.h"


@implementation WYPhotoApi

//+ (void)addSelfPhotoFrom:(NSDictionary *)dict WithBlock:(void (^)(WYPhoto *photo))block {
//    
//    [[WYHttpClient sharedClient] POST:@"api/v1/self_photo/" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
//    
//}
#pragma mark - SELF PHOTO
+ (void)bulkCreateSelfPhotosFrom:(NSArray *)dictArray WithBlock:(void (^)(NSDictionary *dict))block {
    
    [[WYHttpClient sharedClient] POST:@"api/v1/self_photo_bulk_create/" parameters:@{@"photos": dictArray} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(block){
            block(@{@"a": @"a"});
        }
        
        debugMethod();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        debugLog(@"failed");
        if(block)
            block(nil);
    }];
    
}
+ (void)deleteSelfPhotoFrom:(NSString *)uuid WithBlock:(void (^)(NSDictionary *response))block
{
    NSString *s = [NSString stringWithFormat:@"api/v1/self_photo/%@/", uuid];
    [[WYHttpClient sharedClient] DELETE:s parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [WYPhoto deletePhotoFromLocalDB:uuid];
        if(block)
            block(@{});
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [OMGToast showWithText:@"服务器开小差，图片未能及时删除"];
        if(block)
            block(nil);
    }];
}
//+ (void)listSelfPhotosFrom:(NSDictionary *)dict WithBlock:(void (^)(NSArray *photoArray))block {
//    
//    [[WYHttpClient sharedClient] GET:@"api/v1/self_photo/" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
////        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
////        NSLog(@"cmd %@, status code: %li", NSStringFromSelector(_cmd), (long)httpResponse.statusCode);
//        
//        NSArray *res = [responseObject valueForKeyPath:@"results"];
//        NSLog(@"res is %@", res);
//        
//        NSMutableArray *mutableRes = [NSMutableArray arrayWithCapacity:[res count]];
//        NSError *aError = nil;
//        mutableRes = [WYPhoto arrayOfModelsFromDictionaries:res error:&aError];
//        
//        if(mutableRes.count > 0)
//        {
//            [WYPhoto savePhotosToLocalDB:[mutableRes copy] Block:^(BOOL result){}];
//        }
//        
//        if(block)
//            block([mutableRes copy]);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (block)
//            block(nil);
//        
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
//        NSLog(@"cmd %@, status code: %li", NSStringFromSelector(_cmd), (long)httpResponse.statusCode);
//    }];
//}
+ (void)listSelfPhotosTopWithBlock:(void (^)(NSArray *photoArray, NSArray *deletedUuids))block
{
    NSString *selfUuid = [WYUIDTool sharedWYUIDTool].uid.uuid;
    NSNumber *topAddNum = [WYPhotoApi getTopAddNumberFromUuid:selfUuid];
    NSNumber *topDelNum = [WYPhotoApi getTopDelNumberFromUuid:selfUuid];

    [[WYHttpClient sharedClient] GET:@"api/v1/self_photo/top/"
                          parameters:@{@"top_add": topAddNum, @"top_del": topDelNum}
                            progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 
//                                 NSString * st = [NSString stringWithFormat:@"cmd %@, res %@", NSStringFromSelector(_cmd), responseObject];
//                                 printf("%s\n", [st UTF8String]);
                                 
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
                                     
        NSArray *add = [responseObject valueForKeyPath:@"add_list"];
        NSArray *del = [responseObject valueForKeyPath:@"del_list"];
        NSNumber *newTopAdd = [responseObject valueForKey:@"new_top_add"];
        NSNumber *newTopDel = [responseObject valueForKey:@"new_top_del"];
        
#warning  这里之前没返回对象数组吗?
        NSArray *mutableAdd = [NSArray yy_modelArrayWithClass:[WYPhoto class] json:add];
        
        if(mutableAdd.count > 0)
        {
            [WYPhoto savePhotosToLocalDB:[mutableAdd copy] Block:^(BOOL result) {
                if(result)
                    [WYPhotoApi saveTopAddNumber:newTopAdd ForUuid:selfUuid];
            }];
        }
        
        if(del.count > 0)
        {
            [WYPhoto deletePhotosFromUuidList:del Block:^(BOOL result) {
               if(result)
                   [WYPhotoApi saveTopDelNumber:newTopDel ForUuid:selfUuid];
            }];
        }
        
        if(block)
            block([add copy], [del copy]);
    });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block)
            block(nil, nil);
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        NSLog(@"cmd %@, status code: %li", NSStringFromSelector(_cmd), (long)httpResponse.statusCode);
    }];
    
}
+ (void)listSelfPhotosBottomWithBlock:(void (^)(NSArray *photoArray))block
{
    NSNumber *bottom = [WYPhotoApi getBottomNumberForSelf];
    
    if([bottom isEqual:@0])
    {
        //前端数据缓存中，没有任何的数据，这样的请求就是没有意义的
        return;
    }
    
    [[WYHttpClient sharedClient] GET:@"api/v1/self_photo/bottom/" parameters:@{@"bottom": bottom} progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 
                                 NSString * st = [NSString stringWithFormat:@"cmd %@, res %@", NSStringFromSelector(_cmd), responseObject];
                                 printf("%s\n", [st UTF8String]);
                                 
                                 NSArray *results = [responseObject valueForKeyPath:@"results"];
                                 
                                 
                                 NSArray *models = [NSArray yy_modelArrayWithClass:[WYPhoto class] json:results];
                                
                                 if(models.count > 0)
                                     [WYPhoto savePhotosToLocalDB:[models copy] Block:NULL];
                                 
                                 if(block)
                                     block(models);
                                 
                             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 if (block)
                                     block(nil);
                                 
                                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                 NSLog(@"cmd %@, status code: %li", NSStringFromSelector(_cmd), (long)httpResponse.statusCode);
                             }];
}
+ (void)requestSelfPhotoFullResolutionUrl:(NSString *)uuid WithBlock:(void (^)(NSString *url))block
{
    [[WYHttpClient sharedClient] GET:[NSString stringWithFormat:@"api/v1/self_photo/%@/full_url/", uuid]
                          parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                              NSLog(@"cmd %@, status code: %li", NSStringFromSelector(_cmd), (long)httpResponse.statusCode);
                              
                              NSString *res = [responseObject valueForKeyPath:@"url"];
                              
                              if(block)
                                  block(res);
                              
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              if (block)
                                  block(nil);
                              
                              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                              NSLog(@"cmd %@, status code: %li", NSStringFromSelector(_cmd), (long)httpResponse.statusCode);
                          }];
    
}
#pragma mark - TOP ADD DEL BOTTOM

+ (NSNumber *)getTopAddNumberFromUuid:(NSString *)uuid
{
    //使用一个独立的topAdd而不是去查询缓存数据库的原因是因为，自己本地是可以自己发布的，自己发布的时间可以很新，之前如果没有拉取完所有的更新数据的话，中间就出现了断档，所以此时要以后端数据为准
    __block NSNumber *num = @0;
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *query = [NSString stringWithFormat:@"select top_add from 'photo_sync_record' where uuid = ? "];
        FMResultSet * rs = [db executeQuery:query, uuid];
        while ([rs next]) {
            num = [NSNumber numberWithDouble:[rs doubleForColumnIndex:0]];
        }
        
    }];
    
    return num;

}
+ (NSNumber *)getTopDelNumberFromUuid:(NSString *)uuid
{
    //其他用户最近删除了哪些内容，以及什么时候删除的，这些都一无所知，所以需要与后端保持一致，在前端建立好这个备份
    __block NSNumber *num = @0;
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *query = [NSString stringWithFormat:@"select top_del from 'photo_sync_record' where uuid = ? "];
        FMResultSet * rs = [db executeQuery:query, uuid];
        while ([rs next]) {
            num = [NSNumber numberWithDouble:[rs doubleForColumnIndex:0]];
        }
        
    }];
    
    return num;
}
+ (NSNumber *)getBottomNumberForSelf
{
    //这是后端给出的一个数字，但是这个数字本质上应该与前端的数据库中的所有的照片的createdAtFloat的最小值一致
//    这里没有做这个检查，略有问题
//    尤其如果首次是0的话，那么从后端反馈来看，这个bottom数字永远是0，因为没有比0更小的，所以它得不到更新
//    所以最好的途径还是过一遍数据库，找到最小的
    
//    主要的使用场景是，用户觉得太多照片太占地方了，需要清理一些空间，先从本地上删除一年前的照片，之后可以继续从云端获取
//    用户删除时，这个bottom就应该更新，但是其实可以从前端缓存数据库直接读取，找到最小的就是了
    
//    要考虑有没有可能是跳着删除的，比如新老数据是不连续的，中间有空档？似乎没有这样的可能
    
    __block NSNumber *num = @0;
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *query = [NSString stringWithFormat:@"select createdAtFloat, group_uuid from 'photo' where (group_uuid is NULL OR group_uuid = '') AND uploader = ? order by createdAtFloat asc limit 1"];
        FMResultSet * rs = [db executeQuery:query, kuserUUID];
        while ([rs next]) {
            num = [NSNumber numberWithDouble:[rs doubleForColumnIndex:0]];
            NSLog(@"group uuid is %@", [rs stringForColumnIndex:1]);
        }
        
    }];
    
    return num;
}
+ (NSNumber *)getBottomNumberFromUuid:(NSString *)uuid
{
    __block NSNumber *num = @0;
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *query = [NSString stringWithFormat:@"select createdAtFloat from 'photo' where group_uuid = ? order by createdAtFloat asc limit 1"];
        FMResultSet * rs = [db executeQuery:query, uuid];
        while ([rs next]) {
            num = [NSNumber numberWithDouble:[rs doubleForColumnIndex:0]];
        }
        
    }];
    
    return num;
}
+ (void)saveTopAddNumber:(NSNumber *)num ForUuid:(NSString *)uuid
{
    __block NSNumber *top_add = @0.0;
    __block NSNumber *top_del = @0.0;
    __block NSNumber *bottom = @0.0;

     [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
         FMResultSet * rs = [db executeQueryWithFormat:@"select top_add, top_del, bottom from photo_sync_record where uuid = %@", uuid];
         while ([rs next]) {
             top_add = [NSNumber numberWithDouble:[rs doubleForColumnIndex:0]];
             top_del = [NSNumber numberWithDouble:[rs doubleForColumnIndex:1]];
             bottom = [NSNumber numberWithDouble:[rs doubleForColumnIndex:2]];
         }
     }];
    
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSString * sql_photo = @"insert or replace into 'photo_sync_record' (uuid, top_add, top_del, bottom) values (?, ?, ?, ?) ";
        BOOL res;
        int errorCount = 0;
        
//        printf("%s\n", [@"cc" UTF8String]);
        
        res = [db executeUpdate:sql_photo, uuid, num, top_del, bottom];
        
        if (!res) {
            debugLog(@"error to insert top num");
            errorCount++;
            *rollback = YES;
            return;
        }
    }];
}
+ (void)saveTopDelNumber:(NSNumber *)num ForUuid:(NSString *)uuid
{
    __block NSNumber *top_add = @0.0;
    __block NSNumber *top_del = @0.0;
    __block NSNumber *bottom = @0.0;
    
    [[[WYDBManager getSharedInstance] sharedQueue] inDatabase:^(FMDatabase *db) {
        
//        printf("%s\n", [@"aa" UTF8String]);
        
        FMResultSet * rs = [db executeQueryWithFormat:@"select top_add, top_del, bottom from photo_sync_record where uuid = %@", uuid];
        while ([rs next]) {
            top_add = [NSNumber numberWithDouble:[rs doubleForColumnIndex:0]];
            top_del = [NSNumber numberWithDouble:[rs doubleForColumnIndex:1]];
            bottom = [NSNumber numberWithDouble:[rs doubleForColumnIndex:2]];
        }
    }];
    
    [[[WYDBManager getSharedInstance] sharedQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * sql_photo = @"insert or replace into 'photo_sync_record' (uuid, top_add, top_del, bottom) values (?, ?, ?, ?) ";
        BOOL res;
        int errorCount = 0;
        
        res = [db executeUpdate:sql_photo, uuid, top_add, num, bottom];
        
        if (!res) {
            debugLog(@"error to insert data");
            errorCount++;
        }
        
        if (errorCount != 0) {
            *rollback = YES;
            return;
        }
    }];
}
#pragma mark - GROUP PHOTO
+ (void)bulkCreateGroupPhotosToGroup:(NSString *)groupUuid From:(NSArray *)dictArray WithBlock:(void (^)(NSDictionary *dict))block {
    
    NSString *s = [NSString stringWithFormat:@"api/v1/group_photo_bulk_create/%@/", groupUuid];
    [[WYHttpClient sharedClient] POST:s parameters:@{@"photos": dictArray} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(block){
            block(@{});
        }
        
        debugMethod();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        debugLog(@"failed");
        if(block)
            block(nil);
    }];
    
}
+ (void)deleteGroupPhotoFrom:(NSString *)uuid WithBlock:(void (^)(NSDictionary *response))block {
    NSString *s = [NSString stringWithFormat:@"api/v1/group_photo/%@/", uuid];
    [[WYHttpClient sharedClient] DELETE:s parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [WYPhoto deletePhotoFromLocalDB:uuid];
        if(block)
            block(@{});
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [OMGToast showWithText:@"服务器开小差，图片未能及时删除"];
        if(block)
            block(nil);
    }];
    
    
}
+ (void)listGroup:(NSString *)groupUuid PhotosTopWithBlock:(void (^)(NSArray *photoArray))block {
    NSNumber *topAddNum = [WYPhotoApi getTopAddNumberFromUuid:groupUuid];
    NSNumber *topDelNum = [WYPhotoApi getTopDelNumberFromUuid:groupUuid];
    [[WYHttpClient sharedClient] GET:@"api/v1/group_photo/top/"
                          parameters:@{@"top_add": topAddNum, @"top_del": topDelNum, @"group": groupUuid}
                            progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 
//                                 NSString * st = [NSString stringWithFormat:@"cmd %@, res %@", NSStringFromSelector(_cmd), responseObject];
//                                 printf("%s\n", [st UTF8String]);
                                 
                                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
                                     
                                     NSArray *add = [responseObject valueForKeyPath:@"add_list"];
                                     NSArray *del = [responseObject valueForKeyPath:@"del_list"];
                                     NSNumber *newTopAdd = [responseObject valueForKey:@"new_top_add"];
                                     NSNumber *newTopDel = [responseObject valueForKey:@"new_top_del"];
                                     
                                     NSArray *models = [NSArray yy_modelArrayWithClass:[WYPhoto class] json:add];
                                     
                                     if(models.count > 0)
                                     {
                                         [WYPhoto savePhotosToLocalDB:[models copy] Block:^(BOOL result) {
                                             if(result)
                                                 [WYPhotoApi saveTopAddNumber:newTopAdd ForUuid:groupUuid];
                                         }];
                                     }
                                     
                                     if(del.count > 0)
                                     {
                                         [WYPhoto deletePhotosFromUuidList:del Block:^(BOOL result) {
                                             if(result)
                                                 [WYPhotoApi saveTopDelNumber:newTopDel ForUuid:groupUuid];
                                         }];
                                     }
                                     
                                     if(block)
                                         block([add copy]);
                                 });
                                 
                             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 if (block)
                                     block(nil);
                                 
                                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                 NSLog(@"cmd %@, status code: %li", NSStringFromSelector(_cmd), (long)httpResponse.statusCode);
                             }];
}
+ (void)listGroup:(NSString *)groupUuid PhotosBottomWithBlock:(void (^)(NSArray *photoArray))block
{
    NSNumber *bottom = [WYPhotoApi getBottomNumberFromUuid:groupUuid];
    
    if([bottom isEqual:@0])
    {
        //前端没有任何的数据，这样的请求就是没有意义的
        return;
    }
    
    [[WYHttpClient sharedClient] GET:@"api/v1/group_photo/bottom/" parameters:@{@"bottom": bottom, @"group": groupUuid} progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 
                                 NSString * st = [NSString stringWithFormat:@"cmd %@, res %@", NSStringFromSelector(_cmd), responseObject];
                                 printf("%s\n", [st UTF8String]);
                                 
                                 NSArray *results = [responseObject valueForKeyPath:@"results"];
                                 
                                 NSArray *models = [NSArray yy_modelArrayWithClass:[WYPhoto class] json:results];
                                 
                                 if(models.count > 0)
                                     [WYPhoto savePhotosToLocalDB:models Block:NULL];
                                 
                                 if(block)
                                     block(models);
                                 
                             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 if (block)
                                     block(nil);
                                 
                                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                 NSLog(@"cmd %@, status code: %li", NSStringFromSelector(_cmd), (long)httpResponse.statusCode);
                             }];
}
+ (void)requestGroupPhotoFullResolutionUrl:(NSString *)uuid WithBlock:(void (^)(NSString *url))block
    {
        [[WYHttpClient sharedClient] GET:[NSString stringWithFormat:@"api/v1/group_photo/%@/full_url/", uuid]
                              parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                  NSLog(@"cmd %@, status code: %li", NSStringFromSelector(_cmd), (long)httpResponse.statusCode);
                                  
                                  NSString *res = [responseObject valueForKeyPath:@"url"];
                                  
                                  if(block)
                                      block(res);
                                  
                              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                  if (block)
                                      block(nil);
                                  
                                  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                  NSLog(@"cmd %@, status code: %li", NSStringFromSelector(_cmd), (long)httpResponse.statusCode);
                              }];
        
    }

@end
