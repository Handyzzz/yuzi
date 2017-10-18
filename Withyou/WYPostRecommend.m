//
//  testVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/5/4.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYPostRecommend.h"
#import "WYPostRecommendCell.h"
#import "YZPostListApi.h"
#import "WYWaterflowLayout.h"
#import "WYGroup.h"
#import "WYGroupDetailVC.h"
#import "YZPostDetailVC.h"
#import "WYUserVC.h"
#import "WYPost.h"

@interface WYPostRecommend ()<UICollectionViewDelegate,UICollectionViewDataSource,WYWaterflowLayoutDelegate,UISearchBarDelegate>
@property(nonatomic, strong)UISearchBar *searchBar;
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *postList;
@property(nonatomic, strong)NSMutableArray *groupList;
@property(nonatomic, strong)UIScrollView *headerView;
@property(nonatomic, strong)NSMutableArray *heightArr;

@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@end

@implementation WYPostRecommend


/*
 头部是网络请求有了推荐群组的结果之后才设置头部
 */


static NSString * cellIdentifer = @"CollectionCell";
static NSString * headerViewIdentifier = @"hederview";




-(NSMutableArray*)heightArr{
    if (_heightArr == nil) {
        _heightArr = [NSMutableArray array];
    }
    return _heightArr;
}

//要保证能给所有的数据更新 用户登录的时候用的这个方法
- (void)initData{
    
    
    //    只有在登录的情况下，这些才执行
    __weak WYPostRecommend *weakSelf = self;
    
    if([[WYUIDTool sharedWYUIDTool] isLoggedIn]){
        //先从缓存中获取数据
        [self loadRecommendPost];
        
        [self.collectionView addHeaderRefresh:^{
            [weakSelf requestRecommendPost];
        }];
        
        [self.collectionView addFooterRefresh:^{
            [weakSelf requestMoreRecommendPost];
        }];
    }
}


#pragma loadData

//从缓存中
-(void)loadRecommendPost{
    self.postList = [[WYPost queryRecommendPostsFromCache] mutableCopy];
    debugLog(@"%ld",self.postList.count);
    [self.collectionView reloadData];

}

//下拉网络请求
-(void)requestRecommendPost{
    __weak WYPostRecommend *weakSelf = self;
    [YZPostListApi recommendPostListHandler:^(NSArray *eventArr, NSArray *groupArr, NSArray *postArr) {
        
        [weakSelf.collectionView endHeaderRefresh];
        
        if (groupArr.count > 0 || postArr.count > 0) {
            weakSelf.postList = [postArr mutableCopy];
            weakSelf.groupList = [groupArr mutableCopy];
            [weakSelf.heightArr removeAllObjects];
            
            //下拉刷新成功开始 changeFrame
            [weakSelf changeFrame];
            
            [weakSelf.collectionView reloadData];
        }else{
            //加载失败
        }
    }];
}

