//
//  WYUserExtra.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/8.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYUserExtra.h"

@implementation WYUserExtra
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
             @"public_groups" : [WYGroup class]
             };
}

@end
