//
//  WYMediaCollectionViewCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/9/27.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYMediaCollectionViewCell.h"
#import "WYMediaAPI.h"

@interface WYMediaCollectionViewCell()
@property(nonatomic, strong)WYMedia *media;
@end

@implementation WYMediaCollectionViewCell
#define itemW  ((kAppScreenWidth - 2 * 10 - 3 * 5)/4.f)
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _iconIV = [UIImageView new];
        _iconIV.layer.cornerRadius = 4.f;
        _iconIV.clipsToBounds = YES;
        [self.contentView addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.centerX.equalTo(0);
            make.width.height.equalTo(54);
        }];
        
        _nameLb = [UILabel new];
        [self.contentView addSubview:_nameLb];
        _nameLb.numberOfLines = 0;
        _nameLb.textAlignment = NSTextAlignmentCenter;
        _nameLb.font = [UIFont systemFontOfSize:13];
        _nameLb.textColor = kRGB(51, 51, 51);
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_iconIV.mas_bottom).equalTo(6);
            make.centerX.equalTo(0);
            make.width.equalTo(itemW - 20);
        }];
        
        _attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.attentionBtn setBackgroundImage:[UIImage imageNamed:@"media_follow"] forState:UIControlStateNormal];
        [self.attentionBtn setBackgroundImage:[UIImage imageNamed:@"media_followed"] forState:UIControlStateSelected];
        [_attentionBtn addTarget:self action:@selector(attionAction:) forControlEvents: UIControlEventTouchUpInside];
        [self.contentView addSubview:_attentionBtn];
        [_attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.bottom.equalTo(-10);
            make.width.equalTo(40);
            make.height.equalTo(24);
        }];
    }
    return self;
}

-(void)setUpCellDetail:(WYMedia *)media{
    self.media = media;
    self.nameLb.text = media.name;
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:media.icon_url]];
    if (media.followed == YES) {
        self.attentionBtn.selected = YES;
    }else{
        self.attentionBtn.selected = NO;
    }
}

-(void)attionAction:(UIButton *)sender{
    
    __weak WYMediaCollectionViewCell *weakSelf = self;
    if (sender.selected == YES) {
        sender.selected = NO;
        //cancel
        [WYMediaAPI cancelFollowToMedia:self.media.uuid callback:^(NSInteger status) {
            debugLog(@"cancel %ld",status);
            if (status == 204) {
                sender.selected = NO;
                weakSelf.media.followed = NO;
            }else{
                sender.selected = YES;
                weakSelf.media.followed = YES;
                debugLog(@"%@",self.media.uuid);
                [OMGToast showWithText:@"取消关注失败"];
            }
        }];
    }else{
        sender.selected = YES;
        //add follow
        [WYMediaAPI addFollowToMedia:self.media.uuid callback:^(NSInteger status) {
            debugLog(@"add %ld",status);
            if (status == 201) {
                sender.selected = YES;
                weakSelf.media.followed = YES;

            }else{
                sender.selected = NO;
                weakSelf.media.followed = NO;
                [OMGToast showWithText:@"关注失败"];
            }
        }];
    }
}

@end
