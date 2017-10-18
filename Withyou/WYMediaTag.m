//
// Created by Handyzzz on 2017/9/27.
// Copyright (c) 2017 Withyou Inc. All rights reserved.
//

#import "WYMediaTag.h"


@implementation WYMediaTag
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
             @"media_list" : [WYMedia class]
             };
}
@end
