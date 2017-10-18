//
//  NSURLRequest+Url.h
//  Withyou
//
//  Created by hongfei on 14-5-6.
//  Copyright (c) 2014年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (Url)

+ (NSURLRequest *)requestWithPath:(NSString *)path params:(NSDictionary *)params;

@end
