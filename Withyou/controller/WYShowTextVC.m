//
//  WYShowTextVC.m
//  Withyou
//
//  Created by Tong Lu on 2016/10/22.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import "WYShowTextVC.h"

@implementation WYShowTextVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    [self createView];
    
}
- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.navigationTitle;
}
- (void)createView
{
    //发布框
    CGFloat offset = 15.0f;
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(kBorderWidth, kHeightNavigationItemAndStatusBar + offset, kAppScreenWidth - kBorderWidth*2, kAppScreenHeight - kHeightNavigationItemAndStatusBar - kBottomToolbarHeight - offset - offset)];
    _textView.font = [UIFont systemFontOfSize:14.0f];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _textView.textColor = kMediumGrayTextColor;
    _textView.selectable = YES;
    _textView.editable = NO;
    _textView.bounces = YES;
    _textView.alwaysBounceVertical = NO;
    _textView.userInteractionEnabled = YES;
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.text = self.text;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:_textView];
//    _textView.delegate = self;
    
}

@end
