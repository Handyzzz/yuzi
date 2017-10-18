//
//  WYAddUserIntroductionVC.h
//  Withyou
//
//  Created by Handyzzz on 2017/9/23.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYAddUserIntroductionVC : UIViewController
@property (nonatomic, copy)NSString *defaultText;
@property (nonatomic, copy) void(^myBlock)(NSString *text);

@end
