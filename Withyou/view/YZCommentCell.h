//
//  YZCommentCell.h
//  Withyou
//
//  Created by ping on 2017/2/19.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZCommentFrame.h"
#import "YZUserHeadView.h"

@protocol YZCommentCellDelegate <NSObject>

@optional
//个人
- (void)onIconClick: (YZPostComment *)comment;
//回复
- (void)replyComment: (YZPostComment *)comment;
// @高亮点击
- (void)atStringClick:(YZMarkText *)mark;
//删除评论 或者举报评论
-(void)showAlertAction:(YZPostComment *)comment;
//给评论加星标
-(void)starCommentAction:(YZPostComment *)comment starBtn:(UIButton *)btn starCountLb:(UILabel *)starCountLb;
@end

@interface YZCommentCell : UITableViewCell

@property (weak, nonatomic) YZUserHeadView *iconImage;

// container 包含以下 子view
@property (weak, nonatomic) UIView  *containerView;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UILabel *timeLabel;
@property (weak, nonatomic) UIButton *moreBtn;
@property (weak, nonatomic) UIButton *starBtn;
@property (weak, nonatomic) UILabel *starCountLb;
@property (weak, nonatomic) UITextView *contentTV;
@property (weak, nonatomic) UIView *replayTip;
@property (weak, nonatomic) UILabel *replayLabel;
@property (weak, nonatomic) UIView *separateView;

@property (strong, nonatomic) YZCommentFrame *comment;
@property (weak, nonatomic) id <YZCommentCellDelegate> delegate;

@end
