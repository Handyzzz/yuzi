//
//  YZPostCellBase.h
//  Withyou
//
//  Created by ping on 2017/5/20.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYCellPostFrame.h"
#import "YZPostViewBase.h"


@interface YZPostCellBase : UITableViewCell

@property (nonatomic, strong) WYCellPostFrame *postFrame;
@property (nonatomic, weak)id <WYCellPostDelegate>delegate;

// subclass overload
- (YZPostViewBase *)getContentView;

// 设置详情页的frame
- (void)setDetailLayout:(WYCellPostFrame *)postFrame;


/** 播放按钮block */
@property (nonatomic, copy) void(^playBlock)(WYPost *post,UIView *fatherView);


@end
