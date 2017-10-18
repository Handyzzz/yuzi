//
//  UINavigationController+WYFadeEx.h
//  Withyou
//
//  Created by Tong Lu on 10/22/14.
//  Copyright (c) 2014 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (WYFadeEx)

- (void)pushFadeViewController:(UIViewController *)viewController;
- (void)fadePopViewController;

@end
