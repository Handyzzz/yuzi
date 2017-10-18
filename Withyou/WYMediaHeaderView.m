//
//  WYMediaHeaderView.m
//  Withyou
//
//  Created by Handyzzz on 2017/9/27.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYMediaHeaderView.h"
#import "WYMedia.h"
#import "WYMediaAPI.h"

@interface WYMediaHeaderView()
@property(nonatomic,strong)WYMedia *media;
@end
@implementation WYMediaHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _iconIV = [UIImageView new];
        _iconIV.layer.cornerRadius = 4.f;
        _iconIV.clipsToBounds = YES;
        [self addSubview:_iconIV];
        [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(15);
            make.width.equalTo(94);
            make.height.equalTo(94);
        }];
        
        _nameLb = [UILabel new];
        _nameLb.font = [UIFont systemFontOfSize:22];
        _nameLb.textColor = UIColorFromHex(0x333333);
        [self addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconIV.mas_right).equalTo(12);
            make.top.equalTo(21);
            make.right.equalTo(-12);
        }];
        
        _numLb = [UILabel new];
        _numLb.font = [UIFont systemFontOfSize:12];
        _numLb.textColor = kRGB(153, 153, 153);
        [self addSubview:_numLb];
        [_numLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconIV.mas_right).equalTo(15);
            make.top.equalTo(_nameLb.mas_bottom).equalTo(10);
        }];
        
        _attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_attentionBtn addTarget:self action:@selector(attionAction:) forControlEvents: UIControlEventTouchUpInside];
        [_attentionBtn setBackgroundImage:[UIImage imageNamed:@"media_follow"] forState:UIControlStateNormal];
        [_attentionBtn setBackgroundImage:[UIImage imageNamed:@"media_followed"] forState:UIControlStateSelected];
        [self addSubview:_attentionBtn];
        [_attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconIV.mas_right).equalTo(15);
            make.top.equalTo(_numLb.mas_bottom).equalTo(10);
        }];
        
        _introductionLb = [UILabel new];
        _introductionLb.numberOfLines = 0;
        _introductionLb.font = [UIFont systemFontOfSize:14];
        _introductionLb.textColor = kRGB(102, 102, 102);
        [self addSubview:_introductionLb];
        [_introductionLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.right.equalTo(-38);
            make.top.equalTo(self.iconIV.mas_bottom).equalTo(15);
            make.bottom.equalTo(-15);
        }];
        
        _rightIV = [UIImageView new];
        [self addSubview:_rightIV];
        [_rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-16);
            make.centerY.equalTo(_introductionLb);
        }];
        
        _lineView = [UIView new];
        [self addSubview:_lineView];
        [_lineView setBackgroundColor:UIColorFromHex(0xf5f5f5)];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(8);
        }];
    }
    return self;
}

-(void)setHeaderViewWithMedia:(WYMedia *)media{
    self.media = media;

    //calculate introductionLb height
    CGFloat headerH = 0.f;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:8.f];
    CGFloat maxWidth = kAppScreenWidth - 15 - 38;
    CGFloat kFont14H = 17.f;
    CGFloat maxHeight = (kFont14H + 8)*2;
    CGFloat textH = [media.introduction sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(maxWidth, maxHeight) minimumLineHeight:8].height;
    headerH = 15 + 94 + 15 + textH + 15 + 8;
    self.height = headerH;
    
    //set Data
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc]initWithString:media.introduction attributes:@{NSParagraphStyleAttributeName : style}];
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:media.icon_url]];
    [self.nameLb setText:media.name];
    [self.numLb setText:[NSString stringWithFormat:@"%d",media.follower_num]];
    if (media.followed == YES) {
        self.attentionBtn.selected = YES;
    }else{
        self.attentionBtn.selected = NO;
    }
    [self.introductionLb setAttributedText:mas];
    [self.rightIV setImage:[UIImage imageNamed:@""]];
    // if textH > (14 + 8) * 2;
    if (textH > (14 + 8) * 2) {
        self.rightIV.hidden = NO;
    }else{
        self.rightIV.hidden = YES;
    }
}

-(void)attionAction:(UIButton *)sender{
    
    __weak WYMediaHeaderView *weakSelf = self;
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
