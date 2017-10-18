//
//  WYDocumentLiabaryCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/22.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYDocumentLiabaryCell.h"

@implementation WYDocumentLiabaryCell
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
            make.right.equalTo(self.preViewBtn.mas_left).equalTo(-20);
        }];
    }
    return _nameLb;
}

-(UIButton *)preViewBtn{
    if (_preViewBtn == nil) {
        _preViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _preViewBtn.backgroundColor = UIColorFromHex(0x2BA1D4);
        [_preViewBtn setTitle:@"预览" forState:UIControlStateNormal];
        [_preViewBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        _preViewBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_preViewBtn addTarget:self action:@selector(preViewAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_preViewBtn];
        [_preViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-30);
            make.top.equalTo(25);
            make.height.equalTo(30);
            make.width.equalTo(60);
        }];
    }
    return _preViewBtn;
}

-(void)preViewAction{
    self.preViewClick();
}

-(void)setCellData:(YZPdf *)pdf{
    self.iconIV.image = [UIImage imageNamed:@"publish_big_pdf"];
    [self groundView];
    self.nameLb.text = pdf.name;
    [self preViewBtn];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (!self.editing) {
        return;
    }
    [super setSelected:selected animated:animated];
    
    if (self.editing) {
        //这两个必须要写
        self.selectedBackgroundView = [UIView new];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.nameLb.backgroundColor = [UIColor clearColor];
        self.groundView.backgroundColor = kRGB(245, 245, 245);
        self.iconIV.backgroundColor = [UIColor clearColor];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    return;
}

@end
