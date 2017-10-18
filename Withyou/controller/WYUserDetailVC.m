//
//  WYUserDetailVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/5/11.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYUserDetailVC.h"
#import "WYUserDetailBasicCell.h"
#import "WYUserDetaillnterestsCell.h"
#import "WYUserDetailActivityCell.h"
#import "WYUserDetailHeaderView.h"
#import "WYSelfDetailEditing.h"
#import "WYuserPublicGroupsVC.h"
#import "WYUserDetailGroupCell.h"
#import "WYUserAllStudysVC.h"
#import "WYUserAllJobsVC.h"
#import "WYGroupDetailVC.h"

@interface WYUserDetailVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *data;
@end

@implementation WYUserDetailVC

#define Kbasic @"基本信息"
#define Kdetail @"详细信息"
#define Kgroups @"所在群组"
#define Kstudys @"教育经历"
#define Kworks @"工作经历"
#define Kinterests @"TA的兴趣"
#define Kevents @"TA的活动"


static NSString * userBasicCell = @"userBasicCell";
static NSString * userDefaultCell = @"userDefaultCell";
static NSString * userSubtitleCell = @"userSubtitleCell";
static NSString * userInterestCell = @"userInterestCell";
static NSString * userActivityCell = @"userActivityCell";


-(void)initData{
    
    if (!self.userInfo || !self.userExtra) {
        return;
    }
    
    _data = [NSMutableArray array];
    
    NSArray *nickNameArr = self.userInfo.profile.nick_names;
    NSMutableString *s = [NSMutableString string];
    for (int i = 0; i < nickNameArr.count; i ++) {
        WYNickName *nickName = nickNameArr[i];
        if(i == 0){
            [s appendString:nickName.name];
        }else{
            [s appendString:[NSString stringWithFormat:@", %@",nickName.name]];
        }
    }
    NSString *work;
    if (self.userInfo.profile.current_work.org || self.userInfo.profile.current_work.position) {
          work = [NSString stringWithFormat:@"%@ %@",self.userInfo.profile.current_work.org,self.userInfo.profile.current_work.position];
    }else{
          work = @"";
    }
   
    
    NSDictionary *basicDic = @{
                               Kbasic:[@[
                                         @{@"姓名:":(self.userInfo.fullName ? self.userInfo.fullName : @"")},
                                         @{@"与子ID:":(self.userInfo.account_name ? self.userInfo.account_name : @"")},
                                         @{@"性别:":(self.userInfo.sexStr ? self.userInfo.sexStr : @"")},
                                         @{@"常住地:":(self.userInfo.profile.city ? self.userInfo.profile.city : @"")}
                                        ] mutableCopy]
                               };
    
    NSDictionary *detailDic = @{
                                Kdetail:[@[
                                           @{@"昵称:":(s ? s : @"")},
                                           @{@"当前工作:":work},
                                           @{@"个人简介":(self.userInfo.profile.intro ? self.userInfo.profile.intro : @"")},
                                           @{@"情感状态:":(self.userInfo.profile.relationshipStr ? self.userInfo.profile.relationshipStr : @"")},
                                           @{@"手机号:":(self.userInfo.profile.phone ? self.userInfo.profile.phone : @"")}
                                           ]mutableCopy]
                                };
    [_data addObject:basicDic];
    [_data addObject:detailDic];

    //以下这样做的原因是 如果是空数组 就不存在这个分区section
    
    //可以有很多 但最多只显示三个 后端虽然只返回了3个 但是编辑后的通知会增加数组长度
    if (self.userExtra.public_groups.count > 0) {
        NSInteger max = self.userInfo.profile.work_experience.count > 3 ? 3 : self.userExtra.public_groups.count;

        NSArray *smallArray = [self.userExtra.public_groups subarrayWithRange:NSMakeRange(0, max)];

        NSDictionary *groupDic = @{
                                   Kgroups:[smallArray mutableCopy]
                                   };
        [_data addObject:groupDic];
    }
    if (self.userInfo.profile.study_experience.count > 0) {
        NSInteger max = self.userInfo.profile.study_experience.count > 3 ? 3 : self.userInfo.profile.study_experience.count;

        NSArray *smallArray = [self.userInfo.profile.study_experience subarrayWithRange:NSMakeRange(0, max)];

        NSDictionary *studyDic = @{
                                   Kstudys:[smallArray mutableCopy]
                                   };
        [_data addObject:studyDic];
    }
    if (self.userInfo.profile.work_experience.count > 0) {
        NSInteger max = self.userInfo.profile.work_experience.count > 3 ? 3 : self.userInfo.profile.work_experience.count;
        NSArray *smallArray = [self.userInfo.profile.work_experience subarrayWithRange:NSMakeRange(0, max)];

        NSDictionary *workDic = @{
                                  Kworks:[smallArray mutableCopy]
                                  };
        [_data addObject:workDic];
    }
    if (self.userInfo.profile.interests.count > 0) {
        
        NSDictionary *interestsDic = @{
                                     Kinterests:[self.userInfo.profile.interests mutableCopy]
                                      };
        [_data addObject:interestsDic];
    }
    if (self.userInfo.profile.events.count > 0) {
        
        NSDictionary *eventDic = @{
                                   Kevents:[self.userInfo.profile.events mutableCopy]
                                   };
        [_data addObject:eventDic];
    }
    
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self setUpTableView];
    [self setUpTableHeaderVeiw];
    [self initData];
    [self resignNoti];
}


