
//
//  WYSelectGroupsOrFriendsVC.m
//  Withyou
//
//  Created by 夯大力 on 2017/2/24.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYSelectGroupsOrFriendsVC.h"
#import "UIScrollView+EmptyDataSet.h"
#import "WYSelectGroupOrFriendsCell.h"
#import "WYGroup.h"
#import "WYFollow.h"
#import "WYUser.h"

@interface WYSelectGroupsOrFriendsVC () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *groups;
@property(nonatomic, strong) NSMutableArray *user;
@property(nonatomic, strong) NSIndexPath *index;
@property(nonatomic, strong) NSIndexPath *lastIndex;

@end

@implementation WYSelectGroupsOrFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self creatTableView];
    [self initData];
}

- (void)setNavigationBar {
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];

    self.navigationItem.leftBarButtonItem = leftBtnItem;

}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)initData {
    if ([self.selectType isEqualToString:APPOINTGROUPSTYPE]) {
        self.title = @"指定群组";
//        [WYGroup queryAllMultiplePersonGroupsWithBlock:^(NSArray *groups) {
        [WYGroup queryAllGroupsWithBlock:^(NSArray *groups) {
            if (groups) {
                _groups = [groups mutableCopy];
                [self.tableView reloadData];
            }
        }];
    }
    if ([self.selectType isEqualToString:APPOINTFRIENDSTYPE]) {
        self.title = @"指定朋友";
        _user = [[WYFollow queryMutualFollowingFriends] mutableCopy];
        [self.tableView reloadData];
    }

}

- (void)creatTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.tableFooterView = [UIView new];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.sectionIndexColor = [UIColor blueColor];
    _tableView.sectionIndexTrackingBackgroundColor = UIColorFromHex(0xf5f5f5);
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 70.f;

    //UIScrollView+EmptyDataSet
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    // 编辑模式
    _tableView.editing = YES;
    // 允许多选
    _tableView.allowsMultipleSelection = NO;
    [_tableView registerClass:[WYSelectGroupOrFriendsCell class] forCellReuseIdentifier:@"WYSelectGroupOrFriendsCell"];
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.selectType isEqualToString:APPOINTGROUPSTYPE] ? _groups.count : _user.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WYSelectGroupOrFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WYSelectGroupOrFriendsCell" forIndexPath:indexPath];

    /*
     进来时候显示之前选过的cell的
     存了之前选过的群组或者好友的Uuid 通过这个信息往Group中迭代
     如果有的话就就找出这个好友或者群组的index获取对应的cell
     然后让对应的cell的钩钩设置为选择状态
     */

    if ([self.selectType isEqualToString:APPOINTGROUPSTYPE]) {
        //通过Uuid去找位置
        WYGroup *group = _groups[indexPath.row];
        NSURL *url = [NSURL URLWithString:group.group_icon];
        [cell.myImageView sd_setImageWithURL:url];
        cell.textLabel.text = group.name;
        //通过Uuid找到Group
        if ([_Uuid isEqualToString:group.uuid]) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            //这里相当于自动选择 选择后我们要self.index = indexPath 因为用户可能进来就出去了 这也相当于它有了自动选择
            self.index = indexPath;
            //自动选择后也要报刘上一次的index 后边可以用来判断
            _lastIndex = indexPath;
        }
    }

    if ([self.selectType isEqualToString:APPOINTFRIENDSTYPE]) {

        WYUser *user = _user[indexPath.row];
        NSURL *url = [NSURL URLWithString:user.icon_url];
        [cell.myImageView sd_setImageWithURL:url];
        cell.textLabel.text = user.fullName;
        cell.descriptionLabel.text = user.account_name;
        //通过Uuid找到Group
        if ([_Uuid isEqualToString:user.uuid]) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            self.index = indexPath;
            _lastIndex = indexPath;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.index = nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    self.index = indexPath;
    //刚进来的时候有一次自动选择 但是_lastIndex不会肯定存在 因为并不是任何情况下都有自动选择
    if (_lastIndex) {

        if (indexPath != _lastIndex) {
            [tableView deselectRowAtIndexPath:_lastIndex animated:NO];
        } else {
            //判断上一次cell的状态  在点击的是相同的cell的时候 这次cell的状态和上次必然是相反的 
            WYSelectGroupOrFriendsCell *cell = [tableView cellForRowAtIndexPath:_lastIndex];
            if ([cell isSelected]) {
                self.index = indexPath;
            } else {
                self.index = nil;
            }
        }
    }

    _lastIndex = indexPath;

    if (self.index) {
        if ([self.selectType isEqualToString:APPOINTGROUPSTYPE]) {
            if ([[self.tableView cellForRowAtIndexPath:self.index] isSelected]) {
                WYGroup *group = _groups[self.index.row];
                self.visiableScopeBlock(group.uuid, group.name, group, YES);
            }
        }
        if ([self.selectType isEqualToString:APPOINTFRIENDSTYPE]) {
            if ([[self.tableView cellForRowAtIndexPath:self.index] isSelected]) {
                WYUser *user = _user[self.index.row];
                self.visiableScopeBlock(user.uuid, user.fullName, nil, YES);
            }
        }
    } else {
        self.visiableScopeBlock(nil, nil, nil, NO);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

@end