//上拉网络请求
-(void)requestMoreRecommendPost{
    __weak WYPostRecommend *weakSelf = self;
    //得出最后20条帖子
    int sum = (int)weakSelf.postList.count;
    NSMutableArray *uuidList = [NSMutableArray array];
    for (int i = sum-1 ; ((i >= sum-20)&&(i >= 0)) ; i --) {
        [uuidList insertObject:((WYPost*)(weakSelf.postList[i])).uuid atIndex:0];
    }
    debugLog(@"%@",uuidList);
    
    [YZPostListApi moreRecommendPostList:[uuidList copy] Handler:^(NSArray *postArr) {
        [weakSelf.collectionView endFooterRefresh];
        if (postArr.count > 0) {
            [weakSelf.postList addObjectsFromArray:postArr];
            [weakSelf.collectionView reloadData];
        }else{
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
}

-(void)changeFrame{
    if (_groupList.count > 0) {
        //todo 暂时先不用做 等有了推荐群组在做
    }else{
        //
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setUpNavigationView];
    [self creatHeaderView];
    _headerView.hidden = YES;
    [self setNaviItem];
    [self setupUI];
    [self initData];
    
}

-(void)setUpNavigationView{
    _searchBar = [[UISearchBar alloc]init];
    _searchBar.placeholder = @"大家都在搜美景";
    _searchBar.backgroundImage = [[UIImage alloc] init];
    _searchBar.delegate = self;
    _searchBar.tintColor = [UIColor clearColor];
    _searchBar.backgroundColor = [UIColor clearColor];
    
    //去除搜索条 让它成为灰色
    //searchField.borderStyle = UITextBorderStyleNone;
    //searchField.background = [UIImage imageNamed:@"ic_top"];
    //searchField.layer.cornerRadius = 4.0;
    //searchField.leftViewMode=UITextFieldViewModeNever;
    //searchField.textColor=[UIColor whiteColor];
    
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    
    [searchField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    
    [searchField setValue:UIColorFromHex(0x999999) forKeyPath:@"_placeholderLabel.textColor"];

    searchField.backgroundColor = UIColorFromHex(0xf5f5f5);
    
    searchField.frame = CGRectMake(15, 0, kAppScreenWidth-30, 32);
    _searchBar.frame = CGRectMake(15, 0, kAppScreenWidth-30, 32);
    self.navigationItem.titleView = _searchBar;
    
}

-(void)setNaviItem{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

#pragma actions
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)creatHeaderView{
    if (_headerView == nil) {
        _headerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kStatusAndBarHeight, kAppScreenWidth, 104)];
        _headerView.showsHorizontalScrollIndicator = FALSE;
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    [self.collectionView addSubview:_headerView];
    [self setHeadViewDate];
}

-(void)setHeadViewDate{
    CGFloat viewWidth = 61;
    CGFloat iconWidth = 57;
    CGFloat TopMargin = 12;
    CGFloat Margin = 21;
    CGFloat contentWidth;
    UIView *lastView;
    
    contentWidth = _groupList.count *(21 + 61) +21;
    
    _headerView.contentSize = CGSizeMake(contentWidth, 104);
    if (_groupList.count > 0) {
        for (int i= 0; i< _groupList.count; i++) {
            WYGroup*group = _groupList[i];
            UIView*view = [UIView new];
            view.layer.cornerRadius = viewWidth/2.0;
            view.clipsToBounds = YES;
            view.layer.borderWidth = 2;
            view.layer.borderColor = UIColorFromHex(0x4990e2).CGColor;
            [_headerView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(TopMargin);
                make.height.width.equalTo(viewWidth);
                if (i == 0) {
                    make.left.equalTo(Margin);
                }else{
                    make.left.equalTo(lastView.mas_right).equalTo(Margin);
                }
            }];
            lastView = view;
            
            UIImageView *icon = [UIImageView new];
            icon.userInteractionEnabled = YES;
            icon.tag = 1000+i;
            UITapGestureRecognizer *contentGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(groupIconClick:)];
            [icon addGestureRecognizer:contentGesture];
            
            icon.userInteractionEnabled = YES;
            icon.layer.cornerRadius = iconWidth*0.5;
            icon.clipsToBounds = YES;
            icon.layer.borderWidth = 2;
            icon.layer.borderColor = [UIColor whiteColor].CGColor;
            [icon sd_setImageWithURL:[NSURL URLWithString:group.group_icon]];
            [view addSubview:icon];
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(2);
                make.left.equalTo(2);
                make.height.width.equalTo(iconWidth);
            }];
            
            UILabel *nameLb = [UILabel new];
            [_headerView addSubview:nameLb];
            nameLb.font = [UIFont systemFontOfSize:12];
            nameLb.textColor = UIColorFromHex(0x333333);
            nameLb.text = group.name;
            [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(icon.mas_bottom).equalTo(6);
                make.centerX.equalTo(icon.mas_centerX).equalTo(0);
            }];
        }
    }
}

