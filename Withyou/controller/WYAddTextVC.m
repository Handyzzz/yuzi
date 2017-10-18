//
//  WYAddTextVC.m
//  Withyou
//
//  Created by Tong Lu on 7/31/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import "WYAddTextVC.h"


@interface WYAddTextVC() <UITextViewDelegate>
@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, strong)UILabel *textViewPlaceholderLabel;
@end


@implementation WYAddTextVC

#pragma lazy
-(NSString *)defaultText{
    if (_defaultText == nil) {
        _defaultText = @"";
    }
    return _defaultText;
}

-(NSString *)navigationTitle{
    if (_navigationTitle == nil) {
        _navigationTitle = @"添加文字";
    }
    return _navigationTitle;
}

-(NSString *)placeHolderText{
    if (_placeHolderText == nil) {
        _placeHolderText = @"请输入文字";
    }
    return _placeHolderText;
}

-(CGFloat )top{
    if (!_top) {
        _top = 15;
    }
    return _top;
}
-(CGFloat )left{
    if (!_left) {
        _left = 15;
    }
    return _left;
}
-(CGFloat )right{
    if (!_right) {
        _right = 15;
    }
    return _right;
}
-(CGFloat )height{
    if (!_height) {
        _height = 15;
    }
    return _height;
}

-(UIFont *)font{
    if (_font == nil) {
        _font = [UIFont systemFontOfSize:15];
    }
    return _font;
}
-(UIColor *)color{
    if (_color == nil) {
        _color = [UIColor blackColor];
    }
    return _color;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self createView];
    [self setNaviBar];
    
    //监听键盘的三个通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}



- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.navigationTitle;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)createView
{
    
    //发布框
    _textView = [UITextView new];
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.text = _defaultText;
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
    
    
    //默认字
    if (_defaultText == nil || [_defaultText isEqualToString:@""]) {
        _textViewPlaceholderLabel.text = @"请输入内容";
    }else{
        _textView.text = _defaultText;
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


- (void)doneAction
{
    self.myBlock(self.textView.text);
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
    }
}

# pragma mark - keyboard notification
- (void)keyboardWillShow:(NSNotification *)notification{
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue* keyboardFrameEnd = [userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameEndRect = [keyboardFrameEnd CGRectValue];
    keyboardFrameEndRect = [self.view convertRect:keyboardFrameEndRect fromView:nil];
    
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue* keyboardFrameEnd = [userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameEndRect = [keyboardFrameEnd CGRectValue];
    keyboardFrameEndRect = [self.view convertRect:keyboardFrameEndRect fromView:nil];
    
}

@end
