//
//  selectGroopOrFriendScopeSecondtimeVC.h
//  Withyou
//
//  Created by Handyzzz on 2017/4/25.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYGroup.h"
@interface WYselectGroopOrFriendScopeSecondtimeVC : UIViewController
//1.group 2.friend
@property(nonatomic ,assign)NSInteger selectType;
@property (nonatomic, copy) void(^myBlock)(int publishVisibleScopeType, NSString *targetUuid,NSString*title,WYGroup *group);
@end
