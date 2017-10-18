//
//  WYPreviewPhotoListVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/26.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYPreviewPhotoListVC.h"
#import "WYPreviewPhotoListCell.h"

@interface WYPreviewPhotoListVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,QBImagePickerControllerDelegate>
@property(nonatomic, strong)UICollectionView *collectionView;
//数据源
@property(nonatomic, strong)NSMutableArray *assetArr;
@property(nonatomic, strong)NSMutableArray *imageArr;
@property(nonatomic, assign)BOOL isChange;
@property(nonatomic, strong)NSMutableArray *cellAttributesArray;
@property(nonatomic, strong)UIImage *temp;
@property(nonatomic, strong)UIToolbar *toolBar;
@end

@implementation WYPreviewPhotoListVC

-(NSMutableArray *)cellAttributesArray{
    if (_cellAttributesArray == nil) {
        _cellAttributesArray = [NSMutableArray array];
    }
    return _cellAttributesArray;
}

-(NSMutableArray *)assetArr{
    if (_assetArr == nil) {
        _assetArr = [NSMutableArray array];
    }
    return _assetArr;
}

-(NSMutableArray *)imageArr{
    if (_imageArr == nil) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

-(void)initData{

    [self.assetArr addObjectsFromArray:self.selectedAssetArr];
    [self prepareShowPhoto:self.assetArr];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"已选图片";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNaviBar];
    [self setUpToolBarChooseBtn];
    [self setUpCollectionView];
    [self initData];
}

-(void)setNaviBar{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
    self.navigationItem.rightBarButtonItem = item;

}

-(void)doneClick{
    self.selectedPhotos(self.assetArr,self.imageArr);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUpToolBarChooseBtn{
    UIImage *chooseBtnImg = [[UIImage imageNamed:@"Publish page_album_image_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *chooseBtnHighlightImg = [[UIImage imageNamed:@"Publish page_album_image_pressed"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseBtn setImage:chooseBtnImg forState:UIControlStateNormal];
    [chooseBtn setImage:chooseBtnHighlightImg forState:UIControlStateHighlighted];
    [chooseBtn
     sizeToFit];
    
    [chooseBtn addTarget:self action:@selector(addPhotosFromLibraryAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *chooseView = [[UIView alloc]initWithFrame:chooseBtn.bounds];
    [chooseView addSubview:chooseBtn];
    UIBarButtonItem *chooseItem = [[UIBarButtonItem alloc]initWithCustomView:chooseView];
    
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kAppScreenHeight - kBottomToolbarHeight, kAppScreenWidth, kBottomToolbarHeight)];
    UIBarButtonItem *placeHolderItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [_toolBar setItems:@[placeHolderItem, chooseItem, placeHolderItem] animated:YES];
    [self.view addSubview:_toolBar];
}

-(void)setUpToolBarOfTypeRemove{
    
    UIImageView *iv = [UIImageView new];
    iv.image = [UIImage imageNamed:@"publish_rubbish"];
    
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kAppScreenHeight - kBottomToolbarHeight, kAppScreenWidth, kBottomToolbarHeight)];
    [_toolBar addSubview:iv];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(0);
    }];
    
   [self.view addSubview:_toolBar];

}

-(void)setUpCollectionView{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //创建CollectionView
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, kAppScreenWidth, kAppScreenHeight -kStatusAndBarHeight - kDefaultBarHeight) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.bounces = YES;
    [collectionView registerClass:[WYPreviewPhotoListCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView = collectionView;
    [self.view addSubview:self.collectionView];
}
#pragma  FlowLayoutDelegate

//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = (kAppScreenWidth - 10 *2 - 10 *2)/3.0;
    CGFloat height = width*1.3;
    
    return CGSizeMake(width, height);
}


//设置分区边界, 具体看下图
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

    return 8;
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
  
    return 8;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WYPreviewPhotoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        
    
    UIImage *image = self.imageArr[indexPath.row];
    cell.photoIV.image = image;
    
    __weak WYPreviewPhotoListVC *weakSelf = self;
    cell.longTapClick = ^(UILongPressGestureRecognizer *longPress) {
        [weakSelf longAction:longPress];
    };
    return cell;
}

//cell被选择时被调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self showPhotoWithSize:CGSizeMake(2000, 2000) index:indexPath];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

//准备显示数据
-(void)prepareShowPhoto:(NSMutableArray*)arr{
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    requestOptions.synchronous = true;
    
    
    PHImageManager *manager = [PHImageManager defaultManager];
    
    
    __weak WYPreviewPhotoListVC *weakSelf = self;
    [self.view showHUDNoHide];
    
    [weakSelf.imageArr removeAllObjects];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < arr.count; i ++) {
            PHAsset *asset = arr[i];
            [manager requestImageForAsset:asset
                               targetSize:CGSizeMake(2000, 2000)
                              contentMode:PHImageContentModeAspectFit
                                  options:requestOptions
                            resultHandler:^void(UIImage *image, NSDictionary *info) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [weakSelf.imageArr addObject:image];
                                });
            }];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [weakSelf.view hideAllHUD];
            [weakSelf.collectionView reloadData];
        });
    });
    
}
//选择的时候
-(void)showPhotoWithSize:(CGSize)size index:(NSIndexPath *)indexPath{
   
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    requestOptions.synchronous = true;
    
    PHAsset *asset = self.assetArr[indexPath.row];
    PHImageManager *manager = [PHImageManager defaultManager];


    [self.view showHUDNoHide];
    __weak WYPreviewPhotoListVC *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [manager requestImageForAsset:asset
                       targetSize:size
                      contentMode:PHImageContentModeAspectFit
                          options:requestOptions
                    resultHandler:^void(UIImage *image, NSDictionary *info) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.view hideAllHUD];
                            [WYZoomImage showWithImage:image imageURL:nil];
                        });
        }];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [weakSelf.view hideAllHUD];
        });
    });

}

