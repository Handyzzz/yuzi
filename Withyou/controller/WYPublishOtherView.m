
//
//  WYPublishOtheerView.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/12.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYPublishOtherView.h"

@interface WYPublishOtherView()

@end
@implementation WYPublishOtherView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //范围
        UIView *viewOfVisiableRange = [UIView new];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectScopeSecondTime)];
        [viewOfVisiableRange addGestureRecognizer:tap];
        [self addSubview:viewOfVisiableRange];
        viewOfVisiableRange.layer.borderWidth = 1;
        viewOfVisiableRange.layer.borderColor = UIColorFromHex(0xf5f5f5).CGColor;
        [viewOfVisiableRange mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(-1);
            make.left.equalTo(-1);
            make.width.equalTo(kAppScreenWidth + 2);
            make.height.equalTo(51);
        }];
        
        
        UIImageView *imgView = [UIImageView new];
        [viewOfVisiableRange addSubview:imgView];
        imgView.image = [UIImage imageNamed:@"publish_cell_right"];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.right.equalTo(-11);
            make.width.equalTo(14);
        }];
        
        UIImageView *visiableleftIV = [UIImageView new];
        visiableleftIV.image = [UIImage imageNamed:@"Publish page_album_visible"];
        [viewOfVisiableRange addSubview:visiableleftIV];
        [visiableleftIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.centerY.equalTo(0);
            make.width.equalTo(20);
        }];
        
        UILabel *visiableleftLb = [UILabel new];
        visiableleftLb.textColor = UIColorFromHex(0xc5c5c5);
        visiableleftLb.font = [UIFont systemFontOfSize:15 weight:0.23];
        visiableleftLb.text = @"可见范围";
        [viewOfVisiableRange addSubview:visiableleftLb];
        [visiableleftLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(visiableleftIV.mas_right).equalTo(8);
            make.centerY.equalTo(0);
            make.width.equalTo(80);
            
        }];
        
        _rangeLabel = [UILabel new];
        _rangeLabel.textAlignment = NSTextAlignmentRight;
        _rangeLabel.textColor = UIColorFromHex(0x333333);
        _rangeLabel.font = [UIFont systemFontOfSize:15];
        [viewOfVisiableRange addSubview:_rangeLabel];
        [_rangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(visiableleftLb.mas_right).equalTo(10);
            make.right.equalTo(imgView.mas_left).equalTo(-3);
            make.centerY.equalTo(0);
        }];
        
        //标签
        UIView *viewOfTags = [UIView new];
        UITapGestureRecognizer *tapimgViewOfTags = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tagsAction)];
        [viewOfTags addGestureRecognizer:tapimgViewOfTags];
        [self addSubview:viewOfTags];
        viewOfTags.layer.borderWidth = 1;
        viewOfTags.layer.borderColor = UIColorFromHex(0xf5f5f5).CGColor;
        [viewOfTags mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(viewOfVisiableRange.mas_bottom).equalTo(-1);
            make.left.equalTo(-1);
            make.width.equalTo(kAppScreenWidth + 2);
            make.height.equalTo(51);
        }];
        
        
        UIImageView *imgViewOfTags = [UIImageView new];
        [viewOfTags addSubview:imgViewOfTags];
        imgViewOfTags.image = [UIImage imageNamed:@"publish_cell_right"];
        [imgViewOfTags mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.right.equalTo(-11);
            make.width.equalTo(14);
        }];
        
        UIImageView *visiableleftIVOfTags = [UIImageView new];
        visiableleftIVOfTags.image = [UIImage imageNamed:@"publishTag"];
        [viewOfTags addSubview:visiableleftIVOfTags];
        [visiableleftIVOfTags mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(visiableleftIV);
            make.centerY.equalTo(0);
        }];
        
        UILabel *leftLbOfTags = [UILabel new];
        leftLbOfTags.textColor = UIColorFromHex(0xc5c5c5);
        leftLbOfTags.font = [UIFont systemFontOfSize:15 weight:0.23];
        leftLbOfTags.text = @"帖子标签";
        [viewOfTags addSubview:leftLbOfTags];
        [leftLbOfTags mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(visiableleftIV.mas_right).equalTo(8);
            make.centerY.equalTo(0);
            make.width.equalTo(80);
            
        }];
        
        _tagsLabel = [UILabel new];
        _tagsLabel.textAlignment = NSTextAlignmentRight;
        _tagsLabel.textColor = UIColorFromHex(0x333333);
        _tagsLabel.font = [UIFont systemFontOfSize:15];
        [viewOfTags addSubview:_tagsLabel];
        [_tagsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(visiableleftLb.mas_right).equalTo(10);
            make.right.equalTo(imgView.mas_left).equalTo(-3);
            make.centerY.equalTo(0);
        }];

        //地址
        UIView *viewOfLocation = [UIView new];
        UITapGestureRecognizer *tapimgViewOfLocation = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locationAction)];
        [viewOfLocation addGestureRecognizer:tapimgViewOfLocation];
        [self addSubview:viewOfLocation];
        viewOfLocation.layer.borderWidth = 1;
        viewOfLocation.layer.borderColor = UIColorFromHex(0xf5f5f5).CGColor;
        [viewOfLocation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(viewOfTags.mas_bottom).equalTo(-1);
            make.left.equalTo(-1);
            make.width.equalTo(kAppScreenWidth + 2);
            make.height.equalTo(51);
        }];
        
        
        UIImageView *imgViewOfLocation = [UIImageView new];
        [viewOfLocation addSubview:imgViewOfLocation];
        imgViewOfLocation.image = [UIImage imageNamed:@"publish_cell_right"];
        [imgViewOfLocation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.right.equalTo(-11);
            make.width.equalTo(14);
        }];
        
        UIImageView *visiableleftIVOfLocation = [UIImageView new];
        visiableleftIVOfLocation.image = [UIImage imageNamed:@"Publish page_location"];
        [viewOfLocation addSubview:visiableleftIVOfLocation];
        [visiableleftIVOfLocation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(visiableleftIV);
            make.centerY.equalTo(0);
        }];
        
        UILabel *leftLbOfLocation = [UILabel new];
        leftLbOfLocation.textColor = UIColorFromHex(0xc5c5c5);
        leftLbOfLocation.font = [UIFont systemFontOfSize:15 weight:0.23];
        leftLbOfLocation.text = @"所在位置";
        [viewOfLocation addSubview:leftLbOfLocation];
        [leftLbOfLocation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(visiableleftIV.mas_right).equalTo(8);
            make.centerY.equalTo(0);
            make.width.equalTo(80);
            
        }];
        _locationLabel = [UILabel new];
        _locationLabel.textAlignment = NSTextAlignmentRight;
        _locationLabel.textColor = UIColorFromHex(0x333333);
        _locationLabel.font = [UIFont systemFontOfSize:15];
        [viewOfLocation addSubview:_locationLabel];
        [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(visiableleftLb.mas_right).equalTo(10);
            make.right.equalTo(imgView.mas_left).equalTo(-3);
            make.centerY.equalTo(0);
        }];
        
        //提及
        UIView *viewOfRemind = [UIView new];
        UITapGestureRecognizer *tapimgViewOfRemind = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(remindAction)];
        [viewOfRemind addGestureRecognizer:tapimgViewOfRemind];
        [self addSubview:viewOfRemind];
        viewOfRemind.layer.borderWidth = 1;
        viewOfRemind.layer.borderColor = UIColorFromHex(0xf5f5f5).CGColor;
        [viewOfRemind mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(viewOfLocation.mas_bottom).equalTo(-1);
            make.left.equalTo(-1);
            make.width.equalTo(kAppScreenWidth + 2);
            make.height.equalTo(51);
        }];
        
        
        UIImageView *imgViewOfRemind = [UIImageView new];
        [viewOfRemind addSubview:imgViewOfRemind];
        imgViewOfRemind.image = [UIImage imageNamed:@"publish_cell_right"];
        [imgViewOfRemind mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.right.equalTo(-11);
            make.width.equalTo(14);
        }];
        
        UIImageView *leftIVOfRemind = [UIImageView new];
        leftIVOfRemind.image = [UIImage imageNamed:@"combinedShape"];
        [viewOfRemind addSubview:leftIVOfRemind];
        [leftIVOfRemind mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(visiableleftIV);
            make.centerY.equalTo(0);
        }];
        
        UILabel *leftLbOfRemind = [UILabel new];
        leftLbOfRemind.textColor = UIColorFromHex(0xc5c5c5);
        leftLbOfRemind.font = [UIFont systemFontOfSize:15 weight:0.23];
        leftLbOfRemind.text = @"与谁一起";
        [viewOfRemind addSubview:leftLbOfRemind];
        [leftLbOfRemind mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(visiableleftIV.mas_right).equalTo(8);
            make.centerY.equalTo(0);
            make.width.equalTo(80);
        }];
        
        _remindLabel = [UILabel new];
        _remindLabel.textAlignment = NSTextAlignmentRight;
        _remindLabel.textColor = UIColorFromHex(0x333333);
        _remindLabel.font = [UIFont systemFontOfSize:15];
        [viewOfRemind addSubview:_remindLabel];
        [_remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(visiableleftLb.mas_right).equalTo(10);
            make.right.equalTo(imgView.mas_left).equalTo(-3);
            make.centerY.equalTo(0);
        }];
    }
    return self;
}

-(void)selectScopeSecondTime{
    self.visiableRangeViewClick();
}

-(void)tagsAction{
    self.tagsClick();
}

-(void)locationAction{
    self.LocationClick();
}

-(void)remindAction{
    self.remindClick();
}

@end
