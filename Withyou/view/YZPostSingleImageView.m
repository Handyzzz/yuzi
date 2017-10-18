//
//  YZPostImageVIew.m
//  Withyou
//
//  Created by ping on 2017/5/20.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZPostSingleImageView.h"

@implementation YZPostSingleImageView

- (UIImageView *)imageView {
    if(!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *imageClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
        [imageView addGestureRecognizer:imageClick];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        _imageView = imageView;
        [self.bodyView addSubview:imageView];
    }
    return _imageView;
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
    self.imageView.frame = postFrame.singleImageFrame;
    self.contentLabel.frame = postFrame.singleImageTextFrame;
    self.contentLabel.text = postFrame.post.content;
    self.contentLabel.numberOfLines = 3;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:postFrame.post.mainPic.url] placeholderImage:PlaceHolderImage];
    
}

- (void)setDetailLayout:(WYCellPostFrame *)postFrame {
    [super setDetailLayout:postFrame];
    self.imageView.frame = postFrame.singleImageFrame;
    self.contentLabel.frame = postFrame.singleImageTextFrame;
    self.contentLabel.text = postFrame.post.content;
    self.contentLabel.numberOfLines = 0;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:postFrame.post.mainPic.url] placeholderImage:PlaceHolderImage];
}
// tap action
- (void)imageClick:(UITapGestureRecognizer *)tap {
    if([self.delegate respondsToSelector:@selector(showImageFromPost:)]) {
        [self.delegate showImageFromPost:self.postFrame.post];
    }
}

@end
