//
//  WYInViteFollowFromMeJoinGroupVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/14.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYInViteFollowFromMeJoinGroupVC.h"
#import "WYFollow.h"
#import "WYInviteUserJoinGroupCell.h"
#import "NSString+WYStringEx.h"
#import "UIScrollView+EmptyDataSet.h"
#import "WYTipTypeOne.h"
#import "WYGroupApi.h"

@interface WYInViteFollowFromMeJoinGroupVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSMutableArray *statusArr;
@property (nonatomic, copy) NSArray *indexs;
@property (nonatomic, copy) NSDictionary *dataSource;
@property (nonatomic, copy) NSMutableDictionary *statusDic;
//指的是在群组中的人 并没有去掉
@property (nonatomic, copy) NSMutableArray *removedArr;
@end

@implementation WYInViteFollowFromMeJoinGroupVC

#pragma mark - lazy
- (NSDictionary *)dataSource {
    if(_dataSource == nil) {
        _dataSource = [NSDictionary dictionary];
    }
    return _dataSource;
}

-(NSMutableDictionary *)statusDic{
    if (_statusDic == nil) {
        _statusDic = [NSMutableDictionary dictionary];
    }
    return _statusDic;
}

-(NSMutableArray *)statusArr{
    if (_statusArr == nil) {
        _statusArr = [NSMutableArray array];
    }
    return _statusArr;
}

- (NSArray *)indexs {
    if(_indexs == nil) {
        _indexs = [NSArray array];
    }
    return _indexs;
}

-(NSMutableArray *)removedArr{
    if (_removedArr == nil) {
        _removedArr = [NSMutableArray array];
    }
    return _removedArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNaviItem];
    
    [self createTableView];
    [self initData];
    [self loadData];
}


-(void)setNaviItem{
    
    //我关注的人
    self.title = @"邀请群成员";

    
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData {
    
    //查找 我关注的人
    NSArray * infArr = [[WYFollow queryAllFollowListFromMe] mutableCopy];
    NSArray * folArr = [[WYFollow queryAllFollowListToMe] mutableCopy];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableDictionary *statusDic = [NSMutableDictionary dictionary];
    for (WYUser *user in infArr) {
        
        NSString * letter = [NSString pinyinFirstLetter:user.last_name];
        
        //分组
        if(dict[letter]){
            NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:dict[letter]];
            [tmpArr addObject:user];
            [dict setObject:tmpArr forKey:letter];
        }else {
            [dict setObject:@[user] forKey:letter];
        }
        
        if (statusDic[letter]) {
            NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:statusDic[letter]];
            NSNumber *i = [self caculateStatus:user infArr:infArr folArr:folArr];
            [tmpArr addObject:i];
            [statusDic setObject:tmpArr forKey:letter];
        }else{
            NSNumber *i = [self caculateStatus:user infArr:infArr folArr:folArr];
            [statusDic setObject:@[i] forKey:letter];
        }
        
    }
    // 排序
    self.indexs = [dict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
        NSString *letter1 = obj1;
        NSString *letter2 = obj2;
        if ([letter2 isEqualToString:@""] || letter2 == nil) {
            return NSOrderedDescending;
        }else if ([letter1 characterAtIndex:0] < [letter2 characterAtIndex:0]) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    
    self.dataSource = dict;
    self.statusDic = statusDic;
}


-(NSNumber *)caculateStatus:(WYUser *)user infArr:infArr folArr:folArr{
    /*这个判断是互斥的    0没有关系  1 仅我关注的人 2仅关注我的人 3朋友 4 自己*/
   NSInteger status = [WYFollow queryRelationShipWithMeFollowArr:user.uuid infArr:infArr folArr:folArr];
    return @(status);
}

-(void)loadData{
    
    
    [self.view showHUDNoHide];
    
    __weak WYInViteFollowFromMeJoinGroupVC *weakSelf = self;
    //我关注的人
    [WYFollow listFollowListToMeNotInGroup:self.group.uuid Block:^(NSArray *removeArr,BOOL success) {
        [self.view hideAllHUD];
        if (success) {
            if (removeArr.count > 0) {
                [self.removedArr addObjectsFromArray:removeArr];
                [weakSelf.tableView reloadData];
            }
        }else{
            [OMGToast showWithText:@"网络不畅"];
        }
    }];
}


//初始化UITableView
- (void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.sectionIndexColor = [UIColor blueColor];
    self.tableView.sectionIndexTrackingBackgroundColor = UIColorFromHex(0xf5f5f5);
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 70.f;
    [self.view addSubview:self.tableView];
}



#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _indexs.count;
}
//返回section中的row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [(NSArray*)self.dataSource[self.indexs[section]] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WYInviteUserJoinGroupCell *cell = (WYInviteUserJoinGroupCell *)[tableView dequeueReusableCellWithIdentifier:@"WYCommonTableViewCell"];
    if (cell == nil) {
        cell = [[WYInviteUserJoinGroupCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"WYCommonTableViewCell"];
    }
    
    WYUser *user = [(NSArray*)self.dataSource[self.indexs[indexPath.section]] objectAtIndex:indexPath.row];
    NSNumber *i = [(NSArray*)self.statusDic[self.indexs[indexPath.section]] objectAtIndex:indexPath.row];
    
    [cell setCellData:user IsInGroup:[self calculateIsInGroup:user.uuid] relation:[i integerValue]];
    __weak WYInViteFollowFromMeJoinGroupVC *weakSelf = self;
    cell.controlBlcok = ^(WYInviteType type) {
        [weakSelf onSelected:type User:user];
    };
    return cell;
}

