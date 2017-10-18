//
//  WYGroupDetailView.h
//  Withyou
//
//  Created by Handyzzz on 2017/4/1.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYGroup.h"

@interface WYGroupDetailView : UIView
@property (nonatomic, strong)UILabel *groupNameLb;
@property (nonatomic, strong)UILabel *groupInfoLb;
@property (nonatomic, strong)UIScrollView *allIconSV;
@property (nonatomic, strong)UIButton *inviteButton;
@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, strong)UILabel *numberLable;
@property (nonatomic, strong)UIView *headLineView;
@property (nonatomic, strong)UIView *shareView;
@property (nonatomic, strong)UIImageView *myIcon;
@property (nonatomic, strong)UILabel *shareTitleLabel;
@property (nonatomic, strong)UIButton *shareButton;
@property (nonatomic, strong)UIView *shareLineView;


//群组介绍
@property (nonatomic, strong)UILabel *descLabel;
@property (nonatomic, strong)UILabel *applyLabel;
@property (nonatomic, strong)UIButton *applyBtn;

@property (nonatomic, strong)UIView *categoryView;
@property (nonatomic, strong)UILabel *categoryLb;
@property (nonatomic, strong)UIView *tagView;
@property (nonatomic, strong)UILabel *tagLb;


@property (nonatomic, copy) void(^onApplyClick)(UIButton *applyBtm,NSString *text);

- (id)initWithGroup:(WYGroup *)group;
- (void)didChangeAppliedStatus:(int)appliedStatus;

@end
