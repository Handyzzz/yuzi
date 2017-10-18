//
//  YZPostDetailVC.m
//  Withyou
//
//  Created by ping on 2017/6/7.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZPostDetailVC.h"
#import "YZCommentCell.h"
#import "YZPostComment.h"
#import "YZLoadingBtn.h"
#import "YZPostComment.h"
#import "WYPlaceholderView.h"

//  切换 公开评论 私密评论的view 高度
#define tabSectionH 45.f
#define tabBtnW 96.f
#define tabBtnMarginLeft 15.f
#define tabBtnMarginRight 25.f
// 底部toolbar 高度
#define toolH  49.f
#define moreBtnH 30.f


@interface YZPostDetailVC ()<UIScrollViewDelegate,UITableViewDelegate, UITableViewDataSource, YZCommentCellDelegate,WYCellPostDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *holderHeadView;

@property (nonatomic, strong) UITableView *leftTable;
@property (nonatomic, strong) UITableView *rightTable;
@property (nonatomic, assign) int index;

// section header
@property (nonatomic, strong) UIView *tabSection;
@property (nonatomic, weak) YZPostViewBase *postDetailView;
@property (nonatomic, strong) UIView *indexView;

@property (nonatomic, strong) UIView *toolBar;

// 发送评论按钮
@property (nonatomic, weak) UIButton *replyPublishBtn;
@property (nonatomic, weak) UIButton *replyPrivacyBtn;
@property (nonatomic, strong) UIView *toolIndexView;

// 公开评论 和 私密评论 数据源
@property (nonatomic, strong) NSMutableArray *privacyArr;
@property (nonatomic, strong) NSMutableArray *publishArr;

// 网络连接失败 时候显示 点击重新加载  只有在刚进页面的请求错误时展示
@property (nonatomic, strong) UIView *restartView;
@property (nonatomic, strong) YZLoadingBtn *restartBtn;

// 占位默认高度的view
@property (nonatomic, strong) UIView *emptyView;


// 加载历史评论按钮
@property (nonatomic, strong) YZLoadingBtn *loadMoreBtn;
// 标记是否能加载更多
@property (nonatomic, assign) BOOL publishHasMore;
@property (nonatomic, assign) BOOL privacyHasMore;



@end

@implementation YZPostDetailVC

#pragma mark lazy load

- (YZLoadingBtn *)loadMoreBtn {
    if(!_loadMoreBtn) {
        CGFloat moreBtnW = 200;
        YZLoadingBtn * loadMoreBtn = [[YZLoadingBtn alloc] initWithFrame:CGRectMake((self.view.frame.size.width - moreBtnW) / 2, 0, moreBtnW, moreBtnH)];
        [loadMoreBtn setTitle:@"加载更多评论" forState:UIControlStateNormal];
        [loadMoreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        loadMoreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [loadMoreBtn addTarget:self action:@selector(loadMoreData:) forControlEvents:UIControlEventTouchUpInside];
        
        _loadMoreBtn = loadMoreBtn;
    }
    return _loadMoreBtn;
}
- (UIScrollView *)mainScrollView {
    if(!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kHeightNavigationItemAndStatusBar, kAppScreenWidth, self.view.height - kHeightNavigationItemAndStatusBar - toolH)];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.delegate = self;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.bounces = NO;
    }
    return _mainScrollView;
}
- (UIView *)headView {
    if(!_headView) {
        _headView = [UIView new];
        WYCellPostFrame * model = [[WYCellPostFrame alloc] initWithPostWithNoHeightLimit:self.post];
        
        YZPostViewBase *view = [self getPostDetail:model];
        
        [_headView addSubview:view];
        self.tabSection.top = CGRectGetMaxY(view.frame);
        [_headView addSubview:self.tabSection];
        
        _headView.frame = CGRectMake(0, 0, view.width, CGRectGetMaxY(self.tabSection.frame));
        
        self.postDetailView = view;
        
    }
    return _headView;
}
- (UIView *)tabSection {
    if(!_tabSection) {
        _tabSection = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, tabSectionH)];
        _tabSection.backgroundColor = [UIColor whiteColor];
        NSString *publishS = nil;
        if(self.post.commentNum < 100){
            publishS = [NSString stringWithFormat:@"公开评论·%d",self.post.commentNum];
        }else {
            publishS = @"公开评论·99+";
        }
        UIButton * publishBtn = [self createButtonWith:publishS FontSize:15 image:nil];
        // 设置enabled 为no  默认选中 公开列表, 公开列表按钮就不可以再点击了
        publishBtn.enabled = NO;
        publishBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:0.4];
        
        publishBtn.frame = CGRectMake(tabBtnMarginLeft, 0, tabBtnW, tabSectionH);
        [publishBtn addTarget:self action:@selector(changeCommentType:) forControlEvents:UIControlEventTouchUpInside];
        
        self.publishBtn = publishBtn;
        
        self.indexView.left = publishBtn.left;
        [_tabSection addSubview:self.indexView];
        
        [_tabSection addSubview:publishBtn];
        
        if([self needHidePrivacy] == NO){
            NSString *privacyS = nil;
            if(self.post.private_comment_num < 100){
                privacyS = [NSString stringWithFormat:@"私密评论·%d",self.post.private_comment_num];
            }else {
                privacyS = @"私密评论·99+";
            }
            UIButton * privacyBtn = [self createButtonWith:privacyS FontSize:14 image:nil];
           
            privacyBtn.frame = CGRectMake(tabBtnW + tabBtnMarginRight, 0, tabBtnW, tabSectionH);
            
            
            [privacyBtn addTarget:self action:@selector(changeCommentType:) forControlEvents:UIControlEventTouchUpInside];
            self.privacyBtn = privacyBtn;
            [_tabSection addSubview:privacyBtn];
        }
        
    }
    return _tabSection;
}
- (UIView *)indexView {
    if(_indexView == nil){
        _indexView = [[UIView alloc] initWithFrame:CGRectMake(0, tabSectionH - 2, tabBtnW, 2)];
        _indexView.backgroundColor = kRGB(51, 51, 51);
    }
    return _indexView;
}

