//
//  WYRemindFriendsVC.h
//  Withyou
//
//  Created by Handyzzz on 2017/7/15.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYRemindFriendsVC : UIViewController
//类型公开或者朋友
@property (nonatomic, copy) void(^remindFriends)(NSArray *friendsArr);
@property (nonatomic, strong) NSMutableArray *selectedMember;
@property (nonatomic, strong)NSString *naviTitle;
@end
