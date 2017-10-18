//
//  WYGroupQRcodeVC.m
//  
//
//  Created by Handyzzz on 2017/7/31.
//
//

#import "WYGroupQRcodeVC.h"
#import "QRCodeGenerator.h"
#import "Masonry.h"

@interface WYGroupQRcodeVC ()
@property(nonatomic,strong)UIImageView*outImageView;
@property (nonatomic, strong) UIScrollView *scrollerView;
@end

@implementation WYGroupQRcodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.navigationTitle;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setUpNaviBar];
    [self setupUI];
    [self createQRCode];
}

-(void)setUpNaviBar{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIImage *rightImage = [[UIImage imageNamed:@"naviRightBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(moreAction)];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

- (void)setupUI{
    
    _scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, kAppScreenHeight)];
    _scrollerView.bounces = YES;
    _scrollerView.scrollEnabled = YES;
    _scrollerView.contentSize = CGSizeMake(kAppScreenWidth,kAppScreenHeight + 1);
    [self.view addSubview:_scrollerView];
    
    
    //自动往下缩 64
    
    //自动布局影响 scrollerView contentSize
    UIView *fillView = [UIView new];
    [self.scrollerView addSubview:fillView];
    [fillView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(64);
        make.width.equalTo(kAppScreenWidth);
        make.height.equalTo(kAppScreenHeight - kStatusAndBarHeight);
        make.right.equalTo(fillView.superview.mas_right).offset(0);
        make.bottom.equalTo(fillView.superview.mas_bottom).offset(-1);
    }];
    
    
    //背景图
    UIImageView *backIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kAppScreenWidth, kAppScreenHeight - kStatusAndBarHeight)];
    backIV.image = [UIImage imageNamed:@"qrcodesBackground"];
    backIV.contentMode = UIViewContentModeScaleToFill;
    [self.scrollerView addSubview:backIV];
    
    
    //标题栏
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    label.text = @"与子群组 连接真实的朋友";
    [backIV addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(34);
    }];
    
    UIView *leftLine = [UIView new];
    leftLine.backgroundColor = kRGB(232, 240, 244);
    [backIV addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(label.mas_left).equalTo(-16);
        make.centerY.equalTo(label);
        make.height.equalTo(2);
        make.width.equalTo(16);
    }];
    
    UIView *rightLine = [UIView new];
    rightLine.backgroundColor = kRGB(232, 240, 244);
    [backIV addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label);
        make.left.equalTo(label.mas_right).equalTo(16);
        make.height.equalTo(2);
        make.width.equalTo(16);
    }];

    
    //二维码栏
    UIImageView *qrbackIV = [UIImageView new];
    qrbackIV.image = [UIImage imageNamed:@"qrcodes_user"];
    [backIV addSubview:qrbackIV];
    [qrbackIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(80);
        make.width.equalTo(270);
        make.height.equalTo(330);
    }];
    
    //头像
    UIImageView *iconIV = [UIImageView new];
    iconIV.layer.cornerRadius = 25;
    iconIV.clipsToBounds = YES;
    [iconIV sd_setImageWithURL:[NSURL URLWithString:self.group.group_icon]];
    [qrbackIV addSubview:iconIV];
    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.top.equalTo(15);
        make.width.height.equalTo(50);
    }];
    
    //姓名
    UILabel *nameLb = [UILabel new];
    nameLb.font = [UIFont systemFontOfSize:20];
    nameLb.textColor = kRGB(51, 51, 51);
    nameLb.text = self.group.groupName;
    [qrbackIV addSubview:nameLb];
    [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconIV.mas_right).equalTo(8);
        make.top.equalTo(30);
        make.right.equalTo(-50);
    }];
    
    //二维码
    UIImageView *qrIV = [UIImageView new];
    qrIV.image = [self createQRCode];
    [qrbackIV addSubview:qrIV];
    [qrIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(50);
        make.right.equalTo(-50);
        make.top.equalTo(97);
        make.bottom.equalTo(-63);
    }];
    
    
    //邀请人
    UILabel *inviteLb = [UILabel new];
    inviteLb.textAlignment = NSTextAlignmentCenter;
    inviteLb.text = [NSString stringWithFormat:@"邀请人%@",kLocalSelf.fullName];
    inviteLb.numberOfLines = 0;
    inviteLb.textColor = [UIColor whiteColor];
    inviteLb.font = [UIFont systemFontOfSize:14];
    [backIV addSubview:inviteLb];
    [inviteLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qrbackIV.mas_bottom).equalTo(10);
        make.centerX.equalTo(0);
        make.width.equalTo(270);
    }];
    
    //横线
    UIView *midLine = [UIView new];
    midLine.backgroundColor = kRGB(229, 237, 241);
    [backIV addSubview:midLine];
    [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qrbackIV.mas_bottom).equalTo(39);
        make.centerX.equalTo(0);
        make.height.equalTo(2);
        make.width.equalTo(20);
    }];

    
    //群组介绍
    UILabel *desLb = [UILabel new];
    desLb.numberOfLines = 0;
    desLb.textAlignment = NSTextAlignmentCenter;
    desLb.textColor = [UIColor whiteColor];
    desLb.text = self.group.introduction;
    desLb.font = [UIFont systemFontOfSize:14];
    
    [backIV addSubview:desLb];
    [desLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qrbackIV.mas_bottom).equalTo(56);
        make.centerX.equalTo(0);
        make.width.equalTo(270);
        make.bottom.lessThanOrEqualTo(-35);
    }];
}

#pragma mark-> 二维码生成
-(UIImage*)createQRCode{
    
    UIImage*tempImage=[QRCodeGenerator qrImageForString:self.targetUrl imageSize:360 Topimg:nil withColor:nil];
    return  tempImage;
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)moreAction{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"更多" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"分享群组二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //icon
        UIImage *image = [self.view WYImageAtFrame:self.view.bounds];
        //标题
        NSString *text = [NSString stringWithFormat:@"%@的二维码名片",self.group.name];
        NSArray *activityItems = @[text,image];
        
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
        [self presentViewController:activityVC animated:TRUE completion:nil];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:done];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
