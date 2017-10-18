//
//  YZPostHeader.h
//  Withyou
//
//  Created by ping on 2017/5/13.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZPostHeader : UIView

@property (nonatomic, weak) UIImageView *iconImage;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UIButton *moreButton;

- (void)setupWith:(WYPost *)post;
@end
