//
//  YZPostCellBase.h
//  Withyou
//
//  Created by ping on 2017/5/14.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZPostHeader.h"
#import "WYCellPostFrame.h"
#import "YZPostInfoView.h"
#import "YZPostCommentView.h"
#import "YZPostLocationView.h"
#import "YZPostStarView.h"
#import "YZPostRemindView.h"
#import "WYPostTagView.h"

@protocol WYCellPostDelegate <NSObject>

@optional

- (void)star:(WYPost *)post;
// 在详情页星标
- (void)starAtDetailPage:(WYPost *)post;

- (void)detail:(WYPost *)post;
//对他人的发帖可以举报，对自己的发帖可以删除，对所有的公开发帖可以获取url
- (void)deletePost:(WYPost *)post;
- (void)moreActions:(WYPost *)post btn:(UIButton *)Btn;
- (void)flag:(WYPost *)post;
- (void)copyLink:(WYPost *)post;

- (void)iconClick:(WYUser *)user;
//- (void)showMoreImages:(WYPost *)post;

- (void)showImageFromPost:(WYPost *)post;
- (void)showAlbumFromPost:(WYPost *)post;
- (void)showLinkContentFromPost:(WYPost *)post;
- (void)setElementStyle;

// @高亮点击
- (void)atStringClick:(YZMarkText *)mark;
//标签
-(void)tagsClick:(WYPost*)post index:(NSInteger)index;
//地址
- (void)addressClick:(YZAddress *)address;
//提及
- (void)remindClick:(WYUser *)user;
//pdf
- (void)attchMentPdfs:(NSArray<YZPdf*>*)pdfs;

-(void)attchMentPdfsInDetail:(YZPdf *)pdf;
@end


@interface YZPostViewBase : UIView <UITextViewDelegate>

// views
// cell
//  - header
//  - body (subclass custome)
//  - location
//  - remind
//  - info
//  - comment


@property (nonatomic, weak) YZPostHeader *header;
@property (nonatomic, strong) WYPostTagView *tagView;
@property (nonatomic, weak) YZPostLocationView *locationView;
@property (nonatomic, strong) YZPostRemindView *remindView;
@property (nonatomic, weak) YZPostInfoView *infoView;
// only post detail
@property (nonatomic, weak) YZPostStarView *starView;


@property (nonatomic, weak) YZPostCommentView *commentView;

@property (nonatomic, weak) UIView *bodyView;

@property (nonatomic, weak) UILabel *timeLabel;

// data
@property (nonatomic, strong)WYCellPostFrame *postFrame;
@property (nonatomic, weak) id <WYCellPostDelegate> delegate;

/** 播放按钮block */
@property (nonatomic, copy) void(^playBlock)(WYPost *post,UIView *fatherView);

// 设置详情页的frame
- (void)setDetailLayout:(WYCellPostFrame *)postFrame;
- (void)setupStarView:(WYCellPostFrame *)postFrame;


@end
