//
//  WYRecommendGroup.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/29.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYRecommendGroup.h"

@implementation WYRecommendGroup
-(NSString *)tagsString{
    
    NSMutableString *ms = [NSMutableString string];
    
    if (self.tags.length > 0) {
        NSArray*strArr = [self.tags componentsSeparatedByString:@","];
        [strArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [ms appendString:@"#"];
            [ms appendString:obj];
            [ms appendString:@"  "];
        }];
    }
    return [ms copy];
}
@end
