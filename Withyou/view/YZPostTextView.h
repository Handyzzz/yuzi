//
//  YZPostTextView.h
//  Withyou
//
//  Created by ping on 2017/5/13.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZPostViewBase.h"

@interface YZPostTextView : YZPostViewBase

//  - body
//    -title
//    -content
//    -attachment

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UITextView *contentTV;
//九张图
@property (nonatomic, strong) UICollectionView *collectionView;
//分享详情页的pdf
@property (nonatomic, strong) UITableView *pdfsView;
//分享页的pdf
@property (nonatomic, weak) UIImageView *attachmentIV;
@property (nonatomic, weak) UILabel *attachmentLB;
@end