- (UIView *)toolIndexView {
    if(_toolIndexView == nil){
        if([self needHidePrivacy]) {
          _toolIndexView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, toolH)];
        }else {
            _toolIndexView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width / 2, toolH)];
        }
        _toolIndexView.backgroundColor = kRGB(43, 161, 212);
    }
    return _toolIndexView;
}

- (UIView *)restartView {
    if(!_restartView) {
        _restartView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.mainScrollView.height)];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"网络连接失败";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor lightGrayColor];
        [_restartView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
        
        YZLoadingBtn * restartBtn = [[YZLoadingBtn alloc] initWithFrame:CGRectZero];
        restartBtn.layer.borderWidth = 1;
        restartBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        restartBtn.layer.cornerRadius = 5;
        [restartBtn setTitle:@"点击重试" forState:UIControlStateNormal];
        [restartBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        restartBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [restartBtn addTarget:self action:@selector(restartAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.emptyView addSubview:restartBtn];
        [_restartView addSubview:restartBtn];
        
        [restartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.equalTo(label.mas_centerY).offset(40);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(30);
        }];
        _restartBtn = restartBtn;
    }
    return _restartView;
}


- (UIView *)emptyView {
    if(!_emptyView) {
        CGFloat normalH = self.view.height - kHeightNavigationItemAndStatusBar - toolH - tabSectionH;
        _emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, normalH)];
        _emptyView.backgroundColor = [UIColor whiteColor];
    }
    return _emptyView;
}


- (UIView *)emptyTextView {
    CGFloat normalH = self.view.height - kHeightNavigationItemAndStatusBar - toolH;
    WYPlaceholderView *view = [[WYPlaceholderView alloc] initWithImage:@"post_detail_placeholder_view" msg:@"快来抢占沙发吧" imgW:62 imgH:75];
    view.frame = CGRectMake(0, 0, self.view.width, normalH);
    
    return view;
}


- (NSMutableArray *)privacyArr {
    if(!_privacyArr){
        _privacyArr = [NSMutableArray array];
    }
    return _privacyArr;
}
- (NSMutableArray *)publishArr {
    if (!_publishArr) {
        _publishArr = [NSMutableArray array];
    }
    return _publishArr;
}

// 创建底部toolbar  回复评论 按钮入口
- (void)createToolBar {
    
    UIView * toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - toolH, self.view.frame.size.width, toolH)];
    toolBar.backgroundColor = kRGB(232, 240, 244);
    [toolBar addSubview:self.toolIndexView];
    
    UIButton *replyBtn = [self createButtonWith:@"公开评论" image:@"shareDetailpagePubliccomment" bgColor: [UIColor clearColor] titleColor:[UIColor whiteColor]];
    
    UIButton *privateReplyBtn = [self createButtonWith:@"私密评论" image:@"shareDetailpageSercetcommentCopy" bgColor: [UIColor clearColor] titleColor:UIColorFromHex(0x333333)];
    
    CGFloat btnWidth = self.view.frame.size.width / 2;
    replyBtn.frame = CGRectMake(0, 0, btnWidth, toolH);
    privateReplyBtn.frame = CGRectMake(btnWidth , 0, btnWidth, toolH);
    
    [replyBtn addTarget:self action:@selector(postPublishComment:) forControlEvents:UIControlEventTouchUpInside];
    [privateReplyBtn addTarget:self action:@selector(postPrivateComment:) forControlEvents:UIControlEventTouchUpInside];
    
    [toolBar addSubview: replyBtn];
    [toolBar addSubview: privateReplyBtn];
    self.replyPublishBtn = replyBtn;
    self.replyPrivacyBtn = privateReplyBtn;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 1)];
    line.backgroundColor = UIColorFromHex(0xdfdfdf);
    [toolBar addSubview:line];
    [self.view addSubview:toolBar];

    if([self needHidePrivacy]) {
        self.privacyBtn.hidden = YES;
        self.replyPrivacyBtn.hidden = YES;
        // 撑满 父view
        self.replyPublishBtn.frame = CGRectMake(0, 0, self.view.width, toolH);
    }
    self.toolBar = toolBar;
}

