//
//  YZPostAlbumView.m
//  Withyou
//
//  Created by ping on 2017/5/20.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZPostAlbumView.h"

@implementation YZPostAlbumView

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        UILabel *titleLabel = [UILabel new];
        [self.bodyView addSubview:titleLabel];
        titleLabel.font = kPostTitleFont;
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = UIColorFromHex(0x3333333);
        titleLabel.userInteractionEnabled = YES;
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (YZCarouselView *)carouselView {
    if(!_carouselView) {
        YZCarouselView *carouselView = [[YZCarouselView alloc] initWithFrame:CGRectZero];
        [self.bodyView addSubview:carouselView];
        UITapGestureRecognizer *albumClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(albumClick:)];
        [carouselView addGestureRecognizer:albumClick];
        _carouselView = carouselView;
    }
    return _carouselView;
}

- (UILabel *)contentLabel {
    if(!_contentLabel) {
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        contentLabel.font = kPostContentFont;
        contentLabel.textColor = UIColorFromHex(0x333333);
        contentLabel.userInteractionEnabled = YES;
        _contentLabel = contentLabel;
        [self.bodyView addSubview:contentLabel];
    }
    return _contentLabel;
}

- (void)setPostFrame:(WYCellPostFrame *)postFrame {
    [super setPostFrame:postFrame];
    self.carouselView.frame = postFrame.singleImageFrame;
    self.contentLabel.frame = postFrame.singleImageTextFrame;
    self.titleLabel.frame = postFrame.albumTitleFrame;
    
    
    self.titleLabel.text = postFrame.post.albumTitle;
    self.contentLabel.text = postFrame.post.content;
    self.contentLabel.numberOfLines = 3;
    self.carouselView.photos = postFrame.post.images;
}

- (void)setDetailLayout:(WYCellPostFrame *)postFrame {
    [super setDetailLayout:postFrame];
    self.carouselView.frame = postFrame.singleImageFrame;
    self.contentLabel.frame = postFrame.singleImageTextFrame;
    self.titleLabel.frame = postFrame.albumTitleFrame;
    
    
    self.titleLabel.text = postFrame.post.albumTitle;
    self.contentLabel.text = postFrame.post.content;
    self.contentLabel.numberOfLines = 0;
    self.carouselView.photos = postFrame.post.images;
}
// tap action
- (void)albumClick:(UITapGestureRecognizer *)tap {
    if([self.delegate respondsToSelector:@selector(showAlbumFromPost:)]) {
        [self.delegate showAlbumFromPost:self.postFrame.post];
    }
}

@end
