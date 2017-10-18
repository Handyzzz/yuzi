//
//  UIView+HUD.h
//  
//
//  Created by 夯大力 on 16/9/9.
//  Copyright © 2016年 Handyzzz. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

@interface UIView (HUD)
- (void)showHUDNoHide;

- (void)showHUDDelayHide;

- (void)hideAllHUD;

-(void)showMsgNOHide:(NSString *)msg;

- (void)showMsgDelayHide:(NSString *)msg;

@end













