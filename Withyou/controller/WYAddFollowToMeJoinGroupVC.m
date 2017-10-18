
//
//  WYAddFollowToMeJoinGroupVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/14.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYAddFollowToMeJoinGroupVC.h"
#import "WYFollow.h"
#import "WYSelectStyleCell.h"
#import "NSString+WYStringEx.h"
#import "UIScrollView+EmptyDataSet.h"
#import "WYTipTypeOne.h"
#import "WYGroupApi.h"

@interface WYAddFollowToMeJoinGroupVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSMutableArray *arr;
@property (nonatomic, copy) NSMutableArray *selectedMember;
@property (nonatomic, copy) NSArray *indexs;
@property (nonatomic, copy) NSDictionary *dataSource;
@property (nonatomic, copy) NSMutableArray *removedArr;

@end

@implementation WYAddFollowToMeJoinGroupVC


#pragma mark - lazy

- (NSMutableArray *)selectedMember {
    if(_selectedMember == nil) {
        _selectedMember = [NSMutableArray array];
    }
    return _selectedMember;
}

- (NSDictionary *)dataSource {
    if(_dataSource == nil) {
        _dataSource = [NSDictionary dictionary];
    }
    return _dataSource;
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
    
    self.title = @"添加群成员";
    
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(onSelected:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadData{
    
    
    [self.view showHUDNoHide];
    
    __weak WYAddFollowToMeJoinGroupVC *weakSelf = self;
    //关注我的人
    [WYFollow listFollowListFromMeNotInGroup:self.group.uuid Block:^(NSArray *removeArr,BOOL success) {
        if (success) {
            if (removeArr.count > 0) {
                [self.removedArr addObjectsFromArray:removeArr];
                [weakSelf.tableView reloadData];
            }
        }else{
            [OMGToast showWithText:@"网络不畅"];
        }
        [self.view hideAllHUD];
    }];
}

- (void)initData {
    
    //查找 关注我的人
    _arr = [[WYFollow queryAllFollowListToMe] mutableCopy];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (WYUser *user in _arr) {
        
        NSString * letter = [NSString pinyinFirstLetter:user.last_name];
        
        //分组
        if(dict[letter]){
            NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:dict[letter]];
            [tmpArr addObject:user];
            [dict setObject:tmpArr forKey:letter];
        }else {
            [dict setObject:@[user] forKey:letter];
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
    // 编辑模式
    self.tableView.editing = YES;
    // 允许多选
    self.tableView.allowsMultipleSelection = YES;
    
    [self.view addSubview:self.tableView];
}


#pragma mark -
//点击确定按钮并且选择了最少一个成员的时候 button才可以按
- (void)onSelected:(UIBarButtonItem *)btn {
    
    [self.view showHUDNoHide];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    __weak WYAddFollowToMeJoinGroupVC *weakSelf = self;
    //拉关注我的人入群
    [WYUtility requireSetAccountNameOrAlreadyHasName:^{
        [WYGroupApi addFollowerToGroup:self.group.uuid inviteArr:self.selectedMember Block:^(NSArray *alreadyArr, NSArray *notFollowerArr, NSArray *successArr, long status) {
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
                weakSelf.group.member_num = self.group.member_num +(int)successArr.count;
                weakSelf.group.partial_member_list = [mutablePartialMemberList copy];
                //发送通知，回传群组
                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateGroupDataSource object:weakSelf userInfo:@{@"group":self.group}];
            }
            
            if (status == 200) {
                [WYTipTypeOne showWithMsg:@"添加成功" imageWith:@"groupapplicationAgree"];
                [weakSelf.view hideAllHUD];
                [weakSelf popVC];
            }
            else if (status == 206) {
                NSString *alertString;
                
                if(notFollowerArr.count > 0 && alreadyArr.count > 0)
                {
                    // 邀请的人中有人未关注我, 也有是群成员的, 两种错误都有
                    alertString = [NSString stringWithFormat:@"未添加%lu位 %@已经是群成员，%@暂未关注你",
                                   notFollowerArr.count + alreadyArr.count,
                                   [NSString nameStringsFromBackendDictOfInviteResult:alreadyArr],
                                   [NSString nameStringsFromBackendDictOfInviteResult:notFollowerArr]
                                   ];
                    
                    
                }else{
                    //只有一种错误
                    
                    if(alreadyArr.count > 0){
                        // 错误只出在了有人已经是群成员，没有未关注我的人
                        alertString = [NSString stringWithFormat:@"未添加%lu位，%@已经是群成员",
                                       notFollowerArr.count + alreadyArr.count,
                                       [NSString nameStringsFromBackendDictOfInviteResult:alreadyArr]
                                       ];
                    }
                    else{
                        // 错误只出在了有未关注我的人存在
                        alertString = [NSString stringWithFormat:@"未添加%lu位，%@暂未关注你",
                                       notFollowerArr.count + alreadyArr.count,
                                       [NSString nameStringsFromBackendDictOfInviteResult:notFollowerArr]
                                       ];
                        
                    }
                }
                
                [WYTipTypeOne showWithMsg:alertString imageWith:@"groupapplicationDisagree"];
                [weakSelf.view hideAllHUD];
                [weakSelf popVC];
            }
            else{
                [WYTipTypeOne showWithMsg:@"添加成员未成功" imageWith:@"groupapplicationDisagree"];
                [weakSelf.view hideAllHUD];
                [weakSelf popVC];
            }
        }];
    } navigationController:self.navigationController];
}
-(void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)changeRightBarButtonStatus {
    if(self.selectedMember.count == 0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _indexs.count;
}
//返回section中的row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [(NSArray*)self.dataSource[self.indexs[section]] count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYSelectStyleCell *cell = (WYSelectStyleCell *)[tableView dequeueReusableCellWithIdentifier:@"WYCommonTableViewCell"];
    if (cell == nil) {
        cell = [[WYSelectStyleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"WYCommonTableViewCell"];
    }
    
    WYUser *user = [(NSArray*)self.dataSource[self.indexs[indexPath.section]] objectAtIndex:indexPath.row];
    cell.textLabel.text = user.fullName;
    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:user.icon_url]
                        placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    //判断一下是否是 在removeArr中
    if ([self calculateIsInGroup:user.uuid]) {
        //设置tintColor
        cell.tintColor = UIColorFromHex(0xc5c5c5);
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }else{
        cell.tintColor = UIColorFromHex(0x2BA1D4);
    }
    return cell;
}

//可以考虑第一次算出来 性能更好 
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

//手选的时候才会调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WYUser *user = [(NSArray*)self.dataSource[self.indexs[indexPath.section]] objectAtIndex:indexPath.row];
    BOOL exist = NO;
    for (NSString *uuid in self.selectedMember) {
        if([user.uuid isEqualToString:uuid]) {
            exist = YES;
            break;
        }
    }
    if(exist == NO) {
        [self.selectedMember addObject:user.uuid];
    }
    [self changeRightBarButtonStatus];
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    //如果是灰色的 就不让他反选
    WYUser *user = [(NSArray*)self.dataSource[self.indexs[indexPath.section]] objectAtIndex:indexPath.row];
    if ([self calculateIsInGroup:user.uuid]) {
        return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    WYUser *user = [(NSArray*)self.dataSource[self.indexs[indexPath.section]] objectAtIndex:indexPath.row];
    [self.selectedMember removeObject:user.uuid];
    [self changeRightBarButtonStatus];
}


// 选择模式
- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
@end
