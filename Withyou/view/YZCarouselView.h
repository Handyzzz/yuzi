//
//  YZCarouselView.h
//  Withyou
//
//  Created by ping on 2017/5/28.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPhoto.h"

@interface YZCarouselView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) int index;

@property (nonatomic, strong) NSArray <WYPhoto *> *photos;


@end
