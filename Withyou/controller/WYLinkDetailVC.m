//
//  WYLinkDetailVC.m
//  Withyou
//
//  Created by Tong Lu on 8/8/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import "WYLinkDetailVC.h"
#import <WebKit/WebKit.h>
#import "UIActionSheet+Blocks.h"

@interface WYLinkDetailVC ()<WKNavigationDelegate>
{
    WKWebView *_webView;
    UIProgressView *_progressView;
}

@end

@implementation WYLinkDetailVC

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviBar];
    [self createLayout];
    [self resiginNoti];

}

-(void)setNaviBar{
    
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;

    UIBarButtonItem *moreBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"naviRightBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(moreBtnAction)];
    self.navigationItem.rightBarButtonItem = moreBtn;
}


- (void)backAction{
    
    //得到栈里面的list webView.backForwardList
    if (_webView.backForwardList.backList.count>0) {
        ////得到现在加载的list WKBackForwardListItem * item = webView.backForwardList.currentItem;
        [_webView goToBackForwardListItem:_webView.backForwardList.backList[_webView.backForwardList.backList.count - 1]];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)resiginNoti{
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
}
-(void)dealloc{
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)createLayout
{
    self.view.backgroundColor = kGlobalBg;
    self.title = @"分享链接";
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    _webView.navigationDelegate = self;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.opaque = NO;
    _progressView = [UIProgressView new];
    _progressView.frame = CGRectMake(0, 42, SCREEN_WIDTH, 2);
    
    UIView *navBar = [self.navigationController navigationBar];
    [navBar addSubview:_progressView];
    [self.view addSubview:_webView];

    NSString *encodedString=[self.post.link.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *weburl = [NSURL URLWithString:encodedString];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:weburl]];
    
}
#pragma mark -delegate

//用代理方法 计算progressView 跑起来的时候是点段状的 通知是线性的
#pragma mark 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
}

#pragma mark 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
}

#pragma mark 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
}

#pragma mark 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        if (object == _webView) {
            [_progressView setAlpha:1.0f];
            [_progressView setProgress:_webView.estimatedProgress animated:YES];
            
            if(_webView.estimatedProgress >= 1.0f) {
                
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [_progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [_progressView setProgress:0.0f animated:NO];
                }];
                
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    }
}

#pragma mark - Actions
- (void)moreBtnAction{
    
    UIActionSheet *as =
     [[UIActionSheet alloc] initWithTitle:@"链接"
                         cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
         return;
    }]

                    destructiveButtonItem:nil
     
                         otherButtonItems:[RIButtonItem itemWithLabel:@"复制链接地址" action:^{
         
         [UIPasteboard generalPasteboard].string = self.post.link.url;
         [OMGToast showWithText:@"地址已复制"];
         
     }], nil];
    [as showInView:self.view];
}

#pragma mark - link page switching
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
