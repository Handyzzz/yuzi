//
//  YZPostDetailVC.h
//  Withyou
//
//  Created by ping on 2017/6/7.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYBaseMentionTextVC.h"
#import "YZPostComment.h"
#import "YZLoadingBtn.h"
#import "YZPostComment.h"
#import "YZPostViewBase.h"
#import "YZPostTextCell.h"
#import "YZPostSingleImageCell.h"
#import "YZPostLinkCell.h"
#import "YZPostVideoCell.h"
#import "YZPostAlbumCell.h"
#import "ZFPlayer.h"
#import "WYUserVC.h"
#import "YZMapViewController.h"
#import "WYPostApi.h"
#import "WYPost.h"
#import "WYUserVC.h"
#import "YZPostDelegateVC.h"

@interface YZPostDetailVC : YZPostDelegateVC

@property (nonatomic, strong) NSString *postUuid;
@property (nonatomic, strong) WYPost *post;

// 公开 私密 评论列表切换
@property (nonatomic, weak) UIButton *privacyBtn;
@property (nonatomic, weak) UIButton *publishBtn;

@end
