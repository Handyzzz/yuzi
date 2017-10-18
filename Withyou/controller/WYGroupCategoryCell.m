//
//  WYGroupCategoryCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/29.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYGroupCategoryCell.h"
#import "EdgeInsetsLabel.h"
#define iconWH 40
#define Kcolor1 kRGB(43, 161, 212)
#define Kcolor2 kRGB(75, 201, 172)
#define Kcolor3 kRGB(255, 160, 138)

//cell高度 125
@implementation WYGroupCategoryCell


-(UILabel *)nameLb{
    if (_nameLb == nil) {
        _nameLb = [UILabel new];
        _nameLb.font = [UIFont systemFontOfSize:18 weight:0.4];
        _nameLb.textColor = kRGB(51, 51, 51);
        [self.contentView addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(15);
        }];
    }
    return _nameLb;
}

-(UILabel *)memberCountLb{
    if (_memberCountLb == nil) {
        _memberCountLb = [UILabel new];
        _memberCountLb.font = [UIFont systemFontOfSize:12];
        _memberCountLb.textColor = kRGB(153, 153, 153);
        [self.contentView addSubview:_memberCountLb];
        [_memberCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(39);
        }];
    }
    return _memberCountLb;
}

-(UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [UIView new];
        _lineView.backgroundColor = kRGB(223, 223, 223);
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(40);
            make.left.equalTo(self.memberCountLb.mas_right).equalTo(6);
            make.width.equalTo(1);
            make.height.equalTo(10);
        }];
    }
    return _lineView;
}


-(UILabel *)postCountLb{
    if (_postCountLb == nil) {
        _postCountLb = [UILabel new];
        _postCountLb.font = [UIFont systemFontOfSize:12];
        _postCountLb.textColor = kRGB(153, 153, 153);
        [self.contentView addSubview:_postCountLb];
        [_postCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lineView.mas_right).equalTo(6);
            make.top.equalTo(39);
        }];
    }
    return _postCountLb;
}

-(UIButton *)applyBtn{
    if (_applyBtn == nil) {
        _applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _applyBtn.layer.cornerRadius = 4;
        _applyBtn.clipsToBounds = YES;
        _applyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_applyBtn addTarget:self action:@selector(applyGroupAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_applyBtn];
        [_applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(19);
            make.right.equalTo(-14);
            make.width.equalTo(56);
            make.height.equalTo(28);
        }];
    }
    return _applyBtn;
}

-(UIImageView *)backIV{
    if (_backIV == nil) {
        _backIV = [UIImageView new];
        _backIV.image = [UIImage imageNamed:@"groupHeadbackground"];
        [self.contentView addSubview:_backIV];
        [_backIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(11);
            make.top.equalTo(57);
            make.width.height.equalTo(50);
        }];
    }
    
    return _backIV;
}

-(UIImageView *)iconIV{
    if (_iconIV == nil) {
        _iconIV = [UIImageView new];
        _iconIV.layer.cornerRadius = iconWH/2.0;
        _iconIV.clipsToBounds = YES;
        [self.backIV addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(5);
            make.top.equalTo(5);
            make.width.height.equalTo(iconWH);
        }];
    }
    return _iconIV;
}

-(UILabel *)desLb{
    if (_desLb == nil) {
        _desLb = [UILabel new];
        _desLb.font = [UIFont systemFontOfSize:14];
        _desLb.textColor = kRGB(102, 102, 102);
        _desLb.numberOfLines = 0;
        [self.contentView addSubview:_desLb];
        [_desLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).equalTo(9);
            make.right.equalTo(-22);
            make.top.equalTo(62);
            make.height.equalTo(40);
        }];
    }
    return _desLb;
}

-(UIView*)tagView{
    if (_tagView == nil) {
        _tagView = [UIView new];
        [self.contentView addSubview:_tagView];
        [_tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.top.equalTo(self.iconIV.mas_bottom).equalTo(11);
            make.height.equalTo(20);
        }];
    }
    return _tagView;
}

-(UIView*)line{
    if (_line == nil) {
        _line = [UIView new];
        _line.backgroundColor = UIColorFromHex(0xf5f5f5);
        [self.contentView addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.bottom.equalTo(0);
            make.height.equalTo(1);
        }];
    }
    return _line;
}

-(void)setUpTagView:(WYRecommendGroup*)recommendGroup{
    NSArray *colorArr = @[Kcolor1,Kcolor2,Kcolor3];
    NSArray *tagsArr = [recommendGroup.tags componentsSeparatedByString:@","];
    
    UILabel *lastLb;
    for (int i = 0; i < tagsArr.count; i ++) {
        NSString *str = tagsArr[i];
        EdgeInsetsLabel *label = [EdgeInsetsLabel new];
        label.layer.borderWidth = 1;
        label.layer.borderColor = [colorArr[i] CGColor];
        label.layer.cornerRadius = 4;
        label.layer.masksToBounds = YES;
        label.edgeInsets = UIEdgeInsetsMake(4, 4, 4, 4); // 设置内边距
        label.textColor = colorArr[i];
        label.font = [UIFont systemFontOfSize:11];
        [label sizeToFit]; // 重新计算尺寸
        label.text = str;
       
        [self.tagView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconIV.mas_bottom).equalTo(11);
            if (i == 0) {
                make.left.equalTo(15);
            }else{
                make.left.equalTo(lastLb.mas_right).equalTo(10);
            }
        }];
        lastLb = label;
    }
}

-(void)setUpCellDetail:(WYRecommendGroup *)recommendGroup{
    self.nameLb.text = recommendGroup.name;
    self.memberCountLb.text = [NSString stringWithFormat:@"%d个群成员",recommendGroup.member_num];
    self.postCountLb.text = [NSString stringWithFormat:@"%d个帖子",recommendGroup.post_num];
    if (recommendGroup.able_to_apply == YES) {
        [self.applyBtn setTitle:@"申请加入" forState:UIControlStateNormal];
        self.applyBtn.backgroundColor = kRGB(43, 161, 212);
        [_applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.applyBtn.layer.borderWidth = 0;
        self.applyBtn.layer.borderColor = [UIColor clearColor].CGColor;
        self.applyBtn.enabled = YES;
    }else{
        [self.applyBtn setTitle:@"已申请" forState:UIControlStateNormal];
        self.applyBtn.backgroundColor = [UIColor whiteColor];
        [_applyBtn setTitleColor:kRGB(197, 197, 197) forState:UIControlStateNormal];
        self.applyBtn.layer.borderWidth = 1;
        self.applyBtn.layer.borderColor = kRGB(197, 197, 197).CGColor;
        self.applyBtn.enabled = NO;
    }
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:recommendGroup.group_icon]];
    self.desLb.text = recommendGroup.introduction;
    

    if (recommendGroup.tags.length > 0) {
        self.tagView.hidden = NO;
        [self setUpTagView:recommendGroup];
    }else{
        self.tagView.hidden = YES;
    }
    [self line];
}

-(void)applyGroupAction{
    self.applyGroupClick();
}

@end