#pragma mark- ViewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"分享详情";
    [self setUpNaivi];
    [self.view addSubview:self.mainScrollView];
    self.index = 0;
    
    self.leftTable = [self createTaleView:0];
    [self initPost];
    [self designNoti];
    
}


-(void)designNoti{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notiUpdatePost:) name:kNotificationUpdatePublishPostAction object:nil];
}

-(void)notiUpdatePost:(NSNotification *)noti{
    
    //重新设置
    WYPost *post = [noti.userInfo objectForKey:@"post"];
    [self.postDetailView setDetailLayout:[[WYCellPostFrame alloc] initWithPostWithNoHeightLimit:post]];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)setUpNaivi{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUpHeader{
    self.holderHeadView = [[UIView alloc] initWithFrame:self.headView.bounds];
    self.holderHeadView.backgroundColor = [UIColor whiteColor];
    self.leftTable.tableHeaderView = self.headView;
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"feeds_detail__setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClick:)];
    
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)setupTitleViewAlpha:(CGFloat)alpha {
    if(self.navigationItem.titleView == nil) {
        YZUserHeadView *icon = [[YZUserHeadView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [icon loadImage:self.post.author.icon_url];
        self.navigationItem.titleView = icon;
    }
    self.navigationItem.titleView.alpha = alpha;
}

- (UITableView *)createTaleView:(int)tag {
    CGFloat width = self.mainScrollView.frame.size.width;
    CGFloat height = self.mainScrollView.frame.size.height;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(width * tag, 0, width, height) style:UITableViewStylePlain];
    tableView.tag = tag;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.tableHeaderView = self.holderHeadView;
    tableView.tableFooterView = self.emptyView;
    [tableView registerClass:[YZCommentCell class] forCellReuseIdentifier:@"YZCommentCell"];
    [self.mainScrollView addSubview:tableView];
    

    // 创建上拉加载 为更新评论
    __weak typeof(self) this = self;
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [this refreshData:tag];
    }];
    [footer setTitle:@"刷新评论" forState:MJRefreshStateIdle];
    [footer setTitle:@"立即刷新" forState:MJRefreshStatePulling];
    [footer setTitle:@"刷新中" forState:MJRefreshStateRefreshing];
    tableView.mj_footer = footer;
    
    return tableView;
}

- (void)refreshData:(int)index {
    if(index == 0) {
        [YZPostComment publishCommentsTopFor:self.post.uuid t:@0 Block:^(NSArray *arr, BOOL hasMore) {
            [self.leftTable.mj_footer endRefreshing];
            if(arr.count > 0) {
                
                NSMutableArray *temp = [NSMutableArray array];
                
                // 记录是否需要清空当前数据
                BOOL needClearOldData = YES;
                
                // 遍历请求过来的数据 进行过滤操作
                for (YZPostComment *comment in arr) {
                    // 如果当前没有数据 则直接把最新的 添加到temp 当中
                    if(self.publishArr.count == 0) {
                        [temp insertObject:[[YZCommentFrame alloc] initWithComment:comment] atIndex:0];
                    }else {
                        // 如果有数据 取出当前最新的评论 为数据源的最后一条
                        YZCommentFrame *last = self.publishArr[self.publishArr.count - 1];
                        
                        // 判断已有最新评论的时间是否比请求的小, 如果比当前最新的评论大 那么就是更新的数据 且不能是相等的uuid
                        // 这里有可能一下更新 非常多的数据, 导致服务器还有更多新评论没有请求下来, 所以如果 都是最新的评论 那么 needClearOldData 就 等于 YES 就情况旧数据 用户点击再加载历史的
                        if([last.comment.created_at_float doubleValue] < [comment.created_at_float doubleValue] && [last.comment.uuid isEqualToString:comment.uuid] == NO){
                            [temp insertObject:[[YZCommentFrame alloc] initWithComment:comment] atIndex:0];
                        }else {
                            needClearOldData = NO;
                        }
                    }
                }
                if(needClearOldData) {
                    [self.publishArr removeAllObjects];
                }
                [self.publishArr addObjectsFromArray:temp];
                [self scrollsToBottom:index];
            }
        }];
    }else { // 逻辑同上 只是数据源不同
        [YZPostComment privateCommentsTopFor:self.post.uuid t:@0 Block:^(NSArray *arr, BOOL hasMore) {
            [self.rightTable.mj_footer endRefreshing];
            if(arr.count > 0) {
                // 记录是否需要清空当前数据
                BOOL needClearOldData = YES;
                
                NSMutableArray *tmp = [NSMutableArray array];
                for (YZPostComment *comment in arr) {
                    if(self.privacyArr.count == 0) {
                        [tmp insertObject:[[YZCommentFrame alloc] initWithComment:comment] atIndex:0];
                    }else {
                        YZCommentFrame *last = self.privacyArr[self.privacyArr.count - 1];
                        if([last.comment.created_at_float doubleValue] < [comment.created_at_float doubleValue] && [last.comment.uuid isEqualToString:comment.uuid] == NO){
                            [tmp insertObject:[[YZCommentFrame alloc] initWithComment:comment] atIndex:0];
                        }else {
                            needClearOldData = NO;
                        }
                    }
                }
                if(needClearOldData) {
                    [self.privacyArr removeAllObjects];
                }
                [self.privacyArr addObjectsFromArray:tmp];
                [self scrollsToBottom:index];
            }
        }];
    }
}

