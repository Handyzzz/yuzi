//
//  WYUserVC.h
//  Withyou
//
//  Created by Handyzzz on 2017/5/11.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYUserVC : UIViewController
//如果是present过来的必须实现
@property(nonatomic,assign)BOOL isPresent;

//如果是自己 headView 和右上角的导航栏按钮不一样
@property(nonatomic, strong)WYUser *user;
@property(nonatomic, strong) NSString *userUuid;


@end
