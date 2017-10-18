//
//  WYSelfDetailEditing.m
//  Withyou
//
//  Created by Handyzzz on 2017/5/28.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYSelfDetailEditing.h"
#import "WYUserEditEducationVC.h"
#import "WYUserEditWorkVC.h"
#import "WYUserEditVC.h"
#import "CityViewController.h"
#import "WYUserAffectiveState.h"
#import "WYUserNickNameVC.h"
#import "WYUserDetailApi.h"
#import "WYProfileApi.h"
#import "WYStudyApi.h"
#import "WYJobApi.h"
#import "WYAddUserIntroductionVC.h"

@interface WYSelfDetailEditing ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *titleArr;
@property (nonatomic, strong)NSMutableArray *publicData;

@property (nonatomic, strong)NSMutableArray *normalArr;
@property (nonatomic, strong)NSMutableArray *educationArr;
@property (nonatomic, strong)NSMutableArray *workArr;

@end

@implementation WYSelfDetailEditing
/*
 这个页面还有一个入口 就是添加关注未成功的时候 跳转到此页面来 完善个人信息 这个时候是不带数据进来的
 */
-(void)loadData{
    __weak WYSelfDetailEditing *weakSelf = self;
    [WYUserDetailApi retrieveUserInfo:kuserUUID Block:^(WYUserDetail *userInfo) {
        if (userInfo) {
            weakSelf.userInfo = userInfo;
            [weakSelf initData];
            [weakSelf.tableView reloadData];
        }
    }];
}


-(NSMutableArray *)normalArr{
    if (_normalArr == nil) {
        _normalArr = [NSMutableArray array];
    }
    return _normalArr;
}


-(NSMutableArray *)workArr{
    if (_workArr == nil) {
        _workArr = [NSMutableArray array];
    }
    return _workArr;
}

-(NSMutableArray *)educationArr{
    if (_educationArr == nil) {
        _educationArr = [NSMutableArray array];
    }
    return _educationArr;
}

-(void)initData{
    _titleArr = [@[
                  @"公开资料",
                  @"详细资料",
                  @"添加教育信息",
                  @"添加工作经历",
                  ]mutableCopy];
    _publicData = [@[
                     @[@"姓",
                       @"名",
                       @"与子ID",
                       @"性别",
                       @"常住地"],
                     @[@"昵称",
                       @"个人简介",
                       @"情感状态",
                       @"注册手机"]
                     ]mutableCopy];

    self.normalArr = [@[
                        [@[self.userInfo.last_name ? self.userInfo.last_name :@"",
                           self.userInfo.first_name ? self.userInfo.first_name :@"",
                           self.userInfo.account_name ? self.userInfo.account_name :@"",
                           self.userInfo.sexStr ? self.userInfo.sexStr : @"",
                           self.userInfo.profile.city ? self.userInfo.profile.city : @""
                           ] mutableCopy],
                        [@[[self.userInfo.profile.nick_names mutableCopy],
                           self.userInfo.profile.intro ? self.userInfo.profile.intro : @"",
                           self.userInfo.profile.relationshipStr ? self.userInfo.profile.relationshipStr : @"",
                           self.userInfo.profile.phone ? self.userInfo.profile.phone : @"",
                           ] mutableCopy],
                       ]mutableCopy];
    
    self.workArr = [self.userInfo.profile.work_experience mutableCopy];
    self.educationArr = [self.userInfo.profile.study_experience mutableCopy];
    
    [self.tableView reloadData];
}


-(void)setUpUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth,kAppScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    
    [self setUpUI];
    if (self.userInfo) {
        [self initData];
    }else{
        [self loadData];
    }
}

-(void)setNavigationBar{
    
    self.title = @"编辑资料";
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArr.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }else if (section == 1){
        return 3;
    }else if (section == 2){
        return self.educationArr.count;
    }
    
    return self.workArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52.f;
}

