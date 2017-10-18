//
//  WYSelectGroupCategoryVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/1.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYSelectGroupCategoryVC.h"
#import "WYSelectGroupCategoryCell.h"
#import "WYGroupCategory.h"
#import "WYGroupCategroyApi.h"


@interface WYSelectGroupCategoryVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *tagsArr;
@end

@implementation WYSelectGroupCategoryVC

-(NSMutableArray *)tagsArr{
    if (_tagsArr == nil) {
        _tagsArr = [NSMutableArray array];
    }
    return _tagsArr;
}

-(void)viewDidLoad{
    [self setUpTableView];
    self.title = @"群组类型";
    [self setNaviBar];
    [self initData];
}

-(void)initData{
    __weak WYSelectGroupCategoryVC *weakSelf = self;
    [self.view showHUDNoHide];
    [WYGroupCategroyApi listAllGroupCategoryBlock:^(NSArray *tagsArr, BOOL success) {
        [weakSelf.view hideAllHUD];
        if (success) {
            if (tagsArr.count > 0) {
                [weakSelf.tagsArr addObjectsFromArray:tagsArr];
                [weakSelf.tableView reloadData];
            }
        }else{
            [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
        }
    }];
}

-(void)setUpTableView{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tagsArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYSelectGroupCategoryCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[WYSelectGroupCategoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    WYGroupCategory *tags = self.tagsArr[indexPath.row];
    [cell.iconIV sd_setImageWithURL:[NSURL URLWithString:tags.image]];
    cell.nameLb.text = tags.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WYSelectGroupCategoryCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"grouptypeChosen"]];
    WYGroupCategory *tag = self.tagsArr[indexPath.row];
    self.selectedClick(tag);
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setNaviBar{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
