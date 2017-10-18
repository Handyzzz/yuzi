//
//  WYPublishOtheerView.h
//  Withyou
//
//  Created by Handyzzz on 2017/6/12.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYPublishOtherView : UIView

@property(nonatomic, strong)UILabel *rangeLabel;
@property(nonatomic, strong)UILabel *tagsLabel;
@property(nonatomic, strong)UILabel *locationLabel;
@property(nonatomic, strong)UILabel *remindLabel;

@property (nonatomic, copy) void(^visiableRangeViewClick)();
@property (nonatomic, copy) void(^tagsClick)();
@property (nonatomic, copy) void(^LocationClick)();
@property (nonatomic, copy) void(^remindClick)();
@end
