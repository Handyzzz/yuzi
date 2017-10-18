//
//  WYGroupDetailView.m
//  Withyou
//
//  Created by Handyzzz on 2017/4/1.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYGroupDetailView.h"
#import "UIImage+WYUtils.h"
#import "WYPopUpTextView.h"

@implementation WYGroupDetailView

-(UILabel *)groupNameLb{
    if (_groupNameLb == nil) {
        _groupNameLb = [UILabel new];
        [self addSubview:_groupNameLb];
        
        _groupNameLb.textColor = [UIColor whiteColor];
        _groupNameLb.font = [UIFont systemFontOfSize:24];
        [_groupNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(144);
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
        _groupInfoLb.font = [UIFont systemFontOfSize:14];
        [_groupInfoLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(179);
            make.left.equalTo(15);
            make.right.equalTo(-40);
        }];
    }
    return _groupInfoLb;
}

-(UIScrollView*)allIconSV{
    if (_allIconSV == nil) {
        _allIconSV = [UIScrollView new];
        [self addSubview:_allIconSV];
        _allIconSV.showsHorizontalScrollIndicator = NO;
    }
    return _allIconSV;
}

-(UILabel *)numberLable{
    if (_numberLable == nil) {
        _numberLable = [UILabel new];
        [self addSubview:_numberLable];        
        _numberLable.textAlignment = NSTextAlignmentRight;
        _numberLable.textColor = UIColorFromHex(0x999999);
        _numberLable.font = [UIFont systemFontOfSize:14];
    }
    return _numberLable;
}

-(UIButton *)inviteButton{
    if (_inviteButton == nil) {
        _inviteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_inviteButton];
    }
    return _inviteButton;
}


- (UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [UIButton buttonWithType:UIButtonTypeCustom];
        _lineView.backgroundColor = UIColorFromHex(0xf2f2f2);
        [self addSubview:_lineView];
    }
    return _lineView;
}

- (UIView *)shareView{
    if (_shareView == nil) {
        _shareView = [UIView new];
        _headLineView = [UIView new];
        _headLineView.backgroundColor = UIColorFromHex(0xf5f5f5);
        [_shareView addSubview:_headLineView];
        [_headLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(0);
            make.height.equalTo(8);
        }];
        
        _shareLineView = [UIView new];
        _shareLineView.backgroundColor = UIColorFromHex(0xf5f5f5);
        [_shareView addSubview:_shareLineView];
        [_shareLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.bottom.equalTo(0);
            make.height.equalTo(8);
        }];
        
        _myIcon = [UIImageView new];
        _myIcon.userInteractionEnabled = YES;
        _myIcon.layer.cornerRadius = 16;
        _myIcon.clipsToBounds = YES;
        [_shareView addSubview:_myIcon];
        [_myIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(23);
            make.height.width.equalTo(32);
        }];
        
        _shareTitleLabel = [UILabel new];
        [_shareView addSubview:_shareTitleLabel];
//        _shareTitleLabel.textColor = kRGB(51, 51, 51);
        _shareTitleLabel.textColor = UIColorFromHex(0x666666);
        
        _shareTitleLabel.font = [UIFont systemFontOfSize:14];
        [_shareTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(55);
            make.top.equalTo(32);
            make.width.equalTo(200);
        }];
        
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setBackgroundImage:[UIImage imageNamed:@"groupPageEdit"] forState:UIControlStateNormal];
        [_shareView addSubview:_shareButton];
        [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-24);
            make.top.equalTo(26);
            make.width.equalTo(20);
            make.height.equalTo(24);
        }];
    }
    return _shareView;
}
- (UILabel *)descLabel {
    if(_descLabel == nil) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descLabel.numberOfLines = 0;
        _descLabel.font = [UIFont systemFontOfSize:14];
        _descLabel.textColor = kRGB(51, 51, 51);
        [self addSubview:_descLabel];
        
    }
    return _descLabel;
}

-(UIView *)categoryView{
    if (_categoryView == nil) {
        _categoryView = [UIView new];
        [self addSubview:_categoryView];
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

- (UILabel *)applyLabel {
    if(!_applyLabel) {
        _applyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _applyLabel.numberOfLines = 0;
        _applyLabel.textColor = kRGB(246, 62, 19);
        _applyLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_applyLabel];
        [_applyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.right.equalTo(-10);
            make.bottom.equalTo(-57-30);
        }];
    }
    return _applyLabel;
}

