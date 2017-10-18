//
//  YZChatCollectionViewCell.m
//  Withyou
//
//  Created by ping on 2017/3/25.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZChatCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import <Hyphenate/Hyphenate.h>
#import "NSDate+Category.h"

@interface YZChatCollectionViewCell ()

@property (nonatomic, strong) WYUser *user;
@property (nonatomic, strong) EMConversation *conversation;

@end

@implementation YZChatCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        
        UIView *groundView = [UIView new];
        groundView.backgroundColor = [UIColor whiteColor];
        groundView.layer.cornerRadius = 2;
        groundView.clipsToBounds = YES;
        [self.contentView addSubview:groundView];
        [groundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(chatItemW);
            make.left.right.equalTo(0);
            make.bottom.equalTo(0);
        }];
        self.groudView = groundView;
        
        //加背景圆环
        _annularIV = [UIImageView new];
        _annularIV.layer.cornerRadius = (annularWH/2.0);
        //_annularIV.clipsToBounds = YES;
        [self.contentView addSubview:_annularIV];
        [_annularIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(annularWH);
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(10);
        }];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_annularIV addSubview:image];
        image.layer.cornerRadius = (chatImageWH/2.0);
        image.clipsToBounds = YES;
        self.iconImage = image;
        
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(3, 3, 3, 3));
        }];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLabel.textColor = kRGB(153, 153, 153);
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:12];
        nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        nameLabel.numberOfLines = 2;
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(8);
            make.right.equalTo(-8);
            make.centerX.equalTo(0);
            make.top.equalTo(self.iconImage.mas_bottom).equalTo(12);
        }];
        
        UILabel *textlb = [UILabel new];
        [self.contentView addSubview:textlb];
        textlb.textAlignment =
        textlb.numberOfLines = 0;
        textlb.font = [UIFont systemFontOfSize:13 weight:-0.4];
        textlb.textColor = kRGB(197, 197, 197);
        [textlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(8);
            make.right.equalTo(-8);
            make.top.equalTo(self.nameLabel.mas_bottom).equalTo(6);
            make.height.lessThanOrEqualTo(40);
        }];
        self.textLabel = textlb;
        
        UILabel *timeLabel = [UILabel new];
        [self.contentView addSubview:timeLabel];
        timeLabel.numberOfLines = 1;
        timeLabel.textColor = kRGB(197, 197, 197);
        timeLabel.font = [UIFont systemFontOfSize:10];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-8);
            make.bottom.equalTo(-8);
        }];
        self.timeLabel = timeLabel;
        
        self.contentView.backgroundColor = kRGB(232, 240, 244);
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        [self.contentView addGestureRecognizer:longPress];
    };
    return self;
}

- (void)longPressAction:(UILongPressGestureRecognizer *)gesture {
    if(gesture.state != UIGestureRecognizerStateBegan) return;
    if(self.removeMessageBlock) self.removeMessageBlock();
}

- (void) rebuildWith:(WYUser *)user;{
    if (user != self.user) {
        self.user = user;
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:user.icon_url]];
        self.nameLabel.text = user.fullName;
        
        self.conversation = [[EMClient sharedClient].chatManager getConversation:user.easemob_username type:EMConversationTypeChat createIfNotExist:YES];
        
    }
    
    if (self.conversation) {
        
        int unreadCount = [self.conversation unreadMessagesCount];
        if (unreadCount > 0) {
            self.annularIV.image = [UIImage imageNamed:[self setUpAnnularImage]];
            
//            self.annularIV.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
//            self.annularIV.layer.shadowOffset = CGSizeMake(0, 2);//偏移距离
//            self.annularIV.layer.shadowOpacity = 0.6;//不透明度
//            self.annularIV.layer.shadowRadius = 80.0;//半径
            
            self.textLabel.textColor = UIColorFromHex(0x333333);
        }else{
            self.annularIV.image = [UIImage imageNamed:@"chatting page_picture boarder0"];
            
            self.annularIV.layer.shadowColor = [UIColor clearColor].CGColor;//阴影颜色

            self.textLabel.textColor = kRGB(197, 197, 197);
        }
        
        EMMessage *message = [self.conversation latestMessage];
        if (message) {
            NSString *content = @"";
            switch (message.body.type) {
                case EMMessageBodyTypeText:
                {
                    EMTextMessageBody *body = (EMTextMessageBody *)message.body;
                    content = body.text;
                    self.textLabel.textAlignment = NSTextAlignmentLeft;
                }
                    break;
                case EMMessageBodyTypeImage:
                {
                    content = @"[图片]";
                    self.textLabel.textAlignment = NSTextAlignmentCenter;
                }
                    break;
                case EMMessageBodyTypeVideo:
                {
                    content = @"[视频]";
                    self.textLabel.textAlignment = NSTextAlignmentCenter;
                }
                    break;
                case EMMessageBodyTypeLocation:
                {
                    content = @"[位置]";
                    self.textLabel.textAlignment = NSTextAlignmentCenter;
                }
                    break;
                case EMMessageBodyTypeVoice:
                {
                    content = @"[语音]";
                    self.textLabel.textAlignment = NSTextAlignmentCenter;
                }
                    break;
                case EMMessageBodyTypeFile:
                {
                    content = @"[文件]";
                    self.textLabel.textAlignment = NSTextAlignmentCenter;
                }
                    break;
                    
                default:
                    break;
            }
            self.textLabel.text = content;
            
            NSDate *messageDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
            self.timeLabel.text = [messageDate formattedTime];
            
        }else{
            self.groudView.backgroundColor = [UIColor whiteColor];
            self.textLabel.text = @"";
            self.timeLabel.text = @"";
        }
    }else{
        self.groudView.backgroundColor = [UIColor whiteColor];
        self.textLabel.text = @"";
        self.timeLabel.text = @"";
    }
}
//设置圆环
-(NSString *)setUpAnnularImage{
    //生成1到9的随机数
    int i = 1 + arc4random() % 9;
    NSString *name = [NSString stringWithFormat:@"chatting page_picture boarder%d",i];
    
    return name;
}

@end
