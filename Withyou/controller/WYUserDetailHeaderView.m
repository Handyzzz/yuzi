//
//  WYUserDetailHeaderView.m
//  Withyou
//
//  Created by Handyzzz on 2017/5/11.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//
#import "WYFollow.h"
#import "WYUserDetailHeaderView.h"
#import "WYUserDetail.h"
#import "WYPublishVC.h"


#define imageHeight (kAppScreenWidth*17/32.f)
//18等分宽度
#define oneTo18 (kAppScreenWidth/18.f)

@implementation WYUserDetailHeaderView

-(UIImageView *)groudIV{
    if (_groudIV == nil) {
        _groudIV = [UIImageView new];
        _groudIV.contentMode = UIViewContentModeScaleAspectFill;
        _groudIV.clipsToBounds = YES;
        [self addSubview:_groudIV];
        _groudIV.frame = CGRectMake(0, 0, kAppScreenWidth, imageHeight);
    }
    return _groudIV;
}

-(UIImageView *)iconIV{
    if (_iconIV == nil) {
        _iconIV = [UIImageView new];
        _iconIV.layer.cornerRadius = 60;
        _iconIV.clipsToBounds = YES;
        _iconIV.layer.borderWidth = 3;
        _iconIV.layer.borderColor = [UIColor whiteColor].CGColor;
        _iconIV.userInteractionEnabled = YES;
        UITapGestureRecognizer *contentGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iocnTapClick:)];
        [_iconIV addGestureRecognizer:contentGesture];
        [self addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.groudIV.mas_bottom);
            make.centerX.equalTo(0);
            make.width.height.equalTo(120);
        }];
    }
    return _iconIV;
}


-(UILabel *)nameLb{
    if (_nameLb == nil) {
        _nameLb = [UILabel new];
        _nameLb.numberOfLines = 1;
        _nameLb.font = [UIFont systemFontOfSize:24];
        _nameLb.textColor = UIColorFromHex(0x333333);
        _nameLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconIV.mas_bottom).equalTo(4);
            make.centerX.equalTo(0);
        }];
    }
    return _nameLb;
}

-(UILabel*)introductionLb{
    if (_introductionLb == nil) {
        _introductionLb = [UILabel new];
        _introductionLb.textAlignment = NSTextAlignmentCenter;
        _introductionLb.font = [UIFont systemFontOfSize:12];
        _introductionLb.textColor = UIColorFromHex(0x666666);
        [self addSubview:_introductionLb];
        [_introductionLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLb.mas_bottom).equalTo(6);
            make.centerX.equalTo(0);
            make.width.equalTo(kAppScreenWidth *5/12.0);
        }];
    }
    return _introductionLb;
}

