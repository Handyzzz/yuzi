//
//  WYMsgListVC.h
//  Withyou
//
//  Created by Handyzzz on 2017/8/5.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^msgNumBlock)(BOOL checkedAll, int type);

@interface WYMsgListVC : UIViewController

@property (nonatomic, copy) msgNumBlock block;

@property(nonatomic,assign) int type;
@property(nonatomic,strong) NSString *naviTitle;
@end