//分区头

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section > 1) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 30)];
    view.backgroundColor = UIColorFromHex(0xf5f5f5);
    
    //添加titleLb
    UILabel *titleLb = [UILabel new];
    [view addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.centerY.equalTo(0);
    }];
    titleLb.text = self.titleArr[section];
    titleLb.textColor = kRGB(197, 197, 197);
    titleLb.font = [UIFont systemFontOfSize:12];
    return view;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 30;
    }else{
        return 0.01f;
    }
}
//分区尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        return nil;
    }else if(section == 1){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 8)];
        view.backgroundColor = UIColorFromHex(0xf5f5f5);
        return view;
    }
    UIView  *view = [[UIView alloc]initWithFrame:CGRectMake(-1, 0, kAppScreenWidth + 2, 58)];
    view.layer.borderColor = UIColorFromHex(0xf5f5f5).CGColor;
    view.layer.borderWidth = 1;
    view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:button];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:_titleArr[section] forState:UIControlStateNormal];
    [button setTitleColor:kRGB(51, 51, 51) forState:UIControlStateNormal];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(50);
    }];
    [button addTarget:self action:@selector(buttonActionClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = section;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kAppScreenWidth, 8)];
    lineView.backgroundColor = UIColorFromHex(0xf5f5f5);
    [view addSubview:lineView];
    return view;
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01f;
    }if (section == 1){
        return 8;
    }else{
        return 58;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *publicCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!publicCell) publicCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"publicCell"];
    
    publicCell.textLabel.font = [UIFont systemFontOfSize:14];
    publicCell.textLabel.textColor = UIColorFromHex(0x999999);
    publicCell.textLabel.textAlignment = NSTextAlignmentLeft;

    publicCell.detailTextLabel.textColor = UIColorFromHex(0x333333);
    publicCell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    publicCell.detailTextLabel.textAlignment = NSTextAlignmentLeft;

    publicCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    //设置分割线
    UIView *line = [publicCell.contentView viewWithTag:999];
    if (indexPath.row == 0) {
        if (line) {
            [line removeFromSuperview];
        }
    }else{
        if (line == nil) {
            line = [[UIView alloc]initWithFrame:CGRectMake(15, 0, kAppScreenWidth - 15, 1)];
            line.tag = 999;
            line.backgroundColor = UIColorFromHex(0xf5f5f5);
            [publicCell.contentView addSubview:line];
        }
    }
    
    if (indexPath.section == 0 || indexPath.section == 1) {
        publicCell.textLabel.text = _publicData[indexPath.section][indexPath.row];
        publicCell.textLabel.font = [UIFont systemFontOfSize:14 weight:0.4];
        if (indexPath.section == 1 && indexPath.row == 0) {
            
            NSArray *arr = _normalArr[indexPath.section][indexPath.row];
            NSMutableString *mutableStr = [NSMutableString string];
            for (int i = 0; i < arr.count; i ++) {
                WYNickName *nickName = arr[i];
                if (i <= arr.count -2) {
                    if ([nickName.name length] > 0) {
                        [mutableStr appendString:[NSString stringWithFormat:@"%@  ",nickName.name]];
                    }
                }else{
                    if ([nickName.name length] > 0) {
                        [mutableStr appendString:nickName.name];
                    }
                }
            }
            publicCell.detailTextLabel.text = mutableStr;
            
        }else{
            publicCell.detailTextLabel.text = _normalArr[indexPath.section][indexPath.row];
        }
        return publicCell;
        
    }else if (indexPath.section == 2){
        WYStudy *study = self.educationArr[indexPath.row];
        publicCell.textLabel.text = study.school;
        publicCell.textLabel.font = [UIFont systemFontOfSize:14 weight:0.4];
        publicCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ —— %@",study.start_year_month
                                           ,study.finish_year_month];
        
    }else{
        WYJob *job = self.workArr[indexPath.row];
        publicCell.textLabel.text = job.org;
        publicCell.textLabel.font = [UIFont systemFontOfSize:14 weight:0.4];
        publicCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ —— %@",job.start_year_month
                                           ,job.finish_year_month];
    }
    
    return publicCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    __weak WYSelfDetailEditing *weakSelf = self;
    
    if (indexPath.section == 0) {
        if (indexPath.row <= 2) {
            WYUserEditVC *vc = [WYUserEditVC new];
            if (indexPath.row == 0) vc.key = @"last_name";
            if (indexPath.row == 1) vc.key = @"first_name";
            if (indexPath.row == 2) vc.key = @"account_name";

            vc.labelString = _publicData[indexPath.section][indexPath.row];
            vc.textFieldString = _normalArr[indexPath.section][indexPath.row];
            vc.doneClick = ^(NSString *str) {
                [weakSelf.normalArr[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:str];
                [weakSelf.tableView reloadData];
                
                //发通知个其他页面 userVC userDetailVC descoverVC 这三个页面
                [self postUserInfoNotification];
            };
            
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 3){
            UIAlertController *alert = [[UIAlertController alloc]init];
            UIAlertAction *actionMan = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf PatchUserDetailDic:@{@"sex":@(1)} indexPath:indexPath str:@"男"];
            }];
            UIAlertAction *actionWoman = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf PatchUserDetailDic:@{@"sex":@(2)} indexPath:indexPath str:@"女"];
            }];
            UIAlertAction *blank = [UIAlertAction actionWithTitle:@"暂不设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf PatchUserDetailDic:@{@"sex":@(3)} indexPath:indexPath str:@""];
            }];
            [alert addAction:actionMan];
            [alert addAction:actionWoman];
            [alert addAction:blank];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }else if (indexPath.row == 4){
            CityViewController *controller = [[CityViewController alloc] init];
            controller.selectString = ^(NSString *string){
                [weakSelf PatchProfireDic:@{@"city":string} indexPath:indexPath str:string];
            };
            [self presentViewController:controller animated:YES completion:nil];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            WYUserNickNameVC *vc = [WYUserNickNameVC new];
            vc.keyWords = @"昵称";
            [vc.detailArr addObjectsFromArray:self.normalArr[indexPath.section][indexPath.row]];
            vc.doneClick = ^(NSMutableArray *detailArr) {
                [weakSelf.normalArr[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:detailArr];
                [weakSelf.tableView reloadData];
                //发通知个其他页面 userVC userDetailVC descoverVC 这三个页面
                [self postUserInfoNotification];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1){
            WYAddUserIntroductionVC *vc = [WYAddUserIntroductionVC new];
            vc.defaultText = _normalArr[indexPath.section][indexPath.row];
            vc.myBlock = ^(NSString *text) {
                [weakSelf.normalArr[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:text];
                [weakSelf.tableView reloadData];
                weakSelf.userInfo.profile.intro = text;
                [self postUserInfoNotification];
            };
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (indexPath.row == 2){
            WYUserAffectiveState *vc = [WYUserAffectiveState new];
            vc.str = _normalArr[indexPath.section][indexPath.row];
            vc.doneClick = ^(NSString *str, NSInteger status) {
                [weakSelf.normalArr[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:str];
                [weakSelf.tableView reloadData];
                
                weakSelf.userInfo.profile.relationship_status = (int)status;
                //发通知个其他页面 userVC userDetailVC descoverVC 这三个页面
                [self postUserInfoNotification];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (indexPath.section == 2){
        WYUserEditEducationVC *vc = [WYUserEditEducationVC new];
        vc.isAdd = NO;
        vc.study = self.educationArr[indexPath.row];
        vc.doneClick = ^(WYStudy *study) {
            [weakSelf.educationArr replaceObjectAtIndex:indexPath.row withObject:study];
            [weakSelf.tableView reloadData];
            //发通知个其他页面 userVC userDetailVC descoverVC 这三个页面
            [self postUserInfoNotification];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 3){
        WYUserEditWorkVC *vc = [WYUserEditWorkVC new];
        vc.isAdd = NO;
        vc.job = self.workArr[indexPath.row];
        vc.doneClick = ^(WYJob *job) {
            //如果这份工作是当前工作 将之前的所有的工作 都不是当前工作
            if (job.current_work == YES) {
                weakSelf.userInfo.profile.current_work = job;
                for (int i = 0; i < weakSelf.workArr.count; i ++) {
                    WYJob *job = weakSelf.workArr[i];
                    job.current_work = NO;
                    [weakSelf.workArr replaceObjectAtIndex:i withObject:job];
                }
            }

            [weakSelf.workArr replaceObjectAtIndex:indexPath.row withObject:job];
            [weakSelf.tableView reloadData];
            //发通知个其他页面 userVC userDetailVC descoverVC 这三个页面
            [self postUserInfoNotification];
        };
       
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)PatchUserDetailDic:(NSDictionary *)dic indexPath:(NSIndexPath*)indexPath str:(NSString*)str{
    
    __weak WYSelfDetailEditing *weakSelf = self;
    
    [WYUserDetailApi patchUserDetailDic:dic Block:^(WYUser *user, NSInteger status) {
        if (user) {
            [weakSelf.normalArr[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:str];
            [weakSelf.tableView reloadData];
            
            //发通知个其他页面 userVC userDetailVC descoverVC 这三个页面
            [self postUserInfoNotification];
        }else{
            [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
        }

    }];
}
-(void)PatchProfireDic:(NSDictionary *)dic indexPath:(NSIndexPath*)indexPath str:(NSString*)str{
    
    __weak WYSelfDetailEditing *weakSelf = self;
    
    [WYProfileApi patchProfireDic:dic Block:^(WYProfile *profile) {
        if (profile) {
            [weakSelf.normalArr[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:str];
            [weakSelf.tableView reloadData];
            
            
            //发通知个其他页面 userVC userDetailVC descoverVC 这三个页面
            [self postUserInfoNotification];
        }else{
            [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
        }
    }];
}

-(void)buttonActionClick:(UIButton *)button{
    
    __weak WYSelfDetailEditing *weakSelf = self;

    if (button.tag == 2) {
        //添加教育信息
        WYUserEditEducationVC *vc = [WYUserEditEducationVC new];
        vc.isAdd = YES;
        vc.doneClick = ^(WYStudy *study) {
            
            [weakSelf.educationArr addObject:study];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.educationArr.count - 1 inSection:2];
            [_tableView beginUpdates];
            [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            [_tableView endUpdates];
            
            //发通知个其他页面 userVC userDetailVC descoverVC 这三个页面
            [self postUserInfoNotification];
        };
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if (button.tag == 3){
        //添加工作经历
        WYUserEditWorkVC *vc = [WYUserEditWorkVC new];
        vc.isAdd = YES;
        vc.doneClick = ^(WYJob *job) {
            
            //如果这份工作是当前工作 将之前的所有的工作 都不是当前工作
            if (job.current_work == YES) {
                weakSelf.userInfo.profile.current_work = job;
                for (int i = 0; i < weakSelf.workArr.count; i ++) {
                    WYJob *job = weakSelf.workArr[i];
                    job.current_work = NO;
                    [weakSelf.workArr replaceObjectAtIndex:i withObject:job];
                }
            }
            [weakSelf.workArr addObject:job];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.workArr.count - 1 inSection:3];
            [_tableView beginUpdates];
            [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            [_tableView endUpdates];
            
            //发通知个其他页面 userVC userDetailVC descoverVC 这三个页面
            [self postUserInfoNotification];
        };
       
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma delegate

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 || indexPath.section == 3) {
        return YES;
    }
    
    return NO;
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __weak WYSelfDetailEditing *weakSelf = self;
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            //如果是教育或者工作经历
            if (indexPath.section == 2) {
                WYStudy *study = self.educationArr[indexPath.row];
                [WYStudyApi deleteStudyDetail:study.uuid Block:^(BOOL haveDelete) {
                    if (haveDelete) {
                        [weakSelf.educationArr removeObjectAtIndex:indexPath.row];
                        [weakSelf.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        //发通知个其他页面 userVC userDetailVC descoverVC 这三个页面
                        [self postUserInfoNotification];
                    }
                }];
            }else if (indexPath.section == 3){
                WYJob *job = self.workArr[indexPath.row];
                if (job.current_work == YES) {
                    self.userInfo.profile.current_work = nil;
                }
                [WYJobApi deleteJobDetail:job.uuid Block:^(BOOL haveDelete) {
                    if (haveDelete) {
                        [weakSelf.workArr removeObjectAtIndex:indexPath.row];
                        [weakSelf.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        //发通知个其他页面 userVC userDetailVC descoverVC 这三个页面
                        [self postUserInfoNotification];
                    }
                }];
            }
        }
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(int)calculateSexNum:(NSString *)s{
    int sex;
    if ([s isEqualToString:@"男"]) {
        sex = 1;
    }else if([s isEqualToString:@"女"]){
        sex = 2;
    }else{
        sex = 3;
    }
    return sex;
}

//每次编辑详情页的修改只要成功都会立即回调到这个页面 然后发送用户信息改变的通知
-(void)postUserInfoNotification{
    
    //数组中的数据是新的 根据数组中的元素 构建一个更新过的userInfo
    self.userInfo.last_name = self.normalArr[0][0];
    self.userInfo.first_name = self.normalArr[0][1];
    self.userInfo.account_name = self.normalArr[0][2];
    NSString *s = self.normalArr[0][3];
    self.userInfo.sex = [self calculateSexNum:s];
    self.userInfo.profile.city = self.normalArr[0][4];
    
    self.userInfo.profile.nick_names = [self.normalArr[1][0] copy];
    //_status 写在点击的回调里了
    self.userInfo.profile.phone = self.normalArr[1][2];
    self.userInfo.profile.work_experience = [self.workArr copy];
    self.userInfo.profile.study_experience = [self.educationArr copy];
    
    [WYUser saveUserToDB:self.userInfo.user];
    [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateUserInfoDataSource object:nil userInfo:@{@"userInfo":self.userInfo}];
}

@end
