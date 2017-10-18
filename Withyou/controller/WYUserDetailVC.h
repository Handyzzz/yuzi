//
//  WYUserDetailVC.h
//  Withyou
//
//  Created by Handyzzz on 2017/5/11.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYUserBaseVC.h"
#import "WYUserDetail.h"
@interface WYUserDetailVC : WYUserBaseVC
@property (nonatomic, strong)WYUserDetail *userInfo;
@property (nonatomic, strong)UITableView *tableView;
//一下这个是展示更多公开群组用到的 个人资料集中在userIndo 模型中
@property (nonatomic, strong)WYUserExtra *userExtra;

@end
