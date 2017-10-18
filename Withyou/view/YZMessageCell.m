//
//  YZMessageCell.m
//  Withyou
//
//  Created by lx on 16/12/19.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import "YZMessageCell.h"
#import "UIImageView+EMWebCache.h"

#define YZMessageCellTimeLableBottomMargin 8.0f
#define YZMessageCellTargetAreaDimension 72.0f
#define YZMessageCellTargetAreaMargin 10.0f
#define YZMessageCellMininumHeight (YZMessageCellTargetAreaDimension + YZMessageCellTargetAreaMargin*2)

@implementation YZMessageCell


#pragma mark -

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGRect rect = CGRectZero;
        rect.origin.x = 15;
        rect.size.width = width - rect.origin.x;
        rect.size.height = 1;
        self.lineImg = [[UIImageView alloc] initWithFrame:rect];
        self.lineImg.backgroundColor = UIColorFromHex(0xf5f5f5);
        [self addSubview:self.lineImg];
        
        rect.size.width = 40;
        rect.size.height = rect.size.width;
        rect.origin.x = 15;
//        rect.origin.y = 15;
        rect.origin.y = YZMessageCellTargetAreaMargin;
        self.iconImg = [[YZUserHeadView alloc] initWithFrameWithNoBorder:rect];
        self.iconImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClick:)];
        [self.iconImg addGestureRecognizer:iconGesture];
        [self addSubview:self.iconImg];
        
        rect.size.width = YZMessageCellTargetAreaDimension;
        rect.size.height = rect.size.width;
        rect.origin.x = width - rect.size.width - rect.origin.y;
        self.targetImg = [[UIImageView alloc] initWithFrame:rect];
        self.targetImg.clipsToBounds = YES;
        self.targetImg.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.targetImg];
        
        self.targetLabel = [[UILabel alloc] initWithFrame:rect];
        self.targetLabel.textColor = UIColorFromHex(0x666666);
        self.targetLabel.font = [UIFont systemFontOfSize:12];
        self.targetLabel.numberOfLines = 0;
        [self addSubview:self.targetLabel];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        [self.contentView addGestureRecognizer:longPress];
        
        
        rect.origin.x = CGRectGetMaxX(self.iconImg.frame) + 10;
        rect.size.height = 15;
        rect.size.width = 200;
        self.nameLabel = [[UILabel alloc] initWithFrame:rect];
//        self.nameLabel.backgroundColor = [UIColor redColor];
        
        self.nameLabel.textColor = UIColorFromHex(0x333333);
        self.nameLabel.font = [UIFont systemFontOfSize:kMsgTitleFontSize];
        self.nameLabel.numberOfLines = 0;
        [self addSubview:self.nameLabel];
        
        UIImage *image = [UIImage imageNamed:@"message_star"] ;
        rect.size = image.size;
        rect.origin.y = CGRectGetMaxY(self.nameLabel.frame) + 10;
        self.starImg = [[UIImageView alloc] initWithFrame:rect];
        self.starImg.image = image;
        [self addSubview:self.starImg];
        
        image = [UIImage imageNamed:@"info page-user_filled"] ;
        rect.size = image.size;
        rect.origin.y = CGRectGetMaxY(self.nameLabel.frame) + 10;
        self.fansImg = [[UIImageView alloc] initWithFrame:rect];
        self.fansImg.image = image;
        [self addSubview:self.fansImg];
        
        rect.size.height = 15;
        rect.size.width = 200;
        rect.origin.y = CGRectGetMaxY(self.starImg.frame) + 10;
        self.contentLabel = [[UILabel alloc] initWithFrame:rect];
        self.contentLabel.textColor = UIColorFromHex(0x999999);
        self.contentLabel.font = [UIFont systemFontOfSize:14];
        self.contentLabel.numberOfLines = 0;
        [self addSubview:self.contentLabel];
        
        rect.size.height = 15;
        rect.size.width = 200;
        rect.origin.y = CGRectGetMaxY(self.contentLabel.frame) + 10.0f;
        self.timeLabel = [[UILabel alloc] initWithFrame:rect];
        self.timeLabel.textColor = UIColorFromHex(0x999999);
        self.timeLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.timeLabel];
        
        rect.size.height = 51;
        rect.size.width = 2;
        rect.origin.y = CGRectGetMaxY(self.contentLabel.frame) + 6;
        self.replyImg = [[UIImageView alloc] initWithFrame:rect];
        self.replyImg.backgroundColor = UIColorFromHex(0x999999);
        [self addSubview:self.replyImg];
        
        rect.size.height = 15;
        rect.size.width = 200;
        rect.origin.x = CGRectGetMaxX(self.replyImg.frame) + 5;
        rect.origin.y = CGRectGetMaxY(self.contentLabel.frame) + 4;
        self.replyLabel = [[UILabel alloc] initWithFrame:rect];
        self.replyLabel.textColor = UIColorFromHex(0x999999);
        self.replyLabel.font = [UIFont systemFontOfSize:12];
        self.replyLabel.numberOfLines = 0;
