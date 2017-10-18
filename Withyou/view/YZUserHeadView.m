//
//  YZUserHeadView.m
//  Withyou
//
//  Created by CH on 17/5/20.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZUserHeadView.h"

@interface YZUserHeadView()


@end

@implementation YZUserHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = UIColorFromHex(0x2ba1d4).CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = frame.size.width * 0.5;
        self.clipsToBounds = YES;
        
       
        self.headView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, frame.size.width - 4, frame.size.height - 4)];
        self.headView.backgroundColor = kRGB(232, 240, 244);
        self.headView.layer.cornerRadius = self.headView.frame.size.width * 0.5;
        self.headView.clipsToBounds = YES;
        self.headView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.headView];
    }
    return self;
}
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    self.headView.frame = CGRectMake(2, 2, frame.size.width - 4, frame.size.height - 4);
    self.headView.layer.cornerRadius = self.headView.frame.size.width * 0.5;
    self.headView.clipsToBounds = YES;
    
    self.layer.cornerRadius = frame.size.width * 0.5;
    self.clipsToBounds = YES;
}
// 不要蓝色线的init方法
- (id)initWithFrameWithNoBorder:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        self.headView.backgroundColor = UIColorFromHex(0xf2f2f2);
        self.headView.layer.cornerRadius = self.headView.frame.size.width * 0.5;
        self.headView.clipsToBounds = YES;
        self.headView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.headView];
    }
    return self;
}
#pragma mark -
- (void)loadImage:(NSString *)iconUrl{
    [self.headView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:PlaceHolderImage];
}


@end
