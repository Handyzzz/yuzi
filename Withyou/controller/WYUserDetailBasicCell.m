//
//  WYUserDetailBasicCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/5/22.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYUserDetailBasicCell.h"
//30
@implementation WYUserDetailBasicCell
-(UILabel *)titleLb{
    if (_titleLb == nil) {
        _titleLb = [UILabel new];
        _titleLb.font = [UIFont systemFontOfSize:14];
        _titleLb.textColor = UIColorFromHex(0x333333);
        [self.contentView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(0);
        }];
    }
    return _titleLb;
}

-(UILabel *)contentLb{
    if (_contentLb == nil) {
        _contentLb = [UILabel new];
        _contentLb.numberOfLines = 0;
        _contentLb.textColor = UIColorFromHex(0x333333);
        _contentLb.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_contentLb];
        [_contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.equalTo(80);
            make.right.equalTo(-20);
        }];
    }
    return _contentLb;
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
