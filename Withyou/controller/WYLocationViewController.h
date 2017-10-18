//
//  WYLocationViewController.h
//  Withyou
//
//  Created by Handyzzz on 2017/6/12.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYLocationViewController : UIViewController
//搜索回调的结果
@property (nonatomic, copy) void(^locationClick)(YZAddress*address);
@end

