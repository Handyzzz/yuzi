//
//  YZPostAlbumView.h
//  Withyou
//
//  Created by ping on 2017/5/20.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZPostViewBase.h"
#import "YZCarouselView.h"
@interface YZPostAlbumView : YZPostViewBase

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) YZCarouselView *carouselView;
@property (nonatomic, weak) UILabel *contentLabel;

@end
