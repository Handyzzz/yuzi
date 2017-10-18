//
//  WYArticleCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/9/27.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYArticleCell.h"
#import "WYMediaAPI.h"
#import "WYArticle.h"
@interface WYArticleCell()
@property(nonatomic, strong)WYArticle *article;
@end
@implementation WYArticleCell
#define imageH (kAppScreenWidth *134/345.f)

-(UIImageView *)iconIV{
    if (_iconIV == nil) {
        _iconIV = [UIImageView new];
        _iconIV.userInteractionEnabled = YES;
        _iconIV.layer.cornerRadius = 2;
        _iconIV.clipsToBounds = YES;
        [self.contentView addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(15);
            make.width.equalTo(32);
            make.height.equalTo(32);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mediaAction)];
        [_iconIV addGestureRecognizer:tap];
    }
    return _iconIV;
}

-(UILabel *)nameLb{
    if (_nameLb == nil) {
        _nameLb = [UILabel new];
        _nameLb.font = [UIFont systemFontOfSize:14];
        _nameLb.textColor = UIColorFromHex(0x333333);
        [self.contentView addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).equalTo(6);
            make.centerY.equalTo(self.iconIV);
        }];
    }
    return _nameLb;
}

-(UIButton *)attentionBtn{
    if (_attentionBtn == nil) {
        _attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_attentionBtn addTarget:self action:@selector(attionAction:) forControlEvents: UIControlEventTouchUpInside];
        [_attentionBtn setBackgroundImage:[UIImage imageNamed:@"media_follow"] forState:UIControlStateNormal];
        [_attentionBtn setBackgroundImage:[UIImage imageNamed:@"media_followed"] forState:UIControlStateSelected];
        [self.contentView addSubview:_attentionBtn];
        [_attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-15);
            make.centerY.equalTo(self.iconIV);
        }];
    }
    return _attentionBtn;
}

-(UIImageView *)contentIV{
    if (_contentIV == nil) {
        _contentIV = [UIImageView new];
        _contentIV.contentMode = UIViewContentModeScaleAspectFill;
        _contentIV.clipsToBounds = YES;
        [self.contentView addSubview:_contentIV];
        [_contentIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(58);
            make.right.equalTo(-15);
            make.height.equalTo(imageH);
        }];
    }
    return _contentIV;
}

-(UILabel *)titleLb{
    if (_titleLb == nil) {
        _titleLb = [UILabel new];
        _titleLb.font = [UIFont systemFontOfSize:18];
        _titleLb.textColor = UIColorFromHex(0x333333);
        [self.contentView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.right.equalTo(-15);
        }];
    }
    return _titleLb;
}

-(UILabel *)contentLb{
    if (_contentLb == nil) {
        _contentLb = [UILabel new];
        _contentLb.font = [UIFont systemFontOfSize:14];
        _contentLb.textColor = kRGB(153, 153, 153);
        [self.contentView addSubview:_contentLb];
        [_contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.right.equalTo(-15);
            make.bottom.equalTo(-52);
        }];
    }
    return _contentLb;
}

-(UIButton *)starBtn{
    if (_starBtn == nil) {
        _starBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_starBtn];
        [_starBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.bottom.equalTo(-24);
            make.width.height.equalTo(18);
        }];
    }
    return _starBtn;
}

-(UILabel *)starLb{
    if (_starLb == nil) {
        _starLb = [UILabel new];
        _starLb.font = [UIFont systemFontOfSize:14];
        _starLb.textColor = kRGB(153, 153, 153);
        [self.contentView addSubview:_starLb];
        [_starLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.starBtn.mas_right).equalTo(3);
            make.centerY.equalTo(self.starBtn);
        }];
    }
    return _starLb;
}

-(UIButton *)commentBtn{
    if (_commentBtn == nil) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_commentBtn];
        [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.starLb.mas_right).equalTo(45);
            make.centerY.equalTo(self.starBtn);
        }];
    }
    return _commentBtn;
}

-(UILabel *)commentLb{
    if (_commentLb == nil) {
        _commentLb = [UILabel new];
        _commentLb.font = [UIFont systemFontOfSize:14];
        _commentLb.textColor = kRGB(153, 153, 153);
        [self.contentView addSubview:_commentLb];
        [_commentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.commentBtn.mas_right).equalTo(3);
            make.centerY.equalTo(self.starBtn);
        }];
    }
    return _commentLb;
}

-(UILabel *)timeLb{
    if (_timeLb == nil) {
        _timeLb = [UILabel new];
        _timeLb.font = [UIFont systemFontOfSize:12];
        _timeLb.textColor = kRGB(153, 153, 153);
        [self.contentView addSubview:_timeLb];
        [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-15);
            make.centerY.equalTo(self.starBtn);
        }];
    }
    return _timeLb;
}

