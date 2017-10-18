//
//  WYMorePhotoCell.m
//  Withyou
//
//  Created by Tong Lu on 8/8/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import "WYMorePhotoCell.h"
#import "UIImage+WYUtils.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation WYMorePhotoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.myImageView = [[UIImageView alloc] init];
        self.myImageView.clipsToBounds = YES;
        self.myImageView.contentMode = UIViewContentModeScaleAspectFill;
//        self.myImageView.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:self.myImageView];
        
        self.myTextView = [UITextView new];
        self.myTextView.font = kFont_14;
        self.myTextView.editable = false;
        self.myTextView.scrollEnabled = false;
        self.myTextView.textContainer.lineFragmentPadding = 0;
        self.myTextView.textContainerInset = UIEdgeInsetsZero;
        self.myTextView.textColor = kMediumGrayTextColor;
        self.myTextView.dataDetectorTypes = UIDataDetectorTypeAll;
        self.myTextView.userInteractionEnabled = YES;
//        self.myTextView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.myTextView];
        
        self.countLb = [UILabel new];
        self.countLb.textAlignment = NSTextAlignmentCenter;
        self.countLb.font = [UIFont systemFontOfSize:18];
        self.countLb.textColor = kMediumGrayTextColor;
        [self.contentView addSubview:self.countLb];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.backgroundColor = [UIColor whiteColor];
}
- (CGFloat)setupCellFromPhoto:(WYPhoto *)photo :(NSInteger)currrntIndex{
    CGFloat imageHeight = [UIImage getHeightOfImageViewFromOriginalHeight:photo.height
                                                          Width:photo.width
                                                    WithInWidth:kAppScreenWidth];
    self.myImageView.frame = CGRectMake(0, 0, kAppScreenWidth, imageHeight);
    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:photo.url]
                        placeholderImage:[UIImage imageNamed:@"111111-0"]];
    
    
    self.countLb.text = [NSString stringWithFormat:@"%lu",currrntIndex+1];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.minimumLineHeight = kContentLineSpacing;
    paragraph.maximumLineHeight = kContentLineSpacing;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:photo.content attributes:@{NSParagraphStyleAttributeName: paragraph, NSFontAttributeName: kFont_14, NSForegroundColorAttributeName: kMediumGrayTextColor}]; //, NSForegroundColorAttributeName: kMediumGrayTextColor
    
    CGFloat textEdgeInset = 40;
    CGFloat textWidth = kAppScreenWidth-textEdgeInset;

    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    CGFloat textHeight = rect.size.height;
    
    //给让textView字不太靠边 上左下右
    CGFloat top, left, bottom, right;
    top = 3;
    left = 0;
    bottom = 30;
    right = 10;
    
    self.myTextView.textContainerInset = UIEdgeInsetsMake(top, left, bottom, right);
//    self.myTextView.backgroundColor = [UIColor blueColor];
    //左边留40给数字标号
    if (photo.content.length >= 1) {
        self.countLb.frame = CGRectMake(0, imageHeight, textEdgeInset, textEdgeInset);
        //让文字留边距 相对textView大小把边距加上去
        self.myTextView.frame = CGRectMake(textEdgeInset, imageHeight, textWidth, textHeight+ top + bottom);
        self.myTextView.attributedText = attributedString;
    }else{
        self.countLb.frame = CGRectMake(0, 0, 0, 0);
        self.myTextView.frame = CGRectMake(0, 0, 0, 0);
        self.myTextView.attributedText = [[NSAttributedString alloc]initWithString:@""];
        return imageHeight + 60;
    }
//    self.countLb.backgroundColor = [UIColor redColor];
    return imageHeight + textHeight + 40;
}


@end
