//
//  WYDraftVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/17.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYDraftVC.h"
#import "WYPost.h"
#import "WYDraftCell.h"

@interface WYDraftVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *contentArr;
@property(nonatomic, strong)NSMutableArray *timeArr;
@end

@implementation WYDraftVC

-(NSMutableArray *)contentArr{
    if (_contentArr == nil) {
        _contentArr = [NSMutableArray array];
    }
    return _contentArr;
}

-(NSMutableArray*)timeArr{
    if (_timeArr == nil) {
        _timeArr = [NSMutableArray array];
    }
    return _timeArr;
}

-(void)initData{
    
    __weak WYDraftVC *weakSelf = self;
    [WYPost queryDraftFromCacheBlock:^(NSArray *contentArr, NSArray *timeArr) {
        if (contentArr.count > 0) {
            [weakSelf.contentArr addObjectsFromArray:contentArr];
            [weakSelf.timeArr addObjectsFromArray:timeArr];
            [weakSelf.tableView reloadData];
        }
    }];
}
-(void)setNavigationBar{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self setUpUI];
    [self initData];
}

-(void)setUpUI{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[WYDraftCell class] forCellReuseIdentifier:@"cell"];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    debugLog(@"%@",self.contentArr);
    debugLog(@"%f",[WYDraftCell caculateCellHeight:self.contentArr[indexPath.row]]);

    return  [WYDraftCell caculateCellHeight:self.contentArr[indexPath.row]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contentArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYDraftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell setCellData:self.contentArr :self.timeArr :indexPath];
    
    __weak WYDraftVC *weakSelf = self;
    cell.removeDraftBlock = ^{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定要删除这条草稿吗?" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //删掉数据库
            [WYPost deleDraftFromDB:weakSelf.timeArr[indexPath.row]];
            [weakSelf.contentArr removeObjectAtIndex:indexPath.row];
            [weakSelf.timeArr removeObjectAtIndex:indexPath.row];
            [weakSelf.tableView reloadData];

        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        }]];
        [weakSelf presentViewController:alert animated:YES completion:nil];

    };
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
