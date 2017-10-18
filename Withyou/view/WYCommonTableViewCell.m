//
//  WYComonTableViewCell.m
//  Withyou
//
//  Created by Tong Lu on 8/1/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import "WYCommonTableViewCell.h"

//cell height of 70
static int cellHeight = 70;
static int verticalInset = 10;
static int textLabelHeight = 20;


@implementation WYCommonTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        int honrizontalInset = 10;
        int iconImageDimension = cellHeight - verticalInset * 2;
        
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
        self.descriptionLabel.numberOfLines = 1;
        self.descriptionLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.descriptionLabel];
        
        self.myImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.myImageView.frame = CGRectMake(honrizontalInset, verticalInset, iconImageDimension, iconImageDimension);
        self.myImageView.layer.cornerRadius = 4;
        self.myImageView.clipsToBounds = YES;
        self.myImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.myImageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor whiteColor];
    
    self.textLabel.font = [UIFont systemFontOfSize:16.0f];
    self.textLabel.textColor = kGrayColor75;
    self.textLabel.frame = CGRectMake(cellHeight, verticalInset, kAppScreenWidth - 60 - 70, textLabelHeight);
    self.textLabel.textAlignment = NSTextAlignmentLeft;
    
    self.descriptionLabel.frame = CGRectMake(cellHeight, verticalInset*2 + textLabelHeight, kAppScreenWidth - 60 - 30, textLabelHeight);
    self.descriptionLabel.font = kFont_12;
    
}


@end




