//
//  WYGroupCategoryVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/29.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYGroupCategoryVC.h"
#import "WYGroupCategoryCell.h"
#import "WYGroupDetailVC.h"
#import "WYRecommendGroup.h"
#import "WYRecommendGroupListApi.h"
#import "WYPopUpTextView.h"
#import "WYGroupApi.h"
#import "WYTipTypeOne.h"

@interface WYGroupCategoryVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *groupsArr;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)BOOL hasMore;
@end

@implementation WYGroupCategoryVC

-(NSMutableArray *)groupsArr{
    if (_groupsArr == nil) {
        _groupsArr = [NSMutableArray array];
    }
    return _groupsArr;
}

-(void)initData{
    
    _page = 1;
    
    __weak WYGroupCategoryVC *weakSelf = self;
    [self.view showHUDNoHide];
    [WYRecommendGroupListApi listGroupArrForCategory:self.categoryType Page:_page :^(NSArray *recommentGroupArr, BOOL hasMore) {
        [weakSelf.view hideAllHUD];        
        if (recommentGroupArr) {
            weakSelf.page += 1;
            weakSelf.hasMore = hasMore;
            [weakSelf.groupsArr addObjectsFromArray:recommentGroupArr];
            [weakSelf.tableView reloadData];
        }else{
            [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
        }
    }];
    
    //上拉加载
    [self.tableView addFooterRefresh:^{
        
        if (!weakSelf.hasMore){
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        [WYRecommendGroupListApi listGroupArrForCategory:weakSelf.categoryType Page:weakSelf.page :^(NSArray *recommentGroupArr, BOOL hasMore) {
            if (recommentGroupArr) {
                weakSelf.page += 1;
                weakSelf.hasMore = hasMore;
                [weakSelf.groupsArr addObjectsFromArray:recommentGroupArr];
                [weakSelf.tableView reloadData];
            }else{
                [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
            }
            [weakSelf.tableView endFooterRefresh];

        }];
    }];

   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.name;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNaviBar];
    [self setUpTableView];
    [self initData];
}

-(void)setNaviBar{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
}

-(void)setUpTableView{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYRecommendGroup *recommendGroup = self.groupsArr[indexPath.row];
    if (recommendGroup.tags.length > 0) {
        return 152;
    }
    return 117;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groupsArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYGroupCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WYGroupCategoryCell"];
    if (cell == nil) {
        cell = [[WYGroupCategoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WYGroupCategoryCell"];
    }
    
    WYRecommendGroup *recommendGroup = self.groupsArr[indexPath.row];
    [cell setUpCellDetail:recommendGroup];
    
    __weak WYGroupCategoryVC *weakSelf = self;
    cell.applyGroupClick = ^{
        WYPopUpTextView *textView = [[WYPopUpTextView alloc]initWithPlaceHoder:nil];
        textView.textClick = ^(NSString *text) {
            [WYUtility requireSetAccountNameOrAlreadyHasName:^{
                [weakSelf applyJoinGroup:text recommendGroup:recommendGroup];
            } navigationController:weakSelf.navigationController];
        };
    };
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WYRecommendGroup *recommendGroup = self.groupsArr[indexPath.row];
    WYGroupDetailVC *vc = [WYGroupDetailVC new];
    vc.groupUuid = recommendGroup.uuid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - apply join

- (void)applyJoinGroup:(NSString *)text recommendGroup:(WYRecommendGroup *)recommendGroup{
    
    __weak WYGroupCategoryVC *weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"申请如果被管理员拒绝，须一周后才能再次申请。\n请确认自己的个人资料真实完善，且符合群介绍中的入群要求" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"继续申请" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [WYGroupApi requestJoinGroup:recommendGroup.uuid comment:text callback:^(BOOL success) {
            if(success){
                [WYTipTypeOne showWithMsg:@"群管理员已收到你的申请，请耐心等待审核结果" imageWith:WYTipTypeOneImageSuccess];
                for (int i = 0; i < weakSelf.groupsArr.count; i ++) {
                    WYRecommendGroup *group = weakSelf.groupsArr[i];
                    group.able_to_apply = NO;
                    [weakSelf.groupsArr replaceObjectAtIndex:i withObject:group];
                    [weakSelf.tableView reloadData];
                }
            }else {
                [WYTipTypeOne showWithMsg:@"申请失败" imageWith:WYTipTypeOneImageFail];
            }
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:doneAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
