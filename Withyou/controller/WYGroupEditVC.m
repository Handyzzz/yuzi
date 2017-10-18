//
//  WYGroupEditVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/4/14.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYGroupEditVC.h"
#import "WYGroup.h"
#import "WYGroupApi.h"

@interface WYGroupEditVC ()<UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong)UILabel *titleLable;
@property (nonatomic, strong)UITextField*textFiled;
@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, assign)BOOL isAdmin;
@property (nonatomic, assign)BOOL canEditing;
@end

@implementation WYGroupEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setLeftNaviTitle];
    
    NSArray*array = [self.group.administrator componentsSeparatedByString:@","];
    
    if (array.count >0) {
        for (NSString  *uid in array) {
            if ([uid isEqualToString:kuserUUID]) {
                self.isAdmin = YES;
                [self setRighttNaviTitle];
            }
        }
    }
    
    [self creatUI];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)setLeftNaviTitle{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)creatUI{
    
    self.titleLable.text = self.labelString;
    self.title = self.labelString;
    
    if (self.type) {
        self.textView.attributedText = [self aStringText:self.textFieldString lineSpacing:1.4 font:self.textView.font];
        self.textView.editable = NO;
        if (self.textFieldString.length == 0 && [self isAdmin] == YES) {
            self.textView.text = @"输入群组简介";
            self.textView.tag = 1000;
        }else{
            self.textView.tag = 1001;
        }
    }else{
        self.textFiled.text = self.textFieldString;
        _canEditing = NO;
    }
   
}

-(UILabel *)titleLable{
    if (_titleLable == nil) {
        _titleLable = [UILabel new];
        _titleLable.font = [UIFont systemFontOfSize:14];
        _titleLable.textColor = UIColorFromHex(0x999999);
        [self.view addSubview:_titleLable];
        [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.right.equalTo(0);
            make.top.equalTo(64);
            make.height.equalTo(51);
        }];
    }
    return _titleLable;
}

-(UITextField *)textFiled{
    if (_textFiled == nil) {
        _textFiled = [UITextField new];
        _textFiled.delegate = self;
        _textFiled.font = [UIFont systemFontOfSize:14];
        _textFiled.textColor = UIColorFromHex(0x333333);
        _textFiled.delegate = self;
        [self.view addSubview:_textFiled];
        [_textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(86);
            make.right.equalTo(-40);
            make.height.equalTo(51);
            make.centerY.equalTo(self.titleLable);
        }];
    }
    return _textFiled;
}

- (UITextView *)textView{
    if (_textView == nil) {
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = UIColorFromHex(0xf5f5f5);
        [self.view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(114);
            make.height.equalTo(1);
        }];
        
        _textView = [UITextView new];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.textColor = UIColorFromHex(0x333333);
        _textView.delegate = self;
        [self.view addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.right.equalTo(-15);
            make.top.equalTo(115);
            make.bottom.equalTo(0);
        }];
    }
    return _textView;
}

#pragma actions
-(void)setRighttNaviTitle{
    UIBarButtonItem *title = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(doEidt)];
    self.navigationItem.rightBarButtonItem = title;
}

- (void)doEidt{
    if (self.type) {
        self.textView.editable = YES;
        [self.textView becomeFirstResponder];
    }else{
        [self.textFiled becomeFirstResponder];
        _canEditing = YES;
    }
    self.navigationItem.rightBarButtonItem = nil;
    UIBarButtonItem *title = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(DoneClick)];
    self.navigationItem.rightBarButtonItem = title;
}

//textFiled实现 可以复制不可以编辑的方式
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return _canEditing;
}

-(void)DoneClick{
    self.navigationController.navigationItem.rightBarButtonItem.enabled = NO;
    
    NSString *text = self.type ? (self.textView.text ? self.textView.text : @"") : (self.textFiled.text ? self.textFiled.text : @"");
    
    if ((text.length<1) && (self.type == 0)) {
        [OMGToast showWithText:@"请输入内容"];
        return;
    }
   
    //将修改后的群名称和头像patch 成功后将text传回去
    NSDictionary *dic = [NSDictionary dictionaryWithObject:text forKey:self.key];
    
    __block WYGroupEditVC *weakSelf = self;
    [WYGroupApi changeGroupDetail:self.group.uuid dic:dic Block:^(WYGroup *group) {
        //发送群名称或者介绍 变更的通知
        if (group) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateGroupDataSource object:self userInfo:@{@"group":group}];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
            self.navigationController.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }];
}

#pragma mark - UITextViewDelegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if(textView.tag == 1000) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        textView.tag = 1001;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (NSMutableAttributedString *)aStringText:(NSString *)text lineSpacing:(CGFloat)lineSpacing font:(UIFont *)font{
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:text.length > 0 ? text : @" "];
    NSRange range = NSMakeRange(0, aString.length);
    [aString addAttribute:NSFontAttributeName value:font range:range];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    [aString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return aString;
}


@end
