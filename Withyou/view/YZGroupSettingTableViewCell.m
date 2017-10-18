//
//  YZGroupSettingTableViewCell.m
//  Withyou
//
//  Created by CH on 2017/6/10.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZGroupSettingTableViewCell.h"

@implementation YZGroupSettingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor whiteColor];
}


- (UILabel *)contentLb{
    if (_contentLb == nil) {
        _contentLb = [UILabel new];
        [self addSubview:_contentLb];
        
        _contentLb.textColor = UIColorFromHex(0x333333);
        _contentLb.font = [UIFont systemFontOfSize:15];
    }
    return _contentLb;
}

- (UIImageView *)iconIV{
    if (_iconIV == nil) {
        _iconIV = [UIImageView new];
        [self addSubview:_iconIV];
        
        _iconIV.clipsToBounds = YES;
        _iconIV.layer.cornerRadius = 30;
        _iconIV.contentMode = UIViewContentModeScaleAspectFill;
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(15);
            make.height.width.equalTo(60);
            make.left.equalTo(90);
        }];
    }
    return _iconIV;
}

- (UIButton *)exitButton{
    if (_exitButton == nil) {
        _exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_exitButton];
        _exitButton.clipsToBounds = YES;
        _exitButton.layer.cornerRadius = 2;
        _exitButton.backgroundColor = UIColorFromHex(0xF63E13);
        [_exitButton setTitle:@"退出群组" forState:UIControlStateNormal];
        [_exitButton setTitleColor:UIColorFromHex(0xffffff) forState:UIControlStateNormal];
        _exitButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _exitButton;
}

- (UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [UIView new];
        _lineView.backgroundColor = UIColorFromHex(0xf5f5f5);
        [self addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(0);
            make.height.equalTo(1);
            make.left.equalTo(15);
            make.right.equalTo(-15);
        }];
    }
    return _lineView;
}

@end
