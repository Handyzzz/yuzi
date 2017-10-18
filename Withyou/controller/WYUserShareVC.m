//
//  TestViewController.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/6.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZPostListApi.h"
#import "WYUserShareVC.h"
#import "WYUserDetailHeaderView.h"
#import "WYUserDetailApi.h"

@interface WYUserShareVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *heightArr;
@property (nonatomic, strong)UIButton *starBtn;
@property (nonatomic, strong)UIButton *allBtn;
@property (nonatomic, assign)BOOL isAll;
@property (nonatomic, assign)BOOL isUseDragging;
@property (nonatomic, strong)NSMutableArray *meParticipatePostArr;
@end

@implementation WYUserShareVC

-(NSMutableArray *)meParticipatePostArr{
    if (_meParticipatePostArr == nil) {
        _meParticipatePostArr = [NSMutableArray array];
    }
    return _meParticipatePostArr;
}

-(NSMutableArray *)postArr{
    if (_postArr == nil) {
        _postArr = [NSMutableArray array];
    }
    return _postArr;
}

-(NSMutableArray *)heightArr{
    if (_heightArr == nil) {
        _heightArr = [NSMutableArray array];
    }
    return _heightArr;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isUseDragging = YES;
}

//方法调用的时候 时间的间距还是比较明显的
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isUseDragging == YES) {
        //发通知
        CGFloat y = scrollView.contentOffset.y;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"tableViewScroll" object:self userInfo:@{@"contenty":@(y)}];
    }
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (_isUseDragging == YES) {
        //发通知
        CGFloat y = scrollView.contentOffset.y;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"tableViewScroll" object:self userInfo:@{@"contenty":@(y)}];
    }
    _isUseDragging = NO;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"tableViewScroll" object:nil];
}


-(void)initData{
    
    __weak WYUserShareVC *weakSelf = self;
    [weakSelf.dataSource removeAllObjects];
    for (WYPost *post in self.postArr)
    {
        WYCellPostFrame *frame = [[WYCellPostFrame alloc] initWithPost:post];
        [self.dataSource addObject:frame];
    }
    [self.tableView reloadData];
    
    
    //添加下拉刷新
    /*
     //源码 不会重复添加 赋值替换
     self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:handler];
     */
    [self.tableView addFooterRefresh:^{
        
        WYPost *lastPost = weakSelf.postArr.lastObject;

        if (!lastPost.createdAtFloat) {
            [OMGToast showWithText:@"TA还没有发贴哦!"];
            [weakSelf.tableView endFooterRefresh];
            return ;
        }
        
        [WYUserDetailApi listMorePosts:weakSelf.userInfo.uuid time:lastPost.createdAtFloat Block:^(NSArray *morePostArr,BOOL success) {
            if (success == YES) {
                if (morePostArr.count > 0) {
                    [weakSelf.postArr addObjectsFromArray:morePostArr];
                    [weakSelf.dataSource removeAllObjects];
                    for (WYPost *post in weakSelf.postArr)
                    {
                        WYCellPostFrame *frame = [[WYCellPostFrame alloc] initWithPost:post];
                        [weakSelf.dataSource addObject:frame];
                    }
                    [weakSelf.tableView reloadData];

                }else{
                    [OMGToast showWithText:@"没有更多帖子了"];
                }
            }else{
                [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
            }
            [weakSelf.tableView endFooterRefresh];
            
        
        }];
        
    }];

    self.tableView.mj_footer.automaticallyHidden = YES;
}


//重写清空一下 去除下拉功能 (避免父类下拉影响)
- (void)createRefreshView{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = self.tableView.frame;
    frame = CGRectMake(0, 0, kAppScreenWidth, kAppScreenHeight);
    self.tableView.frame = frame;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"分享";
    [self setUpTableHeaderVeiw];
    [self setUpUI];
    [self initData];
    [self initDataForMeTakePartIn];
    _isUseDragging = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noti:) name:@"tableViewScroll" object:nil];
}

