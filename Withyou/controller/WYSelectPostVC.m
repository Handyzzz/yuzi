//
//  WYSelectPostVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/4/5.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYSelectPostVC.h"
#import "YZSearchBar.h"

@interface WYSelectPostVC ()<UISearchBarDelegate>
@property (nonatomic, strong)NSMutableArray *postList;
@property (nonatomic, strong)YZSearchBar *searchBar;
@property(nonatomic, strong)UIView *searchView;
@property(nonatomic, strong)UIView *classView;
@property(nonatomic, assign)NSInteger type;
@end

@implementation WYSelectPostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查找帖子";
    [self setNaviBAr];
    self.tableView.frame = self.view.bounds;
    [self creatTabHeadVeiw];
}

-(void)setNaviBAr{
    
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


//重写清空一下 去除下拉功能 (避免父类下拉影响)
- (void)createRefreshView{}

-(void)searchData{
    
    MJWeakSelf
    [YZPostListApi selectPostForGroup:weakSelf.group.uuid text:weakSelf.searchBar.text lastTime:@0 Block:^(NSArray *postList) {
        [weakSelf.dataSource removeAllObjects];
        [weakSelf turnInto:[postList mutableCopy]];
        [weakSelf.tableView endHeaderRefresh];
        [weakSelf.tableView reloadData];
    }];
    //上拉加载
    [self.tableView addFooterRefresh:^{
        //在那边有判断 如果lastTime不存在 就用的是@0
        [YZPostListApi selectPostForGroup:weakSelf.group.uuid text:weakSelf.searchBar.text lastTime:((WYCellPostFrame*)(weakSelf.dataSource.lastObject)).post.createdAtFloat Block:^(NSArray *postList) {
            if (postList.count > 0) {
                [weakSelf turnInto:[postList mutableCopy]];
                [weakSelf.tableView endFooterRefresh];
                [weakSelf.tableView reloadData];
            }else{
                [OMGToast showWithText:@"未能搜索到相关帖子"];
            }
        }];
    }];
}

-(void)turnInto:(NSMutableArray*)arr{
    if (arr > 0) {
        for (WYPost*post in arr) {
            [self.dataSource addObject:[[WYCellPostFrame alloc]initWithPost:post]];
        }
    }
}

//设置表头视图 搜索框
-(void)creatTabHeadVeiw{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 60)];
    _searchView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kAppScreenWidth - 80, 40)];
    _searchView.layer.cornerRadius = 4;
    _searchView.clipsToBounds = YES;
    _searchView.backgroundColor = UIColorFromHex(0xf5f5f5);
    [view addSubview:_searchView];
    
    self.searchBar = [YZSearchBar new];
    self.searchBar.placeholder = @"群内搜索";
    [self.searchBar becomeFirstResponder];
    self.searchBar.font = [UIFont systemFontOfSize:16];
    self.searchBar.backgroundColor = UIColorFromHex(0xf5f5f5);
    [self.searchBar addTarget:self action:@selector(onSearchBarChange:) forControlEvents:UIControlEventEditingChanged];
    [self.searchBar addTarget:self action:@selector(onSearchBarEixt:) forControlEvents:UIControlEventEditingDidEnd];
    [self.searchBar addTarget:self action:@selector(onSearchBarReturenKeyClick:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_searchView addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(5);
        make.bottom.equalTo(-5);
    }];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:UIColorFromHex(0x999999) forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelButton addTarget:self action:@selector(handleCancel:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.centerY.equalTo(0);
        make.width.equalTo(35);
        make.height.equalTo(30);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = UIColorFromHex(0xf5f5f5);
    [view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(0);
        make.bottom.equalTo(-1);
        make.height.equalTo(1);
    }];
    
    self.tableView.tableHeaderView = view;
}

- (void)setupClassView{
    self.classView = [[UIView alloc] initWithFrame:CGRectMake(0, 95, self.view.frame.size.width, self.view.frame.size.height - 75)];
    [self.view addSubview:self.classView];
    
    CGFloat width = 60;
    CGFloat pandding = (self.view.frame.size.width - width * 4) * 0.2;
    for (NSInteger i = 0; i < 4; ++i) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(pandding * (i + 1) + width * i, 50, width, width);
        button.layer.cornerRadius = width * 0.5;
        button.clipsToBounds = YES;
        button.tag = 1000 + i + 1;
        [button addTarget:self action:@selector(classClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.classView addSubview:button];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 14, 38, 38)];
        [button addSubview:imageView];
        switch (i) {
            case 0:
            {
                button.backgroundColor = UIColorFromHex(0x6BBDFF);
                imageView.image = [UIImage imageNamed:@"grouppage_searchpage_video"];
            }
                break;
            case 1:
            {
                button.backgroundColor = UIColorFromHex(0x61C8FF);
                imageView.image = [UIImage imageNamed:@"grouppage_searchpage_link"];
            }
                break;
            case 2:
            {
                button.backgroundColor = UIColorFromHex(0xFF7C5D);
                imageView.image = [UIImage imageNamed:@"grouppage_searchpage_pdf"];
            }
                break;
            case 3:
            {
                button.backgroundColor = UIColorFromHex(0xFFB653);
                imageView.image = [UIImage imageNamed:@"grouppage_searchpage_image"];
            }
                break;
                
            default:
                break;
        }
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - Action

- (void)handleCancel:(id)sender{
   
    _searchBar.text = @"";
    [self.view endEditing:YES];
}

- (void)classClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    self.type = button.tag - 1000;
    self.classView.hidden = YES;
}

#pragma mark- UITextFieldChange
- (void)onSearchBarReturenKeyClick:(UITextField *)textField {
    if (textField.text.length <= 1) {
        [OMGToast showWithText:@"关键字至少为两个"];
        return;
    }
    if (textField.text.length > 30){
        [OMGToast showWithText:@"关键字长度最长为30字"];
    }
    [self searchData];
    [textField resignFirstResponder];
}

- (void)onSearchBarEixt:(UITextField *)textField {
        NSString *text = textField.text;
        if([text isEqualToString:@""]) return;
        // 清空搜索
        textField.text = @"";
        [self onSearchBarChange:textField];
}

- (void)onSearchBarChange:(UITextField *)textField {
    // 先缓存所有数据
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
