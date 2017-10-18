//
//  WYBasicGroupHeaderView.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/28.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYBasicGroupHeaderView.h"

@implementation WYBasicGroupHeaderView

-(UIImageView *)backGroundView{
    if (_backGroundView == nil) {
        _backGroundView = [UIImageView new];
        [self addSubview:_backGroundView];
        [_backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(0);
            make.height.equalTo(200);
        }];
    }
    return _backGroundView;
}

-(CAGradientLayer*)blackLayer{
    if (_blackLayer == nil) {
        _blackLayer = [CAGradientLayer layer];
        _blackLayer.frame = CGRectMake(0, 130, kAppScreenWidth, 70);
        _blackLayer.colors = @[(__bridge id)UIColorFromRGBA(0x333333, 0).CGColor, (__bridge id)UIColorFromRGBA(0x000000, 0.28).CGColor];
        _blackLayer.locations  = @[@(0.0), @(1.0)];
        _blackLayer.startPoint = CGPointMake(0, 0);
        _blackLayer.endPoint = CGPointMake(0, 1.0);
        [self.backGroundView.layer addSublayer:_blackLayer];
    }
    return _blackLayer;
}

-(UILabel *)groupNameLb{
    if (_groupNameLb == nil) {
        _groupNameLb = [UILabel new];
        [self addSubview:_groupNameLb];
        
        _groupNameLb.textColor = [UIColor whiteColor];
        _groupNameLb.font = [UIFont systemFontOfSize:24];
        [_groupNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(143);
            make.left.equalTo(13);
            make.right.equalTo(-40);
        }];
        
    }
    return _groupNameLb;
}

-(UILabel *)groupInfoLb{
    if (_groupInfoLb == nil) {
        _groupInfoLb = [UILabel new];
        [self addSubview:_groupInfoLb];
        
        _groupInfoLb.textColor = [UIColor whiteColor];
        _groupInfoLb.font = [UIFont systemFontOfSize:24];
        _groupInfoLb.font = [UIFont systemFontOfSize:14];
        [_groupInfoLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(179);
            make.left.equalTo(15);
            make.right.equalTo(-40);
        }];
    }
    return _groupInfoLb;
}

-(UILabel *)introductionLb{
    if (_introductionLb == nil) {
        _introductionLb = [UILabel new];
        _introductionLb.font = [UIFont systemFontOfSize:14];
        _introductionLb.textColor = kRGB(51, 51, 51);
        _introductionLb.numberOfLines = 0;
        [self addSubview:_introductionLb];
        [_introductionLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.right.equalTo(-15);
            make.top.equalTo(self.backGroundView.mas_bottom).equalTo(8);
        }];
        
        UIView *view = [UIView new];
        [_introductionLb addSubview:view];
        view.backgroundColor = UIColorFromHex(0xf5f5f5);
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.bottom.equalTo(15);
            make.height.equalTo(1);
        }];
    }
    return _introductionLb;
}

-(UIView*)allIconView{
    if (_allIconView == nil) {
        _allIconView = [UIView new];
        [self addSubview:_allIconView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(memberClick)];
        [_allIconView addGestureRecognizer:tap];
        
        UIView *view = [UIView new];
        view.backgroundColor = UIColorFromHex(0xf5f5f5);
        [_allIconView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(8);
        }];
        
    }
    return _allIconView;
}

-(UILabel *)numberLable{
    if (_numberLable == nil) {
        _numberLable = [UILabel new];
        [self.allIconView addSubview:_numberLable];
        _numberLable.textAlignment = NSTextAlignmentRight;
        _numberLable.textColor = UIColorFromHex(0x999999);
        _numberLable.font = [UIFont systemFontOfSize:14];
        [_numberLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(27);
            make.right.equalTo(-35);
        }];
    }
    return _numberLable;
}


-(UIView *)categoryView{
    if (_categoryView == nil) {
        _categoryView = [UIView new];
        [self addSubview:_categoryView];
        [_categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.allIconView.mas_bottom);
            make.left.right.equalTo(0);
            make.height.equalTo(103);
        }];
        UIView *lineView = [UIView new];
        lineView.backgroundColor = kRGB(43, 161, 212);
        [_categoryView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(7);
            make.top.equalTo(14);
            make.width.equalTo(2);
            make.height.equalTo(14);
        }];
        
        UILabel *nameLb = [UILabel new];
        nameLb.text = @"群组类别";
        nameLb.font = [UIFont systemFontOfSize:14];
        nameLb.textColor = kRGB(153, 153, 153);
        [_categoryView addSubview:nameLb];
        [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(17);
            make.top.equalTo(14);
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = UIColorFromHex(0xf5f5f5);
        [_categoryView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(44);
            make.width.equalTo(kAppScreenWidth - 15);
            make.height.equalTo(1);
        }];
        
        _categoryLb = [UILabel new];
        _categoryLb.font = [UIFont systemFontOfSize:14];
        _categoryLb.textColor = kRGB(51, 51, 51);
        [_categoryView addSubview:_categoryLb];
        [_categoryLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(17);
            make.top.equalTo(63);
        }];
        
        UIView *backView = [UIView new];
        backView.backgroundColor = UIColorFromHex(0xf5f5f5);
        [_categoryView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(8);
        }];
    }
    return _categoryView;
}

