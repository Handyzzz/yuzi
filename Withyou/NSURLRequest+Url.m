//
//  NSURLRequest+Url.m
//  Withyou
//
//  Created by hongfei on 14-5-6.
//  Copyright (c) 2014年 Withyou Inc. All rights reserved.
//

#import "NSURLRequest+Url.h"


@implementation NSURLRequest (Url)
+ (NSURLRequest *)requestWithPath:(NSString *)path params:(NSDictionary *)params
{
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@%@", kBaseURL, path];
    
    if (params) { // 如果有参数
        // 拼接问号
        [url appendString:@"?"];
        
        // 拼接参数 利用block遍历字典，不需要知道字典的键值
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [url appendFormat:@"%@=%@&", key, obj];
        }];
        
        [url deleteCharactersInRange:NSMakeRange([url length]-1, 1)];
        

        url = (NSMutableString *)[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
    }
    
    return [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
}

@end
