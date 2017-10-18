//
//  WYMessageCategory.h
//  Withyou
//
//  Created by Handyzzz on 2017/8/5.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYMessageCategory : NSObject<NSCoding>

@property(nonatomic, strong) NSString * name;
@property(nonatomic, strong) NSString * icon_url;
@property(nonatomic, strong) NSNumber *unread_num;
@property(nonatomic, strong) NSNumber *type;

+(void)listMsgCategory:(int)type Block:(void(^)(NSInteger total_unread_num,NSArray *categoryArr))block;

@end