-(UIView *)tagView{
    if (_tagView == nil) {
        _tagView = [UIView new];
        [self addSubview:_tagView];
        [_tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(0);
            make.left.right.equalTo(0);
            make.height.equalTo(103);
        }];
        UIView *lineView = [UIView new];
        lineView.backgroundColor = kRGB(43, 161, 212);
        [_tagView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(7);
            make.top.equalTo(14);
            make.width.equalTo(2);
            make.height.equalTo(14);
        }];
        
        UILabel *nameLb = [UILabel new];
        nameLb.text = @"群组标签";
        nameLb.font = [UIFont systemFontOfSize:14];
        nameLb.textColor = kRGB(153, 153, 153);
        [_tagView addSubview:nameLb];
        [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(17);
            make.top.equalTo(14);
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = UIColorFromHex(0xf5f5f5);
        [_tagView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(44);
            make.width.equalTo(kAppScreenWidth - 15);
            make.height.equalTo(1);
        }];
        
        _tagLb = [UILabel new];
        _tagLb.font = [UIFont systemFontOfSize:14];
        _tagLb.textColor = kRGB(51, 51, 51);
        [_tagView addSubview:_tagLb];
        [_tagLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(17);
            make.top.equalTo(63);
        }];
        
        UIView *backView = [UIView new];
        backView.backgroundColor = UIColorFromHex(0xf5f5f5);
        [_tagView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(8);
        }];
    }
    return _categoryView;
}

-(void)setUpView:(WYGroup *)group{
    
    CGFloat h = 0.0;
    if (group.introduction.length > 0) {
         CGFloat textHeight = [group.introduction sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(kAppScreenWidth - 30,MAXFLOAT)].height;
        CGRect frame = self.introductionLb.frame;
        frame.size.height = textHeight + 2;
        self.introductionLb.frame = frame;
        
        h = 199 + textHeight + 8 + 15 + 2;
        
        self.allIconView.frame = CGRectMake(0, h, kAppScreenWidth, 68 + 8);

    }else{
        h = 199 + 15;
        self.allIconView.frame = CGRectMake(0, h, kAppScreenWidth, 68 + 8);
    }
   
    //set Data
    
    [self.backGroundView sd_setImageWithURL:[NSURL URLWithString:group.group_icon]];
    self.backGroundView.contentMode = UIViewContentModeScaleAspectFill;
    self.backGroundView.clipsToBounds = YES;
    
    [self blackLayer];

    self.groupNameLb.text = group.name;
    if ([group.public_visible boolValue]) {
        self.groupInfoLb.text = [NSString stringWithFormat:@"公开群   群号 %@",group.number];
    }else{
        self.groupInfoLb.text = [NSString stringWithFormat:@"私密群   群号 %@",group.number];
    }
    self.numberLable.text = @(group.member_num).stringValue;
    if (group.introduction.length > 0) {
        self.introductionLb.text = group.introduction;
    }
    
    
    UIImageView *lastIcon;
    CGFloat iconWidth = 38;
    NSInteger count = group.partial_member_list.count <= 5 ? group.partial_member_list.count : 5;
    for (int i= 0; i < count; i++) {
        WYUser*user = group.partial_member_list[i];
        UIImageView *icon = [UIImageView new];
        icon.layer.cornerRadius = iconWidth*0.5;
        icon.clipsToBounds = YES;
        [icon sd_setImageWithURL:[NSURL URLWithString:user.icon_url]];
        [_allIconView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(15);
            make.height.equalTo(iconWidth);
            make.width.equalTo(iconWidth);
            if (i == 0) {
                make.left.equalTo(15);
            }else{
                make.left.equalTo(lastIcon.mas_right).equalTo(8);
            }
        }];
        lastIcon = icon;
    }
    
    if (group.category_name.length > 0) {
        [self categoryView];
    
        self.categoryLb.text = group.category_name;
    }
    
    if (group.tags.length > 0) {
        [self tagView];
        self.tagLb.text = group.tagsString;
    }
}



+(CGFloat)calculateHeaderHeight:(WYGroup *)group{
    
    CGFloat height = 0.0;

    if (group.introduction.length > 0) {
        CGFloat textHeight = [group.introduction sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(kAppScreenWidth - 30, MAXFLOAT)].height;
        height = 199 + textHeight + 8 + 15 + 2;
    }else{
        height = 199 + 15;
    }
    height = height + 76;

    if (group.category_name.length > 0) {
        height = height + 103;
    }
    
    if (group.tags.length > 0) {
        height = height + 103;
    }

    return height;
}
-(void)memberClick{
    if(self.memberViewClick) {
        self.memberViewClick();
    }
}

@end