-(void)groupIconClick:(UITapGestureRecognizer*)sender{
    
    WYGroupDetailVC *vc = [WYGroupDetailVC new];
    vc.group = _groupList[sender.view.tag - 1000];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupUI{
    //创建布局
    
    WYWaterflowLayout * layout = [[WYWaterflowLayout alloc]init];
    layout.columnMargin = 8;
    layout.rowMargin = 8;
    layout.sectionInset = UIEdgeInsetsMake(8, 0, 0, 0);
    layout.columnsCount = 2;
    layout.delegate = self;
    
    
    //创建CollectionView
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = UIColorFromHex(0xf5f5f5);
    
    [self.view addSubview:collectionView];
    
    [collectionView registerClass:[WYPostRecommendCell class] forCellWithReuseIdentifier:cellIdentifer];
    self.collectionView = collectionView;
}


#pragma mark - <UICollectionViewDataSource>
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.postList.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WYPostRecommendCell* cell = (WYPostRecommendCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
    WYPost *post = self.postList[indexPath.item];
    
    cell.contentView.backgroundColor = UIColorFromHex(0xfbfbfb);
        UIView * topBorder = [cell.contentView  viewWithTag:1001];
        if (topBorder == nil) {
            topBorder = [UIView new];
            topBorder.tag = 1001;
            topBorder.backgroundColor = UIColorFromHex(0xdfdfdf);
            [cell.contentView addSubview:topBorder];
        }
        topBorder.frame = CGRectMake(0.0f, 0.0f, cell.size.width, 0.5f);
    
        UIView * leftBorder = [cell.contentView  viewWithTag:1002];
        if (leftBorder == nil) {
            leftBorder = [UIView new];
            leftBorder.tag = 1002;
            leftBorder.backgroundColor = UIColorFromHex(0xdfdfdf);
            [cell.contentView addSubview:leftBorder];
        }
        leftBorder.frame = CGRectMake(0.0f, 0.0f, 0.5f, cell.size.height);
    
        UIView * bottomBorder = [cell.contentView  viewWithTag:1003];
        if (bottomBorder == nil) {
            bottomBorder = [UIView new];
            bottomBorder.tag = 1003;
            bottomBorder.backgroundColor = UIColorFromHex(0xdfdfdf);
            [cell.contentView addSubview:bottomBorder];
        }
        bottomBorder.frame = CGRectMake(0.0f, (cell.size.height - 0.5f), cell.size.width, 0.5f);
    
        UIView * rightBorder = [cell.contentView  viewWithTag:1004];
        if (rightBorder == nil) {
            rightBorder = [UIView new];
            rightBorder.tag = 1004;
            rightBorder.backgroundColor = UIColorFromHex(0xdfdfdf);
            [cell.contentView addSubview:rightBorder];
        }
        rightBorder.frame = CGRectMake((cell.size.width - 0.5f), 0.0, 0.5f, cell.size.height);
    [cell setCellData:self.postList[indexPath.row]];
    
    __weak WYPostRecommend *weakSelf = self;
    cell.iconClick = ^{
        [weakSelf iconClick:post];
    };
    cell.imageClick = ^{
        switch (post.type) {
            case videoType:
            {
                [self postDetailAction:indexPath];
            }
                break;
            case photoAlbumYype:
            {
                [self showAlbumFromPost:post];
            }
                break;

            case linkType:
            {
                [self showLinkContentFromPost:post];
            }
                break;

            case photoType:
            {
                [self showPhotoFromPost:post];
            }
                break;

                
            default:
                break;
        }
    };
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self postDetailAction:indexPath];
}

#pragma mark - <BWaterflowLayoutDelegate>
- (CGFloat)waterflowLayout:(WYWaterflowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath{
    
    if (self.heightArr.count >= indexPath.item+1) {
        
    }else{
        NSNumber *height = [NSNumber numberWithFloat:[WYPostRecommendCell calculateCellHeight:self.postList[indexPath.item]]];
        [self.heightArr addObject:height];
    }
    return [self.heightArr[indexPath.item] floatValue];
}

-(void)postDetailAction:(NSIndexPath *)indexPath{
    WYPost *post = self.postList[indexPath.item];
    YZPostDetailVC *vc = [YZPostDetailVC new];
    vc.postUuid = post.uuid;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}


- (void)iconClick:(WYPost *)post
{
    WYUserVC *vc = [WYUserVC new];
    vc.user = post.author;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showAlbumFromPost:(WYPost *)post
{
    WYPhotoAlbumVC *vc = [WYPhotoAlbumVC new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.delegate = self;
    vc.post = post;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showLinkContentFromPost:(WYPost *)post
{
    WYLinkDetailVC *vc = [WYLinkDetailVC new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.post = post;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)showPhotoFromPost:(WYPost *)post{
    [WYZoomImage showWithImage:nil imageURL:post.mainPic.url];
}

@end
