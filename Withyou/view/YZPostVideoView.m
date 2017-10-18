//
//  YZPostVideoView.m
//  Withyou
//
//  Created by ping on 2017/5/20.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZPostVideoView.h"

#define playViewH 30.0
#define playViewW 80.0
#define playIconH 14

@implementation YZPostVideoView

- (UILabel *)playLabel {
    if(!_playLabel) {
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(playViewH/2 + playIconH + 6, (playViewH - playIconH)/2, playViewW - playViewH - 6 - playIconH, playIconH)];
        
        timeLabel.textColor = UIColorFromHex(0xffffff);
        timeLabel.font = [UIFont systemFontOfSize:10];
        timeLabel.textAlignment = NSTextAlignmentRight;
        [self.playView addSubview:timeLabel];
        _playLabel = timeLabel;
    }
    return _playLabel;
}


- (UIView *)playView {
    if(!_playView) {
        UIView *playView = [UIView new];
        playView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        playView.layer.cornerRadius = playViewH / 2;
        playView.clipsToBounds = YES;
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(playViewH/2, (playViewH - playIconH)/2, playIconH, playIconH)];
        [playView addSubview:icon];
        icon.image = [UIImage imageNamed:@"video_call_filled_white"];
        
        [self.imageView addSubview:playView];
        _playView = playView;
        
        
    }
    return _playView;
}

- (UIImageView *)imageView {
    if(!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        _imageView = imageView;
        [self.bodyView addSubview:imageView];
        
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPlayClick:)];
        [imageView addGestureRecognizer:tap];
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
    self.imageView.frame = postFrame.videoImageFrame;
    self.contentLabel.frame = postFrame.videoTextFrame;
    self.contentLabel.numberOfLines = 3;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:postFrame.post.video.thumbnailImageUrl] placeholderImage:PlaceHolderImage];
    self.contentLabel.text = self.postFrame.post.content;
    
    self.playView.frame = CGRectMake(postFrame.videoImageFrame.size.width - 10 - playViewW, postFrame.videoImageFrame.size.height - 15 - playViewH, playViewW, playViewH);
    self.playLabel.text = [NSString stringFromDuration:[postFrame.post.video.duration intValue]];
}

- (void)setDetailLayout:(WYCellPostFrame *)postFrame {
    [super setDetailLayout:postFrame];
    self.imageView.frame = postFrame.videoImageFrame;
    self.contentLabel.frame = postFrame.videoTextFrame;
    self.contentLabel.numberOfLines = 0;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:postFrame.post.video.thumbnailImageUrl] placeholderImage:PlaceHolderImage];
    self.contentLabel.text = self.postFrame.post.content;
    
    self.playView.frame = CGRectMake(postFrame.videoImageFrame.size.width - 10 - playViewW, postFrame.videoImageFrame.size.height - 15 - playViewH, playViewW, playViewH);
    self.playLabel.text = [NSString stringFromDuration:[postFrame.post.video.duration intValue]];
}

- (void)onPlayClick:(UITapGestureRecognizer *)tap {
    if(self.playBlock) {
        self.playBlock(self.postFrame.post,self.imageView);
    }
}

@end
