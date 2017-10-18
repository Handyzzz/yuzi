//
//  WYPdfListCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/24.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYPdfListCell.h"

@implementation WYPdfListCell
/*
 cell高80
 */

-(UIImageView *)iconIV{
    if (_iconIV == nil) {
        _iconIV = [UIImageView new];
        [self.contentView addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(10);
            make.left.equalTo(10);
            make.width.height.equalTo(60);
        }];
    }
    return _iconIV;
}

-(UIView *)groundView{
    if (_groundView == nil) {
        _groundView = [UIView new];
        _groundView.backgroundColor = kRGB(245, 245, 245);
        [self.contentView addSubview:_groundView];
        [_groundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right);
            make.top.equalTo(10);
            make.right.equalTo(-15);
            make.height.equalTo(60);
        }];
    }
    return _groundView;
}

-(UILabel *)nameLb{
    if (_nameLb == nil) {
        _nameLb = [UILabel new];
        _nameLb.font = [UIFont systemFontOfSize:14];
        _nameLb.textColor = kRGB(51, 51, 51);
        [self.contentView addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).equalTo(8);
            make.centerY.equalTo(0);
            make.right.equalTo(self.groundView.mas_right).equalTo(-20);
        }];
    }
    return _nameLb;
}
-(void)setCellData:(YZPdf *)pdf{
    self.iconIV.image = [UIImage imageNamed:@"publish_big_pdf"];
    [self groundView];
    self.nameLb.text = pdf.name;
    
}

@end