- (UIButton *)applyBtn {
    if(!_applyBtn) {
        _applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _applyBtn.backgroundColor = UIColorFromHex(0x2BA1D4);
        [_applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _applyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_applyBtn addTarget:self action:@selector(applyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_applyBtn];
        [_applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
	        make.left.right.equalTo(0);
            make.bottom.equalTo(-30);
            make.height.equalTo(49);
        }];
    }
    return _applyBtn;
}

- (id)initWithGroup:(WYGroup *)group {
    if(self = [super initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 0)]) {
        [self setup:group];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setup:(WYGroup *)group {
    CGFloat height = 345;

    if ([group.public_visible boolValue]) {
        self.groupInfoLb.text = [NSString stringWithFormat:@"公开群   群号%@",group.number];
    }else{
        self.groupInfoLb.text = [NSString stringWithFormat:@"私密群   群号%@",group.number];
    }
    self.groupNameLb.text = group.name;
    
   
    if ([group meIsMemberOfGroupFromPartialMemberList]) {
        
        CGFloat marginBetweenIcon = 8;
        CGFloat marginOfEdge = 15;
        [self addSubview:self.shareView];
        [_shareView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.bottom.equalTo(0);
            make.height.equalTo(78);
        }];
        
        //设置群成员数据
        float iconWidth = 38;
        NSMutableArray *allArr = [NSMutableArray array];
        [allArr addObjectsFromArray:group.partial_member_list];
        
        NSUInteger count = allArr.count;
        if (count > 5) {
            count = 5;
        }
        CGFloat allWidth = (iconWidth+marginBetweenIcon)*count+ marginOfEdge;
        self.allIconSV.contentSize = CGSizeMake(allWidth, iconWidth);
        [self.allIconSV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(200);
            make.height.equalTo(marginOfEdge * 2 + iconWidth);
            make.width.equalTo(allWidth);
        }];
        UIImageView *lastIcon;
        
        for (int i= 0; i< count; i++) {
            WYUser*user = allArr[i];
            UIImageView *icon = [UIImageView new];
            icon.userInteractionEnabled = YES;
            icon.layer.cornerRadius = iconWidth*0.5;
            icon.clipsToBounds = YES;
            [icon sd_setImageWithURL:[NSURL URLWithString:user.icon_url]];
            [self.allIconSV addSubview:icon];
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo((68 - iconWidth ) * 0.5);
                make.height.equalTo(iconWidth);
                make.width.equalTo(iconWidth);
                if (i == 0) {
                    make.left.equalTo(marginOfEdge);
                }else{
                    make.left.equalTo(lastIcon.mas_right).equalTo(marginBetweenIcon);
                }
            }];
            lastIcon = icon;
        }
        
        [self.inviteButton setBackgroundImage:[UIImage imageNamed:@"groupPageAddFriends"] forState:UIControlStateNormal];
        [self.inviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(222);
            make.right.equalTo(-22);
            make.height.equalTo(24);
            make.width.equalTo(24);
        }];
       
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-102);
            make.height.equalTo(20);
            make.width.equalTo(2);
            make.right.equalTo(self.inviteButton.mas_left).equalTo(-15);
        }];
        
        self.numberLable.text = @(group.member_num).stringValue;
        [self.numberLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-105);
            make.right.equalTo(self.lineView.mas_left).equalTo(-20);
        }];
        
        [self.myIcon sd_setImageWithURL:[NSURL URLWithString:kLocalSelf.icon_url]];
        self.shareTitleLabel.text = @"分享趣事给小伙伴";
        
    }else{
        
        // 申请界面
        height = 0;
        CGFloat descLabelHeight = 0;
        
        if(group.introduction.length > 0) {
            self.descLabel.text = group.introduction;
            CGSize size = [group.introduction boundingRectWithSize:CGSizeMake(kAppScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.descLabel.font} context:nil].size;
            [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(10);
                make.right.equalTo(-10);
                make.top.equalTo(208);
                make.height.equalTo(size.height);
            }];
            descLabelHeight = size.height;
            height = 200 + 8 +descLabelHeight + 8;
        }else{
            height = 200;
        }
        
        //设置群成员数据
        UIView *lineView = [UIView new];
        lineView.backgroundColor = kRGB(43, 161, 212);
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(7);
            make.top.equalTo(height + 15);
            make.height.equalTo(14);
            make.width.equalTo(2);
        }];
        UILabel *membersIntro = [[UILabel alloc] init];
        [self addSubview:membersIntro];
        membersIntro.text = @"群成员";
        membersIntro.font = [UIFont systemFontOfSize:14];
        membersIntro.textColor = UIColorFromHex(0x666666);
        [membersIntro mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(17);
            make.top.equalTo(height + 15);
            make.height.equalTo(15);
        }];
        height = height + 15 + 15 + 15;
        
        
        float iconWidth = 45;
        CGFloat marginBetweenIcon = 8;
        CGFloat marginOfEdge = 7;

        
        NSMutableArray *allArr = [NSMutableArray array];
        [allArr addObjectsFromArray:group.partial_member_list];
        
        NSUInteger count = allArr.count;
        if (count > 5) {
            count = 5;
        }
        
        CGFloat membersIconsHeight = marginOfEdge * 2 + iconWidth;
        CGFloat allWidth = (iconWidth+marginBetweenIcon)*count+ marginOfEdge;
        self.allIconSV.contentSize = CGSizeMake(allWidth, iconWidth);
        [self.allIconSV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(height);
            make.height.equalTo(membersIconsHeight);
            make.width.equalTo(kAppScreenWidth);
        }];
        UIImageView *lastIcon;
        
        for (int i= 0; i< count; i++) {
            WYUser*user = allArr[i];
            UIImageView *icon = [UIImageView new];
            icon.userInteractionEnabled = YES;
            icon.layer.cornerRadius = iconWidth*0.5;
            icon.clipsToBounds = YES;
            [icon sd_setImageWithURL:[NSURL URLWithString:user.icon_url]];
            [self.allIconSV addSubview:icon];
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(marginOfEdge);
                make.height.equalTo(iconWidth);
                make.width.equalTo(iconWidth);
                if (i == 0) {
                    make.left.equalTo(10);
                }else{
                    make.left.equalTo(lastIcon.mas_right).equalTo(marginBetweenIcon);
                }
            }];
            lastIcon = icon;
        }

        self.allIconSV.backgroundColor = UIColorFromHex(0xf0f0f0);
        
        
        height = height + marginOfEdge + iconWidth + marginOfEdge;
        
        if (group.category_name.length > 0) {
            [self categoryView];
            _categoryView.frame = CGRectMake(0, height, kAppScreenWidth, 103);
            height = height + 103;
            self.categoryLb.text = group.category_name;
        }
        
        if (group.tags.length > 0) {
            [self tagView];
            _tagView.frame = CGRectMake(0, height, kAppScreenWidth, 103);
            height = height + 103;
            self.tagLb.text = group.tagsString;
        }
        
        [self didChangeAppliedStatus:[group.applied_status intValue]];
        height = height + 30 + 49 + 30;
    }
    
    self.frame = CGRectMake(0, 0, kAppScreenWidth, height);
}