-(UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [UIView new];
        [self.contentView addSubview:_lineView];
        _lineView.backgroundColor = UIColorFromHex(0xf5f5f5);
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(8);
        }];
    }
    return _lineView;
}

-(void)setUpCellDetail:(WYArticle *)article{
    
    self.article = article;
    //titleLb frame
    if (article.image_url.length > 0) {
        [self.titleLb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(58 + imageH + 5);
        }];
        self.contentIV.hidden = NO;
    }else{
        [self.titleLb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(58);
        }];
        self.contentIV.hidden = YES;
    }
    if (article.title.length > 0) {
        self.titleLb.hidden = NO;
    }else{
        self.titleLb.hidden = YES;
    }
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 8.0f;
    
    NSMutableAttributedString *masTitle = [[NSMutableAttributedString alloc]initWithString:article.title attributes:@{ NSParagraphStyleAttributeName: paragraph}];
    NSMutableAttributedString *masContent = [[NSMutableAttributedString alloc]initWithString:article.content_str attributes:@{NSParagraphStyleAttributeName: paragraph}];
    
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:article.media.icon_url]];
    self.nameLb.text = article.media.name;
    if (article.media.followed == YES) {
        self.attentionBtn.selected = YES;
        self.attentionBtn.hidden = YES;
    }else{
        self.attentionBtn.selected = NO;
        self.attentionBtn.hidden = NO;
    }
    [self.contentIV sd_setImageWithURL:[NSURL URLWithString:article.image_url]];
    self.titleLb.attributedText = masTitle;
    self.contentLb.attributedText = masContent;
    NSString *starImg = article.starred ? @"mediaStarHighlight" : @"mediaStar";
    [self.starBtn setBackgroundImage:[UIImage imageNamed:starImg] forState:UIControlStateNormal];
    self.starLb.text = [NSString stringWithFormat:@"%d",article.star_num];
    [self.commentBtn setBackgroundImage:[UIImage imageNamed:@"mediaComment"] forState:UIControlStateNormal];
    self.commentLb.text = [NSString stringWithFormat:@"%d",article.comment_num];
    self.timeLb.text = [NSString stringWithCreatedAt:[article.createdAtFloat doubleValue]];
    [self lineView];
}

+(CGFloat)heightForCell:(WYArticle*)article{
    
    CGFloat Margin = 15.f;
    CGFloat titleMargin = 5.f;
    CGFloat titleH = 0.f;
    CGFloat contentMargin = 4.f;
    CGFloat contentH = 0.f;
    CGFloat cellH = 0.f;
    
    CGFloat Font18H = 21 + 2/3.f;
    titleH = [article.title sizeWithFont:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(kAppScreenWidth - 2 * Margin, (Font18H + 8) * 2) minimumLineHeight:8].height;
    
    CGFloat Font14H = 17.f;
    contentH = [article.title sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(kAppScreenWidth - 2 * Margin, (Font14H + 8) * 2) minimumLineHeight:8].height;
    
    //top 58
    cellH = cellH + 58;
    if (article.image_url.length > 0) {
        cellH = cellH + imageH;
    }
    
    if (article.title.length > 0) {
        if (article.image_url.length > 0) {
            cellH = cellH + titleMargin + titleH;
        }else{
            cellH = cellH + titleH;
        }
    }
    
    if (article.content_str.length > 0) {
        if (article.image_url.length > 0 || article.title.length > 0) {
            cellH = cellH + contentMargin +contentH;
        }else{
            cellH = cellH + contentH;
        }
    }
    //content bottom equal to -52
    cellH = cellH + 52;
    return cellH;
}

-(void)mediaAction{
    self.mediaClick();
}

-(void)attionAction:(UIButton *)sender{
    
    __weak WYArticleCell *weakSelf = self;
    if (sender.selected == YES) {
        sender.selected = NO;
        //cancel
        [WYMediaAPI cancelFollowToMedia:self.article.media.uuid callback:^(NSInteger status) {
            debugLog(@"cancel %ld",status);
            if (status == 204) {
                sender.selected = NO;
                weakSelf.article.media.followed = NO;
            }else{
                sender.selected = YES;
                weakSelf.article.media.followed = YES;
                debugLog(@"%@",self.article.media.uuid);
                [OMGToast showWithText:@"取消关注失败"];
            }
        }];
    }else{
        sender.selected = YES;
        //add follow
        [WYMediaAPI addFollowToMedia:self.article.media.uuid callback:^(NSInteger status) {
            debugLog(@"add %ld",status);
            if (status == 201) {
                sender.selected = YES;
                weakSelf.article.media.followed = YES;
                
            }else{
                sender.selected = NO;
                weakSelf.article.media.followed = NO;
                [OMGToast showWithText:@"关注失败"];
            }
        }];
    }
}
@end
