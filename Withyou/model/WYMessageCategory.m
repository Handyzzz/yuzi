//
//  WYMessageCategory.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/5.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYMessageCategory.h"

@implementation WYMessageCategory
+(void)listMsgCategory:(int)type Block:(void(^)(NSInteger total_unread_num,NSArray *categoryArr))block{
    NSString *s = @"api/v1/notif/cat_list/";
    NSDictionary *dic = @{@"type":@(type)};
    [[WYHttpClient sharedClient] GET:s parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSInteger unread = [[responseObject objectForKey:@"total_unread_num"] intValue];
        NSDictionary *json = [responseObject objectForKey:@"category"];
        NSArray *cateList = [WYMessageCategory YYModelParse:json];
        if (block) {
            block(unread, cateList);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(0,nil);
        }
    }];
}
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }

@end
