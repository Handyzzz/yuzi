//
//  WYNickNameApi.h
//  Withyou
//
//  Created by Handyzzz on 2017/8/9.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYNickNameApi : NSObject
//展示我的所有昵称
+(void)getUserAllNickNameBlock:(void(^)(NSArray *nickNameArr))block;


//创建昵称
+(void)postUserNickNameDetail:(NSDictionary *)dic Block:(void(^)(WYNickName *nickName))block;

//修改一条昵称
+(void)patchNickNameDetail:(NSString *)nickNameUuid Dic:(NSDictionary *)dic Block:(void(^)( WYNickName*nickName))block;


//删除一条昵称
+(void)deleteNickNameDetail:(NSString *)nickNameUuid Block:(void(^)(BOOL haveDelete))block;


@end
