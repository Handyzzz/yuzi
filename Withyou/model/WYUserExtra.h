//
//  WYUserExtra.h
//  Withyou
//
//  Created by Handyzzz on 2017/6/8.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYGroup.h"
@interface WYUserExtra : NSObject
@property(nonatomic, assign)int post_num;
@property(nonatomic, assign)int photo_num;
@property(nonatomic, assign)int friends_num;
@property(nonatomic, assign)bool allow_check_friends;
@property(nonatomic, assign)int common_friends_num;
@property(nonatomic, assign)int following_me_num;
@property(nonatomic, assign)int followed_by_me_num;
@property(nonatomic, assign)int group_num;
@property(nonatomic, assign)int public_group_num;

@property(nonatomic, copy)NSArray<WYGroup *> * public_groups;

@end
