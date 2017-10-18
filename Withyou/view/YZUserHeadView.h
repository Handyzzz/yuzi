//
//  YZUserHeadView.h
//  Withyou
//
//  Created by CH on 17/5/20.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZUserHeadView : UIView

// 提供了两种init方法，对于是否要加蓝色border线，做了区别
- (id)initWithFrameWithNoBorder:(CGRect)frame;

@property (nonatomic, strong) UIImageView *headView;

- (void)loadImage:(NSString *)iconUrl;

@end
