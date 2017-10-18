
//
//  WYAlbumCollectionViewCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/4.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYAlbumCollectionViewCell.h"

@implementation WYAlbumCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createCell];
    }
    return self;
}

- (void)createCell
{
    _imageView = [UIImageView new];
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}


@end
