//
//  WYGroupListHeaderView.h
//  Withyou
//
//  Created by Handyzzz on 2017/7/28.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYGroupListHeaderView : UIView
//推荐群组在外边最多只有4个可以展示 0 - 4
//高度 42 + 82 + 10 或者是0
@property(nonatomic, strong)UILabel *titleLb;
@property(nonatomic, strong)UIButton *moreBtn;
@property(nonatomic, strong)UIView *bodyView;
@property(nonatomic, strong)UIView *searchView;

@property(nonatomic, copy)void(^showMoreClick)();
@property(nonatomic, copy)void(^categoryClick)(NSInteger tag);
@property(nonatomic, copy)void(^searchClick)();
-(void)setUpSearchView;
-(void)setUpHeaderView:(NSArray*)classArr;
@end
