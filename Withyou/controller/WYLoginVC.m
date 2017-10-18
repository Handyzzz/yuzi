//
//  WYLoginVC.m
//  Withyou
//
//  Created by Tong Lu on 7/26/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import "WYLoginVC.h"
#import "DJRegisterView.h"
#import "WYAccountApi.h"
#import "WYUIDTool.h"
#import "WYWebViewVC.h"
#import "RootPageVC.h"
#import "WYLoginView.h"

@interface WYLoginVC()
{
    
    DJRegisterView *djzcView;
    WYLoginView *_loginView;
    BOOL _agree;
}

@property(nonatomic, strong) UIImageView *tagIV;
@property (nonatomic, assign) NSUInteger cdTime;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIView *bottomTipView;

@end


@implementation WYLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _loginView = [[WYLoginView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, kAppScreenHeight)];
    [_loginView groundIV];
    [_loginView IDTextFiled];
    [_loginView lineOne];
    [_loginView passWordTextFiled];
    [_loginView lineTwo];
    [_loginView lineThree];
    [_loginView verifyBtn];
    [_loginView loginBtn];
    [self.view addSubview:_loginView];
    [_loginView.verifyBtn addTarget:self action:@selector(requestVCodeForPhone) forControlEvents:UIControlEventTouchUpInside];
    [_loginView.loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:djzcView];
    
    
    [self footView];
}

-(void)dealloc{
    self.timer = nil;
}

- (NSMutableAttributedString *)protocolAstring{
    NSString *str = @"已阅读并同意与子用户协议 ";
    NSMutableAttributedString *astring = [[NSMutableAttributedString alloc] initWithString:str];
    [astring addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, str.length)];
    [astring addAttribute:NSForegroundColorAttributeName value:kRGB(255, 196, 98) range:[str rangeOfString:@"用户协议 "]];
    return astring;
}

- (void)footView{
    
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeBtn.frame = CGRectMake(0, kAppScreenHeight - 44, 50, 44);
    [agreeBtn addTarget:self action:@selector(handleAgree) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreeBtn];
    
    self.tagIV = [[UIImageView alloc] initWithFrame:CGRectMake(36, 15, 14, 14)];
    self.tagIV.image = [UIImage imageNamed:@"invalidAgree"];
    [agreeBtn addSubview:self.tagIV];
    
    _agree = YES;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kAppScreenWidth * 0.65, kAppScreenHeight - 28, 2, 12)];
    lineView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6] ;
    [self.view addSubview:lineView];
    
    UIButton *eula = [UIButton buttonWithType:UIButtonTypeCustom];
    [eula setAttributedTitle:[self protocolAstring] forState:UIControlStateNormal];
    eula.titleLabel.font = [UIFont systemFontOfSize:12];
    [eula addTarget:self action:@selector(checkEulaInSafari) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:eula];
    [eula mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(agreeBtn);
        make.left.equalTo(55);
    }];
    
    UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [applyBtn setTitle:@"申请邀请码" forState:UIControlStateNormal];
    [applyBtn setTitleColor:kRGB(255, 196, 98) forState:UIControlStateNormal];
    applyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [applyBtn addTarget:self action:@selector(handleApply) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applyBtn];
    [applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(eula);
        make.right.equalTo(-35);
    }];
}

- (void)handleApply{
    WYWebViewVC *vc = [[WYWebViewVC alloc] init];
    vc.navigationTitle = @"申请注册邀请";
    vc.targetUrl = [NSString stringWithFormat:@"%@/s/apply_invitation_code/",kBaseURL];
    vc.isPresent = YES;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)handleAgree{
    _agree = !_agree;
    self.tagIV.image = _agree ? [UIImage imageNamed:@"invalidAgree"] : [UIImage imageNamed:@"loginpage_gou_unchosen"];
    _loginView.loginBtn.userInteractionEnabled = _agree;
    _loginView.loginBtn.backgroundColor = _agree ? kRGB(255, 196, 98) : kRGB(197, 197, 197);
    [_loginView.loginBtn setTitleColor:_agree ? kRGB(51, 51, 51) : kRGB(153, 153, 153) forState:UIControlStateNormal];
    
}

- (void)checkEulaInSafari
{
    WYWebViewVC *vc = [[WYWebViewVC alloc] init];
    vc.navigationTitle = @"与子用户协议";
    vc.targetUrl = [NSString stringWithFormat:@"%@/static/html/eula.html",kBaseURL];
    vc.isPresent = YES;

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)requestVCodeForPhone{
    
    if(![WYUtility checkPhoneNumber:_loginView.IDTextFiled.text])
    {
        [djzcView huoQuButtonRestart];
        return ;
    }
    
    [self.view showHUDNoHide];
    NSString * t = [WYAccountApi getTokenForVCodeFromPhone:_loginView.IDTextFiled.text];
    NSString *phoneStr = [@"86." stringByAppendingString:_loginView.IDTextFiled.text];
    
    [WYAccountApi getVCodeByParam:@{@"phone": phoneStr, @"t": t} WithBlock:^(NSDictionary *dict, NSError *error, NSInteger status) {
        [self.view hideAllHUD];
        if(error != nil)
        {
            //失败
            if (status == 412) {
                [self bottomTipViewShow];
            }else{
                [WYUtility showAlertWithTitle:@"验证码发送失败，请稍后再尝试登录"];
            }
        }else {
            //成功
            [OMGToast showWithText:@"发送成功,请注意查收"];
            
            self.cdTime = 59;
            _loginView.verifyBtn.hidden = YES;
            _loginView.verifyCDLb.hidden = NO;
            _loginView.verifyCDLb.text = [NSString stringWithFormat:@"%@s后重新发送",@(self.cdTime).stringValue];
            [self timerStart];
        }
    }];
}

