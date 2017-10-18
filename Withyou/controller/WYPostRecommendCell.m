//
//  WYPostRecommendCell.m
//  Withyou
//
//  Created by Handyzzz on 2017/5/6.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYPostRecommendCell.h"
#define CellWidth   (((kAppScreenWidth)-(8))/(2.0))
#define imgHeight   (CellWidth*5/4.f)

#define lineSpace   4.f
#define titleFont   14.f
#define textFont    14.f

#define playViewH 30.0
#define playViewW 80.0
#define playIconH 14

@implementation WYPostRecommendCell
/*
 1.cell自己不用的控件 要hide
 2.从头像往下 都是肯定有的 
   可能出现有的cell有 有的cell没有的情况有title  image title content
 */

-(UIImageView *)contentIV{
    if (_contentIV == nil) {
        _contentIV = [UIImageView new];
        _contentIV.contentMode = UIViewContentModeScaleAspectFill;
        _contentIV.clipsToBounds = YES;
        [self.contentView addSubview:_contentIV];
        _contentIV.userInteractionEnabled = NO;
        UITapGestureRecognizer *authorDetailRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageAction)];
        [_contentIV addGestureRecognizer:authorDetailRecognizer];
    }
    return _contentIV;
}


- (UILabel *)playLabel {
    if(!_playLabel) {
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(playViewH/2 + playIconH + 6, (playViewH - playIconH)/2, playViewW - playViewH - 6 - playIconH, playIconH)];
        
        timeLabel.textColor = UIColorFromHex(0xffffff);
        timeLabel.font = [UIFont systemFontOfSize:10];
        timeLabel.textAlignment = NSTextAlignmentRight;
        [self.playView addSubview:timeLabel];
        _playLabel = timeLabel;
    }
    return _playLabel;
}

- (UIView *)playView {
    if(!_playView) {
        UIView *playView = [UIView new];
        playView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        playView.layer.cornerRadius = playViewH / 2;
        playView.clipsToBounds = YES;
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(playViewH/2, (playViewH - playIconH)/2, playIconH, playIconH)];
        [playView addSubview:icon];
        icon.image = [UIImage imageNamed:@"video_call_filled_white"];
        
        [self.contentIV addSubview:playView];
        [playView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-15);
            make.right.equalTo(-10);
            make.width.equalTo(playViewW);
            make.height.equalTo(playViewH);
        }];
        _playView = playView;
        
        
    }
    return _playView;
}
-(UIImageView *)titleIV{
    if (_titleIV == nil) {
        _titleIV = [UIImageView new];
        [self.contentIV addSubview:_titleIV];
        [_titleIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(8);
            make.top.equalTo(8);
        }];
    }
    return _titleIV;
}


-(UILabel *)titleLb{
    if (_titleLb == nil) {
        _titleLb = [UILabel new];
        _textLb.textAlignment = NSTextAlignmentLeft;
        _titleLb.numberOfLines = 0;
        _titleLb.textColor = UIColorFromHex(0x333333);
        _titleLb.font = [UIFont systemFontOfSize:titleFont weight:0.23];
        [self.contentView addSubview:_titleLb];
    }
    return _titleLb;
}

//一般的情况下给6行 纯文本的时候给了10行
-(UILabel *)textLb{
    if (_textLb == nil) {
        _textLb = [UILabel new];
        _textLb.textAlignment = NSTextAlignmentLeft;
        _textLb.numberOfLines = 0;
        _textLb.font = [UIFont systemFontOfSize:textFont weight:-0.4];
        _textLb.textColor = UIColorFromHex(0x333333);
        [self.contentView addSubview:_textLb];
    }
    return _textLb;
}
-(UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [UIView new];
        _lineView.backgroundColor = UIColorFromHex(0x3ab1c8);
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.bottom.equalTo(self.reasonLb.mas_top).equalTo(-10);
            make.width.equalTo(16);
            make.height.equalTo(2);
        }];
    }
    return _lineView;
}
-(UILabel *)reasonLb{
    if (_reasonLb == nil) {
        _reasonLb = [UILabel new];
        _reasonLb.numberOfLines = 3;
        _reasonLb.textColor = UIColorFromHex(0x666666);
        _reasonLb.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_reasonLb];
        [_reasonLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.bottom.equalTo(self.textLabelLine.mas_top).equalTo(-15);
            make.width.equalTo(CellWidth-20);
        }];
    }
    return _reasonLb;
}
-(UIView *)textLabelLine{
    if (_textLabelLine == nil) {
        _textLabelLine = [UIView new];
        [self.contentView addSubview:_textLabelLine];
        _textLabelLine.backgroundColor = UIColorFromHex(0xf2f2f2);
        [_textLabelLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.iconIV.mas_top).equalTo(-10);
            make.height.equalTo(0.5);
            make.left.equalTo(8);
            make.right.equalTo(-8);
        }];
    }
    return _textLabelLine;
}

