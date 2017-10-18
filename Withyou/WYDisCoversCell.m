//
//  WYDisCoversCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/9/12.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYDisCoversCell.h"

@implementation WYDisCoversCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        _iconIV = [UIImageView new];
        [self.contentView addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.centerY.equalTo(0);
        }];
        
        _titleLb = [UILabel new];
        _titleLb.font = [UIFont systemFontOfSize:16];
        _titleLb.textColor = kRGB(51, 51, 51);
        [self.contentView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconIV.mas_right).equalTo(10);
            make.centerY.equalTo(0);
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = UIColorFromHex(0xf5f5f5);
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.width.equalTo(kAppScreenWidth);
            make.height.equalTo(1);
            make.bottom.equalTo(0);
        }];
    }
    return self;
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
