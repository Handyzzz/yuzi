//
//  WYMediaTagVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/9/27.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYMediaTagVC.h"
#import "WYMediaTag.h"
#import "WYMediaCollectionViewCell.h"
#import "WYMediaDetailVC.h"
#import "WYMediaCollectionHeaderView.h"
#import "WYMediaAPI.h"

@interface WYMediaTagVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)NSMutableArray *mediaArr;
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, assign)NSInteger page;@property(nonatomic, assign)BOOL hasMore;
@end

@implementation WYMediaTagVC
#define itemW  ((kAppScreenWidth - 2 * 10 - 3 * 5)/4.f)
#define itemH  137.f

-(NSMutableArray *)mediaArr{
    if (_mediaArr == nil) {
        _mediaArr = [NSMutableArray array];
    }
    return _mediaArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.mediaTag.tag_name;
    [self setNaviBar];
    [self setUpCollectionView];
    [self initData];
}

-(void)initData{
    _page = 1;
    MJWeakSelf;
    [self.collectionView showHUDNoHide];
    [WYMediaAPI listMeidaWithTagNum:self.mediaTag.tag_num page:weakSelf.page callback:^(NSArray *mediaArr, BOOL hasMore) {
        [weakSelf.collectionView hideAllHUD];
        if (mediaArr) {
            weakSelf.hasMore = hasMore;
            weakSelf.page += 1;
            [weakSelf.mediaArr addObjectsFromArray:mediaArr];
            [weakSelf.collectionView reloadData];
        }
    }];
    [self.collectionView addFooterRefresh:^{
        if (!weakSelf.hasMore) {
            [weakSelf.collectionView endRefreshWithNoMoreData];
            return ;
        }
        [WYMediaAPI listMeidaWithTagNum:weakSelf.mediaTag.tag_num page:weakSelf.page callback:^(NSArray *mediaArr, BOOL hasMore) {
            [weakSelf.collectionView endFooterRefresh];
            if (mediaArr) {
                weakSelf.hasMore = hasMore;
                weakSelf.page += 1;
                [weakSelf.mediaArr addObjectsFromArray:mediaArr];
                [weakSelf.collectionView reloadData];
            }
        }];
    }];
}

-(void)setNaviBar{
    UIImage *leftImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:leftImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

-(void)setUpCollectionView{
    
    //layout
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 5);
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.minimumLineSpacing = 0;
    //会自动均匀分布
    layout.minimumInteritemSpacing = 0;
    
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, kAppScreenHeight) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[WYMediaCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [collectionView registerClass:[WYMediaCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    self.collectionView = collectionView;
    [self.view addSubview:self.collectionView];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.mediaArr count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WYMediaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    WYMedia *media = self.mediaArr[indexPath.row];
    [cell setUpCellDetail:media];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WYMedia *media = self.mediaArr[indexPath.row];
    WYMediaDetailVC *vc = [WYMediaDetailVC new];
    vc.media = media;
    [self.navigationController pushViewController:vc animated:YES];
}

//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        WYMediaCollectionHeaderView *header=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        WYMediaTag *mediaTag = self.mediaTag;
        header.titltLb.text = mediaTag.tag_name;
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