//别人 徐汇字底到黑条的底一起80
-(UIView *)userRealtionShipView{
    if (_userRealtionShipView == nil) {
        _userRealtionShipView = [UIView new];
        _userRealtionShipView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_userRealtionShipView];
        [_userRealtionShipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.height.equalTo(80);
            make.top.equalTo(self.introductionLb.mas_bottom);
        }];
        
        //屏幕5等分 中心对齐 oneToFive
        NSArray *nameArr = @[@"好友",@"共同好友",@"添加关注",@"子聊"];
        
        for (int i = 0; i < nameArr.count; i ++) {
            //现在底下加上View
            UIView *view = [UIView new];
            view.userInteractionEnabled = YES;
            view.tag = 500 + i;
            UITapGestureRecognizer *contentGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapClick:)];
            [view addGestureRecognizer:contentGesture];
            
            [_userRealtionShipView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(11);
                make.centerX.equalTo(_userRealtionShipView.mas_left).equalTo(oneTo18 *(i*4 + 3));
                make.width.equalTo(oneTo18 * 4);
                make.bottom.equalTo(-(20 + 8));

            }];
            
            UILabel *nameLb = [UILabel new];
            nameLb.font = [UIFont systemFontOfSize:12];
            nameLb.textColor = UIColorFromHex(0x666666);
            nameLb.textAlignment = NSTextAlignmentCenter;
            [view addSubview:nameLb];
            nameLb.text = nameArr[i];
            [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(0);
                make.centerX.equalTo(0);
            }];
            
            if (i == 2) {
                _thirdLb = nameLb;
            }
        }
        //用个局部变量给下边的Lb居中
        __block UILabel *masLb;
        
        [_userCountArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *countLb = [UILabel new];
            countLb.text = obj;
            countLb.textAlignment = NSTextAlignmentCenter;
            countLb.font = [UIFont systemFontOfSize:20];
            countLb.textColor = UIColorFromHex(0x333333);
            [_userRealtionShipView addSubview:countLb];
            [countLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(11);
                make.centerX.equalTo(_userRealtionShipView.mas_left).equalTo(oneTo18 *(idx*4 + 3));
                make.width.equalTo(50);
            }];
            if (idx == 0) {
                _firstCountLb = countLb;
            }
            masLb = countLb;
        }];
        
        NSArray *imgArr = @[@"other page_attention",@"other page_share-chat"];
        [imgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *imgView = [UIImageView new];
            imgView.image = [UIImage imageNamed:imgArr[idx]];
            [_userRealtionShipView addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_userRealtionShipView.mas_left).equalTo(oneTo18 *((idx + 2)*4 + 3));
                make.centerY.equalTo(masLb);
            }];
            if (idx == 0) {
                _thirdImg = imgView;
            }
        }];
        
        //竖线条 5 9  11
        for (int i = 0; i < 3; i ++) {
            UIView *lineView = [UIView new];
            lineView.backgroundColor = UIColorFromHex(0xc5c5c5);
            [_userRealtionShipView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_userRealtionShipView.mas_left).equalTo(oneTo18 *(i *4 + 5));
                make.top.equalTo(30);
                make.width.equalTo(1);
                make.height.equalTo(10);
            }];
        }
     
        UIView *grayView = [UIView new];
        grayView.backgroundColor = UIColorFromHex(0xf5f5f5);
        [_userRealtionShipView addSubview:grayView];
        [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.height.equalTo(8);
            make.bottom.equalTo(0);
        }];
    }
    return _userRealtionShipView;
}
//自己
-(UIView *)meRealtionShipView{
    if (_meRealtionShipView == nil) {
        _meRealtionShipView = [UIView new];
        _meRealtionShipView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_meRealtionShipView];
        [_meRealtionShipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.height.equalTo(80);
            make.bottom.equalTo(0);
        }];
        
        //屏幕5等分 中心对齐 oneToFive
        NSArray *nameArr = @[@"好友",@"关注",@"关注者",@"群组"];
        
        for (int i = 0; i < nameArr.count; i ++) {
            //底下加上View
            UIView *view = [UIView new];
            view.userInteractionEnabled = YES;
            view.tag = 500 + i;
            UITapGestureRecognizer *contentGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapClick:)];
            [view addGestureRecognizer:contentGesture];
            
            [_meRealtionShipView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(11);
                make.centerX.equalTo(_meRealtionShipView.mas_left).equalTo(oneTo18 *(i*4 + 3));
                make.width.equalTo(oneTo18 * 4);
                make.bottom.equalTo(-(20 + 8));
            }];
            
            
            UILabel *nameLb = [UILabel new];
            nameLb.font = [UIFont systemFontOfSize:12];
            nameLb.textColor = UIColorFromHex(0x666666);
            nameLb.textAlignment = NSTextAlignmentCenter;
            [view addSubview:nameLb];
            nameLb.text = nameArr[i];
            [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(0);
                make.centerX.equalTo(0);
            }];
            
        }
        
            [_countArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UILabel *countLb = [UILabel new];
                countLb.text = obj;
                countLb.textAlignment = NSTextAlignmentCenter;
                countLb.font = [UIFont systemFontOfSize:20];
                countLb.textColor = UIColorFromHex(0x333333);
                [_meRealtionShipView addSubview:countLb];
                [countLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(11);
                    make.centerX.equalTo(_meRealtionShipView.mas_left).equalTo(oneTo18 *(idx*4 + 3));
                    make.width.equalTo(50);
                }];
            }];
        
        //竖线条 5 9  11
        for (int i = 0; i < 3; i ++) {
            UIView *lineView = [UIView new];
            lineView.backgroundColor = UIColorFromHex(0xc5c5c5);
            [_meRealtionShipView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_meRealtionShipView.mas_left).equalTo(oneTo18 *(i *4 + 5));
                make.top.equalTo(30);
                make.width.equalTo(1);
                make.height.equalTo(10);
            }];
        }

            UIView *grayView = [UIView new];
            grayView.backgroundColor = UIColorFromHex(0xf5f5f5);
            [_meRealtionShipView addSubview:grayView];
            [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(0);
                make.height.equalTo(8);
                make.bottom.equalTo(0);
            }];
    }
    return _meRealtionShipView;
}



