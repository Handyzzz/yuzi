//
//  YZPostVideoView.h
//  Withyou
//
//  Created by ping on 2017/5/20.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZPostViewBase.h"

@interface YZPostVideoView : YZPostViewBase

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *contentLabel;

@property (nonatomic, weak) UIView *playView;
@property (nonatomic, weak) UILabel *playLabel;

@end
