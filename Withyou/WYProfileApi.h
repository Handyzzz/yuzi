//
//  WYProfileApi.h
//  Withyou
//
//  Created by Handyzzz on 2017/8/9.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYProfileApi : NSObject
//请求个自己的详细资料
+ (void)retrieveSelfProfileBlock:(void (^)(WYProfile *profile))block;

//请求某一个人的详细资料
+ (void)retrieveProfileFromUuid:(NSString *)uuid Block:(void (^)(WYProfile *profile))block;

//修改个人资料
+ (void)patchProfireDic:(NSDictionary *)dic Block:(void(^)(WYProfile *profile))block;

@end
