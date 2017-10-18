//
//  WYuserPublicGroupsVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/10.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYuserPublicGroupsVC.h"
#import "WYUserDetail.h"
#import "WYUserDetailApi.h"
#import "YZGroupListTableViewCell.h"
#import "WYGroupDetailVC.h"

@interface WYuserPublicGroupsVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSMutableArray *groupArr;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic, assign)BOOL hasMore;

@end

@implementation WYuserPublicGroupsVC

static NSString *groupCell = @"YZGroupListTableViewCell";

-(NSMutableArray *)groupArr{
    if (_groupArr == nil) {
        _groupArr = [NSMutableArray array];
    }
    return _groupArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];

    [self setUpUI];
    [self initData];
    [self resignNoti];
}



-(void)resignNoti{
    //群组改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGroupDatasource:) name:kUpdateGroupDataSource object:nil];
    //退出群组
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitGroup:) name:kQuitGroup object:nil];
}


#pragma groupsDatasourceChanged
-(void)quitGroup:(NSNotification *)noti{
    WYGroup *newGroup = [noti.userInfo objectForKey:@"group"];
    for (int i = 0; i < _groupArr.count; i ++) {
        WYGroup *group = _groupArr[i];
        if ([group.uuid isEqualToString:newGroup.uuid]) {
            [_groupArr removeObjectAtIndex:i];
            break;
        }
    }
    [_tableView reloadData];
}

-(void)updateGroupDatasource:(NSNotification *)noti{
    WYGroup *newGroup = [noti.userInfo objectForKey:@"group"];
    //将新的group更新到对应的位置
    for (int i =0; i < _groupArr.count; i++) {
        WYGroup *group = _groupArr[i];
        if ([group.uuid isEqualToString:newGroup.uuid]) {
            [_groupArr replaceObjectAtIndex:i withObject:newGroup];
        }
    }
    [_tableView reloadData];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpdateGroupDataSource object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kQuitGroup object:nil];
}

-(void)setNavigationBar{
    self.title = @"所在群组";
    
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
}
-(void)setUpUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, kAppScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

-(void)initData{
    
    _page = 1;
    
    //能按这个按钮 说明肯定有至少一个group 所以直接传就可以了
    __weak WYuserPublicGroupsVC *weakSelf = self;
    //第一次 不需要下拉的效果
    [self.tableView showHUDNoHide];
    [WYUserDetailApi listMorePublicGroup:self.userUuid Page:self.page Block:^(NSArray *moreGroupArr, BOOL hasMore) {

        if (moreGroupArr) {
            self.page += 1;
            weakSelf.hasMore = hasMore;
            [weakSelf.groupArr addObjectsFromArray:moreGroupArr];
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
       [WYUserDetailApi listMorePublicGroup:weakSelf.userUuid Page:weakSelf.page Block:^(NSArray *moreGroupArr, BOOL hasMore) {
                      
           if (moreGroupArr.count > 0) {
               weakSelf.page += 1;
               weakSelf.hasMore = hasMore;
               [weakSelf.groupArr addObjectsFromArray:moreGroupArr];
               [weakSelf.tableView reloadData];
           }else{
               [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
           }
           [weakSelf.tableView endFooterRefresh];

           
        }];
   }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _groupArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YZGroupListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:groupCell];
    if (!cell) {
        cell = [[YZGroupListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:groupCell];
    }
    
    WYGroup *group = self.groupArr[indexPath.row];
    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:group.group_icon]];
    cell.myTextLabel.text = group.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WYGroup *group = self.groupArr[indexPath.row];
    WYGroupDetailVC *vc = [WYGroupDetailVC new];
    vc.groupUuid = group.uuid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma action
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
