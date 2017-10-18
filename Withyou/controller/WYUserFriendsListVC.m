//
//  WYUserFriendsListVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/14.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYUserFriendsListVC.h"
#import "WYUserDetailVC.h"
#import "WYFollowListCell.h"
#import "WYUserVC.h"
#import "WYUserDetailApi.h"

@interface WYUserFriendsListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSMutableArray *friendsArr;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic, assign)BOOL hasMore;
@end

static NSString  *cellIdentifier = @"followCellIdentifier";

@implementation WYUserFriendsListVC

-(NSMutableArray *)friendsArr{
    if (_friendsArr == nil) {
        _friendsArr = [NSMutableArray array];
    }
    return _friendsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self setUpUI];
    [self initData];
}
-(void)setNavigationBar{
    self.title = @"好友";

    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

-(void)setUpUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, kAppScreenHeight) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.sectionIndexColor = [UIColor blueColor];
    _tableView.sectionIndexTrackingBackgroundColor = UIColorFromHex(0xf5f5f5);
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

-(void)initData{
    
    _page = 1;
    
    //能按这个按钮 说明肯定有至少一个group 所以直接传就可以了
    __weak WYUserFriendsListVC *weakSelf = self;
    //第一次 不需要下拉的效果
    [self.tableView showHUDNoHide];
    [WYUserDetailApi listUserFriends:self.userUuid Page:self.page Block:^(NSArray *moreFrdendsArr, BOOL hasMore) {
        
        if (moreFrdendsArr) {
            self.page += 1;
            weakSelf.hasMore = hasMore;
            [weakSelf.friendsArr addObjectsFromArray:moreFrdendsArr];
            [weakSelf.tableView reloadData];

        }else{
            [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
        }
        [weakSelf.tableView hideAllHUD];
    }];

    //上拉加载
    [self.tableView addFooterRefresh:^{
        if (!weakSelf.hasMore){
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];

            return ;
        }
            [WYUserDetailApi listCommonFriends:weakSelf.userUuid Page:weakSelf.page Block:^(NSArray *moreFrdendsArr, BOOL hasMore) {
                
                if (moreFrdendsArr.count > 0) {
                    weakSelf.page += 1;
                    weakSelf.hasMore = hasMore;
                    [weakSelf.friendsArr addObjectsFromArray:moreFrdendsArr];
                    [weakSelf.tableView reloadData];
                }else{
                    [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
                }
                [weakSelf.tableView endFooterRefresh];

        }];
    }];
}


//返回section中的row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.friendsArr.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYFollowListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[WYFollowListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    WYUser *user = self.friendsArr[indexPath.row];
    [cell setCellData:user];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WYUser *user = self.friendsArr[indexPath.row];
    WYUserVC *vc = [WYUserVC new];
    vc.userUuid = user.uuid;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma action
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
