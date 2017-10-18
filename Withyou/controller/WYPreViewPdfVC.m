//
//  WYPreViewPdfVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/22.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYPreViewPdfVC.h"
#import <WebKit/WebKit.h>

@interface WYPreViewPdfVC ()<WKNavigationDelegate, WKUIDelegate>
{
    WKWebView *_webView;
    UIProgressView *_progressView;
}
@end

@implementation WYPreViewPdfVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"预览";
    [self setNaviBar];
    [self createLayout];
    [self registerNotification];
}

-(void)registerNotification{
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
}

-(void)dealloc{
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}

- (void)createLayout
{
    self.view.backgroundColor = kGlobalBg;
    
    // 3. 加载HTML请求
    //    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth, kAppScreenHeight)];
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    
    _webView.backgroundColor = [UIColor clearColor];
    _webView.opaque = NO;
    
    [self.view addSubview:_webView];
    
    _progressView = [UIProgressView new];
    _progressView.frame = CGRectMake(0, 42, SCREEN_WIDTH, 2);
    [self.navigationController.navigationBar.layer addSublayer:_progressView.layer];
    
    
    //todo, links
    NSString *encodedString=[self.targetUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *weburl = [NSURL URLWithString:encodedString];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:weburl]];
    
}
#pragma mark -
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[WYUtility sharedAppDelegate] setNetworkActivityIndicatorVisible:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[WYUtility sharedAppDelegate] setNetworkActivityIndicatorVisible:NO];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[WYUtility sharedAppDelegate] setNetworkActivityIndicatorVisible:NO];
    
}

#pragma navi
-(void)setNaviBar{

    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
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

#pragma mark - Alert View
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
