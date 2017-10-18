//
//  YZCommentCell.m
//  Withyou
//
//  Created by ping on 2017/2/19.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZCommentCell.h"
#import "UILabel+Copy.h"


@interface YZCommentCell() <UITextViewDelegate>

@end

@implementation YZCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}
- (YZUserHeadView *)iconImage {
    if(!_iconImage) {
        YZUserHeadView * iconImage = [[YZUserHeadView alloc] initWithFrame:CGRectZero];
        iconImage.layer.borderColor = UIColorFromHex(0xe8f0e4).CGColor;
        [self.contentView addSubview:iconImage];
        _iconImage = iconImage;
        
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onIconClick:)];
        [_iconImage addGestureRecognizer:iconTap];
    }
    return _iconImage;
}
- (UIView *)containerView {
    if(!_containerView) {
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:containerView];
        _containerView = containerView;
    }
    return _containerView;
}
- (UILabel *)nameLabel {
    if(!_nameLabel) {
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        nameLabel.textColor = UIColorFromHex(0x666666);
        [self.contentView addSubview:nameLabel];
        _nameLabel = nameLabel;
    }
    return _nameLabel;
}
- (UILabel *)timeLabel {
    if(!_timeLabel) {
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.textColor = UIColorFromHex(0x999999);
        timeLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:timeLabel];
        _timeLabel = timeLabel;
    }
    return _timeLabel;
}

-(UIButton *)moreBtn{
    if (_moreBtn == nil) {
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *moreImg = [[UIImage imageNamed:@"share_detail_comment_more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *moreImgHighlight = [[UIImage imageNamed:@"share_detail_comment_more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [moreBtn setImage:moreImg forState:UIControlStateNormal];
        [moreBtn setImage:moreImgHighlight forState:UIControlStateSelected];
        [self.contentView addSubview:moreBtn];
        [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 3.5, 0, 0)];
        [moreBtn addTarget:self action:@selector(showAlertAction:) forControlEvents:UIControlEventTouchUpInside];
        _moreBtn = moreBtn;
    }
    return _moreBtn;
}

-(UIButton *)starBtn{
    if (_starBtn == nil) {
        UIButton *starBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *starImg = [[UIImage imageNamed:@"share_detail_comment_star_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *starImgHighlight = [[UIImage imageNamed:@"share_detail_comment_star_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [starBtn setImage:starImg forState:UIControlStateNormal];
        [starBtn setImage:starImgHighlight forState:UIControlStateSelected];
        [starBtn addTarget:self action:@selector(starCommentAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:starBtn];
        _starBtn = starBtn;
    }
    return _starBtn;
}

-(UILabel *)starCountLb{
    if (_starCountLb == nil) {
        UILabel *starCountLb = [UILabel new];
        starCountLb.textColor = kRGB(153, 153, 153);
        starCountLb.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:starCountLb];
        _starCountLb = starCountLb;
        [_starCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.starBtn).equalTo(8);
            make.left.equalTo(self.starBtn).equalTo(37);
        }];
    }
    return _starCountLb;
}

- (UITextView *)contentTV {
    if(!_contentTV) {
        UITextView *contentTV = [UITextView new];
        contentTV.font = [UIFont systemFontOfSize:13];
        contentTV.textColor = kGrayColor75;
        contentTV.userInteractionEnabled = YES;
        contentTV.scrollEnabled = NO;
        contentTV.editable = NO;
        contentTV.delegate = self;
        contentTV.textContainer.lineFragmentPadding = 0;
        contentTV.textContainerInset = UIEdgeInsetsZero;
        contentTV.dataDetectorTypes = UIDataDetectorTypeAll;
        [self.containerView addSubview:contentTV];
        _contentTV = contentTV;
    }
    return _contentTV;
}

- (UIView *)separateView {
    if(!_separateView) {
        UIView *separateView = [UIView new];
        [self.contentView addSubview:separateView];
        separateView.backgroundColor = SeparateLineColor;
        _separateView = separateView;
    }
    return _separateView;
}
- (UILabel *)replayLabel {
    if(!_replayLabel) {
        UILabel *replayLabel = [[UILabel alloc] init];
        replayLabel.numberOfLines = 2;
        
        [self.containerView addSubview:replayLabel];
        _replayLabel = replayLabel;
    }
    return _replayLabel;
}

- (UIView *)replayTip {
    if(!_replayTip) {
        UIView *replayTip = [UIView new];
        [self.containerView addSubview:replayTip];
        
        replayTip.backgroundColor = UIColorFromHex(0xc5c5c5);
        
        _replayTip = replayTip;
    }
    return _replayTip;
}


- (void)onIconClick:(UITapGestureRecognizer *)tap {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onIconClick:)]) {
        [self.delegate onIconClick:self.comment.comment];
    }
}

