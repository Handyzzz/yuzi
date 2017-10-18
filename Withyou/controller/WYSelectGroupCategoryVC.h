//
//  WYSelectGroupCategoryVC.h
//  Withyou
//
//  Created by Handyzzz on 2017/8/1.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYGroupCategory.h"
@interface WYSelectGroupCategoryVC : UIViewController
@property(nonatomic,copy)void(^selectedClick)(WYGroupCategory*tags);
@end
