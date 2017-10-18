
//
//  WYMyAttentionTagListCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/9/2.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYMyAttentionTagListCell.h"

@implementation WYMyAttentionTagListCell

-(UIImageView *)iconIV{
    if (_iconIV == nil) {
        _iconIV = [UIImageView new];
        [self.contentView addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(10);
        }];
    }
    return _iconIV;
}

-(UILabel *)tagNameLb{
    if (_tagNameLb == nil) {
        _tagNameLb = [UILabel new];
        _tagNameLb.textColor = UIColorFromHex(0x333333);
        _tagNameLb.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_tagNameLb];
        [_tagNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).equalTo(6);
            make.centerY.equalTo(self.iconIV);
        }];
    }
    return _tagNameLb;
}

-(UILabel *)updateCountLb{
    if (_updateCountLb == nil) {
        _updateCountLb = [UILabel new];
        _updateCountLb.textColor = kRGB(43, 161, 212);
        _updateCountLb.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_updateCountLb];
        [_updateCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
            
        }];
    }
    return _updateCountLb;
}

-(UIView *)line{
    if (_line == nil) {
        _line = [UIView new];
        _line.backgroundColor = UIColorFromHex(0xf5f5f5);
        [self.contentView addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.bottom.equalTo(0);
            make.width.equalTo(kAppScreenWidth);
            make.height.equalTo(1);
        }];
    }
    return _line;
}

-(void)setCellDetai:(NSDictionary *)dic{
    if ([[dic objectForKey:@"pro"] boolValue] == YES) {
        self.iconIV.image = [UIImage imageNamed:@"followeingtagHighlight"];
    }else{
        self.iconIV.image = [UIImage imageNamed:@"followeingtag"];
    }
    self.tagNameLb.text = [dic objectForKey:@"name"];
    [self line];
}

@end
