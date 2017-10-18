//
//  WYGroupMemberList.m
//  Withyou
//
//  Created by Handyzzz on 2017/3/30.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYGroupMemberList.h"
#import "WYGroupMemberListCell.h"
#import "WYGroupsVC.h"
#import "WYUser.h"
#import "WYFollow.h"
#import "WYUserVC.h"
#import "WYGroupApi.h"

@interface WYGroupMemberList ()
@property (nonatomic, strong)NSMutableArray *memberList;
@property (nonatomic, strong)NSMutableArray *folArr;
@property (nonatomic, strong)NSMutableArray *infArr;
@end
@implementation WYGroupMemberList

static NSString *cellIdentifier = @"groupCellIdentifier";


-(NSMutableArray *)adminList{
    if (_adminList == nil) {
        _adminList = [NSMutableArray array];
    }
    return _adminList;
}
//普通的群成员的列表
-(NSMutableArray *)memberList{
    if (_memberList == nil) {
        _memberList = [NSMutableArray array];
    }
    return _memberList;
}
-(NSMutableArray *)resultList{
    if (_resultList == nil) {
        _resultList = [NSMutableArray array];
    }
    return _resultList;
}
-(NSMutableArray *)relationshipArrForResultList{
    if (_relationshipArrForResultList == nil) {
        _relationshipArrForResultList = [@[@"",@"我关注了ta",@"ta关注了我",@"好友",@"自己"] mutableCopy];
    }
    return _relationshipArrForResultList;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"群成员";
    [self setNaviItem];
    [self createTableView];
    [self prepareData];
    [self initData];

}

-(void)setNaviItem{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)initData{
    
    __weak WYGroupMemberList *weakSelf = self;
    
    if(self.includeAdminList){
        self.adminList = [self.group.adminList copy];
        [self.relationshipArrForResultList addObjectsFromArray:[self relationshipArrayFromResultList:self.adminList]];
        [self.tableView reloadData];
    }
    
    [self.view showHUDNoHide];
    [WYGroupApi wholeMemberListForGroup:weakSelf.group.uuid lastUuid:@"" Block:^(NSArray *memberList) {
        // 网络在的时候，会请求到一个空的数组，并不为nil
        // 网络不在的时候，会得到nil，那么当前页面连管理员也不显示了就
        [weakSelf.view hideAllHUD];

        if(!memberList) {
            [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
            return;
        }
        [weakSelf.resultList addObjectsFromArray:memberList];
        [weakSelf.relationshipArrForResultList addObjectsFromArray:[weakSelf relationshipArrayFromResultList:memberList]];

        weakSelf.memberList = [memberList mutableCopy];
        [weakSelf.tableView reloadData];
    }];
    //刚进来的时候 没有人去拉 主动刷新一下

    //上拉加载
    [self.tableView addFooterRefresh:^{
        debugLog(@"last uuid %@", ((WYUser*)(weakSelf.memberList.lastObject)).uuid);
        if(weakSelf.memberList.count == 0)
        {
            [weakSelf.tableView endFooterRefresh];
        }
        else{
            [WYGroupApi wholeMemberListForGroup:weakSelf.group.uuid lastUuid:((WYUser*)(weakSelf.memberList.lastObject)).uuid Block:^(NSArray *memberList) {
    //            这个方法很可能返回空的数组，因为这个方法返回的是普通的成员列表
    //            尤其是刚刚创建群组时，只有管理员，这个请求必然返回的是空数组
                [weakSelf.resultList addObjectsFromArray:memberList];
                [weakSelf.relationshipArrForResultList addObjectsFromArray:[weakSelf relationshipArrayFromResultList:memberList]];

                [weakSelf.memberList addObjectsFromArray:memberList];
                [weakSelf.tableView endFooterRefresh];
                [weakSelf.tableView reloadData];
            }];
        }
    }];
}

- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.tableView registerClass:[WYGroupMemberListCell class] forCellReuseIdentifier:@"WYGroupMemberListCell"];
    [self.view addSubview:_tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.includeAdminList && self.adminList.count > 0) {
        return 30;
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.includeAdminList && self.adminList.count > 0) {
        return 2;
    }
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.includeAdminList && self.adminList.count > 0 && section == 0) {
        return self.adminList.count;
    }
    return self.resultList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYGroupMemberListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WYGroupMemberListCell" forIndexPath:indexPath];
    
    WYUser *user = nil;
    if (self.includeAdminList && self.adminList.count > 0 && indexPath.section == 0) {
        user = self.adminList[indexPath.row];
    }else{
        user = self.resultList[indexPath.row];
    }
    [cell.iconIV sd_setImageWithURL:[NSURL URLWithString:user.icon_url]];

    NSString *relation = [self calculateRelationLbText:user];
    if (relation.length > 0) {
        cell.TextLb.hidden = YES;
        cell.nameLb.hidden = NO;
        cell.nameLb.text = user.fullName;
    }else{
        cell.nameLb.hidden = YES;
        cell.TextLb.hidden = NO;
        cell.TextLb.text = user.fullName;
    }
    cell.relationLb.text = relation;
    [self updateCellContent:indexPath];
    
    return cell;
}