- (BOOL)needHidePrivacy {
    NSInteger targetType = [self.post.targetType integerValue];
    if(targetType == 4 || targetType == 5) {
        return YES;
    }else {
        return NO;
    }
}

//postUuid
-(void)initPost{
    
    if (self.post) {
        [self initData];
        [self setUpHeader];
        CGFloat width = self.mainScrollView.frame.size.width;
        if([self needHidePrivacy]) {
            self.mainScrollView.contentSize = CGSizeMake(width, 0);
        }else {
            self.rightTable = [self createTaleView:1];
            self.mainScrollView.contentSize = CGSizeMake(width * 2, 0);
        }
        [self createToolBar];
    }else{
        
        __block  YZPostDetailVC * weakSelf = self;
        
        [self.view showHUDNoHide];
        [WYPostApi retrievePost:self.postUuid Block:^(WYPost *post,NSInteger status) {
            [weakSelf.view hideAllHUD];

            if (post) {
                weakSelf.post = post;
                [weakSelf initData];
                [weakSelf setUpHeader];
                CGFloat width = self.mainScrollView.frame.size.width;
                if([weakSelf needHidePrivacy]) {
                    weakSelf.mainScrollView.contentSize = CGSizeMake(width, 0);
                }else {
                    weakSelf.rightTable = [self createTaleView:1];
                    weakSelf.mainScrollView.contentSize = CGSizeMake(width * 2, 0);
                }
                [self createToolBar];
            }else if(status == 404){
                [OMGToast showWithText:@"该帖已被删除！"];
            }else if(status >= 500){
                [weakSelf.view showMsgDelayHide:@"网络不给力，请检查网络设置！"];
            }
        }];
    }
}

// 获取初始化
- (void)initData {
    // 初始化数据时 先清空数据
    [self.publishArr removeAllObjects];
    [self.privacyArr removeAllObjects];
    
    [YZPostComment publishCommentsTopFor:self.post.uuid t:@0 Block:^(NSArray *arr, BOOL hasMore) {
        // 断网情况
        BOOL requestFailed = NO;
        if(arr == nil ) {
            requestFailed = YES;
        }
        
        if(arr.count > 0) {
            // 服务器的数据是由时间从 大到小排列的 这里颠倒一下顺序 arr最后面放时间最大的, 即cell中的最后一条显示最新的数据
            for (YZPostComment *comment in arr) {
                // 需要将 commen对象交给 frame类来计算cell高度 和frame
                [self.publishArr insertObject:[[YZCommentFrame alloc] initWithComment:comment] atIndex:0];
            }
        }
        // 记录公开评论是否还有历史数据
        self.publishHasMore = hasMore;
        [self tableView:0 showRestartView:requestFailed];
    }];
    if([self needHidePrivacy] == NO) {
        [YZPostComment privateCommentsTopFor:self.post.uuid t:@0 Block:^(NSArray *arr, BOOL hasMore) {
            BOOL requestFailed = NO;
            // 默认没显示这个页面, 如果网络断开 就记录这个值, 在切换到这个私密评论的时候 显示请求失败
            if(arr == nil) {
                requestFailed = YES;
            }
            if(arr.count > 0) {
                for (YZPostComment *comment in arr) {
                    [self.privacyArr insertObject:[[YZCommentFrame alloc] initWithComment:comment] atIndex:0];
                }
            }
            self.privacyHasMore = hasMore;
            [self tableView:1 showRestartView:requestFailed];
        }];
    }
}

- (void)restartAction:(YZLoadingBtn *)btn {
    [self.restartBtn startLoading];
    [self initData];
}


- (void)tableView:(int)index showRestartView:(BOOL)show {
    // 断网情况
    UITableView *tableView = [self getTableView:index];
    if(show) {
        tableView.tableFooterView = self.restartView;
        [self.restartBtn stopLoading];
        [tableView reloadData];
    }else {
        tableView.tableFooterView = self.emptyView;
        // 刷新表格后 滚动到底部
        [self reload:index];
    }
    
}

- (UITableView *)getTableView:(int)index {
    return index == 0 ? self.leftTable : self.rightTable;
}