- (void)replyComment:(UITapGestureRecognizer *)tap {
    if(self.delegate && [self.delegate respondsToSelector:@selector(replyComment:)]) {
        [self.delegate replyComment:self.comment.comment];
    }
}

- (void)setComment:(YZCommentFrame *)comment {
    _comment = comment;
    [self.iconImage loadImage:comment.comment.author.icon_url];
    self.iconImage.frame = comment.iconImageFrame;
    
    self.containerView.frame = comment.containerFrame;
    self.nameLabel.frame = comment.nameLabelFrame;
    self.timeLabel.frame = comment.timeLabelFrame;
    self.moreBtn.frame = comment.moreBtnFrame;
    self.starBtn.frame = comment.starBtnFrame;
    self.replayLabel.frame = comment.replayLabelFrame;
    self.replayTip.frame = CGRectMake(0, comment.replayLabelFrame.origin.y, 2, comment.replayLabelFrame.size.height);
    self.contentTV.frame = comment.contentLabelFrame;
    self.separateView.frame = comment.separateFrame;
    
    
    self.nameLabel.text = comment.comment.author.fullName;
    self.timeLabel.text = [NSString stringWithCreatedAt:[comment.comment.created_at_float floatValue]];
    if (comment.comment.star_num > 0) {
        self.starCountLb.text = [NSString stringWithFormat:@"%d",comment.comment.star_num];
    }else{
        self.starCountLb.text = @"";
    }
    if (comment.comment.starred == YES) {
        self.starBtn.selected = YES;
        self.starCountLb.textColor = UIColorFromHex(0x00B2E1);
    }else{
        self.starBtn.selected = NO;
        self.starCountLb.textColor = UIColorFromHex(0x999999);
    }
    
    NSString *combinedString = [NSString stringWithFormat:@"%@:%@", comment.comment.replied_author.fullName, comment.comment.replied_content];
    NSMutableAttributedString *replayText = [[NSMutableAttributedString alloc] initWithString:combinedString];
    NSRange replayRange = NSMakeRange(0, replayText.length);
    [replayText addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0xc5c5c5) range:replayRange];
    [replayText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:replayRange];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5;
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    [replayText addAttribute:NSParagraphStyleAttributeName value:style range:replayRange];
    
    self.replayLabel.attributedText = replayText;    
   
    
    //带mention textView
    NSMutableAttributedString *contentText = [YZMarkText convert:comment.comment.content abilityToTapStringWith:comment.comment.mention FontSize:14];
    
    NSMutableParagraphStyle *contentStyle = [[NSMutableParagraphStyle alloc] init];
    contentStyle.lineSpacing = 5;
    [contentText addAttribute:NSParagraphStyleAttributeName value:contentStyle range:NSMakeRange(0, contentText.length)];
    self.contentTV.attributedText = contentText;
    self.contentTV.linkTextAttributes = @{NSParagraphStyleAttributeName : contentStyle,NSForegroundColorAttributeName : UIColorFromHex(0x2ba1d4)};
    
    /**
     textView长按复制
     Cell 全部区域点击回复
     Cell 上的@链接优先点击去个人页面
     按钮点击 删除
     */
    UITapGestureRecognizer *replyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyComment:)];
    [self.contentView addGestureRecognizer:replyTap];
}

- (void)showAlertAction:(UIButton *)btn {

    if(self.delegate && [self.delegate respondsToSelector:@selector(showAlertAction:)]) {
        [self.delegate showAlertAction:self.comment.comment];
    }
}

-(void)starCommentAction:(UIButton*)btn{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(starCommentAction: starBtn: starCountLb:)]) {
        [self.delegate starCommentAction:self.comment.comment starBtn:btn starCountLb:self.starCountLb];
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
    if([[URL scheme] isEqualToString:@"marked"]) {
        int index = [[URL host] intValue];
        if(index < self.comment.comment.mention.count) {
            YZMarkText *mark = self.comment.comment.mention[index];
            if([self.delegate respondsToSelector:@selector(atStringClick:)])
            {
                [self.delegate atStringClick:mark];
            }
        }
        
    }
    return YES;
}

@end