//别人页面可能有的情况
-(UIView *)addAttentionView{
//        debugMethod();
    if (_addAttentionView == nil) {
        _addAttentionView = [UIView new];
        [self addSubview:_addAttentionView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(attentionViewAction:)];
        [_addAttentionView addGestureRecognizer:tap];
        [_addAttentionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.bottom.equalTo(0);
            make.height.equalTo(64);
        }];
        
        UIView *grayView = [UIView new];
        grayView.backgroundColor = UIColorFromHex(0xf5f5f5);
        [_addAttentionView addSubview:grayView];
        [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.bottom.equalTo(0);
            make.height.equalTo(8);
        }];
    }
    return _addAttentionView;
}

-(UIImageView *)userIconIV{
    if (_userIconIV == nil) {
        _userIconIV = [UIImageView new];
        _userIconIV.layer.cornerRadius = 16;
        _userIconIV.clipsToBounds = YES;
        [self.addAttentionView addSubview:_userIconIV];
        [_userIconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.addAttentionView.mas_centerY).equalTo(-4);
            make.left.equalTo(15);
            make.width.height.equalTo(32);
        }];
    }
    return _userIconIV;
}

-(UILabel *)realtionShipLb{
    if (_realtionShipLb == nil) {
        _realtionShipLb = [UILabel new];
        _realtionShipLb.font = [UIFont systemFontOfSize:14];
        _realtionShipLb.textColor = UIColorFromHex(0x999999);        
        [self.addAttentionView addSubview:_realtionShipLb];
        [_realtionShipLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.addAttentionView.mas_centerY).equalTo(-4);
            make.left.equalTo(self.userIconIV.mas_right).equalTo(8);
        }];
    }
    return _realtionShipLb;
}

-(UIImageView *)addView{
    if (_addView == nil) {
        _addView = [UIImageView new];
        [self.addAttentionView addSubview:_addView];
        [_addView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.addAttentionView.mas_centerY).equalTo(-4);
            make.centerX.equalTo(kAppScreenWidth/2 - 45);
        }];
    }
    return _addView;
}

+(BOOL)isSelf:(NSString *)uuid{
    if ([uuid isEqualToString:kuserUUID])  return YES;
    return NO;
}


#pragma userClick

