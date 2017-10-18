//
//  RootPageVC.h
//  Withyou
//
//  Created by lx on 17/3/16.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootTabBarController.h"
#import "YZChatList.h"
#import "WYPublishVC.h"

@interface RootPageVC : UIViewController<UINavigationControllerDelegate>

// 当前显示的索引  0 = left ; 1 = tabber ; 2 = right
@property (nonatomic, assign) int index;

@property (nonatomic, strong) RootTabBarController *tabBarVC;

// 左边为相机
@property (nonatomic, strong) WYPublishVC *publishVC;

// 右边为聊天列表 deprecated
@property (nonatomic, strong) YZChatList *chatVC;

@property (nonatomic, strong) UIScrollView *scrollView;

- (void)setScrollViewEnable:(BOOL)enable;

@end
