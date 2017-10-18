//
//  selectSystemScopeSecondTimeVC.h
//  Withyou
//
//  Created by Handyzzz on 2017/4/25.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYselectSystemScopeSecondTimeVC : UIViewController
@property (nonatomic, copy) void(^myBlock)(int publishVisibleScopeType, NSString *targetUuid,NSString*title);
@end
