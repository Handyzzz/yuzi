//
//  WYLocalPhoneContactsVCTableViewController.m
//  Withyou
//
//  Created by Tong Lu on 16/8/23.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import "WYLocalPhoneContactsVCTableViewController.h"
#import "APAddressBook.h"
#import "APContact.h"
#import "LocalContactCell.h"
#import "BMChineseSort.h"
#import "WYFollow.h"
#import "YZNetBadView.h"
#import "YZSuccessView.h"
#import "WYSelfDetailEditing.h"

@interface WYLocalPhoneContactsVCTableViewController () <UIAlertViewDelegate>
{
    NSMutableArray *_contacts;
    
}

@property (nonatomic, strong) NSMutableArray *indexArr;
@property (nonatomic, strong) NSMutableArray *resultArr;

@property (nonatomic, copy) NSDictionary *contactPeopleDict;
@property (nonatomic, copy) NSArray *keys;
@property (nonatomic, assign) BOOL useFast;

@property (nonatomic, copy) NSDictionary *infoDictionary;

@property (nonatomic, strong) UIWindow *keyWindow;

@property (nonatomic, assign) NSInteger addIndex;

@property (nonatomic, strong) UIView *inivteView;

@property (nonatomic, strong) WYUser *user;

@end

@implementation WYLocalPhoneContactsVCTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviItem];
    self.title = @"通讯录";
    self.addIndex = 0;
    
    self.tableView.sectionIndexColor = kRGB(51, 51, 51);
    self.tableView.tableFooterView = [UIView new];
    _contacts = [NSMutableArray array];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexTrackingBackgroundColor = UIColorFromHex(0xf5f5f5);
    
    //添加联系人
//    [self creatNewRecord];
    
    switch([APAddressBook access])
    {
        case APAddressBookAccessUnknown:
        case APAddressBookAccessGranted:
        {
            // Access granted
            [self showAlertBeforeReadingContacts];
            break;
        }
        case APAddressBookAccessDenied:
            // Access denied or restricted by privacy settings
            
            [[[UIAlertView alloc] initWithTitle:@"您之前曾关闭了此功能"
                                        message:@"若希望再次开启本地联系人识别，请点击确定，在手机的系统设置中开启联系人权限"
                               cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
                return;
            }]
                               otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^{
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                
            }], nil] show];
            
            break;
    }
    
    
}
-(void)setNaviItem{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestFriend:(NSString *)friendStr{
    [[WYHttpClient sharedClient] POST:@"api/v1/update_local_contacts/" parameters:@{@"phones": friendStr} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        debugLog(@"update local ok");
        NSMutableArray *arrM = [NSMutableArray array];
        
        NSArray *arr = [responseObject objectForKey:@"registered"];
        for (NSDictionary *dict in arr) {
            NSString *phone = [dict objectForKey:@"phone"];
            if (![self checkMyPhone:phone]) {
                WYUser *user = [WYUser yy_modelWithJSON:[dict valueForKey:@"user"]];
                user.phone = phone;
                user.rel_to_me = [dict objectForKey:@"rel_to_me"];
                [arrM addObject:user];
            }
        }
        
        if (arrM.count > 0) {
            self.addIndex += 1;
            [self.indexArr insertObject:@"#" atIndex:0];
            [arrM insertObject:@"已加入的与子联系人" atIndex:0];
        }
        
        _contacts = arrM;
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        debugLog(@"update local failed");
    }];
}

