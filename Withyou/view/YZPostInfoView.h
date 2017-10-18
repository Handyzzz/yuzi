//
//  YZPostInfoView.h
//  Withyou
//
//  Created by ping on 2017/5/13.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYCellPostFrame.h"

@interface YZPostInfoView : UIView

@property (nonatomic, weak)UIImageView *iconImage;
@property (nonatomic, weak)UILabel *iconLabel;

@property (nonatomic, weak)UIButton *starButton;
@property (nonatomic, weak)UILabel * starCountLabel;
@property (nonatomic, weak)UIButton *commentButton;
@property (nonatomic, weak)UILabel * commentCountLabel;

- (void)setupWith:(WYCellPostFrame *)postFrame isDetail:(BOOL)detailPage;

@end
