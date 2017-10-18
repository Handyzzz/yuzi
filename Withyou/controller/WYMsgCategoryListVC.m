//
//  WYMsgCategoryListVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/5.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYMsgCategoryListVC.h"
#import "WYMsgCategoryListCell.h"
#import "WYMessageCategory.h"
#import "WYMsgListVC.h"

@interface WYMsgCategoryListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray*cateArr;

@end

@implementation WYMsgCategoryListVC

-(NSMutableArray*)cateArr{
    if (_cateArr == nil) {
        _cateArr = [NSMutableArray array];
    }
    return _cateArr;
}

-(void)initDataFomeCache{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSData *data = [user objectForKey:kMsgCategoryListKey];
    NSArray *tempArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self.cateArr addObjectsFromArray:tempArr];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self initDataFomeCache];
    [self addTableHearRefresh];
    [self registerNoti];

}

-(void)addTableHearRefresh{
    __weak WYMsgCategoryListVC *weakSelf = self;
    [self.tableView addHeaderRefresh:^{
        [WYMessageCategory listMsgCategory:0 Block:^(NSInteger total_unread_num, NSArray *categoryArr) {
            [weakSelf.tableView endHeaderRefresh];
            
            if (categoryArr) {
                
                if(total_unread_num > 0) {
                    RootTabBarController *tabbar = [WYUtility tabVC];
                    UITabBarItem *item = tabbar.tabBar.items[2];
                    if(total_unread_num > 0){
                        item.badgeValue = [NSString stringWithFormat:@"%ld", total_unread_num];
                    }
                    else{
                        [item setBadgeValue:nil];
                    }
                }
                
                [weakSelf.cateArr removeAllObjects];
                [weakSelf.cateArr addObjectsFromArray:categoryArr];
                [weakSelf.tableView reloadData];
            }else{
                [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
            }
        }];
    }];
}

-(void)registerNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMsgCategoryListNoti:) name:kMsgCategoryList object:nil];
}

-(void)updateMsgCategoryListNoti:(NSNotification *)noti{
    if (self.cateArr.count > 0) {
        [self.cateArr removeAllObjects];
    }
    NSArray *tempArr = [noti.userInfo objectForKey:@"cateArr"];
    [self.cateArr addObjectsFromArray:tempArr];
    [self.tableView reloadData];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kMsgCategoryList object:nil];
}

-(void)setUpTableView{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[WYMsgCategoryListCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cateArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WYMsgCategoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    WYMessageCategory *single = self.cateArr[indexPath.row];
    [cell.iconIV sd_setImageWithURL:[NSURL URLWithString:single.icon_url]];
    cell.nameLb.text = single.name;
    if(single.unread_num.intValue > 0){
        cell.nameLb.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBlack];
    }
    else{
        cell.nameLb.font = [UIFont systemFontOfSize:16];
    }
    NSString *msg;
    if (single.unread_num.intValue > 0) {
        msg = [NSString stringWithFormat:@"%d",single.unread_num.intValue];
    }else{
        msg = @"";
    }
    cell.countLb.text = msg;
    [cell lineView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WYMessageCategory *single = self.cateArr[indexPath.row];
    WYMsgListVC *vc =  [WYMsgListVC new];
    vc.type = single.type.intValue;
    vc.hidesBottomBarWhenPushed = YES;
    __weak typeof(self) this = self;
    vc.block = ^(BOOL checkedAll, int type){
        if(checkedAll == YES)
            [this updateUnreadNum:type];
    };
    vc.naviTitle = single.name;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)updateUnreadNum:(int)type{
    int unread = 0;
    /**
     OC中 可变数组也是不可变的 改变后的数组本质上是一个新的数组
     */
    for(int i = 0; i < self.cateArr.count; i++){
        WYMessageCategory *mc = self.cateArr[i];
        if(mc.type.intValue == type)
        {
            unread = mc.unread_num.intValue;
            mc.unread_num = @(0);
            [self.cateArr replaceObjectAtIndex:i withObject:mc];
            break;
        }
    }
    [self.tableView reloadData];
    
    RootTabBarController *tabbar = [WYUtility tabVC];
    UITabBarItem *item = tabbar.tabBar.items[2];
    NSInteger oldBadgeValue = [item.badgeValue integerValue];
    NSInteger newBadgeValue = oldBadgeValue - unread;
    if(newBadgeValue > 0){
        [item setBadgeValue:[NSString stringWithFormat:@"%ld", newBadgeValue]];
    }
    else{
        [item setBadgeValue:nil];
    }
}

-(void)reloadMsgData{
    [self.tableView reloadData];
}

@end
