//
//  WYPostBaseVC.h
//  Withyou
//
//  Created by ping on 2017/2/19.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFPlayer.h"
#import "WYCellPostFrame.h"
#import "YZPostViewBase.h"
#import "WYPhotoAlbumVC.h"
#import "WYLinkDetailVC.h"
#import "WYPostApi.h"
#import "YZPostListApi.h"
#import "MJRefresh.h"
#import "YZPostTextCell.h"
#import "YZPostSingleImageCell.h"
#import "YZPostLinkCell.h"
#import "YZPostVideoCell.h"
#import "YZPostAlbumCell.h"

@interface WYPostBaseVC : UIViewController <UITableViewDataSource,UITableViewDelegate,QBImagePickerControllerDelegate,ZFPlayerDelegate,WYCellPostDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, assign) BOOL videoResume;
@property (nonatomic, assign) BOOL isDetial;

// pull to refresh

- (void)setup;
- (void)createRefreshView;
- (void)desiginNoti;

- (void)onPullToRefresh;
- (void)onLoadMore;

- (void)iconAction:(WYUser *)user;

- (void)stopVidoIfNeeded;
- (void)resumeVidoIfNeeded;

@end