- (void)reload:(int)index {
    
    // 设置emptyView的默认高度
    NSArray *frames = nil;
    UITableView *tablView = [self getTableView:index];
    if(index == 0) {
        frames = self.publishArr;
    }else {
        frames = self.privacyArr;
    }
    // 评论section 高度
    CGFloat sectionH = 0;
    
    // 默认需要显示整个屏幕的高度
    CGFloat normalH = self.view.height - kHeightNavigationItemAndStatusBar - toolH;
    if((index == 0 && self.publishHasMore) || (index == 1 && self.privacyHasMore)) {
        normalH = normalH - moreBtnH;
    }
    // count > 0 那么隐藏没有评论的显示
    UIView *footer = nil;
    if(frames.count > 0) {
        // 遍历 frames 获取总高度
        for (YZCommentFrame *frame in frames) {
            sectionH = sectionH + frame.cellHeight;
            // 如果已经大于默认高度 那么就不用再继续遍历了
            if(sectionH > normalH) {
                tablView.tableFooterView = nil;
                [tablView reloadData];
                return;
            }
        }
        // 如果小于默认高度  就让emptyView填充回来
        if(sectionH < normalH) {
            footer = self.emptyView;
            self.emptyView.height = normalH - sectionH ;
        }
    }else {
        footer = self.emptyTextView;
    }
    
    tablView.tableFooterView = footer;
    [tablView reloadData];
}


// 当切换评论的时候 invoke
- (void)changeCommentType:(UIButton *)btn {
    // 各自取反 完成切换
    self.publishBtn.enabled = !self.publishBtn.enabled;
    self.privacyBtn.enabled = !self.privacyBtn.enabled;
    int index = self.publishBtn == btn ? 0 : 1;
    
    [self startToScrollMainView];
    [self.mainScrollView setContentOffset:CGPointMake(self.mainScrollView.width * index, 0) animated:YES];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(tableView.tag == 0) {
        if(section == 0) {
            return self.publishHasMore ? 1 : 0;
        }
        return self.publishArr.count;
    }else if(tableView.tag == 1) {
        if(section == 0) {
            return self.privacyHasMore ? 1 : 0;
        }
        return self.privacyArr.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0) {
        return  indexPath.row == 0 ? moreBtnH : 0;
    }
    WYCellPostFrame *frame = nil;
    if(tableView.tag == 0) {
        frame = self.publishArr[indexPath.row];
    }else if(tableView.tag == 1) {
        frame = self.privacyArr[indexPath.row];
    }
    return frame.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.loadMoreBtn];
        }
        return cell;
    }
    YZCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YZCommentCell" forIndexPath:indexPath];
    YZCommentFrame *frame = nil;
    if(tableView.tag == 0) {
        // index.row - 1 去掉多添加的一条cell
        frame = self.publishArr[indexPath.row];
    }else {
        frame = self.privacyArr[indexPath.row];
    }
    cell.delegate = self;
    cell.comment = frame;
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == self.mainScrollView) {
        [self startToScrollMainView];
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.mainScrollView != scrollView) {
        return;
    }
    CGPoint offset = scrollView.contentOffset;
    int index = offset.x / scrollView.frame.size.width;
    [self endScrollMainView:index];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(self.mainScrollView == scrollView && decelerate == NO) {
        CGPoint offset = scrollView.contentOffset;
        int index = offset.x / scrollView.frame.size.width;
        [self endScrollMainView:index];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.mainScrollView != scrollView) {
        return;
    }
    CGPoint offset = scrollView.contentOffset;
    int index = offset.x / scrollView.frame.size.width;
    [self endScrollMainView:index];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView == self.mainScrollView) {
        CGFloat percentX = scrollView.contentOffset.x / scrollView.contentSize.width;
        
        self.indexView.left = tabBtnMarginLeft + (tabBtnW * 2 + tabBtnMarginRight) * percentX;
        self.toolIndexView.left = self.view.width * percentX;
        [self.replyPrivacyBtn setTitleColor:[UIColor colorWithWhite:percentX * 2 + 0.13 alpha:1] forState:UIControlStateNormal];
        [self.replyPrivacyBtn setTintColor:[UIColor colorWithWhite:percentX * 2 + 0.13 alpha:1]];
        
        [self.replyPublishBtn setTitleColor:[UIColor colorWithWhite:1.13 - (percentX * 2) alpha:1] forState:UIControlStateNormal];
        [self.replyPublishBtn setTintColor:[UIColor colorWithWhite:1.13 - (percentX * 2) alpha:1]];
    }else {
        CGPoint offset = scrollView.contentOffset;
        if(offset.y < CGRectGetMaxY(self.postDetailView.header.frame)) {
            [self setupTitleViewAlpha:0];
        }else {
            [self setupTitleViewAlpha:1];
        }
    }
    
}

