//
//  WYAddUserIntroductionVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/9/23.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYAddUserIntroductionVC.h"
#import "WYProfileApi.h"

@interface WYAddUserIntroductionVC ()<UITextViewDelegate>
@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, strong)UILabel *textViewPlaceholderLabel;
@end

@implementation WYAddUserIntroductionVC
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self createView];
    [self setNaviBar];
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"个人简介";
}

- (void)createView{
    //发布框
    _textView = [UITextView new];
    _textView.text = self.defaultText;
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.selectable = YES;
    _textView.editable = YES;
    _textView.bounces = YES;
    _textView.alwaysBounceVertical = NO;
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.delegate = self;
    [_textView becomeFirstResponder];
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.top.equalTo(15);
        make.height.equalTo(200);
    }];
    
    //PlaceholderLabel
    _textViewPlaceholderLabel = [UILabel new];
    _textViewPlaceholderLabel.textColor = UIColorFromHex(0xc5c5c5);
    _textViewPlaceholderLabel.font = [UIFont systemFontOfSize:14];
    [_textView addSubview:_textViewPlaceholderLabel];
    [_textViewPlaceholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(5);
        make.top.equalTo(8);
    }];
    if (!(self.defaultText.length > 0)) {
        _textViewPlaceholderLabel.text = @"请输入个人简介";
    }
}
- (void)setNaviBar
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItem = item;
    
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}


- (void)doneAction{
    //patch简介
    __weak WYAddUserIntroductionVC *weakSelf = self;
    NSString *str = self.textView.text ? self.textView.text : @"";
    [WYProfileApi patchProfireDic:@{@"intro":str} Block:^(WYProfile *profile) {
        if (profile) {
            weakSelf.myBlock(self.textView.text);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
            weakSelf.navigationController.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backAction
{
    NSString *str = [_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (str.length >= 1) {
        //三个字或以上的，需要弹出些东西来保存，否则就直接退出就好
        [[[UIAlertView alloc] initWithTitle:@"放弃修改?"
                                    message:@"放弃文字修改，确定退出?"
                           cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
            // Handle "Cancel"
            return;
        }]
                           otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^{
            
            [self.navigationController popViewControllerAnimated:YES];
            
            // Handle "Delete"
        }], nil] show];
        
    }else {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

#pragma mark -

- (void)textViewDidChange:(UITextView *)textView{
    _textView.textColor = [UIColor blackColor];
    if (textView.text == nil || textView.attributedText.length == 0) {
        _textViewPlaceholderLabel.hidden = NO;
    }else {
        _textViewPlaceholderLabel.hidden = YES;
        if (textView.text.length > 100) {
            [OMGToast showWithText:@"你最多可以输入100字简介"];
            textView.text = [textView.text substringWithRange:NSMakeRange(0, 100)];
        }
    }
}
@end
