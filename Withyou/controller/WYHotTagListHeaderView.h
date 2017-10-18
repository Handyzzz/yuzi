//
//  WYHotTagListHeaderView.h
//  Withyou
//
//  Created by Handyzzz on 2017/9/1.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYHotTagListHeaderView : UIView
@property(nonatomic,strong)UILabel *hotTitleLb;
@property(nonatomic,strong)UILabel *hotAllTagLb;
@property(nonatomic,strong)UIView *allTagView;
@property(nonatomic,strong)UILabel *attionTitleLb;
@property(nonatomic,strong)UILabel *attionAllTagLb;

@property(nonatomic,copy)void(^tagClicked)(NSInteger index);
@property(nonatomic,copy)void(^hotAllTagLbClick)();
@property(nonatomic,copy)void(^attionAllTagLbClick)();

-(void)setUpHeaderViewDetail:(NSArray *)tagArr;
@end
