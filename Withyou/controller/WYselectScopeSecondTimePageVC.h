//
//  selectScopeSecondTimePageVC.h
//  Withyou
//
//  Created by Handyzzz on 2017/4/25.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMPageController.h"
#import "WYGroup.h"

@interface WYselectScopeSecondTimePageVC : WMPageController
@property (nonatomic, copy) void(^myBlock)(int publishVisibleScopeType, NSString *targetUuid,NSString*title,WYGroup *group);
@end
