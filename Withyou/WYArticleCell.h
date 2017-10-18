//
//  WYArticleCell.h
//  Withyou
//
//  Created by Handyzzz on 2017/9/27.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYArticle.h"

@interface WYArticleCell : UITableViewCell
@property(nonatomic, strong)UIImageView *iconIV;
@property(nonatomic, strong)UILabel *nameLb;
@property(nonatomic, strong)UIImageView *contentIV;
@property(nonatomic, strong)UILabel *titleLb;
@property(nonatomic, strong)UILabel *contentLb;
@property(nonatomic, strong)UIButton *starBtn;
@property(nonatomic, strong)UILabel *starLb;
@property(nonatomic, strong)UIButton *commentBtn;
@property(nonatomic, strong)UILabel *commentLb;
@property(nonatomic, strong)UILabel *timeLb;
@property(nonatomic, strong)UIView *lineView;
@property(nonatomic, strong)UIButton *attentionBtn;

@property(nonatomic,copy)void(^mediaClick)();

+(CGFloat)heightForCell:(WYArticle*)article;
-(void)setUpCellDetail:(WYArticle *)article;

@end
