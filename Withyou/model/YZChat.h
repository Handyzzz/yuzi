//
//  YZChat.h
//  Withyou
//
//  Created by ping on 2017/3/29.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZChat : NSObject 

+ (NSArray *)getArchiverData;

// 更新聊天列表顺序
+ (void)updateChatList:(NSArray *)chatList;

// 切换登录时，要删除的文件
+ (void)deleteChatList;

@end
