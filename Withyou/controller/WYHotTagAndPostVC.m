//
//  WYHotTagAndPostVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/31.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYHotTagAndPostVC.h"
#import "WYSearchPostTagVC.h"
#import "WYHotTagListHeaderView.h"
#import "WYPostTagApi.h"
#import "WYTagsResultPostListVC.h"
#import "WYHotTagListVC.h"
#import "YZPostListApi.h"
#import "WYWaterflowLayout.h"
#import "WYPostRecommendCell.h"
#import "YZPostDetailVC.h"
#import "WYUserVC.h"
#import "WYMyAttentionTagListVC.h"

@interface WYHotTagAndPostVC ()<UICollectionViewDelegate,UICollectionViewDataSource,WYWaterflowLayoutDelegate>
@property(nonatomic,strong)NSMutableArray*hotTagArr;
@property(nonatomic,strong)WYHotTagListHeaderView *headerView;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *postList;
@property(nonatomic, strong) NSMutableArray *heightArr;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)BOOL hasMore;
@end

@implementation WYHotTagAndPostVC
static NSString * cellIdentifer = @"CollectionCell";

-(NSMutableArray *)postList{
    if (_postList == nil) {
        _postList = [NSMutableArray array];
    }
    return _postList;
}

-(NSMutableArray*)heightArr{
    if (_heightArr == nil) {
        _heightArr = [NSMutableArray array];
    }
    return _heightArr;
}


-(NSMutableArray *)hotTagArr{
    if (_hotTagArr == nil) {
        _hotTagArr = [NSMutableArray array];
    }
    return _hotTagArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"热门标签";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNaviItem];
    [self setupCollectionView];
    [self initData];
    [self desiginNoti];
}

-(void)desiginNoti{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notiUpdatePost:) name:kNotificationUpdatePublishPostAction object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notiDeletePost:) name:kNotificationDeletePublishPostAction object:nil];
}

#pragma notiActions
-(void)notiUpdatePost:(NSNotification *)noti{
    
    WYPost *post = [noti.userInfo objectForKey:@"post"];
    //将新的group更新到对应的位置
    for (int i =0; i < self.postList.count; i++) {
        WYPost *myPost = self.postList[i];
        if ([myPost.uuid isEqualToString:post.uuid]) {
            [self.postList replaceObjectAtIndex:i withObject:post];
            break;
        }
    }
    [self.collectionView reloadData];
}

-(void)notiDeletePost:(NSNotification *)noti{
    WYPost *deletePost = [noti.userInfo objectForKey:@"post"];
    
    //将新的group更新到对应的位置
    for (int i =0; i < self.postList.count; i++) {
        WYPost *myPost = self.postList[i];
        if ([myPost.uuid isEqualToString:deletePost.uuid]) {
            [self.postList removeObjectAtIndex:i];
            break;
        }
    }
    [self.collectionView reloadData];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)initData{
    __weak WYHotTagAndPostVC *weakSelf = self;
    [WYPostTagApi hotPostTagBlock:^(NSArray *hotTagArr) {
        if (hotTagArr) {
            NSMutableArray *ma = [NSMutableArray array];
            for (int i = 0; i < hotTagArr.count; i++) {
                NSDictionary *dic = hotTagArr[i];
                [ma addObject:[dic objectForKey:@"name"]];
            }
            [weakSelf.hotTagArr addObjectsFromArray:ma];
            [weakSelf.headerView setUpHeaderViewDetail:hotTagArr];
        }
    }];

    //body
    _page = 1;
    [self firstInitData];
    
    [self.collectionView addFooterRefresh:^{
        [weakSelf initFootRefreshData];
    }];
}


-(void)firstInitData{
    __weak WYHotTagAndPostVC *weakSelf = self;
    [self.view showHUDNoHide];
    [YZPostListApi listMyfollowedTagsPostsWithPage:1 Block:^(NSArray *postArr, BOOL hasMore) {
        [weakSelf.view hideAllHUD];
        if (postArr) {
            weakSelf.page = 2;
            weakSelf.hasMore = hasMore;
            [weakSelf.postList removeAllObjects];
            [weakSelf.postList addObjectsFromArray:postArr];
            [weakSelf.heightArr removeAllObjects];
            [weakSelf.collectionView reloadData];
        }
    }];
}

-(void)initFootRefreshData{
    
    if (!self.hasMore){
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        return ;
    }
    __weak WYHotTagAndPostVC *weakSelf = self;
    [YZPostListApi listMyfollowedTagsPostsWithPage:_page Block:^(NSArray *postArr, BOOL hasMore) {
        if (postArr) {
            if (postArr.count > 0) {
                weakSelf.page += 1;
                weakSelf.hasMore = hasMore;
                [weakSelf.postList addObjectsFromArray:postArr];
                [weakSelf.collectionView reloadData];
                [weakSelf.collectionView endFooterRefresh];
            }else{
                [weakSelf.collectionView endRefreshWithNoMoreData];
            }
        }else{
            [weakSelf.collectionView endFooterRefresh];
        }
    }];
}


-(void)setNaviItem{
    
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"navi_search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(toSearchAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(UIView *)headerView{
    if (_headerView == nil) {
        _headerView = [[WYHotTagListHeaderView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 360)];
        
        __weak WYHotTagAndPostVC *weakSelf = self;
        _headerView.tagClicked = ^(NSInteger index) {
            WYTagsResultPostListVC *vc = [WYTagsResultPostListVC new];
            vc.tagStr = weakSelf.hotTagArr[index];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        _headerView.hotAllTagLbClick = ^{
            WYHotTagListVC *vc = [WYHotTagListVC new];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        
        _headerView.attionAllTagLbClick = ^{
            WYMyAttentionTagListVC *vc = [WYMyAttentionTagListVC new];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    return _headerView;
}

- (void)setupCollectionView{
    //创建布局
    
    WYWaterflowLayout * layout = [[WYWaterflowLayout alloc]init];
    layout.columnMargin = 8;
    layout.rowMargin = 8;
    layout.sectionInset = UIEdgeInsetsMake(8, 0, 0, 0);
    layout.columnsCount = 2;
    layout.delegate = self;
    layout.headerReferenceSize = CGSizeMake(kAppScreenWidth, 360);
    
    //创建CollectionView
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
    
    [collectionView registerClass:[WYPostRecommendCell class] forCellWithReuseIdentifier:cellIdentifer];
    //注册头视图
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];
    
    self.collectionView = collectionView;
}

//创建头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"forIndexPath:indexPath];
        [headView addSubview:self.headerView];
        return headView;
    }
    return nil;
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
    
    __weak WYHotTagAndPostVC *weakSelf = self;
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

#pragma actions
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

-(void)toSearchAction{
    WYSearchPostTagVC *vc = [WYSearchPostTagVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
