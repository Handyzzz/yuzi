//
//  WYRemindFriendsVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/15.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYRemindFriendsVC.h"
#import "WYFollow.h"
#import "WYSelectStyleCell.h"

@interface WYRemindFriendsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSMutableArray *userArr;
@property (nonatomic, copy) NSArray *indexs;
@property (nonatomic, copy) NSDictionary *dataSource;
@property (nonatomic, copy) NSMutableDictionary *statusDic;

@end

@implementation WYRemindFriendsVC

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



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNaviItem];
    [self sortData];
    [self createTableView];
}


-(void)setNaviItem{
    
    self.title = self.naviTitle;
    
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick:)];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sortData{
    
    //查找 我的朋友
    _userArr = [[WYFollow queryMutualFollowingFriends] mutableCopy];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableDictionary *statusDic = [NSMutableDictionary dictionary];

    for (WYUser *user in _userArr) {
        
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
            [tmpArr addObject:[self caculateStatus:user]];
            [statusDic setObject:tmpArr forKey:letter];
        }else{
            [statusDic setObject:@[[self caculateStatus:user]] forKey:letter];
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

-(NSNumber *)caculateStatus:(WYUser *)user{
    for (int i = 0; i < self.selectedMember.count; i ++) {
        WYUser *seletedUser = self.selectedMember[i];
        if ([seletedUser.uuid isEqualToString:user.uuid]) {
            return @(YES);
        }
    }
    return @(NO);
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
- (void)doneClick:(UIBarButtonItem *)btn {
    self.remindFriends(self.selectedMember);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.indexs.count;
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
    cell.tintColor = UIColorFromHex(0x2BA1D4);
    
    //如果cell是预选的
    if ([[(NSArray*)self.statusDic[self.indexs[indexPath.section]] objectAtIndex:indexPath.row] isEqual:@(YES)]) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    return cell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedMember.count < 10) {
        return indexPath;
    }else{
        //提示最多可以@10位朋友
        [OMGToast showWithText:@"你最多可以@10位朋友"];
        return nil;
    }
}

//手选的时候才会调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WYUser *user = [(NSArray*)self.dataSource[self.indexs[indexPath.section]] objectAtIndex:indexPath.row];
    BOOL exist = NO;
    for (WYUser *selectedUser in self.selectedMember) {
        if([selectedUser.uuid isEqualToString:user.uuid]) {
            exist = YES;
            break;
        }
    }
    if(exist == NO) {
        [self.selectedMember addObject:user];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    WYUser *user = [(NSArray*)self.dataSource[self.indexs[indexPath.section]] objectAtIndex:indexPath.row];
    for (int i = 0; i < self.selectedMember.count; i ++) {
        WYUser *selectedUser = self.selectedMember[i];
        if ([selectedUser.uuid isEqualToString:user.uuid]) {
            [self.selectedMember removeObjectAtIndex:i];
            break;
        }
    }
}

//返回索引数组
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    return self.indexs;
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
    
    return self.indexs[section];
}

// 选择模式
- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
@end
