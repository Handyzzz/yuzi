//
//  WYPopUpTextView.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/4.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYPopUpTextView.h"
@interface WYPopUpTextView()<UITextViewDelegate>
@property(nonatomic,strong)NSString *placeHoder;
@property(nonatomic,strong)UITextView*textView;
@property(nonatomic,strong)UIView *backView;
@end

@implementation WYPopUpTextView

- (instancetype)initWithPlaceHoder:(NSString *)placeHoder{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.placeHoder = placeHoder;
        UIWindow *currentWindows = [UIApplication sharedApplication].keyWindow;
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.6);
        
        //加个动画，让整个的过程更加顺畅些
        self.alpha = 0;
        [currentWindows addSubview:self];
        
        [UIView transitionWithView:self
                          duration:0.35
                           options:UIViewAnimationOptionTransitionNone //any animation
                        animations:^ {
                            self.alpha = 1;
                        }
                        completion:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [self setUpView];
    }
   
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(50, 0, kAppScreenWidth -100, 0)];
        _backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backView];
        
        UILabel *titleLb = [UILabel new];
        [_backView addSubview:titleLb];
        titleLb.backgroundColor = UIColorFromHex(0x2ba1d4);
        titleLb.font = [UIFont systemFontOfSize:15];
        titleLb.text = @"留言板";
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.textColor = [UIColor whiteColor];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.top.equalTo(0);
            make.height.equalTo(40);
        }];
        
        _textView = [[UITextView alloc]initWithFrame:CGRectZero];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.delegate = self;
        _textView.text = [NSString stringWithFormat:@"  我是%@",kLocalSelf.fullName];
        [_backView addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLb.mas_bottom);
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.height.equalTo(160);

        }];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = UIColorFromHex(0x2ba1d4);
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backView);
            make.right.equalTo(_backView);
            make.top.equalTo(_textView.mas_bottom).equalTo(0);
            make.height.equalTo(40);
        }];
    }
    return _backView;
}

-(void)setUpView{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self addGestureRecognizer:tap];
    [self backView];
    [self.textView becomeFirstResponder];
}

- (void)keyBoardWillShow:(NSNotification*)notification{
    
    //获取frame
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if (frame.origin.y < kAppScreenHeight) {
        [UIView animateWithDuration:duration animations:^{
            CGFloat y = kAppScreenHeight - 240 - 15 - frame.size.height;
            self.backView.frame = CGRectMake(50, y, kAppScreenWidth -100, 240);
        }completion:^(BOOL finished) {
            if (finished) {
                _textView.selectedRange = NSMakeRange(4, kLocalSelf.fullName.length);
            }
        }];
    }
}

-(void)doneClick{
    [self removeFromSuperview];
    self.textClick([_textView.text copy]);
}

-(void)handleTap{
    [self removeFromSuperview];
}
@end
