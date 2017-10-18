//
//  WYMediaAPI.h
//  Withyou
//
//  Created by Handyzzz on 2017/9/28.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYMediaTag.h"

@interface WYMediaAPI : NSObject

//tag List
+(void)listMediaTagCallback:(NSInteger)page callback:(void(^)(NSArray *tagList, BOOL hasMore))callback;

//media list in a tag
+(void)listMeidaWithTagNum:(int)tagNum page:(NSInteger)page callback:(void(^)(NSArray *mediaArr, BOOL hasMore))callback;

//add follow to media
+(void)addFollowToMedia:(NSString *)mediaUuid callback:(void(^)(NSInteger status))callback;

//cancel follow to media
+(void)cancelFollowToMedia:(NSString *)mediaUuid callback:(void(^)(NSInteger status))callback;

//media list i have followed
+(void)listMediaFollowed:(NSInteger)page callback:(void(^)(NSArray *mediaFollowArr, BOOL hasMore))callback;
@end
