//
//  WYChatApi.h
//  Withyou
//
//  Created by Handyzzz on 2017/8/9.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYChatApi : NSObject
// 通知服务器与某人开始聊天
+ (void)chatWithUser:(WYUser *)user;

// 获得聊天列表
+ (void)getChatList:(void(^)(NSArray *modals))callback;

//请求删除某个人的会话
+ (void)deleteUserChat:(NSString *)uuid Block:(void(^)(BOOL haveDelete))block;
@end