-(UIImageView *)iconIV{
    if (_iconIV == nil) {
        _iconIV = [UIImageView new];
        _iconIV.userInteractionEnabled = NO;
        UITapGestureRecognizer *authorDetailRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(authorDetailAction)];
        [_iconIV addGestureRecognizer:authorDetailRecognizer];
        _iconIV.layer.cornerRadius = 14;
        _iconIV.clipsToBounds = YES;
        [self.contentView addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.width.height.equalTo(28);
            make.bottom.equalTo(-10);
        }];
    }
    return _iconIV;
}
-(UILabel *)nameLb{
    if (_nameLb == nil) {
        _nameLb = [UILabel new];
        _nameLb.numberOfLines = 0;
        _nameLb.textColor = UIColorFromHex(0x333333);
        _nameLb.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).equalTo(8);
            make.centerY.equalTo(self.iconIV);
            make.width.equalTo(CellWidth-50);
        }];
    }
    return _nameLb;
}




#pragma mark -

-(void)setCellData:(WYPost *)recommentPost{
    CGFloat y = 0.0;
    
    self.playView.hidden = YES;
    self.playLabel.hidden = YES;

    switch (recommentPost.type) {
        case videoType:
        {
            self.titleIV.hidden = NO;
            self.contentIV.hidden = NO;
            self.titleLb.hidden = YES;
            self.textLb.hidden = NO;
            self.lineView.hidden = YES;
            self.playView.hidden = NO;
            self.playLabel.hidden = NO;

            //内容
            self.titleIV.image = [UIImage imageNamed:@"movie_filled"];
            [self.contentIV sd_setImageWithURL:[NSURL URLWithString:recommentPost.video.thumbnailImageUrl]];
            self.playLabel.text = [NSString stringFromDuration:[recommentPost.video.duration intValue]];
            [self.iconIV sd_setImageWithURL:[NSURL URLWithString:recommentPost.author.icon_url]];
            self.textLb.attributedText = [recommentPost.content TransToAttributeStrWithLineSpace:lineSpace];
            self.nameLb.text = recommentPost.author.fullName;
            self.reasonLb.text = recommentPost.recommend_reason;
            if (self.reasonLb.text.length > 0) {
                self.lineView.hidden = NO;
            }

            //image frame
            self.contentIV.frame = CGRectMake(0, 0, CellWidth, imgHeight);
            y = imgHeight;
            CGFloat contentHeight = [recommentPost.content sizeWithFont:[UIFont systemFontOfSize:textFont] maxSize:CGSizeMake(CellWidth -16, 61) minimumLineHeight:lineSpace].height;
            
            
            //text frame
            self.textLb.frame = CGRectMake(8, y + 8, CellWidth - 16, contentHeight);
            
        }
            break;
        case photoAlbumYype:
        {
            self.titleIV.hidden = NO;
            self.contentIV.hidden = NO;
            self.titleLb.hidden = NO;
            self.textLb.hidden = NO;
            self.lineView.hidden = YES;

            //内容
            self.titleIV.image = [UIImage imageNamed:@"collage_filled"];
            [self.contentIV sd_setImageWithURL:[NSURL URLWithString:recommentPost.mainPic.url]];
            self.titleLb.attributedText = [recommentPost.albumTitle TransToAttributeStrWithLineSpace:linkType];
            self.textLb.attributedText = [recommentPost.mainPic.content TransToAttributeStrWithLineSpace:lineSpace];
            [self.iconIV sd_setImageWithURL:[NSURL URLWithString:recommentPost.author.icon_url]];
            self.nameLb.text = recommentPost.author.fullName;
            self.reasonLb.text = recommentPost.recommend_reason;
            if (self.reasonLb.text.length > 0) {
                self.lineView.hidden = NO;
            }
            
            //image frame
            self.contentIV.frame = CGRectMake(0, 0, CellWidth, imgHeight);
            y = imgHeight;
            
            //title frame
            CGFloat titleHeight = [recommentPost.albumTitle sizeWithFont:[UIFont systemFontOfSize:titleFont] maxSize:CGSizeMake(CellWidth -16, 61) minimumLineHeight:lineSpace].height;
            self.titleLb.frame = CGRectMake(8, y + 8, CellWidth - 16, titleHeight);
            
            //text frame
            if (recommentPost.albumTitle.length > 0) {
                titleHeight = titleHeight + 8;
            }else{
                titleHeight = 4;
            }
            y = y + titleHeight;
            CGFloat contentHeight = [recommentPost.mainPic.content sizeWithFont:[UIFont systemFontOfSize:textFont] maxSize:CGSizeMake(CellWidth -16, 61) minimumLineHeight:lineSpace].height;
            self.textLb.frame = CGRectMake(8, y + 4, CellWidth - 16, contentHeight);

        }
            break;
        case linkType:
        {
            self.titleIV.hidden = NO;
            self.contentIV.hidden = NO;
            self.titleLb.hidden = NO;
            self.textLb.hidden = NO;
            self.lineView.hidden = YES;

            //普通类型 链接
            self.titleIV.image = [UIImage imageNamed:@"recommentPost_link"];
            [self.contentIV sd_setImageWithURL:[NSURL URLWithString:recommentPost.link.image]];
            self.titleLb.attributedText = [recommentPost.link.title TransToAttributeStrWithLineSpace:lineSpace];
            self.textLb.attributedText = [recommentPost.content TransToAttributeStrWithLineSpace:lineSpace];
            [self.iconIV sd_setImageWithURL:[NSURL URLWithString:recommentPost.author.icon_url]];
            self.nameLb.text = recommentPost.author.fullName;
            self.reasonLb.text = recommentPost.recommend_reason;
            if (self.reasonLb.text.length > 0) {
                self.lineView.hidden = NO;
            }
            //image frame
            self.contentIV.frame = CGRectMake(0, 0, CellWidth, imgHeight);
            y = imgHeight;
            
            
            //title frame
            CGFloat titleHeight = [recommentPost.link.title sizeWithFont:[UIFont systemFontOfSize:titleFont] maxSize:CGSizeMake(CellWidth -16, 61) minimumLineHeight:lineSpace].height;
            self.titleLb.frame = CGRectMake(8, y + 8, CellWidth - 16, titleHeight);
            if (recommentPost.link.title.length > 0) {
                titleHeight = titleHeight + 8;
            }else{
                titleHeight = 4;
            }
            y = y +titleHeight;
            
           //text frame
            CGFloat contentHeight = [recommentPost.content sizeWithFont:[UIFont systemFontOfSize:textFont] maxSize:CGSizeMake(CellWidth -16, 61) minimumLineHeight:lineSpace].height;
            self.textLb.frame = CGRectMake(8, y + 4, CellWidth - 16, contentHeight);
            
        }
            break;
        case photoType:
        {
            self.titleIV.hidden = YES;
            self.contentIV.hidden = NO;
            self.titleLb.hidden = YES;
            self.textLb.hidden = NO;
            self.lineView.hidden = YES;

            //内容
            [self.contentIV sd_setImageWithURL:[NSURL URLWithString:recommentPost.mainPic.url]];
            [self.iconIV sd_setImageWithURL:[NSURL URLWithString:recommentPost.author.icon_url]];
            self.textLb.attributedText = [recommentPost.mainPic.content TransToAttributeStrWithLineSpace:lineSpace];
            self.nameLb.text = recommentPost.author.fullName;
            self.reasonLb.text = recommentPost.recommend_reason;
            if (self.reasonLb.text.length > 0) {
                self.lineView.hidden = NO;
            }
            
            //image frame
            self.contentIV.frame = CGRectMake(0, 0, CellWidth, imgHeight);
            y = imgHeight;
            
            //text frame
            CGFloat contentHeight = [recommentPost.mainPic.content sizeWithFont:[UIFont systemFontOfSize:textFont] maxSize:CGSizeMake(CellWidth -16, 61) minimumLineHeight:lineSpace].height;
            self.textLb.frame = CGRectMake(8, y + 8, CellWidth - 16, contentHeight);
        }
            break;
        case characterType:
        {
            self.titleIV.hidden = YES;
            self.contentIV.hidden = YES;
            self.titleLb.hidden = NO;
            self.textLb.hidden = NO;
            self.lineView.hidden = YES;
            
            //设置内容
            NSString * titleStr = recommentPost.title;
            [self.iconIV sd_setImageWithURL:[NSURL URLWithString:recommentPost.author.icon_url]];
            self.titleLb.attributedText = [recommentPost.title TransToAttributeStrWithLineSpace:lineSpace];
            self.textLb.attributedText = [recommentPost.content TransToAttributeStrWithLineSpace:lineSpace];
            self.nameLb.text = recommentPost.author.fullName;
            self.reasonLb.text = recommentPost.recommend_reason;
            if (self.reasonLb.text.length > 0) {
                self.lineView.hidden = NO;
            }
            
            //title的frame
            CGFloat titleHeight = [recommentPost.title sizeWithFont:[UIFont systemFontOfSize:titleFont] maxSize:CGSizeMake(CellWidth -16, 61) minimumLineHeight:lineSpace].height;
            
            self.titleLb.frame = CGRectMake(8, 8, CellWidth - 16, titleHeight);
            if (titleStr.length > 0) {
                titleHeight = titleHeight +8;
            }else{
                titleHeight = 4;
            }
            
            //设置text的frame
            CGFloat contentHeight = [recommentPost.content sizeWithFont:[UIFont systemFontOfSize:textFont] maxSize:CGSizeMake(CellWidth -16, 201) minimumLineHeight:lineSpace].height;
            self.textLb.frame = CGRectMake(8, titleHeight + 4 , CellWidth - 16, contentHeight);
        }
            break;
            
        default:
            break;
    }
    
}


