//
//  WYStudy.m
//  Withyou
//
//  Created by Tong Lu on 2016/11/4.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import "WYStudy.h"

@implementation WYStudy

-(NSString *)start_year_month{
    //去掉后三位
    if (self.finish_date.length > 3) {
        NSString *s = [self.start_date substringToIndex:self.start_date.length - 3];
        return s;
    }
    return self.start_date;
}

-(NSString *)finish_year_month{
    if (self.finish_date.length > 3) {
        NSString *s = [self.finish_date substringToIndex:self.finish_date.length - 3];
        return s;
    }
    return self.finish_date;
}

@end
