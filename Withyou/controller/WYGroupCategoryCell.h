//
//  WYGroupCategoryCell.h
//  Withyou
//
//  Created by Handyzzz on 2017/7/29.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYGroup.h"
#import "WYRecommendGroup.h"

@interface WYGroupCategoryCell : UITableViewCell

@property(nonatomic,strong)UILabel *nameLb;
@property(nonatomic,strong)UILabel *memberCountLb;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UILabel *postCountLb;
@property(nonatomic,strong)UIButton *applyBtn;

@property(nonatomic,strong)UIImageView *backIV;
@property(nonatomic,strong)UIImageView *iconIV;
@property(nonatomic,strong)UILabel*desLb;
@property(nonatomic,strong)UIView *tagView;
@property(nonatomic,strong)UIView *line;

@property(nonatomic,copy)void(^applyGroupClick)();

-(void)setUpCellDetail:(WYRecommendGroup *)recommendGroup;
@end
