//
//  WYApplicantUser.h
//  Withyou
//
//  Created by Handyzzz on 2017/7/11.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYApplicantUser : NSObject

@property (strong, nonatomic) NSString* uuid;
@property (strong, nonatomic) NSString* first_name;
@property (strong, nonatomic) NSString* last_name;
@property (strong, nonatomic) NSString* account_name;
@property (strong, nonatomic) NSString* icon_url;
@property (strong, nonatomic) NSString* easemob_username;
@property (assign, nonatomic) int sex;
@property (strong, nonatomic) NSNumber *type;

- (NSString *)fullName;
@end
