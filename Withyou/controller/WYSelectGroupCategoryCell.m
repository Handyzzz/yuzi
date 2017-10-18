//
//  WYSelectGroupCategoryCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/1.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYSelectGroupCategoryCell.h"

@implementation WYSelectGroupCategoryCell

-(UIImageView *)iconIV{
    if (_iconIV == nil) {
        _iconIV = [UIImageView new];
        [self.contentView addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(15);
            make.width.height.equalTo(40);
        }];
    }
    return _iconIV;
}

-(UILabel *)nameLb{
    if (_nameLb == nil) {
        _nameLb = [UILabel new];
        _nameLb.textColor = kRGB(51, 51, 51);
        _nameLb.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).equalTo(10);
            make.centerY.equalTo(0);
        }];
    }
    return _nameLb;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
