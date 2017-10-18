//
//  WYGroupCategoryListCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/29.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYGroupCategoryListCell.h"
#define itemWH ((kAppScreenWidth - (12 * 2 + 3 * 4))/3.0)

@implementation WYGroupCategoryListCell

-(UIImageView*)backIV{
    if (_backIV == nil) {
        _backIV = [UIImageView new];
        [self.contentView addSubview:_backIV];
        [_backIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return _backIV;
}

-(UILabel *)nameLb{
    if (_nameLb == nil) {
        _nameLb = [UILabel new];
        _nameLb.font = [UIFont systemFontOfSize:16 weight:0.4];
        _nameLb.textColor = [UIColor whiteColor];
        _nameLb.textAlignment = NSTextAlignmentCenter;

        [self.contentView addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(0);
            make.height.equalTo(40);
            //四个加粗的字 大于4个字 小于5个字
            make.left.equalTo(20);
            make.right.equalTo(-20);
        }];
    }
    return _nameLb;
}

@end
