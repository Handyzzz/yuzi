//
//  WYGroupCategoryListVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/29.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYGroupCategoryListVC.h"
#import "WYGroupCategoryListCell.h"
#import "WYGroupClasses.h"
#import "WYGroupCategoryVC.h"

#define itemWH ((kAppScreenWidth - (15 * 2 + 2 * 4))/3.0)
//弹性的
#define lineSpace 3.0;

@interface WYGroupCategoryListVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *cateArr;
@end

@implementation WYGroupCategoryListVC

-(NSMutableArray *)cateArr{
    if (_cateArr == nil) {
        _cateArr = [NSMutableArray array];
    }
    return _cateArr;
}

-(void)initData{
    [self.view showHUDNoHide];
    __weak WYGroupCategoryListVC *weakSelf = self;
    [WYGroupClasses listRecommentGroupCategory:0 Block:^(NSArray *groupsArr, BOOL success) {
        [weakSelf.view hideAllHUD];
        if (success) {
            if (groupsArr.count > 0) {
                [self.cateArr addObjectsFromArray:groupsArr];
                [self.collectionView reloadData];
            }else{
                [OMGToast showWithText:@"暂无更多推荐分类"];
            }
        }else{
            [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推荐类别";
    [self setNaviBar];
    [self setUpCollectionView];
    [self initData];
}

-(UICollectionView*)setUpCollectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        layout.itemSize = CGSizeMake(itemWH, itemWH);
        //弹性的
        layout.minimumLineSpacing = lineSpace;
        layout.minimumInteritemSpacing = lineSpace;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollsToTop = NO;
        [_collectionView registerClass:[WYGroupCategoryListCell class] forCellWithReuseIdentifier:@"WYGroupCategoryListCell"];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.cateArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WYGroupCategoryListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WYGroupCategoryListCell" forIndexPath:indexPath];
    WYGroupClasses *groupClasses = self.cateArr[indexPath.row];
    [cell.backIV sd_setImageWithURL:[NSURL URLWithString:groupClasses.image]];
    cell.nameLb.text = groupClasses.name;
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WYGroupClasses *gc = self.cateArr[indexPath.row];
    WYGroupCategoryVC *vc = [WYGroupCategoryVC new];
    vc.categoryType = gc.category;
    vc.name = gc.name;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)setNaviBar{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
