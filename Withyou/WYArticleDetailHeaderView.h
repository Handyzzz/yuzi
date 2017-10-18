//
//  WYArticleDetailHeaderView.h
//  Withyou
//
//  Created by Handyzzz on 2017/9/29.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WYArticle.h"

@interface WYArticleDetailHeaderView : UIView
@property(nonatomic, strong)UILabel *titleLb;
@property(nonatomic, strong)UIImageView *iconIV;
@property(nonatomic, strong)UILabel *nameLb;
@property(nonatomic, strong)UIButton *attentionBtn;
@property(nonatomic, strong)WKWebView *webView;

-(void)setHeaderView:(WYArticle *)article;
@end
