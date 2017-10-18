//
//  YZPostStarView.h
//  Withyou
//
//  Created by ping on 2017/6/3.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZUserHeadView.h"

@interface YZPostStarView : UIView

@property (nonatomic, weak) UILabel *starNumberLabel;

@property (nonatomic, weak) UIView *separateLine;
@property (nonatomic, weak) UIButton *starBtn;

@property (nonatomic, copy) void(^onIconClick)(WYUser *user);

@property (nonatomic, strong) NSArray <WYUser *>*users;

- (void)setStaredUsers:(NSArray <WYUser *>*)users;

@end
