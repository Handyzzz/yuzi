//
//  YZPostInfoView.m
//  Withyou
//
//  Created by ping on 2017/5/13.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZPostInfoView.h"

#define height 46
#define iconheight 12
#define iconWidth 18
#define marginLeft 15

#define btnW 60
#define btnH 54
#define betweenBtnW 10


@interface YZPostInfoView ()


@end

@implementation YZPostInfoView

#pragma lazy load

- (UIImageView *)iconImage {
    if(!_iconImage) {
        UIImageView *iconImage = [[UIImageView alloc] init];
        [self addSubview:iconImage];
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(marginLeft);
            make.centerY.equalTo(0);
        }];
        _iconImage = iconImage;
    }
    return _iconImage;
}

- (UILabel *)iconLabel {
    if(!_iconLabel) {
        UILabel *iconLabel = [[UILabel alloc] init];
        [self addSubview:iconLabel];
        iconLabel.font = [UIFont systemFontOfSize:12 weight:0.4];
        iconLabel.textColor = kRGB(51, 51, 51);
        [iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImage.mas_right).equalTo(6);
            make.width.equalTo(100);
            make.centerY.equalTo(self.iconImage);
        }];
        _iconLabel = iconLabel;
    }
    return _iconLabel;
}

- (UIButton *)commentButton {
    if(!_commentButton) {
        UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:commentButton];
        [commentButton setImage:[UIImage imageNamed:@"shareComment"] forState:UIControlStateNormal];
        commentButton.frame = CGRectMake(kAppScreenWidth - (btnW + marginLeft), 0, btnW, btnH);
        _commentButton = commentButton;
    }
    return _commentButton;
}

- (UILabel *)commentCountLabel {
    if (!_commentCountLabel) {
        UILabel *commentCountLabel = [[UILabel alloc] init];
        commentCountLabel.textColor = UIColorFromHex(0x333333);
        commentCountLabel.font = [UIFont systemFontOfSize:10];
        commentCountLabel.frame = CGRectMake(CGRectGetMaxX(self.commentButton.frame) - 13, 8, 15, 15);
        [self addSubview:commentCountLabel];
        _commentCountLabel = commentCountLabel;
    }
    return _commentCountLabel;
}

- (UIButton *)starButton {
    if(!_starButton) {
        UIButton *starButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:starButton];
        starButton.frame = CGRectMake(0, 0, btnW, btnH);
        starButton.frame = CGRectMake(self.commentButton.frame.origin.x - betweenBtnW - btnW, self.commentButton.frame.origin.y, btnW, btnH);
        _starButton = starButton;
    }
    return _starButton;
}

- (UILabel *)starCountLabel {
    if (!_starCountLabel) {
        UILabel *starCountLabel = [[UILabel alloc] init];
        starCountLabel.textColor = UIColorFromHex(0x333333);
        starCountLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:starCountLabel];
        starCountLabel.frame = CGRectMake(CGRectGetMaxX(self.starButton.frame) - 13, 8, 15, 15);
        _starCountLabel = starCountLabel;
    }
    return _starCountLabel;
}


- (void)setupWith:(WYCellPostFrame *)postFrame isDetail:(BOOL)detailPage {
    WYPost *post = postFrame.post;
    
    self.frame = postFrame.infoFrame;
    
    
    
    if([post.targetType isEqualToNumber:@4]){
        self.iconImage.image = [UIImage imageNamed:@"share_visible_highlight"];
        self.iconLabel.textColor = kRGB(43, 161, 212);
    }else {
        self.iconImage.image = [UIImage imageNamed:@"shareVisible"];
        self.iconLabel.textColor = kRGB(51, 51, 51);
    }
    
    switch ([post.targetType integerValue]) {
        case 1:
            self.iconLabel.text = @"公开";
            break;
        case 2:
            if(post.targetName && [post.targetName isEqualToString:@""] == NO ) {
                self.iconLabel.text = post.targetName;
            }else {
                self.iconLabel.text = @"朋友可见";
            }
            break;
        case 3:
            self.iconLabel.text = post.targetName;
            break;
        case 4:
            if([post.targetUuid isEqualToString:kuserUUID]){
                self.iconLabel.text = @"分享给你";
            }
            else{
                self.iconLabel.text = post.targetName;
            }
            break;
        case 5:
            self.iconLabel.text = @"自己";
            break;
        default:
            self.iconLabel.text = @"";
            break;
    }
    
    
    if(detailPage) return;
    self.starCountLabel.text = [NSString getWorldCountLabel:post.starNum];
    self.commentCountLabel.text = [NSString getWorldCountLabel:post.commentNum];
    NSString *starImg = nil;
    if(postFrame.post.starred) {
        starImg = @"shareStarHighlight";
        self.starCountLabel.textColor = UIColorFromHex(0x00B2E1);
    }else {
        starImg = @"shareStar";
        self.starCountLabel.textColor = UIColorFromHex(0x333333);
    }
    [self.starButton setImage:[UIImage imageNamed:starImg] forState:UIControlStateNormal];
}


@end