-(void)addPhotosFromLibraryAction{
    [WYUtility chooseMultiplePhotoFromAlbumWithDelegateQB:self];

}
#pragma mark - ImagePicker Delegates
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets{
    
    [imagePickerController dismissViewControllerAnimated:YES completion:^{}];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.assetArr removeAllObjects];
    if (assets.count > 0) {
        [self.assetArr addObjectsFromArray:assets];
        [self prepareShowPhoto:self.assetArr];
        [self.collectionView reloadData];
    }
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [imagePickerController dismissViewControllerAnimated:YES completion:^{}];
    self.automaticallyAdjustsScrollViewInsets = NO;

}
- (void)longAction:(UILongPressGestureRecognizer *)longPress {
    //获取当前cell所对应的indexpath
    WYPreviewPhotoListCell *cell = (WYPreviewPhotoListCell *)longPress.view;
    NSIndexPath *cellIndexpath = [_collectionView indexPathForCell:cell];
    //将此cell 移动到视图的前面
    [_collectionView bringSubviewToFront:cell];
    _isChange = NO;
    
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            //改变toolBar
            [_toolBar removeFromSuperview];
            [self setUpToolBarOfTypeRemove];
            _temp = self.imageArr[cellIndexpath.row];
            //使用数组将collectionView每个cell的 UICollectionViewLayoutAttributes 存储起来。
            [self.cellAttributesArray removeAllObjects];
            for (int i = 0; i < self.assetArr.count; i++) {
                [self.cellAttributesArray addObject:[_collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]];
            }
        }
            break;
        case UIGestureRecognizerStateChanged: {
            //如果中心在
            CGPoint point = [longPress locationInView:self.view];
            if (point.y > kAppScreenHeight - kDefaultBarHeight) {
                //移除 会多次调用 保证只删除一次
                for (int i = 0; i < self.imageArr.count; i ++) {
                    UIImage *image = self.imageArr[i];
                    if ([image isEqual:_temp]) {
                        _isChange = YES;
                        [self.assetArr removeObjectAtIndex:cellIndexpath.row];
                        [self.imageArr removeObjectAtIndex:cellIndexpath.row];
                        [self.collectionView deleteItemsAtIndexPaths:@[cellIndexpath]];
                        break;
                    }
                }
            }
            //在移动过程中，使cell的中心与移动的位置相同。
            cell.center = [longPress locationInView:_collectionView];
            for (UICollectionViewLayoutAttributes *attributes in self.cellAttributesArray) {
                //判断移动cell的indexpath，是否和目的位置相同，如果相同isChange为YES,然后将数据源交换
                if (CGRectContainsPoint(attributes.frame, cell.center) && cellIndexpath != attributes.indexPath) {
                    _isChange = YES;
                    PHAsset *asset = self.assetArr[cellIndexpath.row];
                    UIImage *image = self.imageArr[cellIndexpath.row];
                    
                    [self.assetArr removeObjectAtIndex:cellIndexpath.row];
                    [self.imageArr removeObjectAtIndex:cellIndexpath.row];
                    
                    [self.assetArr insertObject:asset atIndex:attributes.indexPath.row];
                    [self.imageArr insertObject:image atIndex:attributes.indexPath.row];

                    
                    [self.collectionView moveItemAtIndexPath:cellIndexpath toIndexPath:attributes.indexPath];
                }
            }
            
        }
            break;
        case UIGestureRecognizerStateEnded: {
            //复原toolBar
            [_toolBar removeFromSuperview];
            [self setUpToolBarChooseBtn];
            if (!_isChange) {
                //如果这张图片还在
                for (int i = 0; i < self.imageArr.count; i ++) {
                    UIImage *image = self.imageArr[i];
                    if ([image isEqual:_temp]) {
                        cell.center = [_collectionView layoutAttributesForItemAtIndexPath:cellIndexpath].center;
                        break;
                    }
                }

            }
        }
            break;
        default:
            break;
    }
}


//开始移动的时候调用此方法，可以获取相应的datasource方法设置特殊的indexpath 能否移动,如果能移动返回的是YES ,不能移动返回的是NO
- (BOOL)beginInteractiveMovementForItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

// 在开始移动时会调用此代理方法，
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    //根据indexpath判断单元格是否可以移动，如果都可以移动，直接就返回YES ,不能移动的返回NO
    return YES;
}

@end