//        self.replyLabel.backgroundColor = [UIColor redColor];
        [self addSubview:self.replyLabel];
        
    }
    
    return self;
}
+ (CGFloat)fitHeight:(YZMessage *)msg{
    CGFloat height = 15;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat maxWidth = width - 173;
    
    
    //不建议通过消息的类型去确定UI的布局，右侧是否有图片或文字，直接通过target pic和target content来判断，如果这两个都没有，那就是右侧什么都不展示，那部分空间可以利用
    
    
    if (msg.target_pic.length == 0 && msg.target_content.length == 0) {
        maxWidth = width - 76;
    }
    
    //was 14
    height += [[YZMessageCell title:msg] sizeWithFont:[UIFont systemFontOfSize:kMsgTitleFontSize] maxSize:CGSizeMake(maxWidth, MAXFLOAT) minimumLineHeight:1.4].height;
    height+= 4;
    
    if (msg.message_content.length) {
        height += [msg.message_content sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(maxWidth, MAXFLOAT) minimumLineHeight:1.4].height;
        height+= 4;
    }
    
    if (msg.reply_content.length) {
        CGFloat replyHeight = [msg.reply_content sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(maxWidth, MAXFLOAT) minimumLineHeight:1.4].height;
        if (replyHeight > 51) {
            replyHeight = 51;
        }
        height += replyHeight;
        height += 6;
    }
    
    height += 20;
    
    if (height < YZMessageCellMininumHeight) {
        height = YZMessageCellMininumHeight;
    }
    
    return height;
}

- (void)layoutSubviews{
    CGRect rect = self.timeLabel.frame;
    rect.origin.y = self.frame.size.height - YZMessageCellTimeLableBottomMargin - rect.size.height;
    self.timeLabel.frame = rect;
    
    rect = self.lineImg.frame;
    rect.origin.y = self.frame.size.height - rect.size.height;
    self.lineImg.frame = rect;
}
#pragma mark -
//长按最终应该是出现不同的几种行为方式，比如举报，删除，对target—uuid做出某种操作等等，而不能仅仅是删除
- (void)longPressAction:(UILongPressGestureRecognizer *)gesture {
    if(gesture.state != UIGestureRecognizerStateBegan) return;
    if(self.removeMessageBlock) self.removeMessageBlock(self.msg);
}

