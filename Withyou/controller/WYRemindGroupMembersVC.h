//
//  WYRemindGroupMembersVC.h
//  Withyou
//
//  Created by Handyzzz on 2017/7/17.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYGroupMemberList.h"
@interface WYRemindGroupMembersVC : WYGroupMemberList
@property (nonatomic, copy) void(^remindFriends)(NSArray *membersArr);
@property (nonatomic, strong) NSMutableArray *selectedMember;
@property (nonatomic, strong)NSString *naviTitle;

@end
