
//
//  WYMyAttentionTagListVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/9/2.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYMyAttentionTagListVC.h"
#import "WYMyAttentionTagListCell.h"
#import "WYPostTagApi.h"
#import "WYTagsResultPostListVC.h"

@interface WYMyAttentionTagListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSMutableArray<NSDictionary*>*tagDicList;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, assign) BOOL hasMore;
@end

@implementation WYMyAttentionTagListVC

-(NSMutableArray *)tagDicList{
    if (_tagDicList == nil) {
        _tagDicList = [NSMutableArray array];
    }
    return _tagDicList;
}

-(void)initData{
    
    __weak WYMyAttentionTagListVC *weakSelf = self;
    [self.view showHUDNoHide];
   [WYPostTagApi listAllMyFollowedTags:1 Block:^(NSArray *tagDicList, BOOL hasMore) {
       [weakSelf.view hideAllHUD];
       if (tagDicList) {
           weakSelf.page = 2;
           weakSelf.hasMore = hasMore;
           [weakSelf.tagDicList removeAllObjects];
           [weakSelf.tagDicList addObjectsFromArray:tagDicList];
           [weakSelf.tableView reloadData];
        }else{
           [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
       }
   }];
    
    [self.tableView addFooterRefresh:^{
        if (!weakSelf.hasMore){
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        [WYPostTagApi listAllMyFollowedTags:weakSelf.page Block:^(NSArray *tagDicList, BOOL hasMore) {
            if (tagDicList) {
                if (tagDicList.count > 0) {
                    weakSelf.page = 2;
                    weakSelf.hasMore = hasMore;
                    [weakSelf.tableView endFooterRefresh];
                    [weakSelf.tableView reloadData];
                }else{
                    [weakSelf.tableView endRefreshWithNoMoreData];
                }
            }else{
                [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
                [weakSelf.tableView endFooterRefresh];
            }
        }];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关注标签";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNaviItem];
    [self setUpTableView];
    [self setUpTableHeaderView];
    [self initData];

}

-(void)setUpNaviItem{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

-(void)setUpTableView{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[WYMyAttentionTagListCell class] forCellReuseIdentifier:@"WYMyAttentionTagListCell"];
    [self.view addSubview:_tableView];
}

-(void)setUpTableHeaderView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 8)];
    view.backgroundColor = UIColorFromHex(0xf5f5f5);
    self.tableView.tableHeaderView = view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tagDicList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYMyAttentionTagListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WYMyAttentionTagListCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dic = self.tagDicList[indexPath.row];
    [cell setCellDetai:dic];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = self.tagDicList[indexPath.row];
    NSString *tagName = [dic objectForKey:@"name"];
    WYTagsResultPostListVC *vc = [WYTagsResultPostListVC new];
    vc.tagStr = tagName;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
