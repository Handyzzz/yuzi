//
//  WYUserAllJobsVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/14.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYUserAllJobsVC.h"
#import "WYJobApi.h"

@interface WYUserAllJobsVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSMutableArray *jobArr;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic, assign)BOOL hasMore;


@end
@implementation WYUserAllJobsVC

static NSString *jobCell = @"YZjobListTableViewCell";

-(NSMutableArray *)jobArr{
    if (_jobArr == nil) {
        _jobArr = [NSMutableArray array];
    }
    return _jobArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];

    [self setUpUI];
    [self initData];
}
-(void)setNavigationBar{
    self.title = @"工作经历";
    
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
    __weak WYUserAllJobsVC *weakSelf = self;
    //第一次 不需要下拉的效果
    [self.tableView showHUDNoHide];
    [WYJobApi getUserAllJob:self.userUuid page:_page Block:^(NSArray *jobArr, BOOL hasMore) {
        
        if (jobArr) {
            self.page += 1;
            weakSelf.hasMore = hasMore;
            [weakSelf.jobArr addObjectsFromArray:jobArr];
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
        [WYJobApi getUserAllJob:weakSelf.userUuid page:weakSelf.page Block:^(NSArray *jobArr, BOOL hasMore) {
            
            if (jobArr.count > 0) {
                weakSelf.page += 1;
                weakSelf.hasMore = hasMore;
                [weakSelf.jobArr addObjectsFromArray:jobArr];
                [weakSelf.tableView reloadData];
            }else{
                [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
            }
            [weakSelf.tableView endFooterRefresh];
        }];
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.jobArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:jobCell];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:jobCell];
    }
    WYJob *job = self.jobArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"Personalhomepage_company"];
    cell.textLabel.text = job.org;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ —— %@",job.start_year_month,job.finish_year_month];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = UIColorFromHex(0x999999);
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma action
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