- (void)didChangeAppliedStatus:(int)appliedStatus {
    NSString *applyTitle = nil;
    switch (appliedStatus) {
        case 1:
            applyTitle = @"申请加入";
            self.applyBtn.enabled = YES;
            [_applyLabel removeFromSuperview];
            break;
        case 2:
            applyTitle = @"已申请";
            self.applyBtn.enabled = NO;
            self.applyBtn.backgroundColor = kRGB(197, 197, 197);
            self.applyLabel.text = @"群组申请被拒绝了，请完善个人资料并于一周后申请";
            break;
        case 3:
            applyTitle = @"已申请";
            self.applyBtn.enabled = NO;
            self.applyBtn.backgroundColor = kRGB(197, 197, 197);
            self.applyLabel.text = @"群组申请仍在审核中，请耐心等待";
            break;
        default:
            debugLog(@"group.applied_status is invalid");
            break;
    }
    
    [self.applyBtn setTitle:applyTitle forState:UIControlStateNormal];
}

- (void)applyBtnClick:(UIButton *)btn {
    WYPopUpTextView *textView = [[WYPopUpTextView alloc]initWithPlaceHoder:nil];
    textView.textClick = ^(NSString *text) {
        if(self.onApplyClick) {
            self.onApplyClick(btn,text);
        }
    };
}

@end
