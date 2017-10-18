//
//  YZGroupListTableViewCell.m
//  Withyou
//
//  Created by CH on 2017/6/3.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZGroupListTableViewCell.h"

static int cellHeight = 60;
static int verticalInset = 10;

@implementation YZGroupListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        int iconImageDimension = cellHeight - verticalInset * 2;
        
        self.myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, verticalInset, iconImageDimension, iconImageDimension)];
        self.myImageView.layer.cornerRadius = self.myImageView.frame.size.width * 0.5;
        self.myImageView.clipsToBounds = YES;
        self.myImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.myImageView];
        
        CGRect rect = CGRectZero;
        rect.origin.x = CGRectGetMaxX(self.myImageView.frame) + 10;
        rect.origin.y = self.myImageView.frame.origin.y;
        rect.size.height = self.myImageView.frame.size.height;
        rect.size.width = kAppScreenWidth - rect.origin.x - 40;
        self.myTextLabel = [[UILabel alloc] initWithFrame:rect];
        self.myTextLabel.numberOfLines = 1;
        self.myTextLabel.font = [UIFont systemFontOfSize:15];
        self.myTextLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.myTextLabel];
        
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 59, kAppScreenWidth - 15, 1)];
        view.backgroundColor = UIColorFromHex(0xf5f5f5);
        self.lineView = view;
        [self.contentView addSubview:self.lineView];
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor whiteColor];
}

@end
