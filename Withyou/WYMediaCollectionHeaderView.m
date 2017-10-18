//
//  WYMediaCollectionHeaderView.m
//  Withyou
//
//  Created by Handyzzz on 2017/9/30.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYMediaCollectionHeaderView.h"

@implementation WYMediaCollectionHeaderView
-(UILabel *)titltLb{
    if (_titltLb == nil) {
        _titltLb = [UILabel new];
        _titltLb.font = [UIFont systemFontOfSize:20 weight:0.4];
        _titltLb.textColor = kRGB(51, 51, 51);
        [self addSubview:_titltLb];
        [_titltLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.centerY.equalTo(0);
        }];
    }
    return _titltLb;
}

-(UIButton *)moreBtn{
    if (_moreBtn == nil) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn addTarget:self action:@selector(moreMediaAction:) forControlEvents:UIControlEventTouchUpInside];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:kRGB(153, 153, 153) forState:UIControlStateNormal];
        [self addSubview:_moreBtn];
        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-15);
            make.centerY.equalTo(0);
        }];
    }
    return _moreBtn;
}

-(void)moreMediaAction:(UIButton *)sender{
    self.moreMediaClick();
}
@end
