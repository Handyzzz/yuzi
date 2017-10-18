//
//  WYApplicantUser.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/11.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYApplicantUser.h"

@implementation WYApplicantUser

- (NSString *)fullName
{
    if( (!self.last_name || [self.last_name isEqualToString:@""]) &&
       (!self.first_name || [self.first_name isEqualToString:@""])) {
        return self.account_name;
    }
    
    NSString *fullName = nil;
    
    if([NSString hasUnicodeCharacters:self.last_name] && [NSString hasUnicodeCharacters:self.first_name]) {
        fullName =  [NSString stringWithFormat:@"%@%@", self.last_name, self.first_name];
    }else {
        fullName = [NSString stringWithFormat:@"%@ %@", self.first_name, self.last_name];
    }
    
    return fullName;
}

@end
