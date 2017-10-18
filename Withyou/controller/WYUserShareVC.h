//
//  TestViewController.h
//  Withyou
//
//  Created by Handyzzz on 2017/6/6.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYUserBaseVC.h"
#import "WYUserDetail.h"
#import "WYPostBaseVC.h"
@interface WYUserShareVC :WYPostBaseVC
@property (nonatomic, strong)WYUserDetail *userInfo;
@property (nonatomic, strong)NSMutableArray *postArr;

@end
