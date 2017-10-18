//
//  WYMediaHeaderView.h
//  Withyou
//
//  Created by Handyzzz on 2017/9/27.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYMedia.h"

@interface WYMediaHeaderView : UIView
@property(nonatomic, strong)UIImageView *iconIV;
@property(nonatomic, strong)UILabel *nameLb;
@property(nonatomic, strong)UILabel *numLb;
@property(nonatomic, strong)UIButton *attentionBtn;
@property(nonatomic, strong)UILabel *introductionLb;
@property(nonatomic, strong)UIImageView *rightIV;
@property(nonatomic, strong)UIView *lineView;

-(instancetype)initWithFrame:(CGRect)frame;
-(void)setHeaderViewWithMedia:(WYMedia *)media;
@end
