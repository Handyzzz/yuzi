//
//  WYSelfFriendListsVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/21.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYSelfFriendListsVC.h"
#import "WYFollowListCell.h"
#import "WYUserVC.h"
#import "WYFollow.h"

#define searchBarHeight 30

@interface WYSelfFriendListsVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong)UITableView*tableView;
@property (nonatomic,strong)NSMutableArray *friendsArr;
@property (nonatomic, strong) NSArray *searchArray;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic, assign)BOOL hasMore;
@property (nonatomic, copy) NSArray *indexs;
@property (nonatomic, copy) NSDictionary *dataSource;
@property (nonatomic, strong)UISearchBar *searchBar;

@end
static NSString  *cellIdentifier = @"followCellIdentifier";

@implementation WYSelfFriendListsVC

-(NSMutableArray *)friendsArr{
    if (_friendsArr == nil) {
        _friendsArr = [NSMutableArray array];
    }
    return _friendsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self initData];
    [self setUpUI];
}
-(void)setNavigationBar{
    self.title = @"好友";
    
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
}

-(void)setUpUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, kAppScreenHeight) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.sectionIndexColor = [UIColor blueColor];
    _tableView.sectionIndexTrackingBackgroundColor = UIColorFromHex(0xf5f5f5);
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.tableHeaderView = [self setupSearchView];
    [self.view addSubview:_tableView];
}

- (UIView *)setupSearchView {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth, searchBarHeight + 20)];
    backView.backgroundColor = kRGB(230, 230, 230);
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 10, kAppScreenWidth, searchBarHeight)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"查找好友";
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.backgroundImage = [[UIImage alloc] init];
    _searchBar.barTintColor = [UIColor clearColor];
    
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    searchField.backgroundColor = [UIColor whiteColor];
    [backView addSubview:_searchBar];
    return backView;
}



-(void)initData{

    [self.friendsArr addObjectsFromArray: [WYFollow queryMutualFollowingFriends]];
    [self sortIndex];
}


-(void)sortIndex{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (WYUser *user in self.friendsArr) {
        
        NSString * letter = [NSString pinyinFirstLetter:user.last_name];
        
        //分组
        if(dict[letter]){
            NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:dict[letter]];
            [tmpArr addObject:user];
            [dict setObject:tmpArr forKey:letter];
        }else {
            [dict setObject:@[user] forKey:letter];
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
    WYFollowListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[WYFollowListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    WYUser *user = [(NSArray*)self.dataSource[self.indexs[indexPath.section]] objectAtIndex:indexPath.row];
    [cell setCellData:user];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WYUser *user = [(NSArray*)self.dataSource[self.indexs[indexPath.section]] objectAtIndex:indexPath.row];
    WYUserVC *vc = [WYUserVC new];
    vc.userUuid = user.uuid;
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

#pragma mark- UISearchBarDelagete

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    // 先缓存所有数据
    if(self.searchArray == nil) {
        self.searchArray = [NSArray arrayWithArray:self.friendsArr];
    }
    // 清空数据源
    [self.friendsArr removeAllObjects];
    // 都转为小写 去匹配大小写
    NSString *lowerText = [_searchBar.text lowercaseString];
    NSString *text = [lowerText chChangePin];
    
    if(text.length > 0) {
        NSMutableArray *tmp = [NSMutableArray array];
        // 遍历缓存的所有数据
        for (WYUser *user in self.searchArray) {
            
            if([[[user.fullName lowercaseString] chChangePin] containsString:text]) {
                [tmp addObject:user];
            }
        }
        [self.friendsArr addObjectsFromArray:tmp];
    }else {
        // 从缓存中恢复所有数据
        [self.friendsArr addObjectsFromArray:self.searchArray];
        self.searchArray = nil;
    }
    [self sortIndex];
    [_tableView reloadData];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
@end