-(void)setUpUI{
    
    CGFloat height = [WYUserDetailHeaderView calculateHeaderHeight:self.userInfo];

    self.tableView.contentInset = UIEdgeInsetsMake(height + 40,0,0,0);

}

-(void)setUpTableHeaderVeiw{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 25)];
    view.backgroundColor = UIColorFromHex(0xf5f5f5);
    
    NSString *leftStr;
    NSString *rightStr;
    if ([self.userInfo.uuid isEqualToString:kuserUUID]) {
        leftStr = @"我发布的";
        rightStr = @"我参与的";
    }else{
        leftStr = @"TA发布的";
        rightStr = @"TA参与的";
    }
    
    //我发布的
    //第一次默认选择浏览按钮 所以浏览按钮不可以按
    _starBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _starBtn.enabled = NO;
    [_starBtn setImage:[UIImage imageNamed:@"otherpage_browse"] forState:UIControlStateNormal];
    [_starBtn setImage:[UIImage imageNamed:@"otherpage_browse_pressed"] forState:UIControlStateDisabled];
    [_starBtn addTarget:self action:@selector(starBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_starBtn setTitle:leftStr forState:UIControlStateNormal];
    [_starBtn setTitleColor:UIColorFromHex(0xc5c5c5) forState:UIControlStateNormal];
    [_starBtn setTitleColor:UIColorFromHex(666666) forState:UIControlStateDisabled];
    _starBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_starBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 70)];
    [_starBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    //我参与的
    _allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_allBtn setImage:[UIImage imageNamed:@"otherpage_all_default"] forState:UIControlStateNormal];
    [_allBtn setImage:[UIImage imageNamed:@"otherpage_all_pressed"] forState:UIControlStateDisabled];
    [_allBtn addTarget:self action:@selector(allBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_allBtn setTitle:rightStr forState:UIControlStateNormal];
    [_allBtn setTitleColor:UIColorFromHex(0xc5c5c5) forState:UIControlStateNormal];
    [_allBtn setTitleColor:UIColorFromHex(666666) forState:UIControlStateDisabled];
    _allBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_allBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 70)];
    [_allBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    
    [view addSubview:_allBtn];
    [_allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.centerY.equalTo(0);
        make.width.equalTo(80);
    }];
    
    [view addSubview:_starBtn];
    [_starBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_allBtn.mas_left);
        make.centerY.equalTo(0);
        make.width.equalTo(80);
    }];

    
    self.tableView.tableHeaderView = view;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)noti:(NSNotification *)sender{
    CGFloat y = [[sender.userInfo objectForKey:@"contenty"] floatValue];
    //如果发通知的类不是自己发的 就改变contentOfset
    //不是自己发的
    self.tableView.delegate = nil;
    
    if (![sender.object isKindOfClass:self.class]) {
        //最多同步到顶部
        if (y >= -(40 +64)) {
            y = -104;
        }
        CGPoint point = self.tableView.contentOffset;
        point.y = y;
        self.tableView.contentOffset = point;
    }
    self.tableView.delegate = self;
}
//我发布的
-(void)starBtnClick{
    //点击后自己失能 另外一颗按钮可以按
    _starBtn.enabled = NO;
    _allBtn.enabled = YES;
    _isAll = NO;
    
    //切换数据源
    [self initData];
}
//我参与的
-(void)allBtnClick{
    //点击后自己失能 另外一颗按钮可以按
    _starBtn.enabled = YES;
    _allBtn.enabled = NO;
    _isAll = YES;
    
    //切换数据源
    
    /*
     先从数据中拿数据 如果有 就说明不用拿第一批数据 
     如果没有 就用 用户点击 请求完成自动刷新的方式 但是这个时候 就不一定没有了 因为这个时候它经历了一次网络请求 可能之前预加载没有加载出来的数据 现在出来了  所以只要是获取第一批次数据就要先remove掉所有数据  如果不是第一批次就不用做处理
     */
    
    if (self.meParticipatePostArr.count >0) {
        [self initDataForMeTakePartInFromArr];
    }else{
        [self tapInitDataForMeTakePartIn];
    }
    //将下拉刷新换动
    [self addFooterRefreshMeTakePartIn];
}