- (void)iconClick:(UITapGestureRecognizer *)gesture {
    if(self.iconClick) {
        self.iconClick(self.msg);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark -
- (void)setMsg:(YZMessage *)msg {
    _msg = msg;
    [self.iconImg loadImage:msg.author_icon];
    self.replyLabel.hidden = !msg.target_content.length;
    self.replyImg.hidden = !msg.target_pic.length;
    if (msg.message_content_pic.length) {
        self.contentLabel.hidden = YES;
        self.starImg.hidden = ![msg.message_content_pic isEqualToString:@"star"];
        self.fansImg.hidden = ![msg.message_content_pic isEqualToString:@"friend"];
    }else{
        self.contentLabel.hidden = NO;
        self.starImg.hidden = YES;
        self.fansImg.hidden = YES;
    }
    
    
    if (msg.reply_content.length) {
        self.replyLabel.attributedText = [self aStringText:msg.reply_content lineSpacing:1.4 font:[UIFont systemFontOfSize:12]];
        self.replyLabel.hidden = NO;
    }else{
        self.replyLabel.hidden = YES;
    }
    self.replyImg.hidden = self.replyLabel.hidden;
  
    self.nameLabel.attributedText = [self titleAT:msg lineSpacing:1.4];
    self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.timeLabel.text = [NSString stringWithCreatedAt:msg.created_at_float.floatValue];
    self.contentLabel.attributedText = [self aStringText:msg.message_content lineSpacing:1.4 font:self.contentLabel.font];
    
    if(msg.target_pic != nil && ![msg.target_pic isEqualToString:@""]) {
        self.targetImg.hidden = NO;
        self.targetLabel.hidden = YES;
        [self.targetImg sd_setImageWithURL:[NSURL URLWithString:msg.target_pic] placeholderImage:[UIImage imageNamed:@"111111-0.png"]];
    }else{
        self.targetImg.hidden = YES;
        self.targetLabel.hidden = NO;
        self.targetLabel.attributedText = [self aStringText:msg.target_content lineSpacing:1.4 font:[UIFont systemFontOfSize:12]];
    }
    
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat maxWidth = width - 173;
    
    if (msg.target_pic.length == 0 && msg.target_content.length == 0) {
        maxWidth = width - 76;
    }
    
    CGRect rect = self.nameLabel.frame;
    rect.size.width = maxWidth;
    rect.size.height = [[YZMessageCell title:msg] sizeWithFont:[UIFont systemFontOfSize:kMsgTitleFontSize] maxSize:CGSizeMake(maxWidth, MAXFLOAT) minimumLineHeight:1.4].height;
    self.nameLabel.frame = rect;
    
    rect = self.contentLabel.frame;
    rect.origin.y = CGRectGetMaxY(self.nameLabel.frame) + 4;
    rect.size.width = maxWidth;
    rect.size.height = [msg.message_content sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(maxWidth, MAXFLOAT) minimumLineHeight:1.4].height;
    self.contentLabel.frame = rect;
    
    rect = self.starImg.frame;
    rect.origin.y = CGRectGetMaxY(self.nameLabel.frame) + 10;
    self.starImg.frame = rect;
    
    rect = self.fansImg.frame;
    rect.origin.y = CGRectGetMaxY(self.nameLabel.frame) + 10;
    self.fansImg.frame = rect;
    
    CGFloat height = [msg.reply_content sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(maxWidth, MAXFLOAT) minimumLineHeight:1.4].height;
    
    if (height > 51) {
        height = 51;
    }
    
    rect = self.replyImg.frame;
    rect.origin.y = CGRectGetMaxY(self.contentLabel.frame) + 4 + height * 0.1;
    rect.size.height = height * 0.8;
    self.replyImg.frame = rect;
    
    rect = self.replyLabel.frame;
    rect.origin.y = CGRectGetMaxY(self.contentLabel.frame) + 4;
//    rect.origin.y = self.replyImg.frame.origin.y;
    rect.size.width = maxWidth;
    rect.size.height = height;
    self.replyLabel.frame = rect;
    
}

#pragma mark - Private

+ (NSString *)title:(YZMessage *)msg
{
    NSString *str = msg.author_name;
    if (msg.action_text.length) {
        str = [str stringByAppendingString:msg.action_text];
    }
    return str;
}

- (NSMutableAttributedString *)titleAT:(YZMessage *)msg lineSpacing:(CGFloat)lineSpacing{
    NSString *title = [YZMessageCell title:msg];
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:title.length ? title : @" "];
    
    [aString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kMsgTitleFontSize weight:0.4] range:NSMakeRange(0, msg.author_name.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    [aString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, msg.author_name.length)];
    
    return aString;
}

- (NSMutableAttributedString *)aStringText:(NSString *)text lineSpacing:(CGFloat)lineSpacing font:(UIFont *)font{
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:text.length > 0 ? text : @" "];
    NSRange range = NSMakeRange(0, aString.length);
    [aString addAttribute:NSFontAttributeName value:font range:range];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [aString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return aString;
}

@end
