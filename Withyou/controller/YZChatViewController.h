//
//  YZChatViewController.h
//  Withyou
//
//  Created by ping on 2017/3/18.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "EaseMessageViewController.h"

@interface YZChatViewController : EaseMessageViewController


@property (nonatomic, copy) void(^backClickBlock)(void) ;
@property (nonatomic, strong) WYUser *user;

- (id)initWithUser:(WYUser *)user;



@end
