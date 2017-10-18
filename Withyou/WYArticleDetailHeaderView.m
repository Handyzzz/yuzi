//
//  WYArticleDetailHeaderView.m
//  Withyou
//
//  Created by Handyzzz on 2017/9/29.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYArticleDetailHeaderView.h"
#import "WYMediaAPI.h"

@interface WYArticleDetailHeaderView()
@property(nonatomic, assign) CGFloat titleH;
@property(nonatomic, assign) WYArticle *article;
@end
@implementation WYArticleDetailHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _titleLb = [UILabel new];
        _titleLb.font = [UIFont systemFontOfSize:22];
        _titleLb.textColor = UIColorFromHex(0x333333);
        [self addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(15);
            make.right.equalTo(15);
        }];
        
        _iconIV = [UIImageView new];
        _iconIV.layer.cornerRadius = 2;
        _iconIV.clipsToBounds = YES;
        [self addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.width.equalTo(34);
            make.height.equalTo(34);
        }];
        
        _nameLb = [UILabel new];
        _nameLb.font = [UIFont systemFontOfSize:14];
        _nameLb.textColor = UIColorFromHex(0x333333);
        [self addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconIV.mas_right).equalTo(6);
            make.centerY.equalTo(_iconIV);
        }];
        
        _attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_attentionBtn setBackgroundImage:[UIImage imageNamed:@"media_follow"] forState:UIControlStateNormal];
        [_attentionBtn setBackgroundImage:[UIImage imageNamed:@"media_followed"] forState:UIControlStateSelected];
        [_attentionBtn addTarget:self action:@selector(attionAction:) forControlEvents: UIControlEventTouchUpInside];
        [self addSubview:_attentionBtn];
        [_attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-20);
            make.centerY.equalTo(_iconIV);
        }];
        
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 0)];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.scrollEnabled = NO;
        _webView.opaque = YES;
        [self addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.top.equalTo(_iconIV.mas_bottom).equalTo(25);
        }];
    }
    return self;
}

-(void)setHeaderView:(WYArticle *)article{
    self.article = article;
    CGFloat KFont22H = 26 + 1/3.f;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 10;
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc]initWithString:article.title attributes:@{NSParagraphStyleAttributeName : style}];
    _titleH = [article.title sizeWithFont:[UIFont systemFontOfSize:22] maxSize:CGSizeMake(kAppScreenWidth - 30, KFont22H *2) minimumLineHeight:10].height;
    
    self.titleLb.attributedText = mas;
    self.titleLb.height = _titleH;
    
    CGFloat headerH = 0.f;
    if (article.title.length > 0) {
        [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLb.mas_bottom).equalTo(15);
        }];
        headerH = 15 + _titleH + 15 + 34 + + 25;

    }else{
        self.iconIV.top = 15;
        headerH = 15 + 34 + + 25;
    }
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:article.media.icon_url]];
    [self.nameLb setText:article.media.name];
    if (article.media.followed == YES) {
        self.attentionBtn.selected = YES;
    }else{
        self.attentionBtn.selected = NO;
    }
    
    NSString *encodedString=[article.web_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *weburl = [NSURL URLWithString:encodedString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:weburl]];
    
    self.height = headerH;
}

-(void)attionAction:(UIButton *)sender{
    
    __weak WYArticleDetailHeaderView *weakSelf = self;
    if (sender.selected == YES) {
        sender.selected = NO;
        //cancel
        [WYMediaAPI cancelFollowToMedia:self.article.media.uuid callback:^(NSInteger status) {
            debugLog(@"cancel %ld",status);
            if (status == 204) {
                sender.selected = NO;
                weakSelf.article.media.followed = NO;
            }else{
                sender.selected = YES;
                weakSelf.article.media.followed = YES;
                debugLog(@"%@",self.article.media.uuid);
                [OMGToast showWithText:@"取消关注失败"];
            }
        }];
    }else{
        sender.selected = YES;
        //add follow
        [WYMediaAPI addFollowToMedia:self.article.media.uuid callback:^(NSInteger status) {
            debugLog(@"add %ld",status);
            if (status == 201) {
                sender.selected = YES;
                weakSelf.article.media.followed = YES;
                
            }else{
                sender.selected = NO;
                weakSelf.article.media.followed = NO;
                [OMGToast showWithText:@"关注失败"];
            }
        }];
    }
}
@end