-(void)resignNoti{
    //观察用户资料有没有改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfoDatasource:) name:KUpdateUserInfoDataSource object:nil];
    
    //群组改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGroupDatasource:) name:kUpdateGroupDataSource object:nil];
    //退出群组
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitGroup:) name:kQuitGroup object:nil];
}

-(void)updateUserInfoDatasource:(NSNotification *)noti{
    WYUserDetail *userInfo = [noti.userInfo objectForKey:@"userInfo"];
    self.userInfo = userInfo;
    [self.data removeAllObjects];
    [self initData];
    [self.tableView reloadData];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KUpdateUserInfoDataSource object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpdateGroupDataSource object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kQuitGroup object:nil];
}


-(void)setUpTableView{
    
    CGFloat height = [WYUserDetailHeaderView calculateHeaderHeight:self.userInfo];

    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, kAppScreenHeight) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset = UIEdgeInsetsMake(height + 40,0,0,0);
    self.tableView = tableView;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

-(void)setUpTableHeaderVeiw{
    
    //判断一下如果是自己就设置如果不是自己就不设置
    if (self.userInfo.rel_to_me != 4) return;
       
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 48)];
    view.backgroundColor = [UIColor whiteColor];

    UILabel *label = [UILabel new];
    label.text = @"编辑资料";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = kRGB(43, 161, 212);
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(0);
    }];
    
    UIImageView *leftIV = [UIImageView new];
    [view addSubview:leftIV];
    leftIV.image = [UIImage imageNamed:@"userDetail_editing"];
    [leftIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(label.mas_left).equalTo(-6);
        make.centerY.equalTo(0);
    }];
    
    UIImageView *rightIV = [UIImageView new];
    [view addSubview:rightIV];
    rightIV.image = [UIImage imageNamed:@"userDetail_editing_right"];
    [rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).equalTo(6);
        make.centerY.equalTo(0);
    }];

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editClick)];
    [view addGestureRecognizer:tap];
    self.tableView.tableHeaderView = view;
}

//这个如果是0 后边的就不会执行了 安全
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.data.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString *key = [[self.data[section] allKeys] firstObject];
    
    return [[self.data[section] objectForKey:key] count];
}

//自定义section的头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 30)];
    view.backgroundColor = UIColorFromHex(0xf5f5f5);
    
    //添加titleLb
    UILabel *titleLb = [UILabel new];
    [view addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.centerY.equalTo(0);
    }];
    titleLb.text = [[self.data[section] allKeys] firstObject];
    titleLb.textColor = UIColorFromHex(0xc5c5c5);
    titleLb.font = [UIFont systemFontOfSize:12];
    

    if (section == 0 || section == 1) {
        UIView *extraView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 44)];
        extraView.backgroundColor = [UIColor whiteColor];
        [extraView addSubview:view];
        return extraView;
    }
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    BOOL haveFooter;
    
    haveFooter = ([[[self.data[section] allKeys] firstObject] isEqualToString:Kgroups] && [[[self.data[section] allValues]firstObject] count] >= 3)
        || ([[[self.data[section] allKeys] firstObject] isEqualToString:Kstudys] && [[[self.data[section] allValues]firstObject] count] >= 3)
        || ([[[self.data[section] allKeys] firstObject] isEqualToString:Kworks] &&  [[[self.data[section] allValues]firstObject] count] >= 3);

    
    if (haveFooter == YES) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 44)];
        view.backgroundColor = [UIColor whiteColor];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:@"点击查看更多" forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromHex(0xc5c5c5) forState:UIControlStateNormal];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(0);
        }];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //后边根据这个tag 来判断是添加那个查看更多
        button.tag = section;

        
        return view;
    }
    return nil;
}