//先从数组中拿
-(void)initDataForMeTakePartInFromArr{
    
    [self.dataSource removeAllObjects];
    for (WYPost *post in self.meParticipatePostArr)
    {
        WYCellPostFrame *frame = [[WYCellPostFrame alloc] initWithPost:post];
        [self.dataSource addObject:frame];
    }
    [self.tableView reloadData];
    
}


//预加载的时候从网络获取第一批量数据 放在数组中不用就可以了
-(void)initDataForMeTakePartIn{
    
    __weak WYUserShareVC *weakSelf = self;
    
    //第一次
    [WYUserDetailApi listParticipateForMe:weakSelf.userInfo.uuid time:@(0) Block:^(NSArray *postArr, BOOL success) {
        if (success == YES) {
            if (postArr) {
                //只用请求到数据 保存到数组中就可以了
                [weakSelf.meParticipatePostArr removeAllObjects];
                [weakSelf.meParticipatePostArr addObjectsFromArray:postArr];
                
            }
        }else{
            [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
        }
        
    }];
}

//用户点击的时候从网络获取第-批量数据
-(void)tapInitDataForMeTakePartIn{
    
    __weak WYUserShareVC *weakSelf = self;
    
    //第一次 先给空白 发到里边是不适合的 可能给用户造成点击按钮没有反应的错觉
    [weakSelf.dataSource removeAllObjects];
    [weakSelf.tableView reloadData];

    [WYUserDetailApi listParticipateForMe:weakSelf.userInfo.uuid time:@(0) Block:^(NSArray *postArr, BOOL success) {
        if (success == YES) {
            if (postArr) {
                //这是用户点击的 可能之前数组中就有数据 先Remove
                [weakSelf.meParticipatePostArr removeAllObjects];
                [weakSelf.meParticipatePostArr addObjectsFromArray:postArr];
                for (WYPost *post in weakSelf.meParticipatePostArr)
                {
                    WYCellPostFrame *frame = [[WYCellPostFrame alloc] initWithPost:post];
                    [weakSelf.dataSource addObject:frame];
                }
                [weakSelf.tableView reloadData];
            }
        }else{
            [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
        }
        
    }];
}

//手动刷新获取数据
-(void)addFooterRefreshMeTakePartIn{
    //添加下拉刷新
    /*
     //源码 不会重复添加 赋值替换
     self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:handler];
     */
    __weak WYUserShareVC *weakSelf = self;
    
    //下拉刷新
    [self.tableView addFooterRefresh:^{
        WYPost *lastPost = weakSelf.meParticipatePostArr.lastObject;
        
        if (!lastPost.createdAtFloat) {
            [OMGToast showWithText:@"TA还没有发贴哦!"];

            [weakSelf.tableView endFooterRefresh];
            return ;
        }
        [WYUserDetailApi listParticipateForMe:weakSelf.userInfo.uuid time:lastPost.createdAtFloat Block:^(NSArray *postArr, BOOL success) {
            if (success == YES) {
                if (postArr.count > 0) {
                    [weakSelf.meParticipatePostArr addObjectsFromArray:postArr];
                    [weakSelf.dataSource removeAllObjects];
                    
                    for (WYPost *post in weakSelf.meParticipatePostArr)
                    {
                        WYCellPostFrame *frame = [[WYCellPostFrame alloc] initWithPost:post];
                        [weakSelf.dataSource addObject:frame];
                    }
                    [weakSelf.tableView reloadData];
                    
                }else{
                    [OMGToast showWithText:@"没有更多帖子了"];
                }
            }else{
                [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
            }
            [weakSelf.tableView endFooterRefresh];
            
        }];
    }];
    self.tableView.mj_footer.automaticallyHidden = YES;
}



@end
