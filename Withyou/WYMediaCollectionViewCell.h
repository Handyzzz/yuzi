//
//  WYMediaCollectionViewCell.h
//  Withyou
//
//  Created by Handyzzz on 2017/9/27.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYMedia.h"
@interface WYMediaCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong)UIImageView *iconIV;
@property(nonatomic, strong)UILabel *nameLb;
@property(nonatomic, strong)UIButton *attentionBtn;

-(void)setUpCellDetail:(WYMedia *)media;
@end
