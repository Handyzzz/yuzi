//
//  YZCarouselView.m
//  Withyou
//
//  Created by ping on 2017/5/28.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZCarouselView.h"

#define progressMargin 8
#define progressHeight 2

@interface YZCarouselView()

@property (nonatomic, strong) UIView *trackView;
@property (nonatomic, strong) UIView *progressView;

@end

@implementation YZCarouselView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        self.scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
    return self;
}

- (UIView *)trackView {
    if (!_trackView) {
        _trackView = [UIView new];
        [self addSubview:_trackView];
        _trackView.backgroundColor = UIColorFromRGBA(0x74C1FF, 0.4);
    }
    return _trackView;
}

- (UIView *)progressView {
    if (!_progressView) {
        _progressView = [UIView new];
        [self addSubview:_progressView];
        _progressView.backgroundColor = UIColorFromHex(0x2BA1D4);
    }
    return _progressView;
}


- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [self addSubview:_scrollView];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)setPhotos:(NSArray<WYPhoto *> *)photos {
    _photos = photos;
    self.index = 0;
    [self setupImages];
}

- (void)setupImages {
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    NSInteger count = self.photos.count;
    CGFloat imageH = height - 2 * progressMargin - progressHeight;
    self.progressView.frame = CGRectMake(0, height - progressHeight - progressMargin, width / count, progressHeight);
    self.trackView.frame = CGRectMake(0, self.progressView.frame.origin.y, 0, progressHeight);
    
    for (int i = 0; i < self.photos.count; i++) {
        // setup image
        WYPhoto *photo = self.photos[i];
        int tag = i + 2000;
        UIImageView * imageView = [self.scrollView viewWithTag:tag];
        // 缓存一个view
        if(imageView == nil) {
            imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            imageView.tag = tag;
            [self.scrollView addSubview:imageView];
        }
        imageView.frame = CGRectMake(i * width, 0, width, imageH);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:photo.url] placeholderImage:PlaceHolderImage];
    }
    self.scrollView.contentSize = CGSizeMake(width * count, height);
    self.scrollView.contentOffset = CGPointZero;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat percentX = scrollView.contentOffset.x / scrollView.contentSize.width;
   
    self.progressView.left = self.width * percentX;
    self.trackView.width = self.progressView.frame.origin.x;
    self.trackView.left = 0;
}


@end
