//
//  YZPostStarView.m
//  Withyou
//
//  Created by ping on 2017/6/3.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZPostStarView.h"

#define iconWH 30.f
#define margin 15.f
#define btnHW 26.f
#define iconMargin 8.f
#define iconMarginToLabel 10.f

@interface YZPostStarView()

@property (nonatomic, weak) UIView *topLine;
@property (nonatomic, weak) UIView *bottomLine;
@property (nonatomic, assign) int iconCount;

@end

@implementation YZPostStarView

- (UILabel *)starNumberLabel {
    if(!_starNumberLabel) {
        UILabel *starNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        starNumberLabel.textColor = UIColorFromHex(0x333333);
        starNumberLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [self addSubview:starNumberLabel];
        starNumberLabel.textAlignment = NSTextAlignmentRight;
        _starNumberLabel = starNumberLabel;
    }
    return _starNumberLabel;
}

- (UIView *)separateLine {
    if (!_separateLine) {
        UIView *separateLine = [[UIView alloc] initWithFrame:CGRectZero];
        separateLine.backgroundColor = UIColorFromHex(0xf2f2f2);
        [self addSubview:separateLine];
        
        _separateLine = separateLine;
    }
    return _separateLine;
}
- (UIButton *)starBtn {
    if(!_starBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        _starBtn = btn;
    }
    return _starBtn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(margin, 0, frame.size.width - 2 * margin , 0.5)];
        topLine.backgroundColor = SeparateLineColor;
        [self addSubview:topLine];
        self.topLine = topLine;
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(margin, frame.size.height - 0.5, frame.size.width - 2 * margin , 0.5)];
        bottomLine.backgroundColor = SeparateLineColor;
        [self addSubview:bottomLine];
        self.bottomLine = bottomLine;
        self.iconCount = 3;
    }
    return self;
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGFloat height = frame.size.height;
    CGFloat width = frame.size.width;
    self.starNumberLabel.frame = CGRectMake(width - 113 - 30, (height - 14)/2, 30, 14);
    self.separateLine.frame = CGRectMake(width - 88, (height - btnHW)/2, 2, btnHW);
    self.starBtn.frame = CGRectMake(width - btnHW - 30, (height - btnHW)/2, btnHW, btnHW);
    
    self.topLine.frame = CGRectMake(margin, 0, width - 2 * margin , 0.5);
    self.bottomLine.frame = CGRectMake(margin, height - 0.5, width - 2 * margin , 0.5);
    
    CGFloat iconMaxWidth = self.starNumberLabel.frame.origin.x - margin - iconMarginToLabel;
    
    self.iconCount = (iconMaxWidth  + iconMargin)/ (iconWH + iconMargin);
}

- (void)setUsers:(NSArray<WYUser *> *)users {
    [self setStaredUsers:users];
}

- (void)setStaredUsers:(NSArray<WYUser *> *)users {
    _users = users;
    int i = 0;
    while (i < self.iconCount) {
        YZUserHeadView *icon = [self getCachedImageViewWithTag:i + 999];
        icon.frame = CGRectMake(margin + i * iconWH + i * iconMargin, 20, iconWH, iconWH);
        if(i < users.count){
            icon.layer.borderColor = UIColorFromHex(0x2ba1d4).CGColor;
            WYUser *user = users[i];
            [icon loadImage:user.icon_url];
        }else {
            icon.layer.borderColor = UIColorFromHex(0xe8f0f4).CGColor;
            icon.headView.image = nil;
        }
        i++;
    }
}

- (YZUserHeadView *)getCachedImageViewWithTag:(int)tag {
    YZUserHeadView * header = [self viewWithTag:tag];
    if(!header) {
        header = [[YZUserHeadView alloc] initWithFrame:CGRectZero];
        header.tag = tag;
        [self addSubview:header];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClick:)];
        [header addGestureRecognizer:tap];
    }
    return header;
}

- (void)iconClick:(UITapGestureRecognizer *)tap {
    NSUInteger index = tap.view.tag - 999;
    if(index < self.users.count && self.onIconClick) {
        WYUser *user = self.users[index];
        self.onIconClick(user);
    }
    
}

@end
