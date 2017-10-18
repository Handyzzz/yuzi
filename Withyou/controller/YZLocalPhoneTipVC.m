//
//  YZLocalPhoneTipVC.m
//  Withyou
//
//  Created by CH on 2017/6/24.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZLocalPhoneTipVC.h"
#import "WYLocalPhoneContactsVCTableViewController.h"

@interface YZLocalPhoneTipVC ()

@end

@implementation YZLocalPhoneTipVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通讯录";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNaviBar];
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"discover_findfriends_importaddresslist"];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(50 + kStatusAndBarHeight);
    }];
    
    
    UILabel *label = [UILabel new];
    [self.view addSubview:label];
    label.text = @"与子通过通讯录匹配老朋友，你可以关注他们的动态，查看共同的朋友，还可以相互介绍新朋友给对方认识";
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = kRGB(51, 51, 51);
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(13);
        make.right.equalTo(-13);
        make.height.equalTo(40);
        make.top.equalTo(imageView.mas_bottom).equalTo(40);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 6;
    button.clipsToBounds = YES;
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleNext) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = kRGB(43, 161, 212);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(58);
        make.right.equalTo(-58);
        make.height.equalTo(50);
        make.top.equalTo(label.mas_bottom).equalTo(35);
    }];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"稍后决定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleBack) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:kRGB(197, 197, 197) forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(58);
        make.right.equalTo(-58);
        make.height.equalTo(50);
        make.top.equalTo(label.mas_bottom).equalTo(85);
    }];
    
}

-(void)setNaviBar{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;

}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleNext{
    WYLocalPhoneContactsVCTableViewController *vc = [WYLocalPhoneContactsVCTableViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
