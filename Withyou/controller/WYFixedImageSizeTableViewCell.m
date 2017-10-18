//
//  WYFixedImageSizeTableViewCell.m
//  Withyou
//
//  Created by Tong Lu on 16/8/25.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import "WYFixedImageSizeTableViewCell.h"

@implementation WYFixedImageSizeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        
        CGFloat imageMargin = 15;
        CGFloat imageWH = 112;

        self.myImageView = [UIImageView new];
        self.myImageView.clipsToBounds = YES;
        self.myImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.myImageView];
        [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageMargin);
            make.top.equalTo(imageMargin);
            make.width.height.equalTo(imageWH);
        }];
        
        self.myLabel = [UILabel new];
        self.myLabel.font = [UIFont systemFontOfSize:14];
        self.myLabel.textColor = UIColorFromHex(0xc5c5c5);
        self.myLabel.numberOfLines = 0;
        [self.contentView addSubview:self.myLabel];
        [self.myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.myImageView.mas_right).equalTo(10);
            make.top.equalTo(imageMargin);
            make.right.equalTo(-25);
            make.height.equalTo(imageWH);
        }];

        
    }
    
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor whiteColor];
    
}

@end
