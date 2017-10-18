//
//  YZPostHeader.m
//  Withyou
//
//  Created by ping on 2017/5/13.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZPostHeader.h"


#define iconWH 32


@implementation YZPostHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kAppScreenWidth, iconWH);
        [self setup];
    }
    return self;
}
- (instancetype)init {
    if(self = [super init]) {
        self.frame = CGRectMake(0, 0, kAppScreenWidth, iconWH);
        [self setup];
    }
    return self;
}

- (void)setup {
    // 头像
    UIImageView * iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, iconWH , iconWH)];
    iconImage.layer.cornerRadius = iconWH / 2;
    iconImage.layer.masksToBounds = YES;
    self.iconImage = iconImage;
    [self addSubview:iconImage];
    
    // 昵称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImage.frame) + 8,  (iconWH - 14 ) / 2, 150, kPostAuthorNameFont.pointSize + 2)];
    nameLabel.font = kPostAuthorNameFont;
    nameLabel.textColor = UIColorFromHex(0x333333);
    self.nameLabel = nameLabel;
    [self addSubview:nameLabel];
    
    // ... button
    int btnW = 50;
    UIImage *moreImg = [[UIImage imageNamed:@"postmoreclick"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *moreImgHighlight = [[UIImage imageNamed:@"postmoreclick_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(kAppScreenWidth - 15 - 50, 0, btnW, iconWH);
    [moreButton setImage:moreImg forState:UIControlStateNormal];
    [moreButton setImage:moreImgHighlight forState:UIControlStateSelected];
    moreButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, - (btnW / 2));
    self.moreButton = moreButton;
    [self addSubview:moreButton];
    
}

- (void)setupWith:(WYPost *)post {
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:post.author.icon_url]
                             placeholderImage:[UIImage imageNamed:@"111111-0.png"]
                                      options:SDWebImageRefreshCached];
    self.nameLabel.text = post.author.fullName;
}

@end
