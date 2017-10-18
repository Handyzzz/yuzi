//
//  ClassifyCollectionViewCell.m
//  Withyou
//
//  Created by 夯大力 on 2017/2/23.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYClassifyCollectionViewCell.h"

@interface WYClassifyCollectionViewCell ()<UIGestureRecognizerDelegate>

@end
@implementation WYClassifyCollectionViewCell


-(UILabel*)classifyLb{
    if (_classifyLb == nil) {
        _classifyLb = [UILabel new];
        [self.contentView addSubview:_classifyLb];
        [_classifyLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(0);
            make.height.equalTo(40);
            //四个加粗的字 大于4个字 小于5个字
            make.width.equalTo(70);
        }];
        _classifyLb.numberOfLines = 0;
        _classifyLb.textAlignment = NSTextAlignmentCenter;
        _classifyLb.font = [UIFont systemFontOfSize:14];
        _classifyLb.textColor = kRGB(140, 149, 153);
    }
    return _classifyLb;
}
-(UIView *)leftLineView{
    if (_leftLineView == nil) {
        _leftLineView = [UIView new];
        _leftLineView.backgroundColor = kRGB(192, 212, 220);
        [self.contentView addSubview:_leftLineView];
        [_leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.left.equalTo(-0.5);
            make.width.equalTo(1);
            make.height.equalTo(16);
        }];
    }
    return _leftLineView;
}


-(UIView*)classifyIV{
    if (_classifyIV == nil) {
        _classifyIV = [UIView new];
        _classifyIV.layer.cornerRadius = 2;
        _classifyIV.clipsToBounds = YES;
        _classifyIV.backgroundColor = UIColorFromHex(0x333333);
        [self.contentView addSubview:_classifyIV];
        [_classifyIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(0);
            make.centerX.equalTo(0);
            make.width.equalTo(24);
            make.height.equalTo(4);
        }];
    }
    return _classifyIV;
}
@end
