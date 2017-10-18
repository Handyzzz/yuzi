//
//  YZCommentFrame.m
//  Withyou
//
//  Created by ping on 2017/2/23.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZCommentFrame.h"

@implementation YZCommentFrame

- (instancetype)initWithComment:(YZPostComment *)comment {
    if(self = [super init]) {
        self.comment = comment;
    }
    return self;
}

- (void)setComment:(YZPostComment *)comment {
    _comment = comment;
    
    CGFloat margin = 15.f;

    CGFloat imageWH = 36.f;
    self.iconImageFrame = CGRectMake(margin, margin, imageWH, imageWH);
    self.nameLabelFrame = CGRectMake(CGRectGetMaxX(self.iconImageFrame) + 8, self.iconImageFrame.origin.y + 2, 150, 14);
    self.timeLabelFrame = CGRectMake(self.nameLabelFrame.origin.x, CGRectGetMaxY(self.nameLabelFrame) + 6, 150, 12);
    self.moreBtnFrame = CGRectMake(kAppScreenWidth - 40, margin, 40, 36);
    self.starBtnFrame = CGRectMake(kAppScreenWidth - 90, margin, 50, 36);
    
    CGRect containerFrame = CGRectMake(self.nameLabelFrame.origin.x, CGRectGetMaxY(self.timeLabelFrame) + 8, kAppScreenWidth - self.nameLabelFrame.origin.x - margin, 0);
    
    // 14 lineheigh 20
    debugLog(@"%@",comment.content);
    CGSize size = [comment.content sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(containerFrame.size.width, CGFLOAT_MAX) minimumLineHeight:6];
    self.contentLabelFrame = CGRectMake(0, 0 , containerFrame.size.width, size.height);
    
    if(comment.replied_content.length > 0) {
        // 12 lineheigh 17 最多2行
        NSString *combinedString = [NSString stringWithFormat:@"%@:%@", comment.replied_author.fullName, comment.replied_content];
        CGSize size = [combinedString sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(containerFrame.size.width - 7, CGFLOAT_MAX) minimumLineHeight:5];
        if(size.height > 34) {
            size.height = 34;
        }
        self.replayLabelFrame = CGRectMake(7, CGRectGetMaxY(self.contentLabelFrame) + 8, size.width, size.height);
    }else {
        self.replayLabelFrame = CGRectMake(7, CGRectGetMaxY(self.contentLabelFrame) , 0, 0);
    }
    
    containerFrame.size.height = CGRectGetMaxY(self.replayLabelFrame);
    self.containerFrame = containerFrame;
    
    self.separateFrame = CGRectMake(containerFrame.origin.x, CGRectGetMaxY(containerFrame) + 15, containerFrame.size.width, 0.5);
    
    self.cellHeight = CGRectGetMaxY(self.separateFrame) + 10;
}

@end
