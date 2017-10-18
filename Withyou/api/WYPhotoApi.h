//
//  WYPhotoApi.h
//  Withyou
//
//  Created by Tong Lu on 2016/10/25.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYHttpClient.h"
#import "WYPhoto.h"

@interface WYPhotoApi : NSObject


+ (void)bulkCreateSelfPhotosFrom:(NSArray *)dictArray WithBlock:(void (^)(NSDictionary *dict))block;
+ (void)deleteSelfPhotoFrom:(NSString *)uuid WithBlock:(void (^)(NSDictionary *response))block;
+ (void)listSelfPhotosTopWithBlock:(void (^)(NSArray *photoArray, NSArray *deletedUuids))block;
+ (void)listSelfPhotosBottomWithBlock:(void (^)(NSArray *photoArray))block;
+ (void)requestSelfPhotoFullResolutionUrl:(NSString *)uuid WithBlock:(void (^)(NSString *url))block;


+ (void)bulkCreateGroupPhotosToGroup:(NSString *)groupUuid From:(NSArray *)dictArray WithBlock:(void (^)(NSDictionary *dict))block;
+ (void)deleteGroupPhotoFrom:(NSString *)uuid WithBlock:(void (^)(NSDictionary *response))block;
+ (void)listGroup:(NSString *)groupUuid PhotosTopWithBlock:(void (^)(NSArray *photoArray))block;
+ (void)listGroup:(NSString *)groupUuid PhotosBottomWithBlock:(void (^)(NSArray *photoArray))block;
+ (void)requestGroupPhotoFullResolutionUrl:(NSString *)uuid WithBlock:(void (^)(NSString *url))block;

@end