- (void)loginClick{
    
    
    if([_loginView.passWordTextFiled.text isEqualToString:@""] || [_loginView.IDTextFiled.text isEqualToString:@""] || _loginView.passWordTextFiled.text == nil || _loginView.IDTextFiled.text == nil)
    {
        [WYUtility showAlertWithTitle:@"请先获取验证码"];
        [djzcView validateZhuCeBtn];
        
        return;
    }
    NSString *phoneStr = [@"86." stringByAppendingString:_loginView.IDTextFiled.text];

    [self.view showHUDNoHide];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [WYAccountApi postLoginByParam:@{@"phone": phoneStr, @"vcode": _loginView.passWordTextFiled.text}
                         WithBlock:^(WYUID *uid, NSError *error) {
                             
                             [self.view hideAllHUD];
                             [[UIApplication sharedApplication] endIgnoringInteractionEvents];

                             if(uid != nil)
                             {
                                 //切换用户并且登录成功 重新注册一次通知
                                 [WYUtility registerForRemoteNotification];
                                 //注册通知后 已经注册通知的代理方法会调用 然后更新key给后端 然后设置YES 环信就不会再更新
                                 [djzcView huoQuButtonEndTimerAfterSuccessLogin];
                                 /*
                                 应用的生命周期从启动到杀死进程 [UIApplication sharedApplication].delegate 
                                  UIApplicationDelegate 都是同一个对象
                                  */
                                 AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
                                 RootPageVC * vc = [[RootPageVC alloc] init];
                                 delegate.window.rootViewController = vc;
                                 [WYUtility hxLogin:uid.easemob_username withPassword:uid.easemob_password];
                                 [self timerStop];
                                 
                             }
                             else
                             {
                                 NSLog(@"in login false alert");
                                 [djzcView huoQuButtonRestart];
                                 [WYUtility showAlertWithTitle:@"登录未成功，请检查验证码是否正确输入，是否在3分钟有效期内输入，以及网络是否畅通"];
                                 [djzcView validateZhuCeBtn];
                             }
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - Timer

- (void) timerStart{
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(cdTimechange) userInfo:nil repeats:YES];
    }
}

- (void) timerStop{
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    self.timer = nil;
}

- (void)cdTimechange{
    
    self.cdTime = self.cdTime - 1;
    if (self.cdTime <= 0) {
        self.cdTime = 0;
    
        _loginView.verifyBtn.hidden = NO;
        _loginView.verifyCDLb.hidden = YES;
        
        [self timerStop];
        return;
    }
    
    _loginView.verifyCDLb.text = [NSString stringWithFormat:@"%@s后重新发送",@(self.cdTime).stringValue];
}

#pragma mark - bottomTipView

- (UIView *)bottomTipView{
    if (_bottomTipView == nil) {
        
        _bottomTipView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height + 10, self.view.frame.size.width, 50)];
        _bottomTipView.backgroundColor = kRGB(255, 196, 98);
        
        UILabel *tipLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, self.view.frame.size.width - 65, 36)];
        tipLb.text = @"为保证社区的秩序，与子暂未开放注册。请通过老用户的邀请加入，或者向官方申请邀请码。";
        tipLb.font = [UIFont systemFontOfSize:12];
        tipLb.textColor = kRGB(51, 51, 51);
        tipLb.numberOfLines = 0;
        [_bottomTipView addSubview:tipLb];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(_bottomTipView.frame.size.width - 50, 0, 50, _bottomTipView.frame.size.height);
        [closeBtn addTarget:self action:@selector(bottomTipViewHide) forControlEvents:UIControlEventTouchUpInside];
        [_bottomTipView addSubview:closeBtn];
        
        UIImageView *closeIV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 20, 20)];
        closeIV.image = [UIImage imageNamed:@"invalidClose"];
        [closeBtn addSubview:closeIV];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleApply)];
        [_bottomTipView addGestureRecognizer:tap];
        
    }
    return _bottomTipView;
}

- (void)bottomTipViewShow{

    [_loginView.IDTextFiled resignFirstResponder];
    [_loginView.passWordTextFiled resignFirstResponder];
    
    [self.view addSubview:self.bottomTipView];
    
    self.bottomTipView.frame = CGRectMake(0, self.view.frame.size.height + 10, self.view.frame.size.width, 50);
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = self.bottomTipView.frame;
        rect.origin.y = self.view.frame.size.height - rect.size.height;
        self.bottomTipView.frame = rect;
    }];
}

- (void)bottomTipViewHide{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = self.bottomTipView.frame;
        rect.origin.y = self.view.frame.size.height + 10;
        self.bottomTipView.frame = rect;
    } completion:^(BOOL finished) {
        [self.bottomTipView removeFromSuperview];
    }];
}

@end
