//
//  WYDocumentLibaryVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/22.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYDocumentLibaryVC.h"
#import "WYDocumentLiabaryCell.h"
#import "WYPreViewPdfVC.h"
#import "WYPdfApi.h"
@interface WYDocumentLibaryVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *pdfArr;
@property(nonatomic, strong)NSMutableArray *statusArr;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)BOOL hasMore;
@property(nonatomic, copy)NSMutableArray *markArr;


@end

@implementation WYDocumentLibaryVC
-(NSMutableArray *)markArr{
    if (_markArr == nil) {
        _markArr = [NSMutableArray array];
    }
    return _markArr;
}
-(NSMutableArray *)statusArr{
    if (_statusArr == nil) {
        _statusArr = [NSMutableArray array];
    }
    return _statusArr;
}

- (NSMutableArray *)selectedPdfArr {
    if(_selectedPdfArr == nil) {
        _selectedPdfArr = [NSMutableArray array];
    }
    return _selectedPdfArr;
}


-(NSMutableArray *)pdfArr{
    if (_pdfArr == nil) {
        _pdfArr = [NSMutableArray array];
    }
    return _pdfArr;
}

-(void)initData{
    _page = 1;
    __weak WYDocumentLibaryVC *weakSelf = self;
    [self.tableView showHUDNoHide];
    [WYPdfApi listAllSelfPdfs:1 Block:^(NSArray *pdfsArr, BOOL hasMore) {
        [weakSelf.tableView hideAllHUD];
        if (pdfsArr) {
            if (pdfsArr.count > 0) {
                [weakSelf.pdfArr addObjectsFromArray:pdfsArr];
                //算对钩
                [weakSelf calculateStatus];
                weakSelf.hasMore = hasMore;
                _page += 1;
                [weakSelf.tableView reloadData];
            }else{
                [OMGToast showWithText:@"文件库是空的！"];
            }
        }else{
            [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
        }
    }];
    
    [self.tableView addFooterRefresh:^{
        if (!weakSelf.hasMore){
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];

            return ;
        }
        [WYPdfApi listAllSelfPdfs:weakSelf.page Block:^(NSArray *pdfsArr, BOOL hasMore) {
            if (pdfsArr) {
                if (pdfsArr.count > 0) {
                    weakSelf.page += 1;
                    weakSelf.hasMore = hasMore;
                    [weakSelf.pdfArr addObjectsFromArray:pdfsArr];
                    //算对钩
                    [weakSelf calculateStatus];
                    [weakSelf.tableView reloadData];

                }else{
                    [OMGToast showWithText:@"文件库空空如野！"];
                }
            }else{
                [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
            }
        }];
    }];
}

-(void)calculateStatus{
    [self.statusArr removeAllObjects];
    for (int i = 0; i < self.pdfArr.count; i ++) {
        YZPdf *pdf = self.pdfArr[i];
        NSNumber *status = @(NO);
        for (int j = 0; j < self.markArr.count; j ++) {
            YZPdf *selectedPdf = self.markArr[j];
            if ([selectedPdf.uuid isEqualToString:pdf.uuid]) {
                status = @(YES);
                break;
            }else{
                status = @(NO);
            }
        }
        [self.statusArr addObject:status];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self setUpNaviBar];
    [self.markArr addObjectsFromArray:self.selectedPdfArr];
    [self initData];
}

-(void)setUpNaviBar{
    
    self.title = @"我的文件库";
    
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick:)];

}


-(void)setUpTableView{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.editing = YES;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 5)];
    view.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = view;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pdfArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYDocumentLiabaryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[WYDocumentLiabaryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    __weak WYDocumentLibaryVC *weakSelf = self;
    YZPdf *pdf = self.pdfArr[indexPath.row];
    [cell setCellData:pdf];
    cell.tintColor = kRGB(43, 161, 212);
    cell.preViewClick = ^{
        YZPdf *pdf = self.pdfArr[indexPath.row];
        WYPreViewPdfVC *vc = [WYPreViewPdfVC new];
        vc.targetUrl = pdf.url;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    //如果cell是预选的
    if ([self.statusArr[indexPath.row] isEqual:@(YES)]) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    return cell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.markArr.count < 5) {
        return indexPath;
    }else{
        //提示最多可以@10位朋友
        [OMGToast showWithText:@"你最多可以发布5个pdf文件"];
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YZPdf *pdf = self.pdfArr[indexPath.row];
    BOOL exist = NO;
    for (YZPdf *selectPdf in self.markArr) {
        if([selectPdf.uuid isEqualToString:pdf.uuid]) {
            exist = YES;
            break;
        }
    }
    if(exist == NO) {
        [self.markArr addObject:pdf];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    YZPdf *pdf = self.pdfArr[indexPath.row];
    for (int i = 0; i < self.markArr.count; i ++) {
        YZPdf *selectPdf = self.markArr[i];
        if ([selectPdf.uuid isEqualToString:pdf.uuid]) {
            [self.markArr removeObjectAtIndex:i];
            break;
        }
    }
}


//点击确定按钮并且选择了最少一个成员的时候 button才可以按
- (void)doneClick:(UIBarButtonItem *)btn {
    self.selectedFdfs([self.markArr copy]);
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

// 选择模式
- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

@end
