//
//  WYReccomendUser.h
//  Withyou
//
//  Created by Handyzzz on 2017/6/15.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYUser.h"

@interface WYReccomendUser : NSObject
@property(nonatomic, strong)WYUser *user;
@property(nonatomic, strong)NSString *recommend_reason;
@property (nonatomic, assign) int rel_to_me;

@end
