//
//  WYUserDetailHeaderView.h
//  Withyou
//
//  Created by Handyzzz on 2017/5/11.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYUserDetail.h"

@interface WYUserDetailHeaderView : UIView
//共同的
@property(nonatomic, strong)UIImageView *groudIV;
@property(nonatomic, strong)UIImageView *iconIV;
@property(nonatomic, strong)UILabel *nameLb;
@property(nonatomic, strong)UILabel *introductionLb;

//我的 与别人的RealtionShipView
@property(nonatomic, strong)UIView *userRealtionShipView;
@property(nonatomic, strong)UIView *meRealtionShipView;

//别人页面才有的 根据关注关系来判读这个 如何显示
/*
我们都没有关注             不显示
我关注他 他没有关注我       不显示
他关注我 我没有关注他       显示添加功能的View
 我们相互关注             显示带发帖功能的View
 */
@property(nonatomic, strong)UIView *addAttentionView;
@property(nonatomic, strong)UIImageView *userIconIV;
@property(nonatomic, strong)UILabel *realtionShipLb;
@property(nonatomic, strong)UIImageView *addView;

//userRealtionShipView 事件
@property (nonatomic, copy) void(^viewClick)(NSInteger tag, UIImageView *iv, UILabel *Lb);
@property (nonatomic, copy) void(^iconClick)();
@property (nonatomic, copy) void(^buttonClick)();


@property (nonatomic, copy) void(^goToSelfEditingClick)();


//自己页的
@property (nonatomic, copy) NSMutableArray *countArr;
@property(nonatomic, strong)WYUserDetail *userInfo;

//别人页面的第三个按钮
@property (nonatomic, copy) NSMutableArray *userCountArr;
@property (nonatomic, strong)UILabel *firstCountLb;
@property (nonatomic, strong)UIImageView *thirdImg;
@property (nonatomic, strong)UILabel *thirdLb;

+(CGFloat)calculateHeaderHeight:(WYUserDetail*)userInfo;
-(void)setUpHeadView:(WYUserDetail *)userInfo :(WYUserExtra *)extra;


@end