- (void)startToScrollMainView {
    UITableView *tableView = [self getTableView:self.index];
    CGFloat height = self.headView.frame.size.height;
    // 在headerview 超出屏幕的情况
    if(tableView.contentOffset.y >= height) {
        UITableView *otherTable = tableView == self.leftTable ? self.rightTable : self.leftTable;
        if(otherTable.contentOffset.y < height) {
            otherTable.contentOffset = CGPointMake(0, height);
        }
    }else {
        tableView.tableHeaderView = self.holderHeadView;
        [self.headView removeFromSuperview];
        CGRect rect = self.headView.frame;
        rect.origin.y = - tableView.contentOffset.y + kHeightNavigationItemAndStatusBar;
        self.headView.frame = rect;
        [self.view addSubview:self.headView];
        [self.view bringSubviewToFront:self.toolBar];
        
        UITableView *otherTable = tableView == self.leftTable ? self.rightTable : self.leftTable;
        otherTable.contentOffset = tableView.contentOffset;
    }
}
- (void)endScrollMainView:(int)index {
    [self.headView removeFromSuperview];
    CGRect rect = self.headView.frame;
    rect.origin.y = 0;
    self.headView.frame = rect;
    self.leftTable.tableHeaderView = self.holderHeadView;
    self.rightTable.tableHeaderView = self.holderHeadView;
    if(index == 0) {
        self.leftTable.tableHeaderView = self.headView;
        self.publishBtn.enabled = NO;
        self.publishBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:0.4];
        
        self.privacyBtn.enabled = YES;
        self.privacyBtn.titleLabel.font = [UIFont systemFontOfSize:14];

    }else {
        self.rightTable.tableHeaderView = self.headView;
        self.publishBtn.enabled = YES;
        self.publishBtn.titleLabel.font = [UIFont systemFontOfSize:14];

        self.privacyBtn.enabled = NO;
        self.privacyBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:0.4];

    }
    self.index = index;
}

#pragma mark - Actions
- (void)rightBarButtonClick:(UIBarButtonItem *)btn {
    [self moreActions:self.post];
}


// 加载历史评论 不是上拉刷新
- (void)loadMoreData:(YZLoadingBtn *)btn {
    [btn startLoading];
    
    if(self.index == 0) {
        [self requestPublishList];
    }else {
        [self requestPrivateList];
    }
}

// 加载历史评论
- (void)requestPublishList {
    if(self.publishArr.count == 0) {
        [self.loadMoreBtn stopLoading];
        return;
    };
    // 去除数据源的第一个就是 时间最小的, 然后去请求后面的数据
    YZCommentFrame *frame = self.publishArr[0];
    [YZPostComment publishCommentsTopFor:self.post.uuid t:frame.comment.created_at_float Block:^(NSArray *arr, BOOL hasMore) {
        // 关掉加载更多数据btn的动画
        [self.loadMoreBtn stopLoading];
        if(arr.count > 0) {
            // 同上 服务器是由大到小排列的 这里颠倒一下顺序
            for (YZPostComment *comment in arr) {
                [self.publishArr insertObject:[[YZCommentFrame alloc] initWithComment:comment] atIndex:0];
            }
        }
        self.publishHasMore = hasMore;
        [self reload:0];
    }];
}

- (void)requestPrivateList {
    if(self.privacyArr.count == 0) {
        [self.loadMoreBtn stopLoading];
        return;
    };
    YZCommentFrame *frame = self.privacyArr[0];
    [YZPostComment privateCommentsTopFor:self.post.uuid t:frame.comment.created_at_float Block:^(NSArray *arr, BOOL hasMore) {
        [self.loadMoreBtn stopLoading];
        if(arr.count > 0) {
            for (YZPostComment *comment in arr) {
                [self.privacyArr insertObject:[[YZCommentFrame alloc] initWithComment:comment] atIndex:0];
            }
        }
        self.privacyHasMore = hasMore;
        [self reload:1];
    }];
}

