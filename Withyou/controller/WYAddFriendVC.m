//
//  WYAddFriendVC.m
//  Withyou
//
//  Created by Tong Lu on 7/27/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import "WYAddFriendVC.h"
#import "WYCommonTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "WYUserApi.h"
#import "WYUserVC.h"

@interface WYAddFriendVC() <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    UISearchBar *_searchBar;
    NSMutableArray *_searchResults;
    UITableView * _tableView;
    
    UIBarButtonItem * _leftItem;
    UIBarButtonItem * _rightItem;
    UIView * _titleView;

}

@end

@implementation WYAddFriendVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"查找联系人";
    _searchResults = [NSMutableArray new];
    
    [self createSearchBar];
    [self createTableView];
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kAppScreenWidth, kAppScreenHeight) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.backgroundColor = UIColorFromHex(0xffffff);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
- (void)createSearchBar
{
    CGFloat searchBarHeight = 44;
    CGRect searchFrame = CGRectMake(0, 0, kAppScreenWidth, searchBarHeight);
    UISearchBar *search = [[UISearchBar alloc] initWithFrame:searchFrame];
    search.backgroundColor = UIColorFromHex(0xf5f5f5);
    search.placeholder = @"手机号/用户名";
    search.barTintColor = [UIColor whiteColor];
    search.delegate = self;
    search.showsCancelButton = NO;

    _searchBar = search;
    [_searchBar becomeFirstResponder];
    
    
    _leftItem = self.parentViewController.navigationItem.leftBarButtonItem;
    _titleView = self.parentViewController.navigationItem.titleView;
    _rightItem = self.parentViewController.navigationItem.rightBarButtonItem;;
    self.parentViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[UIView new]];
    self.parentViewController.navigationItem.titleView = _searchBar;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    self.parentViewController.navigationItem.rightBarButtonItem = item;
}
- (void)reloadData
{
    [_tableView reloadData];
}

#pragma mark - UITableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchResults.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"searchResultCell";
    WYCommonTableViewCell *cell = (WYCommonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[WYCommonTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    WYUser *f = _searchResults[indexPath.row];
    
    cell.textLabel.text = f.fullName;
    cell.descriptionLabel.text = f.account_name;
    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:f.icon_url]
                        placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WYUser *user = _searchResults[indexPath.row];
    
    WYUserVC *vc = [WYUserVC new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.user = user;
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark searchBar delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    if([searchBar.text length] < 2){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            [OMGToast showWithText:@"关键词太短"];
        });
        
        return;
    }
    else if([searchBar.text length] > 30)
    {
       [OMGToast showWithText:@"关键字长度最长为30字"];
        return;
        
    }
    //do some further check, todo
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [WYUserApi searchUserByKeyword:searchBar.text
                         Handler:^(NSArray *results) {
                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                             if(results.count > 0){
                                 [_searchResults removeAllObjects];
                                 [_searchResults addObjectsFromArray:results];
                                 [self reloadData];
                             }
                             else{
                                 [OMGToast showWithText:@"未找到匹配的结果" duration:1.3];
                             }
        }];
    }
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if ([searchText length] == 0)
    {
        [searchBar performSelector:@selector(resignFirstResponder)
                        withObject:nil
                        afterDelay:0];
        //        [searchBar setShowsCancelButton:NO animated:YES];
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

-(void)cancelAction{
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";
    self.parentViewController.navigationItem.leftBarButtonItem = _leftItem;
    self.parentViewController.navigationItem.titleView = _titleView;
    self.parentViewController.navigationItem.rightBarButtonItem = _rightItem;
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.parentViewController.navigationItem.titleView endEditing:YES];
}

@end
