//
//  WYPublishTextOtherView.h
//  Withyou
//
//  Created by Handyzzz on 2017/7/24.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYPublishTextOtherView : UIView
@property(nonatomic, strong)UILabel *rangeLabel;
@property(nonatomic, strong)UILabel *tagsLabel;
@property(nonatomic, strong)UILabel *photoLabel;
@property(nonatomic, strong)UILabel *locationLabel;
@property(nonatomic, strong)UILabel *accessoryLabel;
@property(nonatomic, strong)UILabel *remindLabel;

@property (nonatomic, copy) void(^visiableRangeViewClick)();
@property (nonatomic, copy) void(^tagsClick)();
@property (nonatomic, copy) void(^photoClick)();
@property (nonatomic, copy) void(^LocationClick)();
@property (nonatomic, copy) void(^remindClick)();
@property (nonatomic, copy) void(^accessoryClick)();
@end