-(void)buttonClick:(UIButton *)button{
    
    
    NSInteger section = button.tag;
    NSString *key = [[self.data[section] allKeys] firstObject];

    
    if ([key isEqualToString:Kgroups]) {
        //请求更多公开群组
        WYuserPublicGroupsVC *vc = [WYuserPublicGroupsVC new];
        vc.userUuid = self.userInfo.uuid;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if([[[self.data[section] allKeys] firstObject] isEqualToString:Kstudys]){
        //查看更多教育经历
        WYUserAllStudysVC *vc = [WYUserAllStudysVC new];
        vc.userUuid = self.userInfo.uuid;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //查看更多工作经历
        WYUserAllJobsVC *vc = [WYUserAllJobsVC new];
        vc.userUuid = self.userInfo.uuid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//自定义section头部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 44.0;
    }
    return 30.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    BOOL haveFooter;
    
    haveFooter = ([[[self.data[section] allKeys] firstObject] isEqualToString:Kgroups] && [[[self.data[section] allValues]firstObject] count] >= 3)
    || ([[[self.data[section] allKeys] firstObject] isEqualToString:Kstudys] && [[[self.data[section] allValues]firstObject] count] >= 3)
    || ([[[self.data[section] allKeys] firstObject] isEqualToString:Kworks] &&  [[[self.data[section] allValues]firstObject] count] >= 3);

    
    if (haveFooter)  return 42;

    return 0.001;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    NSString *key = [[self.data[section] allKeys] firstObject];

    if ([key isEqualToString:Kbasic]) {
        return 30;
    }else if ([key isEqualToString:Kdetail]){
        NSDictionary *dic = [self.data[section] objectForKey:key][indexPath.row];
        if ([[dic allKeys][0] isEqualToString:@"个人简介"]) {
            //需要算高
            NSString *intro = [dic objectForKey:[dic allKeys][0]];
            CGFloat heigh = [intro sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(kAppScreenWidth - 80 - 15, MAXFLOAT) minimumLineHeight:7].height;
            return heigh + 16 - 7;
        }
        return 30;
    }else if ([key isEqualToString:Kinterests]){
        return [WYUserDetaillnterestsCell calculateCellHeight];
    }else if ([key isEqualToString:Kevents]){
        return [WYUserDetailActivityCell calculateCellHeight:self.userInfo :indexPath];
    }
    
    return 72;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WYUserDetailBasicCell *basicCell = [tableView cellForRowAtIndexPath:indexPath];
    WYUserDetailGroupCell *defaultCell = [tableView cellForRowAtIndexPath:indexPath];
    UITableViewCell *subtitleCell = [tableView cellForRowAtIndexPath:indexPath];
    WYUserDetaillnterestsCell *interestCell = [tableView cellForRowAtIndexPath:indexPath];
    WYUserDetailActivityCell *activityCell = [tableView cellForRowAtIndexPath:indexPath];

    NSInteger section = indexPath.section;
    NSString *key = [[self.data[section] allKeys] firstObject];

    if ([key isEqualToString:Kbasic]|| [key isEqualToString:Kdetail]) {
        if (!basicCell) basicCell = [[WYUserDetailBasicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userBasicCell];
        NSDictionary *dic = [self.data[section] objectForKey:key][indexPath.row];
        basicCell.titleLb.text = [dic allKeys][0];
        basicCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([[dic allKeys][0] isEqualToString:@"个人简介"]) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 7.f;
            NSMutableAttributedString *mas = [[NSMutableAttributedString alloc]initWithString:[dic objectForKey:[dic allKeys][0]]];
            [mas addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [mas length])];
            basicCell.contentLb.attributedText = mas;
            
        }else{
            basicCell.contentLb.text = [dic objectForKey:[dic allKeys][0]];
        }
        
        return basicCell;
        
    }else if ([key isEqualToString:Kgroups]){
        
        
        if (!defaultCell) defaultCell = [[WYUserDetailGroupCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userDefaultCell];
        
        WYGroup *group = [self.data[section] objectForKey:key][indexPath.row];
        [defaultCell.iconIV sd_setImageWithURL:[NSURL URLWithString:group.group_icon]];
        defaultCell.textLb.text = group.name;
        [self addline:defaultCell :indexPath];
        return defaultCell;
        
    }else if ([key isEqualToString:Kstudys]){
        
        if (!subtitleCell) subtitleCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:userSubtitleCell];
        
        WYStudy *study = [self.data[section] objectForKey:key][indexPath.row];
        
        subtitleCell.imageView.image = [UIImage imageNamed:@"Personalhomepage_shcool"];
        subtitleCell.textLabel.text = study.school;
        subtitleCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ —— %@",study.start_year_month,study.finish_year_month];
        
        subtitleCell.textLabel.font = [UIFont systemFontOfSize:14];
        subtitleCell.detailTextLabel.textColor = UIColorFromHex(0x999999);
        [self addline:subtitleCell :indexPath];

        return subtitleCell;
        
    }else if ([key isEqualToString:Kworks]){
        if (!subtitleCell) subtitleCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:userSubtitleCell];;
        
        WYJob *job = [self.data[section] objectForKey:key][indexPath.row];
        
        subtitleCell.imageView.image = [UIImage imageNamed:@"Personalhomepage_company"];
        subtitleCell.textLabel.text = job.org;
        subtitleCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ —— %@",job.start_year_month,job.finish_year_month];
        
        subtitleCell.textLabel.font = [UIFont systemFontOfSize:14];
        subtitleCell.detailTextLabel.textColor = UIColorFromHex(0x999999);
        [self addline:subtitleCell :indexPath];
        return subtitleCell;

    }else if ([key isEqualToString:Kinterests]){
        if (!interestCell) interestCell = [[WYUserDetaillnterestsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userInterestCell];
        
        NSArray *interestsArr = [self.data[section] objectForKey:key];
        
        [interestCell setCellData:interestsArr :indexPath];
        [self addline:interestCell :indexPath];
        return interestCell;
    }
    
    //section == Kevents
    if (!activityCell) activityCell = [[WYUserDetailActivityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userActivityCell];;
    NSArray *eventsArr = [self.data[section] objectForKey:key];

    [activityCell setCellData:eventsArr :indexPath];
    [self addline:activityCell :indexPath];
    return activityCell;
}

-(void)addline:(UITableViewCell *)cell :(NSIndexPath *)indexPath{
    UIView *line = [cell.contentView viewWithTag:999];
    if (line == nil) {
        line = [UIView new];
        line.tag = 999;
        line.backgroundColor = UIColorFromHex(0xf5f5f5);
        [cell.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.bottom.equalTo(0);
            make.width.equalTo(kAppScreenWidth - 15);
            make.height.equalTo(1);
        }];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *key = [[self.data[indexPath.section] allKeys] firstObject];
    if ([key isEqualToString:Kgroups]){
        WYGroup *group = [self.data[indexPath.section] objectForKey:key][indexPath.row];
        WYGroupDetailVC *vc = [WYGroupDetailVC new];
        vc.group = group;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(void)noti:(NSNotification *)sender{
    CGFloat y = [[sender.userInfo objectForKey:@"contenty"] floatValue];
    //如果发通知的类不是自己发的 就改变contentOfset
    //不是自己发的
    self.tableView.delegate = nil;
    
    if (![sender.object isKindOfClass:self.class]) {
        //最多同步到顶部
        if (y >= -(40 +64)) {
            y = -104;
        }
        CGPoint point = self.tableView.contentOffset;
        point.y = y;
        self.tableView.contentOffset = point;
    }
    self.tableView.delegate = self;
}
-(void)editClick{
    WYSelfDetailEditing *vc = [WYSelfDetailEditing new];
    vc.userInfo = self.userInfo;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma groupsDatasourceChanged
-(void)quitGroup:(NSNotification *)noti{
    
    NSMutableArray *groupArr = [self.userExtra.public_groups mutableCopy];
    WYGroup *newGroup = [noti.userInfo objectForKey:@"group"];
    for (int i = 0; i < groupArr.count; i ++) {
        WYGroup *group = groupArr[i];
        if ([group.uuid isEqualToString:newGroup.uuid]) {
            [groupArr removeObjectAtIndex:i];
            break;
        }
    }
    self.userExtra.public_groups = groupArr;
    [self initData];
    [_tableView reloadData];
}

-(void)updateGroupDatasource:(NSNotification *)noti{
    
    NSMutableArray *groupArr = [self.userExtra.public_groups mutableCopy];
    WYGroup *newGroup = [noti.userInfo objectForKey:@"group"];
    //将新的group更新到对应的位置
    for (int i =0; i < groupArr.count; i++) {
        WYGroup *group = groupArr[i];
        if ([group.uuid isEqualToString:newGroup.uuid]) {
            [groupArr replaceObjectAtIndex:i withObject:newGroup];
        }
    }
    self.userExtra.public_groups = groupArr;
    [self initData];
    [_tableView reloadData];
}



@end
