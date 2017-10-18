//
//  YZChat.m
//  Withyou
//
//  Created by ping on 2017/3/29.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZChat.h"

@implementation YZChat


+ (NSString *)getArchiverPath {
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
   return [Path stringByAppendingPathComponent:@"chat_list"];
}

+ (NSArray *)getArchiverData {
    id data = [NSKeyedUnarchiver unarchiveObjectWithFile:[YZChat getArchiverPath]];
    if([data isKindOfClass:[NSArray class]]) {
        return (NSArray *)data;
    }else {
        return @[];
    }
}

+ (void)updateChatList:(NSArray *)chatList {
    
    [NSKeyedArchiver archiveRootObject:chatList toFile:[YZChat getArchiverPath]];
}
+ (void)deleteChatList{
    
    NSFileManager *defaultManager;
    defaultManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL removed = [defaultManager removeItemAtPath:[YZChat getArchiverPath] error:&error];
    debugLog(@"removed chat list %d", removed);
}

@end
