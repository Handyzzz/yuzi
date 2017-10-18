//
//  YZCommentFrame.h
//  Withyou
//
//  Created by ping on 2017/2/23.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZPostComment.h"

@interface YZCommentFrame : NSObject


@property (assign, nonatomic) CGRect iconImageFrame;

@property (assign, nonatomic) CGRect containerFrame;
@property (assign, nonatomic) CGRect nameLabelFrame;
@property (assign, nonatomic) CGRect timeLabelFrame;
@property (assign, nonatomic) CGRect moreBtnFrame;
@property (assign, nonatomic) CGRect starBtnFrame;

@property (assign, nonatomic) CGRect replayLabelFrame;
@property (assign, nonatomic) CGRect contentLabelFrame;

@property (assign, nonatomic) CGRect separateFrame;

@property (assign, nonatomic) CGFloat cellHeight;

@property (strong, nonatomic) YZPostComment *comment;

- (instancetype)initWithComment:(YZPostComment *)comment;

@end
