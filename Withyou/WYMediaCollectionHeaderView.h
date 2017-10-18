//
//  WYMediaCollectionHeaderView.h
//  Withyou
//
//  Created by Handyzzz on 2017/9/30.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYMediaCollectionHeaderView : UICollectionReusableView
@property(nonatomic, strong)UILabel *titltLb;
@property(nonatomic, strong)UIButton *moreBtn;
@property(nonatomic, copy)void(^moreMediaClick)();
@end
