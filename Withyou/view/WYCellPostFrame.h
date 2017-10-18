//
//  WYCellPostFrame.h
//  Withyou
//
//  Created by Tong Lu on 8/5/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYPost.h"


@interface WYCellPostFrame : NSObject


@property (nonatomic, strong) WYPost *post;
@property (nonatomic, assign) CGFloat cellHeight;

//  ============ 公用部分 ================
//头部
@property (nonatomic, assign) CGRect headerFrame;
//标签
@property (nonatomic, assign) CGRect tagsFrame;
//地址
@property (nonatomic, assign) CGRect locationFrame;
//与谁一起
@property (nonatomic, assign) CGRect remindFrame;
//星标和评论按钮
@property (nonatomic, assign) CGRect infoFrame;
@property (nonatomic, assign) CGRect infoStarBtnFrame;
@property (nonatomic, assign) CGRect infoStarLabelFrame;
@property (nonatomic, assign) CGRect infoCommentBtnFrame;
@property (nonatomic, assign) CGRect infoCommentLabelFrame;

// 详情页的星标显示
@property (nonatomic, assign) CGRect starViewFrame;

// 评论 最多3条的frames
@property (nonatomic, assign) CGRect commentBodyFrame;
@property (nonatomic, strong) NSArray <NSValue *>*commentFrames;

// 发布时间
@property (nonatomic, assign) CGRect timeLabelFrame;


//  ============ 内容部分 ================
@property (nonatomic, assign) CGRect bodyFrame;


// type1 text
@property (nonatomic, assign) CGRect textTitleFrame;
@property (nonatomic, assign) CGRect textContentFrame;
@property (nonatomic, assign) CGRect photosFrame;
@property (nonatomic, assign) CGRect textAttachmentFrame;

// type2 image
@property (nonatomic, assign) CGRect singleImageFrame;
@property (nonatomic, assign) CGRect singleImageTextFrame;
@property (nonatomic, assign) CGRect albumTitleFrame;

// type4 link
@property (nonatomic, assign) CGRect linkContentFrame;
@property (nonatomic, assign) CGRect linkContinerFrame;
@property (nonatomic, assign) CGRect linkImageFrame;
@property (nonatomic, assign) CGRect linkTitleFrame;
@property (nonatomic, assign) CGRect linkKeyWordFrame;
@property (nonatomic, assign) CGRect linkSourceFrame;

// type5 video
@property (nonatomic, assign) CGRect videoImageFrame;
@property (nonatomic, assign) CGRect videoTextFrame;



- (instancetype)initWithPost:(WYPost *)post;

/**
 这个是用来给Post的详情页用的，在详情页中，文字的高度和图片的高度都没有限制。

 @param post 分享
 @return instance
 */
- (instancetype)initWithPostWithNoHeightLimit:(WYPost *)post;

@end
