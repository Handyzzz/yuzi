//
//  WYFollowedMediaVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/9/27.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYFollowedMediaVC.h"
#import "WYMediaListCell.h"
#import "WYMedia.h"
#import "WYMediaDetailVC.h"
#import "WYMediaTagLIstVC.h"
#import "WYMediaAPI.h"
#import "WYMediaFollow.h"

@interface WYFollowedMediaVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *mediaFollowList;
@property(nonatomic,strong)NSMutableDictionary *dataSource;
@property(nonatomic,strong)NSArray*indexs;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)BOOL hasMore;
@end

@implementation WYFollowedMediaVC
static NSString *cellIdentifier = @"cellIdentifier";

-(NSMutableArray *)mediaFollowList{
    if (_mediaFollowList == nil) {
        _mediaFollowList = [NSMutableArray array];
    }
    return _mediaFollowList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self initData];
    [self setUpUI];
}
-(void)setNavigationBar{
    self.title = @"媒体列表";
    
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIImage *rightImg = [[UIImage imageNamed:@"medialistAdd"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithImage:rightImg style:UIBarButtonItemStylePlain target:self action:@selector(addMediaAction)];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

-(void)setUpUI{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.sectionIndexColor = [UIColor blueColor];
    _tableView.sectionIndexTrackingBackgroundColor = UIColorFromHex(0xf5f5f5);
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

-(void)initData{
    _page = 1;
    MJWeakSelf;
    [self.tableView showHUDNoHide];
    [WYMediaAPI listMediaFollowed:_page callback:^(NSArray *mediaFollowArr, BOOL hasMore) {
        [weakSelf.tableView hideAllHUD];
        if (mediaFollowArr) {
            weakSelf.page += 1;
            weakSelf.hasMore = hasMore;
            [weakSelf.mediaFollowList addObjectsFromArray:mediaFollowArr];
            [weakSelf sortIndex:weakSelf.mediaFollowList];
            [weakSelf.tableView reloadData];
        }
    }];
    
    [self.tableView addFooterRefresh:^{
        if (!weakSelf.hasMore) {
            [weakSelf.tableView endRefreshWithNoMoreData];
            return ;
        }
        [WYMediaAPI listMediaFollowed:weakSelf.page callback:^(NSArray *mediaFollowArr, BOOL hasMore) {
            [weakSelf.tableView endFooterRefresh];
            if (mediaFollowArr) {
                weakSelf.page += 1;
                weakSelf.hasMore = hasMore;
                [weakSelf.mediaFollowList addObjectsFromArray:mediaFollowArr];
                [weakSelf sortIndex:weakSelf.mediaFollowList];
                [weakSelf.tableView reloadData];
            }
        }];
    }];
}

-(void)sortIndex:(NSMutableArray *)mediaFollowArr{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (WYMediaFollow *mediaF in mediaFollowArr) {
        NSString * letter = [NSString pinyinFirstLetter:mediaF.media.name];

        //分组
        if(dict[letter]){
            NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:dict[letter]];
            [tmpArr addObject:mediaF.media];
            [dict setObject:tmpArr forKey:letter];
        }else {
            [dict setObject:@[mediaF.media] forKey:letter];
        }
    }
    // 排序
    self.indexs = [dict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
        NSString *letter1 = obj1;
        NSString *letter2 = obj2;
        if ([letter2 isEqualToString:@""] || letter2 == nil) {
            return NSOrderedDescending;
        }else if ([letter1 characterAtIndex:0] < [letter2 characterAtIndex:0]) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];

    self.dataSource = dict;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _indexs.count;
}
//返回section中的row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [(NSArray*)self.dataSource[self.indexs[section]] count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYMediaListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[WYMediaListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    WYMedia *media = [self.dataSource[self.indexs[indexPath.section]] objectAtIndex:indexPath.row];
    [cell.iconIV sd_setImageWithURL:[NSURL URLWithString:media.icon_url]];
    cell.nameLb.text = media.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WYMedia *media = [self.dataSource[self.indexs[indexPath.section]] objectAtIndex:indexPath.row];
    WYMediaDetailVC *vc = [WYMediaDetailVC new];
    vc.media = media;
    [self.navigationController pushViewController:vc animated:YES];
}

//返回索引数组
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    return _indexs;
}

//响应点击索引时的委托方法
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    
    NSInteger count = 0;
    
    for (NSString *character in _indexs) {
        
        if ([character hasPrefix:title]) {
            return count;
        }
        
        count++;
    }
    
    return  0;
}

//返回每个索引的内容
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return _indexs[section];
}


#pragma action
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addMediaAction{
    WYMediaTagLIstVC *vc = [WYMediaTagLIstVC new];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
