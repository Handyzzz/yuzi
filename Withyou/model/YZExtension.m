//
//  YZExtension.m
//  Withyou
//
//  Created by ping on 2017/5/28.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZExtension.h"

@implementation YZExtension

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"photos" : [WYPhoto class],
             @"videos": [YZVideo class],
             @"pdfs": [YZPdf class],
             @"links": [YZLink class]
             };
}

@end
