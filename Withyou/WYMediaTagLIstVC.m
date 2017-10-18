//
//  WYMediaTagLIstVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/9/27.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYMediaTagLIstVC.h"
#import "WYMediaCollectionViewCell.h"
#import "WYMediaTag.h"
#import "WYMediaDetailVC.h"
#import "WYMediaAPI.h"
#import "WYMediaCollectionHeaderView.h"
#import "WYMediaTagVC.h"

@interface WYMediaTagLIstVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)NSMutableArray *mediaTagList;
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)BOOL hasMore;
@end

@implementation WYMediaTagLIstVC
#define itemW  ((kAppScreenWidth - 2 * 10 - 3 * 5)/4.f)
#define itemH  137.f

-(NSMutableArray *)mediaTagList{
    if (_mediaTagList == nil) {
        _mediaTagList = [NSMutableArray array];
    }
    return _mediaTagList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加媒体";
    [self setNaviBar];
    [self setUpCollectionView];
    [self initData];
}

-(void)setNaviBar{
    UIImage *leftImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:leftImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

-(void)initData{
    _page = 1;
    MJWeakSelf;
    [self.collectionView showHUDNoHide];
    [WYMediaAPI listMediaTagCallback:_page callback:^(NSArray *tagList, BOOL hasMore) {
        [weakSelf.collectionView hideAllHUD];
        if (tagList) {
            weakSelf.hasMore = hasMore;
            weakSelf.page += 1;
            [weakSelf.mediaTagList addObjectsFromArray:tagList];
            [weakSelf.collectionView reloadData];
        }
    }];
    
    [self.collectionView addFooterRefresh:^{
        if (!weakSelf.hasMore) {
            [weakSelf.collectionView endRefreshWithNoMoreData];
            return ;
        }
        [WYMediaAPI listMediaTagCallback:weakSelf.page callback:^(NSArray *tagList, BOOL hasMore) {
            [weakSelf.collectionView endFooterRefresh];
            if (tagList) {
                weakSelf.hasMore = hasMore;
                weakSelf.page += 1;
                [weakSelf.mediaTagList addObjectsFromArray:tagList];
                [weakSelf.collectionView reloadData];
            }
        }];
    }];
}

-(void)setUpCollectionView{
    
    //layout
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 5);
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.minimumLineSpacing = 0;
    //会自动均匀分布
    layout.minimumInteritemSpacing = 0;
    layout.headerReferenceSize = CGSizeMake(kAppScreenWidth, 60);
    
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, kAppScreenHeight) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[WYMediaCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [collectionView registerClass:[WYMediaCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    self.collectionView = collectionView;
    [self.view addSubview:self.collectionView];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.mediaTagList.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    WYMediaTag *mediaTag = self.mediaTagList[section];
    return [mediaTag.media_list count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WYMediaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    WYMediaTag *mediaTag = self.mediaTagList[indexPath.section];
    NSArray *mediaList = mediaTag.media_list;
    WYMedia *media = mediaList[indexPath.row];
    
    [cell setUpCellDetail:media];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WYMediaTag *mediaTag = self.mediaTagList[indexPath.section];
    NSArray *mediaList = mediaTag.media_list;
    WYMedia *media = mediaList[indexPath.row];
    
    WYMediaDetailVC *vc = [WYMediaDetailVC new];
    vc.media = media;
    [self.navigationController pushViewController:vc animated:YES];
}

//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //如果是头视图
    __weak WYMediaTagLIstVC *weakSelf = self;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        WYMediaCollectionHeaderView *header=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        WYMediaTag *mediaTag = self.mediaTagList[indexPath.section];
        header.titltLb.text = mediaTag.tag_name;
        [header moreBtn];
        header.moreMediaClick = ^{
            WYMediaTagVC *vc = [WYMediaTagVC new];
            vc.mediaTag = mediaTag;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
//        if (mediaTag.tag_sum > 4) {
//            header.moreBtn.hidden = NO;
//        }else{
//            header.moreBtn.hidden = YES;
//        }
        return header;
    }
    //如果底部视图
    //if([kind isEqualToString:UICollectionElementKindSectionFooter]) todo
    return nil;
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
