//
//  WYTagsResultPostListVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/19.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYTagsResultPostListVC.h"
#import "WYPostRecommendCell.h"
#import "YZPostListApi.h"
#import "WYWaterflowLayout.h"
#import "WYPost.h"
#import "YZPostDetailVC.h"
#import "WYPublishVC.h"
#import "WYTagsResultPostListHeaderView.h"
#import "WYPostTagApi.h"
#import "WYWebViewVC.h"


@interface WYTagsResultPostListVC ()<UICollectionViewDelegate,UICollectionViewDataSource,WYWaterflowLayoutDelegate>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *postList;
@property(nonatomic, strong) NSMutableArray *heightArr;
@property(nonatomic, strong) ZFPlayerView        *playerView;
@property(nonatomic, strong) ZFPlayerControlView *controlView;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, assign) BOOL hasMore;
@property(nonatomic, assign) NSInteger count;
@property(nonatomic, strong) UIImageView *addPostIV;
@property(nonatomic, assign) BOOL isFollowing;
@property(nonatomic, copy)   NSArray *userArr;
@property(nonatomic, strong) WYTagsResultPostListHeaderView *headerView;
@property(nonatomic, strong) UILabel *sumLb;
@end

@implementation WYTagsResultPostListVC
static NSString * cellIdentifer = @"CollectionCell";

-(NSMutableArray*)postList{
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.tagStr;
    [self setUpNaviItem];
    [self setupCollectionView];
    [self setUpAddPostIV];
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
    //header
    __weak WYTagsResultPostListVC *weakSelf = self;
    [WYPostTagApi listFollowerListOfTag:self.tagStr Block:^(NSArray *userArr, BOOL isFollowing) {
        if (userArr) {
            weakSelf.userArr = userArr;
        }
        weakSelf.isFollowing = isFollowing;
        [_headerView setUpHeaderViewDetail:userArr tagName:weakSelf.tagStr isFollowing:isFollowing];
    }];
    
    //body

    _page = 1;
    [self firstInitData];

    [self.collectionView addFooterRefresh:^{
        [weakSelf initFootRefreshData];
    }];
}

-(void)firstInitData{
    __weak WYTagsResultPostListVC *weakSelf = self;
    [self.view showHUDNoHide];
    [YZPostListApi listTagResultPostList:self.tagStr page:1 Block:^(NSArray *postArr, BOOL hasMore,NSInteger count) {
        [weakSelf.view hideAllHUD];
        if (postArr) {
            weakSelf.page = 2;
            weakSelf.count = count;
            weakSelf.hasMore = hasMore;
            [weakSelf.postList removeAllObjects];
            [weakSelf.postList addObjectsFromArray:postArr];
            [weakSelf.heightArr removeAllObjects];
            [weakSelf.collectionView reloadData];
            weakSelf.sumLb.text = [NSString stringWithFormat:@"%ld条相关帖子",weakSelf.count];
        }else{
            [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
        }
    }];
}

-(void)initFootRefreshData{
    
    if (!self.hasMore){
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        return ;
    }
    __weak WYTagsResultPostListVC *weakSelf = self;
    [YZPostListApi listTagResultPostList:self.tagStr page:_page Block:^(NSArray *postArr,BOOL hasMore,NSInteger count) {
        if (postArr) {
            if (postArr.count > 0) {
                weakSelf.page += 1;
                weakSelf.count = count;
                weakSelf.hasMore = hasMore;
                [weakSelf.postList addObjectsFromArray:postArr];
                [weakSelf.collectionView endFooterRefresh];
                [weakSelf.collectionView reloadData];
                weakSelf.sumLb.text = [NSString stringWithFormat:@"%ld条相关帖子",weakSelf.count];
            }else{
                [weakSelf.collectionView endRefreshWithNoMoreData];
            }
        }else{
            [weakSelf.collectionView endFooterRefresh];
            [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
        }
    }];
}

-(void)setUpNaviItem{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

- (void)setupCollectionView{
    //创建布局
    
    WYWaterflowLayout * layout = [[WYWaterflowLayout alloc]init];
    layout.columnMargin = 8;
    layout.rowMargin = 8;
    layout.sectionInset = UIEdgeInsetsMake(8, 0, 0, 0);
    layout.columnsCount = 2;
    layout.delegate = self;
    layout.headerReferenceSize = CGSizeMake(kAppScreenWidth, 250);
    
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

-(UIView*)headerView{
    if (_headerView == nil) {
        _headerView = [[WYTagsResultPostListHeaderView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 200)];
        
        __weak WYTagsResultPostListVC *weakSelf = self;
        _headerView.iocnViewClick = ^{
            WYWebViewVC *vc = [WYWebViewVC new];
            vc.navigationTitle = @"关注者";
            NSString *encodedString=[weakSelf.tagStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            vc.targetUrl = [NSString stringWithFormat:@"%@/s/tag_followers/?u=%@&tag=%@",kBaseURL,kuserUUID,encodedString];
            debugLog(@"url is %@",vc.targetUrl);
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    return _headerView;
}

-(UILabel*)sumLb{
    if (_sumLb == nil) {
        _sumLb = [[UILabel alloc]init];
        _sumLb.text = [NSString stringWithFormat:@"%ld条相关帖子",self.count];
        _sumLb.textColor = kRGB(153, 153, 153);
        _sumLb.font = [UIFont systemFontOfSize:12];
    }
    return _sumLb;
}
//创建头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"forIndexPath:indexPath];
       
        [headView addSubview:self.headerView];
        [headView addSubview:self.sumLb];
        [_sumLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(_headerView.mas_bottom).equalTo(20);
        }];
        
        return headView;
    }
    return nil;
}

-(void)setUpAddPostIV{
    _addPostIV = [UIImageView new];
    _addPostIV.userInteractionEnabled = YES;
    _addPostIV.image = [UIImage imageNamed:@"tagresultPublish"];
    [self.view addSubview:_addPostIV];
    [_addPostIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-20);
        make.bottom.equalTo(-65);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPostAction)];
    [_addPostIV addGestureRecognizer:tap];
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
    
    __weak WYTagsResultPostListVC *weakSelf = self;
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

-(void)addPostAction{
    //去往发布页
    WYPublishVC *vc = [WYPublishVC new];
    vc.extraAppointType = 1;
    vc.extraAppointUuid = @"00000000-0000-0000-0000-000000000000";
    vc.extraAppointName = @"公开";
    vc.tagName = self.tagStr;
    __weak WYTagsResultPostListVC *weakSelf = self;
    __weak WYPublishVC *weakVC = vc;
    vc.publishInfoBlock = ^(NSDictionary *dict) {
        //这行代码 比发布5中类型的VC的myBlock的 popViewController先执行
        [weakVC.navigationController popToViewController:weakSelf animated:YES];
        [WYPostApi addPostFromDict:dict WithBlock:^(WYPost *post) {
            if(post){
                //当前页更新数据 然后刷新
                [weakSelf.postList insertObject:post atIndex:0];
                [weakSelf.collectionView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewPublishPostAction object:post];
            }else{
                [OMGToast showWithText:@"未发布成功，请检查网络设置"];
            }
        }];
    };
    [weakSelf.navigationController pushViewController:vc animated:YES];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
