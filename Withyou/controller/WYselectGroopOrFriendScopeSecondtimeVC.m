//
//  selectGroopOrFriendScopeSecondtimeVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/4/25.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYselectGroopOrFriendScopeSecondtimeVC.h"
#import "WYCommonTableViewCell.h"
#import "WYGroup.h"
#import "WYFollow.h"
#import "WYUser.h"

@interface WYselectGroopOrFriendScopeSecondtimeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic ,strong) NSIndexPath *index;
@property (nonatomic, strong) NSIndexPath *lastIndex;
@end

@implementation WYselectGroopOrFriendScopeSecondtimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTableView];
    [self setUpFooterView];
    [self initData];
}
- (void)initData {
    __weak WYselectGroopOrFriendScopeSecondtimeVC *weakSelf = self;
    if (self.selectType == 1) {
        self.title = @"指定群组";
        [WYGroup queryAllGroupsWithBlock:^(NSArray *groups) {
            if (groups) {
                _groups = [groups mutableCopy];
                [weakSelf.tableView reloadData];
            }
        }];
    }
    if (self.selectType == 2) {
        self.title = @"指定朋友";
        _users = [[WYFollow queryMutualFollowingFriends] mutableCopy];
        [self.tableView reloadData];
    }
    
}

-(void)creatTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.tableFooterView = [UIView new];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.sectionIndexColor = [UIColor blueColor];
    _tableView.sectionIndexTrackingBackgroundColor = UIColorFromHex(0xf5f5f5);
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 70.f;
    // 编辑模式
    _tableView.editing = YES;
    // 允许多选
    _tableView.allowsMultipleSelection = NO;
    [_tableView registerClass:[WYCommonTableViewCell class] forCellReuseIdentifier:@"WYCommonTableViewCell"];
    [self.view addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.selectType == 1 ?  _groups.count : _users.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYCommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WYCommonTableViewCell" forIndexPath:indexPath];
    
    if (self.selectType == 1) {
        //通过Uuid去找位置
        WYGroup *group = _groups[indexPath.row];
        NSURL *url = [NSURL URLWithString:group.group_icon];
        [cell.myImageView sd_setImageWithURL:url];
        cell.textLabel.text = group.name;
    }
    if (self.selectType == 2) {
        
        WYUser*user = _users[indexPath.row];
        NSURL *url = [NSURL URLWithString:user.icon_url];
        [cell.myImageView sd_setImageWithURL:url];
        cell.textLabel.text = user.fullName;
        cell.descriptionLabel.text = user.account_name;
    }
    return cell;
}
    
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectType == 1) {
        WYGroup *group = self.groups[indexPath.row];
        self.myBlock(3, group.uuid,group.name,group);
    }else{
        WYUser *user = self.users[indexPath.row];
        self.myBlock(4, user.uuid,user.fullName,nil);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

-(void)setUpFooterView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 100)];
    view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = view;
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
