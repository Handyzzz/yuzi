//
//  WYRecommendGroupVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/24.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYRecommendGroupVC.h"
#import "YZGroupListTableViewCell.h"
#import "WYGroup.h"
#import "WYGroupDetailVC.h"
#import "WYGroupListApi.h"

@interface WYRecommendGroupVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView*tableView;
@property(nonatomic, strong)NSMutableArray *groupArr;
@end

@implementation WYRecommendGroupVC


-(NSMutableArray *)groupArr{
    if (_groupArr == nil) {
        _groupArr = [NSMutableArray array];
    }
    return _groupArr;
}
-(void)initData{
    __weak WYRecommendGroupVC *weakSelf = self;

    //第一次请求
    //[self.view showHUDNoHide];
    [WYGroupListApi listRecommendGroupsBlock:^(NSArray *groupsArr, BOOL success) {
        if (success) {
            //[self.view hideAllHUD];
            if (groupsArr.count > 0) {
                [self.groupArr addObjectsFromArray:groupsArr];
                [weakSelf.tableView reloadData];
            }
        }else{
            [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
        }
    }];
    //上拉刷新
    [self.tableView addFooterRefresh:^{
        if (!(self.groupArr.count > 0)) {
            [weakSelf.tableView endFooterRefresh];
            return;
        }
        NSMutableArray *uuidArr = [NSMutableArray array];
        for (WYGroup *group in weakSelf.groupArr) {
            [uuidArr addObject:group.uuid];
        }

        [WYGroupListApi listMoreRecommendGroups:[uuidArr copy] Block:^(NSArray *moreGroupArr, BOOL success) {
            if (success) {
                if (moreGroupArr.count > 0) {
                    [weakSelf.groupArr addObjectsFromArray:moreGroupArr];
                    [weakSelf.tableView reloadData];
                }else{
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else{
                [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
            }
            [weakSelf.tableView endFooterRefresh];
        }];
    }];
}

-(void)setUpUI{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推荐群组";
    [self setNaviItem];
    [self setUpUI];
    [self initData];
}

-(void)setNaviItem{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groupArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YZGroupListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell = [[YZGroupListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    WYGroup *group = self.groupArr[indexPath.row];
    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:group.group_icon]];
    cell.myTextLabel.text = group.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WYGroupDetailVC *vc = [WYGroupDetailVC new];
    vc.group = self.groupArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma actions
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
