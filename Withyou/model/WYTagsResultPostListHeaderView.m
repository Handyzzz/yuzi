//
//  WYTagsResultPostListHeaderView.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/30.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYTagsResultPostListHeaderView.h"
#import "WYPostTagApi.h"
@interface WYTagsResultPostListHeaderView()
@property(nonatomic,strong)NSString *tagName;
@end

@implementation WYTagsResultPostListHeaderView

-(UILabel*)titleLb{
    if (_titleLb == nil) {
        _titleLb = [UILabel new];
        _titleLb.textColor = kRGB(153, 153, 153);
        _titleLb.font = [UIFont systemFontOfSize:12];
        [self addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(15);
        }];
    }
    return _titleLb;
}

-(UIView*)iconView{
    if (_iconView == nil) {
        _iconView = [UIView new];
        [self addSubview:_iconView];
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.top.equalTo(45);
            make.height.equalTo(85);
        }];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = UIColorFromHex(0xf5f5f5);
        [_iconView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.bottom.equalTo(0);
            make.width.equalTo(kAppScreenWidth);
            make.height.equalTo(1);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconViewAction)];
        [_iconView addGestureRecognizer:tap];
    }
    return _iconView;
}

-(UIImageView*)tagIV{
    if (_tagIV == nil) {
        _tagIV = [UIImageView new];
        [self addSubview:_tagIV];
        [_tagIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(22);
            make.top.equalTo(self.iconView.mas_bottom).equalTo(20);
        }];
    }
    return _tagIV;
}

-(UILabel*)tagLb{
    if (_tagLb == nil) {
        _tagLb = [UILabel new];
        _tagLb.font = [UIFont systemFontOfSize:16];
        _tagLb.textColor = UIColorFromHex(0x333333);
        [self addSubview:_tagLb];
        [_tagLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tagIV.mas_right).equalTo(11);
            make.centerY.equalTo(self.tagIV);
        }];
    }
    return _tagLb;
}

-(UIButton*)addfollowBtn{
    if (_addfollowBtn == nil) {
        _addfollowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addfollowBtn.layer.borderWidth = 1;
        _addfollowBtn.layer.cornerRadius = 4;
        _addfollowBtn.clipsToBounds = YES;
        [_addfollowBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_addfollowBtn setTitleColor:kRGB(43, 161, 212) forState:UIControlStateNormal];
        [_addfollowBtn setTitle:@"已关注" forState:UIControlStateSelected];
        [_addfollowBtn setTitleColor:kRGB(197, 197, 197) forState:UIControlStateSelected];
        
        [_addfollowBtn addTarget:self action:@selector(addAttention:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addfollowBtn];
        [_addfollowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-20);
            make.centerY.equalTo(self.tagIV);
            make.width.equalTo(70);
            make.height.equalTo(30);
        }];
    }
    return _addfollowBtn;
}

-(void)setUpHeaderViewDetail:(NSArray*)userArr tagName:(NSString *)tagName isFollowing:(BOOL)isFollowing{
    
    self.tagName = tagName;
    
    self.titleLb.text = [NSString stringWithFormat:@"%lu名参与用户",userArr.count];
    [self setUpIconView:userArr];
    self.tagIV.image = [UIImage imageNamed:@"tag_result_post_tag"];
    self.tagLb.text = tagName;
    self.addfollowBtn.selected = isFollowing;
    if (isFollowing) {
        self.addfollowBtn.layer.borderColor = kRGB(197, 197, 197).CGColor;
    }else{
        self.addfollowBtn.layer.borderColor = kRGB(43, 161, 212).CGColor;
    }
}

-(void)setUpIconView:(NSArray *)userArr{
    //一排头像 留75能放几个放几个
    for (int i = 0; i < userArr.count; i++) {
        if ((15 + 45*i) > (kAppScreenWidth - 75)) {
            break;
        }
        
        WYUser *user = userArr[i];
        UIImageView *iconIV = [UIImageView new];
        iconIV.layer.cornerRadius = 30;
        iconIV.layer.borderColor = [UIColor whiteColor].CGColor;
        iconIV.layer.borderWidth = 2;
        iconIV.clipsToBounds = YES;
        [self.iconView addSubview:iconIV];
        [iconIV sd_setImageWithURL:[NSURL URLWithString:user.icon_url]];
        [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(60);
            make.top.equalTo(0);
            make.left.equalTo(15 + 45*i);
        }];
    }
    
    UIImageView *rightIV = [UIImageView new];
    rightIV.image = [UIImage imageNamed:@"tag_result_post_enter"];
    [self.iconView addSubview:rightIV];
    [rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(17);
        make.right.equalTo(-12);
    }];
}

-(void)addAttention:(UIButton *)Btn{
    if (Btn.selected == YES) {
        Btn.selected = NO;
        self.addfollowBtn.layer.borderColor = kRGB(43, 161, 212).CGColor;

        [WYPostTagApi cancelFollowToTagName:self.tagName Block:^(NSInteger status) {
            if (status == 204) {
                
            }else{
                //取消关注失败
                Btn.selected = YES;
                self.addfollowBtn.layer.borderColor = kRGB(197, 197, 197).CGColor;

                [OMGToast showWithText:@"未能取消关注,请稍后再试"];
            }
        }];
    }else{
        Btn.selected = YES;
        self.addfollowBtn.layer.borderColor = kRGB(197, 197, 197).CGColor;

        [WYPostTagApi addFollowToTagName:self.tagName Block:^(NSInteger status) {
            if (status == 201) {

            }else{
                //关注失败
                Btn.selected = NO;
                self.addfollowBtn.layer.borderColor = kRGB(43, 161, 212).CGColor;

                [OMGToast showWithText:@"关注未成功,请稍后再试"];
            }
        }];
    }
}

-(void)iconViewAction{
    self.iocnViewClick();
}

@end
