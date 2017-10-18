//
//  WYSelfDetailEditing.h
//  Withyou
//
//  Created by Handyzzz on 2017/5/28.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYUserDetail.h"
@interface WYSelfDetailEditing : UIViewController
/*
 这个页面还有一个入口 就是添加关注未成功的时候 跳转到此页面来 完善个人信息 这个时候是不带数据进来的
 */
//也可以不带参数进来
@property(nonatomic, strong)WYUserDetail *userInfo;
@end
