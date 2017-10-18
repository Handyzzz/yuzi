//
//  WYEvent.h
//  Withyou
//
//  Created by Handyzzz on 2017/6/7.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "NSObject+Parse.h"
@implementation NSObject (Parse)

+ (id)YYModelParse:(id)json{
    if ([json isKindOfClass:[NSArray class]]) {
        //参数1:数组中的元素类型
        return [NSArray yy_modelArrayWithClass:[self class] json:json];
    }
    if ([json isKindOfClass:[NSDictionary class]]) {
        //YYModel提供的JSON字典转 类对象的方法
        return [self yy_modelWithJSON:json];
    }
    return json;
}

@end
