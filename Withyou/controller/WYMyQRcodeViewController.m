//
//  WYMyQRcodeViewController.m
//  Withyou
//
//  Created by Tong Lu on 2017/1/3.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYMyQRcodeViewController.h"
#import "QRCodeGenerator.h"
#import "Masonry.h"

@interface WYMyQRcodeViewController ()

@property(nonatomic,strong)UIImageView*outImageView;
@property(nonatomic,strong)UIImageView *qrbackIV;

@end

@implementation WYMyQRcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.navigationTitle;
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
   
    //背景图
    UIImageView *backIV = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backIV.image = [UIImage imageNamed:@"qrcodesBackground"];
    [self.view addSubview:backIV];
    
    //二维码栏
    _qrbackIV = [UIImageView new];
    _qrbackIV.image = [UIImage imageNamed:@"qrcodes_user"];
    [backIV addSubview:_qrbackIV];
    [_qrbackIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(88 + kStatusAndBarHeight);
        make.width.equalTo(270);
        make.height.equalTo(330);
    }];
    
    //头像
    UIImageView *iconIV = [UIImageView new];
    iconIV.layer.cornerRadius = 25;
    iconIV.clipsToBounds = YES;
    [iconIV sd_setImageWithURL:[NSURL URLWithString:kLocalSelf.icon_url]];
    [_qrbackIV addSubview:iconIV];
    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.top.equalTo(15);
        make.width.height.equalTo(50);
    }];
   
    //姓名
    UILabel *nameLb = [UILabel new];
    nameLb.font = [UIFont systemFontOfSize:20];
    nameLb.textColor = kRGB(51, 51, 51);
    nameLb.text = kLocalSelf.fullName;
    [_qrbackIV addSubview:nameLb];
    [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconIV.mas_right).equalTo(8);
        make.top.equalTo(30);
        make.right.equalTo(-50);
    }];
    
    //二维码
    UIImageView *qrIV = [UIImageView new];
    qrIV.image = [self createQRCode];
    [_qrbackIV addSubview:qrIV];
    [qrIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(50);
        make.right.equalTo(-50);
        make.top.equalTo(97);
        make.bottom.equalTo(-63);
    }];
    
    //横线
    UIView *midLine = [UIView new];
    midLine.backgroundColor = kRGB(229, 237, 241);
    [_qrbackIV addSubview:midLine];
    [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qrIV.mas_bottom).equalTo(17);
        make.centerX.equalTo(0);
        make.height.equalTo(2);
        make.width.equalTo(10);
    }];

    
    //介绍
    UILabel *desLb = [UILabel new];
    desLb.textColor = kRGB(192, 212, 220);
    desLb.font = [UIFont systemFontOfSize:12];
    desLb.text = @"扫描二维码查看朋友资料";
    [_qrbackIV addSubview:desLb];
    [desLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(qrIV.mas_bottom).equalTo(27);
    }];
    
    //网址
    UILabel *netLb = [UILabel new];
    netLb.font = [UIFont systemFontOfSize:10];
    netLb.textColor = kRGB(192, 212, 220);
    netLb.text = @"yuziapp.com";
    [_qrbackIV addSubview:netLb];
    [netLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(desLb.mas_bottom).equalTo(4);
    }];
    
    //标题栏
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor whiteColor];
    label.text = @"与子 认识真朋友";
    [backIV addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(_qrbackIV.mas_bottom).equalTo(46);
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
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"分享我的二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //icon
        UIImage *image = [self.view WYImageAtFrame:self.view.bounds];
        //标题
        NSString *text = [NSString stringWithFormat:@"%@的二维码名片",kLocalSelf.fullName];
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
