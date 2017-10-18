//
//  YZPostLinkView.h
//  Withyou
//
//  Created by ping on 2017/5/20.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZPostViewBase.h"
#import "WYPostOtherLinkView.h"

@interface YZPostLinkView : YZPostViewBase

//  - body
//    -content
//    -container
//      -image
//      -title
//      -keyword
//      -source

@property (nonatomic, weak) UILabel *contentLabel;
@property (nonatomic, weak) UIView *linkContainer;
//内部链接类型
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *keywordLabel;
@property (nonatomic, weak) UILabel *sourceLabel;
//外部链接类型
@property (nonatomic, strong) WYPostOtherLinkView *otherLinkView;
@end
