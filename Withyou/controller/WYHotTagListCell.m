//
//  WYHotTagListCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/9/1.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYHotTagListCell.h"

@interface WYHotTagListCell ()

@end

@implementation WYHotTagListCell

-(void)setUpCellDetail:(NSDictionary *)dic img:(NSString *)img{
    _singleView = [[WYsingleHotTagView alloc]initWithTagName:dic backImg:img];
    [self.contentView addSubview:_singleView];
    [_singleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.left.right.equalTo(0);
        make.height.equalTo(46);
    }];
}

@end
