//
//  WYSearchFriendCollectionViewCell.h
//  Withyou
//
//  Created by Handyzzz on 2017/6/15.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYSearchFriendCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong)UIImageView *iconIV;
@property(nonatomic, strong)UILabel *nameLb;
@property(nonatomic, strong)UILabel *commonLb;
@property(nonatomic, strong)UIImageView *addIV;

@property (nonatomic, copy) void(^addViewClick)();
@end
