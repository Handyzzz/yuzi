//
//  WYBasicGroupHeaderView.h
//  Withyou
//
//  Created by Handyzzz on 2017/6/28.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYGroup.h"

@interface WYBasicGroupHeaderView : UIView

@property (nonatomic, strong)UIImageView *backGroundView;
@property (nonatomic, strong)CAGradientLayer *blackLayer;
@property (nonatomic, strong)UILabel *groupNameLb;
@property (nonatomic, strong)UILabel *groupInfoLb;

@property (nonatomic, strong)UILabel *introductionLb;
@property (nonatomic, strong)UIView *allIconView;
@property (nonatomic, strong)UILabel *numberLable;

//类别一定用 不写就是朋友
@property (nonatomic, strong)UIView *categoryView;
@property (nonatomic, strong)UILabel *categoryLb;
@property (nonatomic, strong)UIView *tagView;
@property (nonatomic, strong)UILabel *tagLb;

@property (nonatomic, copy) void(^memberViewClick)();

+(CGFloat)calculateHeaderHeight:(WYGroup *)group;
-(void)setUpView:(WYGroup *)group;
@end
