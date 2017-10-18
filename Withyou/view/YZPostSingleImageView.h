//
//  YZPostImageVIew.h
//  Withyou
//
//  Created by ping on 2017/5/20.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZPostViewBase.h"

@interface YZPostSingleImageView : YZPostViewBase


//  - body
//    -image
//    -content

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *contentLabel;
@property (copy, nonatomic) void(^photoDetailClick)();
@end