-(BOOL)calculateIsInGroup:(NSString *)userUuid{
    if (self.removedArr.count <= 0) {
        return NO;
    }
    for (NSString *str in self.removedArr) {
        if ([str isEqualToString:userUuid]) {
            return YES;
        }
    }
    return NO;
}


//手选的时候才会调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
//点击确定按钮并且选择了最少一个成员的时候 button才可以按
- (void)onSelected:(WYInviteType )type User:(WYUser *)user{
    [self.view showHUDNoHide];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    //邀请我关注的人(单向)
    __weak WYInViteFollowFromMeJoinGroupVC *weakSelf = self;
    if(type == WYinviteTypeInvite) {
        [WYUtility requireSetAccountNameOrAlreadyHasName:^{
            [WYGroupApi inviteInfluencer:self.group.uuid inviteArr:[@[user.uuid] mutableCopy] Block:^(NSArray *alreadyArr, NSArray *notInfluencerArr, NSArray *successArr, long status) {
                
                weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
                
                if (status == 200) {
                    [WYTipTypeOne showWithMsg:@"邀请成功" imageWith:@"groupapplicationAgree"];
                    [weakSelf.view hideAllHUD];
                }
                else if(status == 206){
                    if(notInfluencerArr.count > 0){
                        //邀请的人中有我未关注的，这个往往可能是第三方开发人员，不是我们自己，可以不处理
                        [weakSelf.view hideAllHUD];
                        
                    }else{
                        //是朋友
                        NSString *hudStr = @"邀请失败";
                        [WYTipTypeOne showWithMsg:hudStr imageWith:@"groupapplicationDisagree"];
                        [weakSelf.view hideAllHUD];
                    }
                }
                else{
                    [WYTipTypeOne showWithMsg:@"邀请失败" imageWith:@"groupapplicationDisagree"];
                    [weakSelf.view hideAllHUD];
                    
                }
                
            }];
        } navigationController:self.navigationController];
    }else {
        //拉关注我的人入群
        [WYUtility requireSetAccountNameOrAlreadyHasName:^{
            [WYGroupApi addFollowerToGroup:self.group.uuid inviteArr:[@[user.uuid] mutableCopy] Block:^(NSArray *alreadyArr, NSArray *notFollowerArr, NSArray *successArr, long status) {
                weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
                if(successArr.count > 0){
                    //添加新成员给group的partial_member_list中
                    NSMutableArray *mutablePartialMemberList = [self.group.partial_member_list mutableCopy];
                    for (NSDictionary *userDict in successArr) {
                        NSString *uuid = [userDict objectForKey:@"uuid"];
                        WYUser *user = [WYUser queryUserWithUuid:uuid];
                        if(user)
                        {
                            [mutablePartialMemberList addObject:user];
                        }
                    }
                    self.group.member_num = self.group.member_num +(int)successArr.count;
                    weakSelf.group.partial_member_list = [mutablePartialMemberList copy];
                    //发送通知，回传群组
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateGroupDataSource object:weakSelf userInfo:@{@"group":self.group}];
                }
                
                if (status == 200) {
                    [WYTipTypeOne showWithMsg:@"添加成功" imageWith:@"groupapplicationAgree"];
                    [weakSelf.view hideAllHUD];
                }
                else if (status == 206) {
                    NSString *alertString;
                    
                    if(notFollowerArr.count > 0 && alreadyArr.count > 0)
                    {
                        // 邀请的人中有人未关注我, 也有是群成员的, 两种错误都有
                        alertString = [NSString stringWithFormat:@"添加失败,TA已经是群成员,且暂未关注你"];
                        
                    }else{
                        //只有一种错误
                        
                        if(alreadyArr.count > 0){
                            // 错误只出在了有人已经是群成员，没有未关注我的人
                            alertString = [NSString stringWithFormat:@"添加失败,TA已经是群成员"];
                        }
                        else{
                            // 错误只出在了有未关注我的人存在
                            alertString = [NSString stringWithFormat:@"添加失败,TA暂未关注你"];
                        }
                    }
                    
                    [WYTipTypeOne showWithMsg:alertString imageWith:@"groupapplicationDisagree"];
                    [weakSelf.view hideAllHUD];
                }
                else{
                    [WYTipTypeOne showWithMsg:@"添加成员未成功" imageWith:@"groupapplicationDisagree"];
                    [weakSelf.view hideAllHUD];
                }
            }];

        } navigationController:self.navigationController];
    }
}

//返回索引数组
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    return _indexs;
}

//响应点击索引时的委托方法
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    
    NSInteger count = 0;
    
    for (NSString *character in _indexs) {
        
        if ([character hasPrefix:title]) {
            return count;
        }
        
        count++;
    }
    
    return  0;
}

//返回每个索引的内容
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return _indexs[section];
}

@end
