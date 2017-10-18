//
//  AppDelegate.h
//  Withyou
//
//  Created by Tony on 14-3-22.
//  Copyright (c) 2014年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) BOOL requestGroupLock;

- (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible;
- (void)handleDatabaseAfterLogin;

@end
