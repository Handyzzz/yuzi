//
//  WYUserChangeIconView.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/14.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYUserChangeIconView.h"
#define itemH 50.f
#define margin 8.f
@implementation WYUserChangeIconView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        self.backgroundColor = [UIColor blackColor];
        
        _iconIV = [UIImageView new];
        _iconIV.contentMode = UIViewContentModeScaleAspectFit;
        _iconIV.clipsToBounds = YES;
        [self addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(0);
            make.height.equalTo(kAppScreenHeight - 4*itemH - margin);
        }];
        
        UILabel *msgLb = [UILabel new];
        msgLb.font = [UIFont systemFontOfSize:15];
        msgLb.textColor = UIColorFromHex(0x999999);
        msgLb.backgroundColor = [UIColor whiteColor];
        msgLb.textAlignment = NSTextAlignmentCenter;
        msgLb.text = @"更换头像";
        [self addSubview:msgLb];
        [msgLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(_iconIV.mas_bottom).equalTo(0);
            make.height.equalTo(itemH);
        }];
        
        _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraBtn addTarget:self action:@selector(cameraAction) forControlEvents:UIControlEventTouchUpInside];
        _cameraBtn.layer.borderColor = UIColorFromHex(0xf5f5f5).CGColor;
        _cameraBtn.layer.borderWidth = 0.5;
        _cameraBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cameraBtn setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
        [_cameraBtn setTitle:@"相机" forState:UIControlStateNormal];
        _cameraBtn.backgroundColor = [UIColor whiteColor];
        [self addSubview:_cameraBtn];
        [_cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(-0.5);
            make.right.equalTo(0.5);
            make.top.equalTo(msgLb.mas_bottom).equalTo(0);
            make.height.equalTo(itemH);
        }];
        
        _albumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_albumBtn addTarget:self action:@selector(albumAction) forControlEvents:UIControlEventTouchUpInside];
        [_albumBtn setTitle:@"相册" forState:UIControlStateNormal];
        [_albumBtn setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
        _albumBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _albumBtn.backgroundColor = [UIColor whiteColor];
        [self addSubview:_albumBtn];
        [_albumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(_cameraBtn.mas_bottom).equalTo(0);
            make.height.equalTo(itemH);
        }];
        
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = UIColorFromHex(0xf5f5f5);
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(_albumBtn.mas_bottom).equalTo(0);
            make.height.equalTo(margin);
        }];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.top.equalTo(lineView.mas_bottom).equalTo(0);
        }];
    }
    return self;
}

-(void)tapAction{
    [self removeFromSuperview];
}

-(void)cameraAction{
    self.cameraClick();
}

-(void)albumAction{
    self.albumClick();
}

-(void)cancelAction{
    [self removeFromSuperview];
}
@end
