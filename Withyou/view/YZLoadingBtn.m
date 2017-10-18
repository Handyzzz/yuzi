//
//  YZLoadingBtn.m
//  Withyou
//
//  Created by ping on 2017/2/25.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZLoadingBtn.h"
#import <Masonry/Masonry.h>

@interface YZLoadingBtn()

@property (nonatomic, strong) UIActivityIndicatorView * indecator;

@end


@implementation YZLoadingBtn

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        
    }
    return self;
}

- (void)setup {
    self.indecator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indecator.hidden = YES;
    self.indecator.userInteractionEnabled = NO;
    self.contentVerticalAlignment =  UIControlContentVerticalAlignmentCenter;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self addSubview:self.indecator];
    
    [self.indecator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
}


- (void)startLoading {
    _isLoading = YES;
    self.titleLabel.alpha = 0;
    [self.indecator startAnimating];
    self.enabled = NO;
}

- (void)stopLoading {
    _isLoading = NO;
    self.titleLabel.alpha = 1;
    [self.indecator stopAnimating];
    self.enabled = YES;
}

@end
