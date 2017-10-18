//
//  YZChatVC.h
//  Withyou
//
//  Created by ping on 2017/3/17.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZChatList : UIViewController


@property (nonatomic, assign)int badgeValue;

- (void)startChatWithUser:(WYUser *)user pushBy:(UINavigationController *)nav;

@end