// 需要在reload 之后执行 否则tebleview 崩溃
- (void)scrollsToBottom:(int)index
{
    UITableView *tableView = [self getTableView:index];
    
    // 若果有count 大于 0 才需要滚到底部
    if( (tableView == self.leftTable && self.publishArr.count > 0)
       ||
       (tableView == self.rightTable && self.privacyArr.count > 0)
       ) {
        
        NSInteger row = [tableView numberOfRowsInSection: 1] - 1;
        if(row < 0) return;
        NSIndexPath *index = [NSIndexPath indexPathForRow:row inSection:1];
        [tableView reloadData];
        [tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
    }
}


//私密评论
- (void)postPrivateComment:(UIButton *)btn {
    [self postCommentForReply:nil replyAuthor:nil private:YES VCTitle:@"添加私密评论"];
}
//公开评论
- (void)postPublishComment:(UIButton *)btn {
    [self postCommentForReply:nil replyAuthor:nil private:NO VCTitle:nil];
}

//回复
- (void)replyComment:(YZPostComment *)comment {
    // tony added, 以后可以允许自己回复自己
    [self postCommentForReply:comment.uuid replyAuthor:comment.author.uuid private:comment.private_type VCTitle:[NSString stringWithFormat:@"回复%@",comment.author.fullName]];
}

- (void)postCommentForReply:(NSString *)uuid replyAuthor:(NSString *)author_uuid  private:(BOOL)private VCTitle:(NSString *)title {
    
    WYBaseMentionTextVC *vc = [WYBaseMentionTextVC new];
    vc.post = self.post;
    __weak typeof(self) this = self;
    vc.myBlock = ^(NSAttributedString *text, NSArray *mention) {
        
        [YZPostComment addPostCommentFor:uuid replyAuthor:author_uuid content:text.string mention:mention targetUUID:this.post.uuid private:private Block:^(YZPostComment *comment) {
            if(!comment){
                [WYUtility showAlertWithTitle:@"评论未成功，请稍后再试"];
                return;
            }
            if(private) {
                [this.privacyArr addObject:[[YZCommentFrame alloc] initWithComment:comment]];
                [this reload:1];
            }else {
                [this.publishArr addObject:[[YZCommentFrame alloc] initWithComment:comment]];
                [this reload:0];
            }
            // 切换到 发送的评论类型的页面去
            if(self.publishBtn.enabled != private) {
                [this changeCommentType:private ? self.privacyBtn : self.publishBtn];
            }else {
                [this reload:0];
                [this scrollsToBottom:0];
            }
            //发送新的评论 发送通知
            if(private) {
                this.post.private_comment_num +=1 ;
            }else {
                this.post.commentNum +=1 ;
            }
            
            if (comment.private_type != YES) {
                //公开
                NSInteger begin = this.publishArr.count >= 3 ? (this.publishArr.count-3) : 0;
                NSMutableArray *tempArr = [NSMutableArray array];
                for (NSInteger i = begin; i < this.publishArr.count; i ++) {
                    YZCommentFrame *frame = this.publishArr[i];
                    [tempArr addObject:frame.comment];
                }
                self.post.comments = [tempArr copy];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdatePublishPostAction object:self userInfo:@{@"post":self.post}];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdatePublishPostAction object:self userInfo:@{@"post":this.post}];
        }];
    };
   
    if(title != nil) {
        vc.navigationTitle = title;
    }else {
        vc.navigationTitle = @"添加评论";
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark private method

- (UIButton *)createButtonWith:(NSString *)title image:(NSString *)image bgColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor{
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.backgroundColor = bgColor;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    if(image){
        [btn setTintColor:titleColor];
        [btn setImage:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 6)];
    }
    
    return btn;
}
//继承上面的方法，提供一个改变button的字体大小的方法
//tony 0306
- (UIButton *)createButtonWith:(NSString *)title FontSize:(int)sizeNum image:(NSString *)image {
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:sizeNum];
    [btn setTitleColor:kRGB(153, 153, 153) forState:UIControlStateNormal];
    [btn setTitleColor:kRGB(51, 51, 51) forState:UIControlStateDisabled];
    
    if(image){
        [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 0)];
    }
    
    return btn;
}



#pragma mark - YZCommentCellDelegate
-(void)showAlertAction:(YZPostComment *)comment{
    
    //如果是自己的帖子 或者是自己的评论 可以删除 之外的显示举报
    if ([self.post.author.uuid isEqualToString:kuserUUID]||[comment.author.uuid isEqualToString:kuserUUID]) {
    
        //删除
        __weak YZPostDetailVC *weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定要删除该条评论吗?" preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (comment.private_type == YES) {
                [weakSelf deleteYZCommentFrameFromArr:weakSelf.privacyArr comment:comment];
            }else{
                [weakSelf deleteYZCommentFrameFromArr:weakSelf.publishArr comment:comment];
            }
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        //举报
        __weak YZPostDetailVC *weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定要举报该条评论吗?" preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"举报该评论" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf reportPostComement:comment];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//给评论加星标
-(void)starCommentAction:(YZPostComment *)comment starBtn:(UIButton *)btn starCountLb:(UILabel *)starCountLb{
    
    UITableView *tableView;
    NSMutableArray *mutArr;
    if (comment.private_type == YES) {
        //私密
        tableView = self.rightTable;
        mutArr = self.privacyArr;
    }else{
        //公开
        tableView = self.leftTable;
        mutArr = self.publishArr;
    }
    debugLog(@"%d",comment.starred);
    if (comment.starred == YES) {
        //去星标
        btn.selected = NO;
        starCountLb.textColor = UIColorFromHex(0x999999);
        
        if (comment.star_num -1 > 0) {
            starCountLb.text = [NSString stringWithFormat:@"%d",comment.star_num - 1];
        }else{
            starCountLb.text = @"";
        }

        [WYPostApi cancelStarToCommentUUid:comment.uuid Block:^(NSInteger status) {

            if (status == 204) {
                //去星标成功
                for (int i = 0; i < mutArr.count; i ++) {
                    YZCommentFrame *frame = mutArr[i];
                    if ([frame.comment.uuid isEqualToString:comment.uuid]) {
                        comment.star_num -=1;
                        comment.starred = NO;
                        [mutArr replaceObjectAtIndex:i withObject:[[YZCommentFrame alloc]initWithComment:comment]];
                        [tableView reloadData];
                        break;
                    }
                }
            }else if (status == 290){
                btn.selected = YES;
                starCountLb.text = [NSString stringWithFormat:@"%d",comment.star_num];
                starCountLb.textColor = UIColorFromHex(0x00B2E1);

            }else{
                btn.selected = YES;
                starCountLb.text = [NSString stringWithFormat:@"%d",comment.star_num];
                starCountLb.textColor = UIColorFromHex(0x00B2E1);

            }
        }];
        
    }else{
        //加星标
        btn.selected = YES;
        starCountLb.text = [NSString stringWithFormat:@"%d",comment.star_num + 1];
        starCountLb.textColor = UIColorFromHex(0x00B2E1);

        [WYPostApi addStarToCommentUUid:comment.uuid author_uuid:kuserUUID Block:^(NSInteger status) {

            if (status == 201) {
                //加星标成功
                for (int i = 0; i < mutArr.count; i ++) {
                    YZCommentFrame *frame = mutArr[i];
                    if ([frame.comment.uuid isEqualToString:comment.uuid]) {
                        comment.starred = YES;
                        comment.star_num +=1;
                        [mutArr replaceObjectAtIndex:i withObject:[[YZCommentFrame alloc]initWithComment:comment]];
                        [tableView reloadData];
                        break;
                    }
                }
            }else{
                //提示 其他问题
                btn.selected = NO;
                starCountLb.text = [NSString stringWithFormat:@"%d",comment.star_num];
                starCountLb.textColor = UIColorFromHex(0x999999);

            }
        }];
    }

    
}

-(void)deleteYZCommentFrameFromArr:(NSMutableArray *)mutArr comment:(YZPostComment *)comment{
    
    UITableView *tableView;
    if (comment.private_type == YES) {
        //私密
        tableView = self.rightTable;
    }else{
        //公开
        tableView = self.leftTable;
    }
    
    [YZPostComment deletePostComment:comment.uuid Block:^(long status) {
        if (status == 204) {
            for (int i = 0; i < mutArr.count; i ++) {
                YZCommentFrame *frame = mutArr[i];
                if ([frame.comment.uuid isEqualToString:comment.uuid]) {
                    
                    [mutArr removeObjectAtIndex:i];
                    [tableView reloadData];
                    if (comment.private_type != YES) {
                        //公开
                        NSInteger begin = mutArr.count >= 3 ? (mutArr.count-3) : 0;
                        NSMutableArray *tempArr = [NSMutableArray array];
                        for (NSInteger i = begin; i < mutArr.count; i ++) {
                            YZCommentFrame *frame = mutArr[i];
                            [tempArr addObject:frame.comment];
                        }
                        self.post.comments = [tempArr copy];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdatePublishPostAction object:self userInfo:@{@"post":self.post}];
                    }
                    break;
                }
            }
        }else{
            [WYUtility showAlertWithTitle:@"未成功删除"];
        }
    }];
}

