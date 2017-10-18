//
//  YZPostLinkView.m
//  Withyou
//
//  Created by ping on 2017/5/20.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZPostLinkView.h"

@implementation YZPostLinkView

- (UILabel *)contentLabel {
    if(!_contentLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.bodyView addSubview:label];
        label.numberOfLines = 0;
        label.textColor = UIColorFromHex(0x333333);
        label.font = kPostContentFont;
        label.userInteractionEnabled = YES;
        _contentLabel = label;
    }
    return _contentLabel;
}

- (UIView *)linkContainer {
    if (!_linkContainer) {
        UIView *container = [UIView new];
        container.backgroundColor = UIColorFromHex(0xfbfbfbfb);
        container.layer.borderWidth = 0.5;
        container.layer.borderColor = UIColorFromHex(0xdfdfdfdf).CGColor;
        [self.bodyView addSubview:container];
        _linkContainer = container;
        
        // add tap
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(linkContainerClick:)];
        [container addGestureRecognizer:tap];
    }
    return _linkContainer;
}

-(WYPostOtherLinkView *)otherLinkView{
    if (!_otherLinkView) {
        _otherLinkView = [WYPostOtherLinkView new];
        _otherLinkView.backgroundColor = UIColorFromHex(0xfbfbfbfb);
        _otherLinkView.layer.borderWidth = 0.5;
        _otherLinkView.layer.borderColor = UIColorFromHex(0xdfdfdfdf).CGColor;
        [self.bodyView addSubview:_otherLinkView];
        
        // add tap
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(linkContainerClick:)];
        [_otherLinkView addGestureRecognizer:tap];
    }
    return _otherLinkView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.linkContainer addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.linkContainer addSubview:label];
        label.numberOfLines = 2;
        label.textColor = UIColorFromHex(0x333333);
        label.font = kPostLinkTitleFont;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UILabel *)sourceLabel {
    if (!_sourceLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.linkContainer addSubview:label];
        label.numberOfLines = 1;
        label.textColor = UIColorFromHex(0x999999);
        label.font = [UIFont systemFontOfSize:12];
        _sourceLabel = label;
    }
    return _sourceLabel;
}

- (UILabel *)keywordLabel {
    if (!_keywordLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.linkContainer addSubview:label];
        label.numberOfLines = 1;
        label.textColor = UIColorFromHex(0x333333);
        label.font = [UIFont systemFontOfSize:12];
        _keywordLabel = label;
    }
    return _keywordLabel;
}

// tap action
- (void)linkContainerClick:(UITapGestureRecognizer *)tap {
    if([self.delegate respondsToSelector:@selector(showLinkContentFromPost:)]) {
        [self.delegate showLinkContentFromPost:self.postFrame.post];
    }
}

- (void)setPostFrame:(WYCellPostFrame *)postFrame {
    [super setPostFrame:postFrame];
    self.contentLabel.frame = postFrame.linkContentFrame;
    if ([postFrame.post.link.url containsString:@"https://yuziapp.com"]) {
        //内部
        self.otherLinkView.hidden = YES;
        self.linkContainer.hidden = NO;

        self.linkContainer.frame = postFrame.linkContinerFrame;
        self.imageView.frame = postFrame.linkImageFrame;
        self.titleLabel.frame = postFrame.linkTitleFrame;
        self.keywordLabel.frame = postFrame.linkKeyWordFrame;
        self.sourceLabel.frame = postFrame.linkSourceFrame;
       
        self.contentLabel.text = postFrame.post.content;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:postFrame.post.link.image] placeholderImage:PlaceHolderImage];
        self.titleLabel.text = postFrame.post.link.title;
        self.sourceLabel.text = postFrame.post.link.source;
           self.keywordLabel.text = [postFrame.post.link.keywords stringByReplacingOccurrencesOfString:@"," withString:@" | "];
    }else{
        //外部
        self.otherLinkView.hidden = NO;
        self.linkContainer.hidden = YES;
        
        self.otherLinkView.frame = postFrame.linkContinerFrame;
        CGFloat height = [postFrame.post.link.title sizeWithFont:[UIFont systemFontOfSize:16 weight:0.4] maxSize:CGSizeMake(kAppScreenWidth - 15 - 80 - 8 - 10 - 15, MAXFLOAT) minimumLineHeight:8.0f].height;
        //限制在两行内就可以了
        if (height > 50) {
            height = 50;
        }
        self.otherLinkView.titleLabel.height = height;
        self.contentLabel.text = postFrame.post.content;
        
        //算高最多算两行
        [self.otherLinkView.imageView sd_setImageWithURL:[NSURL URLWithString:postFrame.post.link.image] placeholderImage:PlaceHolderImage];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8.f];//调整行间距
        NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithString:postFrame.post.link.title];
        [mas addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [mas length])];
        self.otherLinkView.titleLabel.attributedText = mas;
        self.otherLinkView.sourceLabel.text = postFrame.post.link.source;
    }
}

- (void)setDetailLayout:(WYCellPostFrame *)postFrame {
    [super setDetailLayout:postFrame];
    self.contentLabel.frame = postFrame.linkContentFrame;
    if ([postFrame.post.link.url containsString:@"https://yuziapp.com"]) {
        //内部
        self.linkContainer.frame = postFrame.linkContinerFrame;
        self.imageView.frame = postFrame.linkImageFrame;
        self.titleLabel.frame = postFrame.linkTitleFrame;
        self.keywordLabel.frame = postFrame.linkKeyWordFrame;
        self.sourceLabel.frame = postFrame.linkSourceFrame;
        
        self.contentLabel.text = postFrame.post.content;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:postFrame.post.link.image] placeholderImage:PlaceHolderImage];
        self.titleLabel.text = postFrame.post.link.title;
        self.sourceLabel.text = postFrame.post.link.source;
        self.keywordLabel.text = [postFrame.post.link.keywords stringByReplacingOccurrencesOfString:@"," withString:@" | "];
    }else{
        //外部
        self.otherLinkView.hidden = NO;
        self.linkContainer.hidden = YES;
        
        self.otherLinkView.frame = postFrame.linkContinerFrame;
        CGFloat height = [postFrame.post.link.title sizeWithFont:[UIFont systemFontOfSize:16 weight:0.4] maxSize:CGSizeMake(kAppScreenWidth - 15 - 80 - 8 - 10 - 15, MAXFLOAT) minimumLineHeight:8.0f].height;
        //限制在两行内就可以了
        if (height > 50) {
            height = 50;
        }
        self.otherLinkView.titleLabel.height = height;
        self.contentLabel.text = postFrame.post.content;
        
        //算高最多算两行
        [self.otherLinkView.imageView sd_setImageWithURL:[NSURL URLWithString:postFrame.post.link.image] placeholderImage:PlaceHolderImage];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:8.f];//调整行间距
        NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithString:postFrame.post.link.title];
        [mas addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [mas length])];
        self.otherLinkView.titleLabel.attributedText = mas;
        self.otherLinkView.sourceLabel.text = postFrame.post.link.source;
    }
}

@end
