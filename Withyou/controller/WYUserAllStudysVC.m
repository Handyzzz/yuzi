//
//  WYUserAllStudysVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/14.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYUserAllStudysVC.h"
#import "WYStudyApi.h"

@interface WYUserAllStudysVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSMutableArray *studyArr;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic, assign)BOOL hasMore;

@end

@implementation WYUserAllStudysVC
static NSString *studyCell = @"YZStudyListTableViewCell";

-(NSMutableArray *)studyArr{
    if (_studyArr == nil) {
        _studyArr = [NSMutableArray array];
    }
    return _studyArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];

    [self setUpUI];
    [self initData];
}
-(void)setNavigationBar{
    self.title = @"学习经历";
    
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
    __weak WYUserAllStudysVC *weakSelf = self;
    //第一次 不需要下拉的效果
    [self.tableView showHUDNoHide];
    [WYStudyApi getUserAllStudy:self.userUuid page:_page Block:^(NSArray *studyArr, BOOL hasMore) {
        [weakSelf.tableView hideAllHUD];
        if (studyArr) {
            self.page += 1;
            weakSelf.hasMore = hasMore;
            [weakSelf.studyArr addObjectsFromArray:studyArr];
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
        [WYStudyApi getUserAllStudy:weakSelf.userUuid page:weakSelf.page Block:^(NSArray *studyArr, BOOL hasMore) {

            if (studyArr.count > 0) {
                weakSelf.page += 1;
                weakSelf.hasMore = hasMore;
                [weakSelf.studyArr addObjectsFromArray:studyArr];
                [weakSelf.tableView reloadData];
            }else{
                [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
            }
            [weakSelf.tableView endFooterRefresh];
        }];
    }];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.studyArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:studyCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:studyCell];
    }
    
    WYStudy *study = self.studyArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"Personalhomepage_shcool"];
    cell.textLabel.text = study.school;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ —— %@",study.start_year_month,study.finish_year_month];
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