-(void)reportPostComement:(YZPostComment*)comment{
    
    NSArray *titleArr = @[@"泄露隐私", @"人身攻击", @"色情文字", @"违反法律", @"垃圾信息", @"其他",@"取消"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"举报分类" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 0; i < titleArr.count; i ++) {
        if (i < titleArr.count -1) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:titleArr[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [YZPostComment reportPostComment:comment.uuid type:@(i + 1)];
            }];
            [alert addAction:action];
        }else{
            //取消
            UIAlertAction *action = [UIAlertAction actionWithTitle:titleArr[i] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:action];
        }
    }
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)onIconClick:(YZPostComment *)comment {
    [self iconClick:comment.author];
}

#pragma post actions
//星标
- (void)star:(WYPost *)post
{
    __weak YZPostDetailVC *weakSelf = self;
    if(post.starred == 0) {
        [WYUtility requireSetAccountNameOrAlreadyHasName:^{
            [WYPostApi addStarToPost:post.uuid WithBlock:^(NSDictionary *response) {
                if(response) {
                    WYPost *newPost = [WYPost yy_modelWithDictionary:response];
                    [weakSelf.postDetailView setupStarView:[[WYCellPostFrame alloc] initWithPostWithNoHeightLimit:newPost]];
                    weakSelf.post.starred = newPost.starred;
                    [weakSelf getTableView:self.index].tableHeaderView = self.headView;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdatePublishPostAction object:self userInfo:@{@"post":newPost}];
                }
            }];
        } navigationController:self.navigationController];
    }
    else{
        [WYPostApi newRemoveStarToPost:post.uuid WithBlock:^(WYPost *newPost) {
            weakSelf.post.starred = newPost.starred;
            [weakSelf.postDetailView setupStarView:[[WYCellPostFrame alloc] initWithPostWithNoHeightLimit:newPost]];
            [weakSelf getTableView:weakSelf.index].tableHeaderView = weakSelf.headView;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdatePublishPostAction object:self userInfo:@{@"post":newPost}];
        }];
    }
}

-(void)subscribeBtnClick{
    
    __weak YZPostDetailVC *weakSelf = self;
    if (self.post.subscribed == YES) {
        [WYPostApi cancelSubscribeForPost:self.post.uuid Block:^(NSInteger status) {
            if ((status >= 200) && (status < 300)) {
                weakSelf.post.subscribed = NO;
                 [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdatePublishPostAction object:self userInfo:@{@"post":weakSelf.post}];
                [OMGToast showWithText:@"取消订阅"];
            }
        }];
    }else{
        [WYPostApi addSubscribeForPost:self.post.uuid Block:^(WYPost *post) {
            if (post) {
                weakSelf.post = post;
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdatePublishPostAction object:self userInfo:@{@"post":weakSelf.post}];
                [OMGToast showWithText:@"订阅成功"];
            }
        }];
    }
}

- (void)detail:(WYPost *)post {
    // overload  do nothing
}


@end
