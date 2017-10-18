//
//  YZMessageCell.h
//  Withyou
//
//  Created by lx on 16/12/19.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZMessage.h"
#import "YZUserHeadView.h"

@interface YZMessageCell : UITableViewCell
@property (strong, nonatomic) YZUserHeadView *iconImg;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *starImg;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *targetLabel;
@property (strong, nonatomic) UIImageView *targetImg;
@property (strong, nonatomic) UIImageView *replyImg;
@property (strong, nonatomic) UIImageView *fansImg;
@property (strong, nonatomic) UILabel *replyLabel;

@property (strong, nonatomic) UIImageView *lineImg;

@property (strong, nonatomic) YZMessage *msg;
@property (copy, nonatomic) void(^removeMessageBlock)(YZMessage *msg);
@property (copy, nonatomic) void(^iconClick)(YZMessage *msg);

+ (CGFloat)fitHeight:(YZMessage *)msg;

@end