- (void)showAlertBeforeReadingContacts
{
    APAddressBook *addressBook = [[APAddressBook alloc] init];
    [addressBook requestAccess:^(BOOL granted, NSError *error)
     {
         if(granted){
             
             [self readLocalContactList:addressBook];
         }
         else
         {
             
         }
     }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == alertView.cancelButtonIndex)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        APAddressBook *addressBook = [[APAddressBook alloc] init];
        [addressBook requestAccess:^(BOOL granted, NSError *error)
        {
            if(granted){
                
                [self readLocalContactList:addressBook];
            }
            else
            {
                
            }
        }];
    }
}
- (void)readLocalContactList:(APAddressBook *)addressBook
{
//    APAddressBook *addressBook = [[APAddressBook alloc] init];
    addressBook.fieldsMask = APContactFieldName | APContactFieldPhonesWithLabels | APContactFieldRecordDate;
    addressBook.filterBlock = ^BOOL(APContact *contact)
    {
        return contact.phones.count > 0 && contact.name.compositeName.length > 0 ;
    };
    addressBook.sortDescriptors = @[
                                    [NSSortDescriptor sortDescriptorWithKey:@"name.lastName" ascending:YES],
//                                    [NSSortDescriptor sortDescriptorWithKey:@"name.firstName" ascending:YES]
                                    ];
    
//    NSDate *methodStart = [NSDate date];
    
    // don't forget to show some activity
    [addressBook loadContacts:^(NSArray <APContact *> *contacts, NSError *error)
    {
        // hide activity
        if (!error)
        {
            NSMutableArray *tempArray = [NSMutableArray array];
            NSMutableArray *requestArr = [NSMutableArray array];
            
            NSError *error;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^((0086)|(\\+86)|(86)|)[-\\s]?1[358](\\d-?){9,11}" options:NSRegularExpressionCaseInsensitive error:&error];
            
            NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
            NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
            
            NSTextCheckingResult *match;
            NSCharacterSet *notAllowedChars = [NSCharacterSet characterSetWithCharactersInString:@"+- "];
            NSCharacterSet *notAllowedCharsInName = [NSCharacterSet characterSetWithCharactersInString:@":;+- "];
            
            for(APContact *ap in contacts)
            {
                NSString *firstName = [[ap.name.firstName.length ? ap.name.firstName : @"" componentsSeparatedByCharactersInSet:notAllowedCharsInName] componentsJoinedByString:@""];
                NSString *lastName = [[ap.name.lastName.length? ap.name.lastName : @"" componentsSeparatedByCharactersInSet:notAllowedCharsInName] componentsJoinedByString:@""];
                NSString *name = [NSString stringWithFormat:@"%@%@",firstName,lastName];
                
                for(APPhone *ph in ap.phones)
                {
                    NSString *addressBook = @"";
                    NSString *tel = ph.number;
                    if (tel.length) {
                        
                        tel = [tel stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"+"]];
                        tel = [tel stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        tel = [[tel componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
                        if(tel.length > 11)
                        {
                            match = [regex firstMatchInString:tel options:0 range:NSMakeRange(0, [tel length])];
                            if(match != nil){
                                tel = [tel substringWithRange:NSMakeRange(tel.length - 11, 11)];
                            }else{
                                break;
                            }
                        }
                        
                        WYUser *user = [[WYUser alloc] init];
                        user.first_name = lastName;
                        user.last_name = firstName;
                        user.phone = tel;
                        user.rel_to_me = @(0);
                        
                        if([regextestmobile evaluateWithObject:tel] && ![self checkMyPhone:tel]){
                            addressBook = [NSString stringWithFormat:@"%@:%@",name,tel];
                            [requestArr addObject:addressBook];
                            [tempArray addObject:user];
                        }
                        
                    }
                    break;
                }
            }
            
//            _contacts = [BMChineseSort sortObjectArray:tempArray Key:@"first_name"];
            
            self.indexArr = [[NSMutableArray alloc] initWithArray:[BMChineseSort IndexWithArray:tempArray Key:@"fullName"]];
            self.resultArr = [[NSMutableArray alloc] initWithArray:[BMChineseSort sortObjectArray:tempArray Key:@"fullName"]];
            
            if (self.indexArr.count > 1 && [[self.indexArr firstObject] isEqualToString:[BMChineseSort AbnormalLetterString]]) {
                [self.indexArr exchangeObjectAtIndex:0 withObjectAtIndex:self.indexArr.count - 1];
                [self.resultArr exchangeObjectAtIndex:0 withObjectAtIndex:self.resultArr.count - 1];
            }
            
            if (self.resultArr.count > 0) {
                self.addIndex += 1;
                [self.indexArr insertObject:@"" atIndex:0];
                [self.resultArr insertObject:@[@"未加入与子的联系人"] atIndex:0];
            }
            
            NSString *requestStr = [requestArr componentsJoinedByString:@";"];
            
//            [self.tableView reloadData];
            
            if (requestStr.length) {
                [self requestFriend:requestStr];
            }
            
        }
        else
        {
            NSLog(@"error is %@", error);

        }
    }];

//    NSDate *methodFinish = [NSDate date];
//    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
//    NSLog(@"executionTime = %f", executionTime);
    
}

- (void)updateLocalContacts:(NSArray <APContact *> *)contacts
{
    NSNumber *t = [[NSUserDefaults standardUserDefaults] objectForKey:kLocalContactsUpdatedTime];
    if(!t)
    {
        t = @0;
    }
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    
    //3 weeks
    if(timeStamp - [t floatValue] > 60*60*24*21 )
    {

        NSString *res = @"";
        NSError *error;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^((0086)|(\\+86)|(86)|)[-\\s]?1[358](\\d-?){9,11}" options:NSRegularExpressionCaseInsensitive error:&error];
        NSTextCheckingResult *match;
        NSString *numStr;
        NSString *nameStr;
        NSCharacterSet *notAllowedChars = [NSCharacterSet characterSetWithCharactersInString:@"+- "];
        NSCharacterSet *notAllowedCharsInName = [NSCharacterSet characterSetWithCharactersInString:@":;+- "];

        for(APContact *ap in contacts)
        {
            for(APPhone *ph in ap.phones)
            {
                if(ph.number.length > 11){
                    //^((0086)|(\+86)|(86)|)[-\s]?1[358](\d-?){9,11}  maybe correct
                    
                    match = [regex firstMatchInString:ph.number options:0 range:NSMakeRange(0, [ph.number length])];
                    
                    if(match != nil){
                        numStr = [ph.number stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"+"]];
                        numStr = [numStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        numStr = [[ph.number componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
                        if(numStr.length >= 11)
                        {
                            numStr = [numStr substringWithRange:NSMakeRange(numStr.length - 11, 11)];
                        }
                        
                        nameStr = [[ap.name.compositeName componentsSeparatedByCharactersInSet:notAllowedCharsInName] componentsJoinedByString:@""];
                        
                        res = [res stringByAppendingString:nameStr];
                        res = [res stringByAppendingString:@":"];
                        res = [res stringByAppendingString:numStr];
                        res = [res stringByAppendingString:@";"];
                        
                    }
                    else{
//                        NSLog(@"ph.number is %@", ph.number);
                    }
                }
            }
        }

        //        [WYUtility printInfo:res];
//        return;
        
        [[WYHttpClient sharedClient] POST:@"api/v1/update_local_contacts/" parameters:@{@"phones": res} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            debugLog(@"update local ok");
            //一个月更新一次本地联系人
            [[NSUserDefaults standardUserDefaults] setObject:@(timeStamp) forKey:kLocalContactsUpdatedTime];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            debugLog(@"update local failed");
        }];
    }
}

- (void)inviteUser:(WYUser *)user{
    [[WYHttpClient sharedClient] POST:@"api/v1/invite_to_join/" parameters:@{@"name":user.fullName,@"phone":user.phone} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        user.rel_to_me = @(-1);
        [self.tableView reloadData];
        
        YZSuccessView *v = [[YZSuccessView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
        [self.keyWindow addSubview:v];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败
        YZNetBadView *b = [[YZNetBadView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
        [self.keyWindow addSubview:b];
    }];
}

- (void)showInviteView{
    [self.keyWindow addSubview:self.inivteView];
}

- (void)followUser:(WYUser *)user{
    NSInteger rel = user.rel_to_me.integerValue;
    
    __weak WYLocalPhoneContactsVCTableViewController *weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [WYUtility requireSetAccountNameOrAlreadyHasName:^{
        [WYFollow addFollowToUuid:user.uuid Block:^(WYFollow *follow, NSInteger status) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(follow){
                [OMGToast showWithText:@"关注成功"];
                switch (rel) {
                    case 3:
                    {
                        user.rel_to_me = @(1);
                    }
                        break;
                    case 100:
                    {
                        user.rel_to_me = @(2);
                    }
                        break;
                        
                    default:
                        break;
                        
                }
                
            }else{
                    [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
            }
            [weakSelf.tableView reloadData];
            
        }];
    } navigationController:self.navigationController];
}
-(void)goToSelfEditing{
    WYSelfDetailEditing *vc = [WYSelfDetailEditing new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleCancel{
    [self.inivteView removeFromSuperview];
}

- (void)handleOK{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstInvite"];
    [self inviteUser:self.user];
    [self.inivteView removeFromSuperview];
}

- (BOOL)checkMyPhone:(NSString *)phone{
    
    WYUser *user = kLocalSelf;
    NSString *myPhone = user.phone;
    NSArray *arr = [myPhone componentsSeparatedByString:@"."];
    NSString *phoneStr = [arr lastObject];
    if ([phone isEqualToString:phoneStr]) {
        return YES;
    }
    return NO;
}

#pragma mark - Table view data source


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.indexArr objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSString *title = [self tableView:tableView titleForHeaderInSection:section];
    if (title.length > 0) {
        return 30;
    }else{
        return 0.1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *title = [self tableView:tableView titleForHeaderInSection:section];
    if (title.length > 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIView *blockView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 4, 16)];
        blockView.backgroundColor = UIColorFromHex(0x2BA1D4);
        [view addSubview:blockView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 20)];
        label.text = title;
        label.textColor = kRGB(153, 153, 153);
        label.font = [UIFont systemFontOfSize:14];
        [view addSubview:label];
        
        return view;
    }else{
        return nil;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.indexArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 0;
    if (self.addIndex == 2 && section == 0) {
        count = _contacts.count;
    }else{
        NSArray *arr = [self.resultArr objectAtIndex:_contacts.count ? section - 1 : section];
        count = arr.count;
    }
    return count;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexArr;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id modle = nil;
    
    if (self.addIndex == 2 && indexPath.section == 0) {
        modle = [_contacts objectAtIndex:indexPath.row];
    }else{
        modle = [[self.resultArr objectAtIndex:_contacts.count ? indexPath.section - 1 : indexPath.section] objectAtIndex:indexPath.row];
    }
    
    if ([modle isKindOfClass:[WYUser class]]) {
        return 62;
    }else{
        return 30;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"localContactCell";
    LocalContactCell *cell = (LocalContactCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[LocalContactCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    id modle = nil;
    
    if (self.addIndex == 2 && indexPath.section == 0) {
        modle = [_contacts objectAtIndex:indexPath.row];
    }else{
        modle = [[self.resultArr objectAtIndex:_contacts.count ? indexPath.section - 1 : indexPath.section] objectAtIndex:indexPath.row];
    }
    
    cell.controlBlcok = nil;
    
    if ([modle isKindOfClass:[WYUser class]]) {
        WYUser *con = (WYUser *)modle;
        
        cell.user = con;
        
        if(con.fullName){
            cell.nameLb.text = con.fullName;
        }
        [cell.headIV sd_setImageWithURL:[NSURL URLWithString:con.icon_url] placeholderImage:[UIImage imageNamed:@"searchpageAdresslistPersondefault"]];
        
        __weak WYLocalPhoneContactsVCTableViewController *weakself = self;
        
        switch (con.rel_to_me.integerValue) {
            case -1:
            {
                [cell.controlBTN setTitle:@"已邀请" forState:UIControlStateNormal];
                [cell.controlBTN setTitleColor:kRGB(197, 197, 197) forState:UIControlStateNormal];
                cell.controlBTN.layer.borderColor = kRGB(197, 197, 197).CGColor;
                cell.controlBTN.userInteractionEnabled = NO;
            }
                break;
            case 0:
            {
                [cell.controlBTN setTitle:@"邀请" forState:UIControlStateNormal];
                [cell.controlBTN setTitleColor:UIColorFromHex(0x2BA1D4) forState:UIControlStateNormal];
                cell.controlBTN.layer.borderColor = UIColorFromHex(0x2BA1D4).CGColor;
                cell.controlBTN.userInteractionEnabled = YES;
                cell.controlBlcok = ^(WYUser *user){
                    BOOL flag = [[NSUserDefaults standardUserDefaults] boolForKey:@"firstInvite"];
                    if (flag) {
                        [weakself inviteUser:user];
                    }else{
                        weakself.user = user;
                        [weakself showInviteView];
                    }
                };
            }
                break;
            case 1:
            {
                [cell.controlBTN setTitle:@"好友" forState:UIControlStateNormal];
                [cell.controlBTN setTitleColor:kRGB(197, 197, 197) forState:UIControlStateNormal];
                cell.controlBTN.layer.borderColor = kRGB(197, 197, 197).CGColor;
                cell.controlBTN.userInteractionEnabled = NO;
            }
                break;
            case 2:
            {
                [cell.controlBTN setTitle:@"已关注" forState:UIControlStateNormal];
                [cell.controlBTN setTitleColor:kRGB(197, 197, 197) forState:UIControlStateNormal];
                cell.controlBTN.layer.borderColor = kRGB(197, 197, 197).CGColor;
                cell.controlBTN.userInteractionEnabled = NO;
            }
                break;
                
            default:
                [cell.controlBTN setTitle:@"加关注" forState:UIControlStateNormal];
                [cell.controlBTN setTitleColor:UIColorFromHex(0x2BA1D4) forState:UIControlStateNormal];
                cell.controlBTN.layer.borderColor = UIColorFromHex(0x2BA1D4).CGColor;
                cell.controlBTN.userInteractionEnabled = YES;
                cell.controlBlcok = ^(WYUser *user){
                    [weakself followUser:user];
                };
                break;
        }
        
        cell.headView.hidden = YES;
        cell.controlBTN.hidden = NO;
        cell.headIV.hidden = NO;
        cell.nameLb.hidden = NO;
        
        cell.backgroundColor = [UIColor whiteColor];

    }else{
        cell.headView.hidden = NO;
        cell.controlBTN.hidden = YES;
        cell.headIV.hidden = YES;
        cell.nameLb.hidden = YES;
        
        cell.headTitleLb.text = modle;
        cell.backgroundColor = kRGB(245, 245, 245);
        
    }
    
    return cell;
    
}

#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *s = @"nothing";
    SEL selector = NSSelectorFromString(s);
    IMP imp = [self methodForSelector:selector];
    void (*func)(id, SEL) = (void *)imp;
    func(self, selector);
//    if([self respondsToSelector:NSSelectorFromString(s)])
//        [self performSelector:NSSelectorFromString(s)];
}
- (void)nothing
{
    
}


- (UIWindow *)keyWindow
{
    if(_keyWindow == nil)
    {
        _keyWindow = [[UIApplication sharedApplication] keyWindow];
    }
    
    return _keyWindow;
}

- (UIView *)inivteView{
    if(_inivteView == nil)
    {
        _inivteView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
        _inivteView.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.5];
        
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 4;
        [_inivteView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.equalTo(100);
            make.width.equalTo(285);
            make.height.equalTo(370);
        }];
        
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"searchpageAdresslistInvitefriends"];
        [view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.equalTo(0);
            make.width.equalTo(285);
            make.height.equalTo(178);
        }];
        
        UILabel *label = [UILabel new];
        [view addSubview:label];
        label.text = @"我们将短信邀请你的朋友，短信由系统\n发送，不会对你产生任何费用。";
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = kRGB(51, 51, 51);
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.height.equalTo(82);
            make.top.equalTo(imageView.mas_bottom).equalTo(0);;
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        button.layer.cornerRadius = 2;
        button.clipsToBounds = YES;
        [button addTarget:self action:@selector(handleOK) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = UIColorFromHex(0x2BA1D4);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(42);
            make.right.equalTo(-42);
            make.height.equalTo(50);
            make.top.equalTo(label.mas_bottom).equalTo(0);
        }];
        
        UIButton *canclebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [canclebutton setTitle:@"取消" forState:UIControlStateNormal];
        [canclebutton addTarget:self action:@selector(handleCancel) forControlEvents:UIControlEventTouchUpInside];
        [canclebutton setTitleColor:kRGB(197, 197, 197) forState:UIControlStateNormal];
        [view addSubview:canclebutton];
        
        [canclebutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(42);
            make.right.equalTo(-42);
            make.height.equalTo(50);
            make.top.equalTo(button.mas_bottom).equalTo(0);
        }];
        
    }
    
    return _inivteView;
}

@end