+(CGFloat)calculateHeaderHeight:(WYUserDetail*)userInfo{
    
    CGFloat sumHeight = 0.f;
    //256
    if (userInfo.rel_to_me == 1) {
        sumHeight = imageHeight + 257;

    }else if (userInfo.rel_to_me == 2){
        sumHeight = imageHeight + 192;

    }else if (userInfo.rel_to_me == 3){
        sumHeight = imageHeight + 257;

    }else if (userInfo.rel_to_me == 4){
        sumHeight = imageHeight + 192;

    }else if (userInfo.rel_to_me == 100){
        sumHeight = imageHeight + 192;
    }
    return sumHeight;
    
}
-(void)setUpHeadView:(WYUserDetail *)userInfo :(WYUserExtra *)extra{

    self.userInfo = userInfo;
    
    self.groudIV.image = [UIImage imageNamed:@"tersius"];
    if (userInfo.sex == 1) {
        [self.iconIV sd_setImageWithURL:[NSURL URLWithString:userInfo.icon_url] placeholderImage:[UIImage imageNamed:@"userMalePlaceholder"]];
    }else{
        [self.iconIV sd_setImageWithURL:[NSURL URLWithString:userInfo.icon_url] placeholderImage:[UIImage imageNamed:@"userFemalePlaceholder"]];
    }
    self.nameLb.text = userInfo.fullName;
    NSString *sexStr = userInfo.sexStr;
    NSString *cityStr = userInfo.profile.city;
    NSString *introStr = userInfo.profile.intro;
    
    if (introStr.length > 0) {
        self.introductionLb.text = introStr;
    }else{
        if (sexStr.length > 0) {
            if (cityStr.length > 0) {
                self.introductionLb.text = [NSString stringWithFormat:@"%@ | %@",sexStr,cityStr];
            }else{
                self.introductionLb.text = sexStr;
            }
        }else{
            if (cityStr.length > 0) {
                self.introductionLb.text = [NSString stringWithFormat:@"%@",cityStr];
            }else{
                //给一个空格
                self.introductionLb.text = @" ";
            }
        }
    }
    
    NSInteger i = userInfo.rel_to_me;
       if (i == 4) { //我
        _countArr = [NSMutableArray array];
        [_countArr addObject:[NSString stringWithFormat:@"%d",extra.friends_num]];
        [_countArr addObject:[NSString stringWithFormat:@"%d",extra.followed_by_me_num]];
        [_countArr addObject:[NSString stringWithFormat:@"%d",extra.following_me_num]];
        [_countArr addObject:[NSString stringWithFormat:@"%d",extra.group_num]];

        [self meRealtionShipView];
        
    //别人
    }else{        
        _userCountArr = [NSMutableArray array];
        [_userCountArr addObject:[NSString stringWithFormat:@"%d",extra.friends_num]];
        [_userCountArr addObject:[NSString stringWithFormat:@"%d",extra.common_friends_num]];
        
        [self userRealtionShipView];
        
        if (extra.allow_check_friends != YES) {
            _firstCountLb.textColor = UIColorFromHex(0xc5c5c5);
        }
        //重新设置一下 第三个按钮的字 和图片
        if (i == 100) {
            //没有任何关注关系
            _thirdLb.text = @"添加关注";
            _thirdImg.image = [UIImage imageNamed:@"other page_attention"];
        }else if(i == 1){
            //相互关注
            _thirdLb.text = @"相互关注";
            _thirdImg.image = [UIImage imageNamed:@"other page_Mutual attention"];
            
            [self addAttentionView];
            [self.userIconIV sd_setImageWithURL:[NSURL URLWithString:userInfo.icon_url]];
            self.realtionShipLb.text = @"给ta写篇帖子吧!";
            self.addView.image = [UIImage imageNamed:@"userEditToSelf"];
        }else if (i == 2){
            //显示已关注
            _thirdLb.text = @"已关注";
            _thirdImg.image = [UIImage imageNamed:@"other_page_group_followed"];
        }else if (i == 3){
            //显示添加关注
            _thirdLb.text = @"添加关注";
            _thirdImg.image = [UIImage imageNamed:@"other page_attention"];
            
            [self addAttentionView];
            [self.userIconIV sd_setImageWithURL:[NSURL URLWithString:userInfo.icon_url]];
            self.realtionShipLb.text = @"ta关注了你哦,点击关注ta吧!";
            self.addView.image = [UIImage imageNamed:@"other page_add friendsother page_add friends"];
        }
    }
}


-(void)iocnTapClick:(UITapGestureRecognizer *)sender{
    self.iconClick();
}

//是自己的时候 后边两个参数用不到 是空指针
-(void)viewTapClick:(UITapGestureRecognizer *)sender{
    self.viewClick(sender.view.tag,_thirdImg, _thirdLb);
}


- (void)attentionViewAction:(UITapGestureRecognizer *)sender{
    
    if (self.userInfo.rel_to_me == 1 ) {
        //相互关注 去写帖子
        self.buttonClick();
        
    }else if (self.userInfo.rel_to_me == 2){
        //我关注这个人 doNothing 这时候按钮是不存在的
        
    }else if (self.userInfo.rel_to_me == 3){
        
        __weak WYUserDetailHeaderView *weakSelf = self;
        //这个人关注了我 显示的是添加
        [WYFollow addFollowToUuid:self.userInfo.uuid Block:^(WYFollow *follow,NSInteger status) {
            if (follow) {
                self.userInfo.rel_to_me = 1;
                sender.view.userInteractionEnabled = NO;
                self.addView.image = [UIImage imageNamed:@"other page_add friends_added"];
                self.realtionShipLb.text = @"你们相互关注了哦!";
                //还要将第三个按钮的状态改动
                _thirdLb.text = @"相互关注";
                _thirdImg.image = [UIImage imageNamed:@"other page_Mutual attention"];
            }else{
                if (status == 450) {
                    weakSelf.goToSelfEditingClick();
                }else{
                    [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
                }
            }
        }];
        
    }else if (self.userInfo.rel_to_me == 4){
        //我 do nothing 这时候按钮是不存在的
    }else if (self.userInfo.rel_to_me == 100){
        //我们之间没有任何关系 do nothing 这时候按钮是不存在的
    }
}

@end