+(CGFloat)calculateCellHeight:(WYPost*)recommentPost{
    
    //计算图片高度
    CGFloat imageHeight = 0.0;
    if (recommentPost.type == characterType) {
        imageHeight = 0.0;
    }else{
        imageHeight = imgHeight;
    }
    
    
    
    //计算title高度
    NSString * titleStr;
    int top = 8.0;
    if (recommentPost.type == photoAlbumYype) {
        titleStr = recommentPost.albumTitle;
    }else if (recommentPost.type == linkType){
        titleStr = recommentPost.link.title;
    }else if (recommentPost.type == characterType){
        titleStr = recommentPost.title;
    }else{
        titleStr = nil;
    }
    CGFloat titleHeight = [titleStr sizeWithFont:[UIFont systemFontOfSize:titleFont] maxSize:CGSizeMake(CellWidth -16, 61) minimumLineHeight:4].height;

    if (titleStr.length > 0) {
        titleHeight = titleHeight + top;
    }else{
        titleHeight = 4;
    }
    
    
    
    //计算content高度
    NSString *contentStr;
    CGFloat size = textFont;
    CGFloat maxHeight;
    CGFloat contentHeight;
    
    
    if (recommentPost.type == photoAlbumYype || recommentPost.type == photoType) {
        contentStr = recommentPost.mainPic.content;
        maxHeight = 120;
         contentHeight = [contentStr sizeWithFont:[UIFont systemFontOfSize:size] maxSize:CGSizeMake(CellWidth -16, maxHeight) minimumLineHeight:lineSpace].height;

    }else if(recommentPost.type == linkType || recommentPost.type == videoType){
        contentStr = recommentPost.content;
        maxHeight = 120;
         contentHeight = [contentStr sizeWithFont:[UIFont systemFontOfSize:size] maxSize:CGSizeMake(CellWidth -16, maxHeight) minimumLineHeight:lineSpace].height;
    }else{
        //文字类型
        contentStr = recommentPost.content;
        maxHeight = 201;
        contentHeight = [contentStr sizeWithFont:[UIFont systemFontOfSize:size] maxSize:CGSizeMake(CellWidth -16, maxHeight) minimumLineHeight:lineSpace].height;
    }
    if (contentStr.length > 0) {
        contentHeight = contentHeight + 4;
    }else{
        contentHeight = 0;
    }
    
    
    //计算理由高度
    CGFloat reasonHeight = [recommentPost.recommend_reason sizeWithFont:[UIFont systemFontOfSize:10] maxSize:CGSizeMake(CellWidth -16, 43)].height;
    if (recommentPost.recommend_reason.length > 0) {
        CGFloat lineViewHeight = 2;
        lineViewHeight = lineViewHeight + 20;
        reasonHeight = lineViewHeight + reasonHeight + 10;

    }else{
        reasonHeight = 0;
    }

    CGFloat lineHeight = 1;
    lineHeight = lineHeight + 15;
    
    CGFloat iconHeight = 28.0;
    iconHeight = 10 + iconHeight + 10;
    
    
    //如果有这个控件 有给空隙 如果控件不存在的时候 就不给缝隙
    return  imageHeight + titleHeight + contentHeight + reasonHeight + lineHeight + iconHeight;
}

-(void)authorDetailAction{
    self.iconClick();
}
-(void)imageAction{
    self.imageClick();
}
@end
