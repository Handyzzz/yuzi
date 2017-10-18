//
//  WYPostOtherLinkView.m
//  Withyou
//
//  Created by Handyzzz on 2017/9/23.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYPostOtherLinkView.h"

@implementation WYPostOtherLinkView

-(UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [UIImageView new];
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(0);
            make.width.height.equalTo(80);
        }];
    }
    return _imageView;
}

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:16 weight:0.4];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).equalTo(8);
            make.top.equalTo(5);
            make.right.equalTo(-10);
        }];
    }
    return _titleLabel;
}

-(UILabel *)sourceLabel{
    if (_sourceLabel == nil) {
        _sourceLabel = [UILabel new];
        _sourceLabel.textColor = kRGB(153, 153, 153);
        _sourceLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:_sourceLabel];
        [_sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).equalTo(8);
            make.bottom.equalTo(-8);
        }];
    }
    return _sourceLabel;
}

@end
