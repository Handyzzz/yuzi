//
//  WYTagsResultPostListHeaderView.h
//  Withyou
//
//  Created by Handyzzz on 2017/8/30.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYTagsResultPostListHeaderView : UIView
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong)UIView *iconView;
@property(nonatomic,strong)UIImageView *tagIV;
@property(nonatomic,strong)UILabel *tagLb;
@property(nonatomic,strong)UIButton *addfollowBtn;

@property(nonatomic,copy)void(^iocnViewClick)();

-(void)setUpHeaderViewDetail:(NSArray*)userArr tagName:(NSString *)tagName isFollowing:(BOOL)isFollowing;
@end
