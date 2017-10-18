//
//  WYSelfSettingsVC.m
//  Withyou
//
//  Created by Tong Lu on 2016/10/7.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import "WYSelfSettingsVC.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "WYSelfPrivacyVC.h"
#import "WYDraftVC.h"
#import "WYSelfDetailEditing.h"


@interface WYSelfSettingsVC() <UIAlertViewDelegate, MFMailComposeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NSArray *_titleArray;
    NSArray *_imageArray;
    NSArray *_selectorArray;
    UITableView *_tableView;
}

@end

static NSString *cellIdentifierSelfSettings = @"cellIdentifierSelfSettings";


@implementation WYSelfSettingsVC

static NSString * cellIdentifier = @"identifier";


- (void)viewDidLoad{
    self.title = @"设置";
    [self setNavigationBar];
    [self initData];
    [self setUpUI];
}
-(void)setNavigationBar{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;

}
- (void)initData{
    _titleArray = @[
                    @[@"编辑资料",@"草稿箱",@"隐私设置"],
                    @[@"系统权限",@"评测应用",@"联系客服"],
                    @[@"退出当前账号"]
                    ];
    
    _imageArray = @[
                    @[@"selfSettingEditting",@"selfSettingDraft",@"selfSettingPrivacy"],
                    @[@"selfSetting System",@"selfSetting Evaluating",@"selfSetting Service"],
                    @[@""]
                    ];
    
    _selectorArray = @[
                       @[@"selfEditting",@"drafts",@"privacyAction"],
                       @[@"systemSettingsAction",@"rateAppAction",@"mailUsAction"],
                       @[@"logoutAction"]
                       ];
}

-(void)setUpUI{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 12;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 12)];
    view.backgroundColor = UIColorFromHex(0xf5f5f5);
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifierSelfSettings];
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        UILabel *lable = [cell.contentView viewWithTag:1001];
        if (lable == nil) {
            lable = [UILabel new];
            [cell.contentView addSubview:lable];
            lable.tag = 1001;
        }
        lable.text = _titleArray[indexPath.section][indexPath.row];
        lable.textColor = UIColorFromHex(0x333333);
        lable.font = [UIFont systemFontOfSize:15];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(0);
        }];
        cell.accessoryType = UITableViewCellAccessoryNone;

    }else{
        cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.section][indexPath.row]];
        cell.textLabel.text = _titleArray[indexPath.section][indexPath.row];
        cell.textLabel.textColor = UIColorFromHex(0x333333);
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // app版本
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        /*
         app build版本
         NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
         */
        cell.detailTextLabel.text = [NSString stringWithFormat:@"v%@",app_Version];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = kRGB(153, 153, 153);
    }
    
    
    UIView *line = [cell.contentView viewWithTag:999];
    if (indexPath.row == 0) {
        if (line) {
            [line removeFromSuperview];
        }
    }else{
        if (line == nil) {
            line = [[UIView alloc]initWithFrame:CGRectMake(15, 0, kAppScreenWidth - 15, 1)];
            line.tag = 999;
            line.backgroundColor = UIColorFromHex(0xf5f5f5);
            [cell.contentView addSubview:line];
        }
    }
   
    
    return cell;
}


#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *s = _selectorArray[indexPath.section][indexPath.row];
    
    if([self respondsToSelector:NSSelectorFromString(s)])
        [self performSelector:NSSelectorFromString(s)];
}
#pragma mark -

-(void)selfEditting{
    WYSelfDetailEditing *vc = [WYSelfDetailEditing new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)drafts{
    WYDraftVC *vc = [WYDraftVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)privacyAction{
    WYSelfPrivacyVC *vc = [WYSelfPrivacyVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rateAppAction{
    
    /*
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1175153150&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
     
     //IOS8_OR_LATER可以用，但是最近发现不可以了，还是直接跳转到应用详情好了
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=YOUR_APP_ID&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"]];
     */
    
    //跳转到应用的详情页
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1175153150?mt=8"]];
    
}
- (void)systemSettingsAction{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}
- (void)mailUsAction{
    
    if([MFMailComposeViewController canSendMail]){
        
        MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
        vc.mailComposeDelegate = self;
        [vc setSubject:@"与子用户的建议"];
        [vc setToRecipients:[NSArray arrayWithObject:@"linwo@linwo.net"]];
        
        NSString *title = @"与子团队：";
        NSString *content = [NSString stringWithFormat:@"%@\n\n", title];
        [vc setMessageBody:content isHTML:NO];
        [self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        [WYUtility showAlertWithTitle:@"您手机尚未使用邮件功能，请先配置邮箱"];
    }
}

- (void)logoutAction{
    
    [[[UIAlertView alloc] initWithTitle:@"退出登录？"
                                message:@"与子没有密码，只用短信验证码登录"
                       cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
        return;
    }]
                       otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^{
        
        [WYUtility prepareForLogout];;
        
    }], nil] show];
    
}

#pragma mark -
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}


-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
