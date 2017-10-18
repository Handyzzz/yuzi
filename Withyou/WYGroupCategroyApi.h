//
//  WYGroupCategroyApi.h
//  Withyou
//
//  Created by Handyzzz on 2017/8/9.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYGroupCategroyApi : NSObject
//请求所有的群组类型
+(void)listAllGroupCategoryBlock:(void(^)(NSArray*tagsArr,BOOL success))block;

@end
