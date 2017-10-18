//
//  YZSearchBar.m
//  Withyou
//
//  Created by ping on 2017/4/8.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZSearchBar.h"

@implementation YZSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.placeholder = @"搜索";
        self.font = kFont_14;
        self.textColor = kGrayColor60;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.returnKeyType = UIReturnKeySearch;
        
        self.clearButtonMode = UITextFieldViewModeAlways;
        self.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGFloat padding = 5;
    bounds.size.height = bounds.size.height - padding * 2;
    bounds.size.width = bounds.size.height;
    bounds.origin.x = 5;
    bounds.origin.y = padding;
    return bounds;
}

@end
