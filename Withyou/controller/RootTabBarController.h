//
//  RootTabBarController.h
//  Withyou
//
//  Created by ping on 2016/12/27.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootTabBarController : UITabBarController

//是不是某个新版本第一次进app 是在appDelegate传过来的
//@property(nonatomic ,assign)BOOL isFirstLogin;
@property (nonatomic, weak)id<UINavigationControllerDelegate> navDelegate;
- (BOOL)isChildVC:(UIViewController *)vc;

@end
