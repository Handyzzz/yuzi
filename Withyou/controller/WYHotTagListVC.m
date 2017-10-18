//
//  WYHotTagListVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/9/1.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYHotTagListVC.h"
#import "WYHotTagListCell.h"
#import "WYTagsResultPostListVC.h"
#import "WYPostTagApi.h"

@interface WYHotTagListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSMutableArray *hotTagArr;
@property(nonatomic,strong)NSMutableArray *imgArr;
@end

@implementation WYHotTagListVC

-(NSMutableArray *)imgArr{
    if (_imgArr == nil) {
        _imgArr = [NSMutableArray array];
    }
    return _imgArr;
}

-(NSMutableArray *)hotTagArr{
    if (_hotTagArr == nil) {
        _hotTagArr = [NSMutableArray array];
    }
    return _hotTagArr;
}

-(void)initData{
    
    //base
    NSArray *baseImgArr = @[@"hot_taglist_one",
                        @"hot_taglist_two",
                        @"hot_taglist_three",
                        @"hot_taglist_four",
                        @"hot_taglist_five",
                        @"hot_taglist_six",
                        @"hot_taglist_seven"
                        ];

    
    //hotTag
    __weak WYHotTagListVC *weakSelf = self;
    [WYPostTagApi hotPostTagBlock:^(NSArray *hotTagArr) {
        if (hotTagArr) {
            for (int i = 0; i < hotTagArr.count; i++) {
                //img 取余
                NSInteger index = i%7;
                [weakSelf.imgArr addObject:baseImgArr[index]];
            }
            
            [weakSelf.hotTagArr addObjectsFromArray:hotTagArr];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"热门标签";
    [self setNaviItem];
    [self setUpTableView];
    [self initData];
}

-(void)setNaviItem{
    
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

-(void)setUpTableView{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[WYHotTagListCell class] forCellReuseIdentifier:@"WYHotTagListCell"];
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 5)];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.hotTagArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYHotTagListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WYHotTagListCell" forIndexPath:indexPath];
    [cell setUpCellDetail:self.hotTagArr[indexPath.row] img:self.imgArr[indexPath.row]];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WYTagsResultPostListVC *vc = [WYTagsResultPostListVC new];
    NSDictionary *dic = self.hotTagArr[indexPath.row];
    vc.tagStr = [dic objectForKey:@"name"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
