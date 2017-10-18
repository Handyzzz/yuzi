//
//  WYGroupIconVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/25.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYGroupIconVC.h"
#import "WYGroupIconsCellOfTypeOne.h"
#import "WYGroupApi.h"

#define cellWidth ((kAppScreenWidth - (3-1)*5)/3.0)
#define cellHeigth ((kAppScreenWidth - (3-1)*5)/3.0)

@interface WYGroupIconVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *imgDicArr;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)BOOL hasMore;
@end

@implementation WYGroupIconVC

-(NSMutableArray*)imgDicArr{
    if (_imgDicArr == nil) {
        _imgDicArr = [NSMutableArray array];
    }
    return _imgDicArr;
}

-(void)initData{
    
    __weak WYGroupIconVC *weakSelf = self;
    [WYGroupApi listGroupIconsArrPage:1 Block:^(NSArray *dicArr, BOOL hasMore) {
        if (dicArr) {
            weakSelf.page += 1;
            weakSelf.hasMore = hasMore;
            [weakSelf.imgDicArr addObjectsFromArray:dicArr];
            [weakSelf.collectionView reloadData];
        }
    }];
    
    [self.collectionView addFooterRefresh:^{
        if (!weakSelf.hasMore) {
            [weakSelf.collectionView endRefreshWithNoMoreData];
            return ;
        }
        [WYGroupApi listGroupIconsArrPage:weakSelf.page Block:^(NSArray *dicArr, BOOL hasMore) {
            if (dicArr) {
                weakSelf.page += 1;
                weakSelf.hasMore = hasMore;
                [weakSelf.imgDicArr addObjectsFromArray:dicArr];
                [weakSelf.collectionView reloadData];
            }
        }];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群头像";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNaviItem];
    [self setUpCollectionView];
    [self initData];
}

-(void)setNaviItem{
    
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

-(void)setUpCollectionView{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(cellWidth, cellHeigth);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[WYGroupIconsCellOfTypeOne class] forCellWithReuseIdentifier:@"btnCell"];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"imgCell"];
    [self.view addSubview:_collectionView];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imgDicArr.count + 2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WYGroupIconsCellOfTypeOne *btnCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"btnCell" forIndexPath:indexPath];
    UICollectionViewCell *imgCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imgCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        btnCell.iconIV.image = [UIImage imageNamed:@"creatgroupTakephoto"];
        btnCell.nameLb.text = @"拍照";
        return btnCell;
    }else if (indexPath.row == 1){
        btnCell.iconIV.image = [UIImage imageNamed:@"creatgroupSystemimage"];
        btnCell.nameLb.text = @"系统相册";
        return btnCell;
    }else{
        UIImageView *icon = [imgCell .contentView viewWithTag:indexPath.row];
        if (icon == nil) {
            icon = [UIImageView new];
            [imgCell.contentView addSubview:icon];
            icon.tag = indexPath.row;
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(0);
            }];
        }
        NSDictionary *dic = self.imgDicArr[indexPath.row - 2];
        [icon sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"url"]]];
        return imgCell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
         [self chooseImage:UIImagePickerControllerSourceTypeCamera];
    }else if (indexPath.row == 1){
        [self chooseImage:UIImagePickerControllerSourceTypePhotoLibrary];
    }else{
        NSDictionary *dic = self.imgDicArr[indexPath.row - 2];
        self.selectImgClick(nil,nil, dic,select_group_icon_typeB);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)chooseImage:(UIImagePickerControllerSourceType)type {
    //创建图片编辑控制器
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    //设置编辑类型
    imagePickerController.sourceType = type;
    //允许编辑器编辑图片
    imagePickerController.allowsEditing = YES;
    //设置代理
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *chosenImage = [info valueForKey:UIImagePickerControllerEditedImage];
    
    __block PHAsset *asset = nil;
    
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        __block PHAssetChangeRequest *_mChangeRequest = nil;
        __block PHObjectPlaceholder *assetPlaceholder;
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            _mChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:chosenImage];
            assetPlaceholder = _mChangeRequest.placeholderForCreatedAsset;
            
        } completionHandler:^(BOOL success, NSError *error) {
            if (success) {
                PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetPlaceholder.localIdentifier] options:nil];
                asset = [result firstObject];
                self.selectImgClick(chosenImage,asset, nil,select_group_icon_typeA);
                
            }
            else {
                [OMGToast showWithText:@"图片未成功保存"];
                self.selectImgClick(chosenImage,nil, nil,select_group_icon_typeA);
                return;
                
            }
        }];
    }
    else
    {
        NSURL *alAssetUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithALAssetURLs:@[alAssetUrl] options:nil];
        asset = [fetchResult firstObject];
        self.selectImgClick(chosenImage,asset, nil,select_group_icon_typeA);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}


-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
