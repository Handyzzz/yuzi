//
//  WYStarredGroupCell.h
//  Withyou
//
//  Created by Handyzzz on 2017/7/28.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYStarredGroupCell : UITableViewCell
@property(nonatomic, strong)UIImageView *backIV;
@property(nonatomic, strong)UIImageView *iconIV;
@property(nonatomic, strong)UILabel*nameLb;
@property(nonatomic, strong)UILabel*desLb;
@property(nonatomic, strong)UILabel *unReadLb;
@property(nonatomic, strong)UIView *lineView;
@end
