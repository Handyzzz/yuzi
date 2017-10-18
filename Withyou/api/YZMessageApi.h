//
//  YZMessageApi.h
//  Withyou
//
//  Created by ping on 2016/12/25.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZMessage.h"

@interface YZMessageApi : NSObject

+ (void)requestMessageListWith:(void(^)(NSArray<YZMessage *> *list))handler;

+ (void)loadMoreMessages:(YZMessage *)msg Handler:(void(^)(NSArray<YZMessage *> *list))handler;

+ (void)removeMessage:(NSString *)uuid Handler:(void(^)(BOOL result))handler;

+(void)listMsgList:(int)type oldTime:(NSNumber *)oldTime Block:(void(^)(NSArray *msgArr))block;

//更新时间戳
+(void)updateLastTime:(NSNumber*)time;

@end