//给子类留一个可以添加东西的地方 在刷新的时候选select用 就不用将整个cellForRowAtIndexPath方法重写
-(void)updateCellContent:(NSIndexPath *)indexPath{
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(self.includeAdminList && self.adminList.count > 0)
    {
        if (section == 0) {
            return @"群管理员";
        }else{
            return @"群成员";
        }
    }
    else{
        return @"";
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(self.includeAdminList && self.adminList.count > 0)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth, [self tableView:tableView heightForHeaderInSection:section])];
        view.backgroundColor = UIColorFromHex(0xf5f5f5);
        
        UILabel *titleLb = [UILabel new];
        [view addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(0);
            make.right.equalTo(0);
            make.height.equalTo(view.frame.size.height);
        }];
        titleLb.text = [self tableView:tableView titleForHeaderInSection:section];
        titleLb.textColor = UIColorFromHex(0xC5C5C5);
        titleLb.font = [UIFont systemFontOfSize:14];
        return view;
    }
    else{
        return nil;
    }
}
-(void)prepareData{
    _folArr = [[WYFollow queryAllFollowListToMe] mutableCopy];
    _infArr = [[WYFollow queryAllFollowListFromMe] mutableCopy];
}
    
-(NSString*)calculateRelationLbText:(WYUser*)user{
    NSInteger i =[WYFollow queryRelationShipWithMeFollowArr:user.uuid infArr:_infArr folArr:_folArr];
    return self.relationshipArrForResultList[i];
}
    
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WYUser *user = nil;
    if (self.includeAdminList && self.adminList.count > 0 && indexPath.section == 0) {
        user = self.adminList[indexPath.row];
    }else{
        user = self.resultList[indexPath.row];
    }
    
    WYUserVC *vc = [WYUserVC new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.user = user;
    [self.navigationController pushViewController:vc animated:YES];


}
#pragma mark - 
- (NSMutableArray *)relationshipArrayFromResultList:(NSArray<WYUser*>*)resultList
{
    NSMutableArray *ma = [NSMutableArray array];
    NSString *relationshipStr;
    for(WYUser *user in resultList){
        /*这个判断是互斥的    0没有关系  1 仅我关注的人 2仅关注我的人 3朋友 4 自己*/

        NSInteger i =[WYFollow queryRelationShipWithMeFollowArr:user.uuid infArr:_folArr folArr:_infArr];
        switch (i) {
            case 1:
                relationshipStr = @"我关注了ta";
                break;
            case 2:
                relationshipStr = @"ta关注了我";
                break;
            case 3:
                relationshipStr = @"朋友";
                break;
            case 4:
                relationshipStr = @"自己";
                break;
            default:
                relationshipStr = @"";
                break;
        }
        [ma addObject:relationshipStr];
    }
    
    return [ma copy];
}

#pragma mark - Action

- (void)searchAction{
    
}

@end
