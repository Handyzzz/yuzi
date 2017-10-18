//
//  YZPostDelegateVC.h
//  Withyou
//
//  Created by ping on 2017/6/11.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFPlayer.h"
#import "WYCellPostFrame.h"
#import "YZPostViewBase.h"
#import "WYPhotoAlbumVC.h"
#import "WYLinkDetailVC.h"
#import "WYPostApi.h"
#import "MJRefresh.h"
#import "YZPostTextCell.h"
#import "YZPostSingleImageCell.h"
#import "YZPostLinkCell.h"
#import "YZPostVideoCell.h"
#import "YZPostAlbumCell.h"

@interface YZPostDelegateVC :UIViewController <QBImagePickerControllerDelegate,ZFPlayerDelegate,WYCellPostDelegate, UIActionSheetDelegate>


@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, assign) BOOL videoResume;



- (void)iconAction:(WYUser *)user;
- (void)stopVidoIfNeeded;
- (void)resumeVidoIfNeeded;
//导航栏有上角更多
- (void)moreActions:(WYPost *)post;

- (YZPostViewBase *)getPostDetail:(WYCellPostFrame *)frame;

@end
