//
//  WYAddVideoViewController.m
//  Withyou
//
//  Created by tony on 15/01/2017.
//  Copyright © 2017 Withyou Inc. All rights reserved.
//

#import "WYAddVideoViewController.h"
#import "WYAddTextVC.h"
#import "WYQiniuApi.h"
#import "UIImage+WYUtils.h"
#import "UIImageView+Category.h"
#import "WYselectScopeSecondTimePageVC.h"
#import "WYPublishOtherView.h"
#import "WYLocationViewController.h"
#import "WYRemindFriendsVC.h"
#import "WYRemindGroupMembersVC.h"
#import "WYPublishAddTagsVC.h"

#define  WYRemindTypeOfFriends  @"typeOfFriend"
#define  WYRemindTypeOfGroup @"typeOfGroup"

@interface WYAddVideoViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, QBImagePickerControllerDelegate>
{
    UIToolbar *_toolBar;
    UIImageView *_imageView;
    UIScrollView *_scrollView;
    NSArray *_mention;
    UITextView *_textView;
    UILabel *_placeHolder;
    CGFloat _offset;
    UILabel * _secondSelectLb;
    YZAddress *_address;
}
@property (nonatomic, strong) WYPublishOtherView *otherView;
@property (nonatomic, copy) NSDictionary *remindDic;
@property (nonatomic, strong) NSMutableArray *selectedTagsArr;

@end

@implementation WYAddVideoViewController

#define KvedioH (kAppScreenWidth * 8/9.f)
#define KtextH 166.f

-(NSMutableArray*)selectedTagsArr{
    if (_selectedTagsArr == nil) {
        _selectedTagsArr = [NSMutableArray array];
    }
    return _selectedTagsArr;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupUI];
    [self addRightBarButtonItem];
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"新视频";
    
    _offset = 15.0f;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kStatusAndBarHeight, kAppScreenWidth, kAppScreenHeight - kStatusAndBarHeight - kDefaultBarHeight)];
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(kAppScreenWidth, kAppScreenHeight + 100);
    _scrollView.delegate=self;
    
    //自动布局影响 scrollerView contentSize
    UIView *fillView = [UIView new];
    [_scrollView addSubview:fillView];
    [fillView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(64);
        make.width.equalTo(kAppScreenWidth);
        make.height.equalTo(kAppScreenHeight + 100);
        make.right.equalTo(fillView.superview.mas_right).offset(0);
        make.bottom.equalTo(fillView.superview.mas_bottom).offset(-1);
    }];

    //toolBar
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kAppScreenHeight - kBottomToolbarHeight, kAppScreenWidth, kBottomToolbarHeight)];
    UIBarButtonItem *choosePhoto = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"publish_video_on_toolBar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(choosePhotoBtnClickAction)];
    
    UIBarButtonItem *placeHolderItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [_toolBar setItems:@[placeHolderItem, choosePhoto, placeHolderItem] animated:YES];
    
    [self.view addSubview:_toolBar];
    
    //imageView
    _imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.backgroundColor = UIColorFromHex(0xf5f5f5);
    _imageView.layer.borderColor = kGlobalBg.CGColor;
    _imageView.layer.borderWidth = 1;
    [_scrollView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(0);
        make.width.equalTo(0);
        make.top.equalTo(KvedioH);
    }];

    UIView *groundView = [UIView new];
    [_scrollView addSubview:groundView];
    [groundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(-1);
        make.top.equalTo(_imageView.mas_bottom);
        make.width.equalTo(kAppScreenWidth + 2);
        make.height.equalTo(KtextH);
    }];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(15, 10, kAppScreenWidth - 30, KtextH - 20)];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.textColor = UIColorFromHex(0x333333);
    _textView.scrollEnabled = YES;
    _textView.userInteractionEnabled = YES;
    [groundView addSubview:_textView];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTextAction)];
    [_textView addGestureRecognizer:tgr];
    
    _placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kAppScreenWidth - 30, 20)];
    _placeHolder.numberOfLines = 0;
    _placeHolder.text = @"输入文字";
    _placeHolder.textColor = UIColorFromHex(0xc5c5c5);
    _placeHolder.font = [UIFont systemFontOfSize:15 weight:0.23];
    [_textView addSubview:_placeHolder];
    
    self.otherView = [WYPublishOtherView new];
    self.otherView.rangeLabel.text = self.scopeTitle;
    if (self.tagName) {
        [self.selectedTagsArr addObject:self.tagName];
        self.otherView.tagsLabel.text = [self calculateTagsArrName:@[self.tagName]];
    }
    
    [_scrollView addSubview:self.otherView];
    [_otherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(-1);
        make.top.equalTo(groundView.mas_bottom);
        make.width.equalTo(kAppScreenWidth + 2);
        make.height.equalTo(200);
    }];
    __weak WYAddVideoViewController *weakSelf = self;
    self.otherView.visiableRangeViewClick = ^{
        [weakSelf selectScopeSecondTime];
    };
    
    __weak WYPublishOtherView *weakView = self.otherView;
    
    self.otherView.tagsClick = ^{
        [weakSelf tagsAction];
    };
    
    self.otherView.LocationClick = ^{
        WYLocationViewController *vc = [WYLocationViewController new];
        vc.locationClick = ^(YZAddress*address) {
            _address = address;
            weakView.locationLabel.text = address.name;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    _otherView.remindClick = ^{
        [weakSelf remindAction];
    };
}


-(NSMutableString *)calculateRemindName:(NSArray *)friendsArr{
    if (!friendsArr || friendsArr.count == 0) {
        return [NSMutableString stringWithString:@""];
    }
    NSMutableString *mStr = [NSMutableString stringWithString:[friendsArr[0] fullName]];
    for (int i = 1; i < friendsArr.count; i ++) {
        WYUser *user = friendsArr[i];
        NSString *s = [NSString stringWithFormat:@",%@",user.fullName];
        [mStr appendString:s];
    }
    return mStr;
}

-(NSMutableString *)calculateTagsArrName:(NSArray *)tagsArr{
    if (!tagsArr || tagsArr.count == 0) {
        return [NSMutableString stringWithString:@""];
    }
    NSMutableString *mStr = [NSMutableString stringWithString:[NSString stringWithFormat:@"#%@",tagsArr[0]]];
    for (int i = 1; i < tagsArr.count; i ++) {
        NSString *s = tagsArr[i];
        [mStr appendString:[NSString stringWithFormat:@"  #%@",s]];
    }
    return mStr;
}


#pragma selectScopeSecondTime
-(void)tagsAction{
    
    if (self.publishVisibleScopeType == 1){
        __weak WYAddVideoViewController *weakSelf = self;
        WYPublishAddTagsVC *vc = [[WYPublishAddTagsVC alloc]initWithType:AddTagFromPublish];
        vc.contentStr = _textView.text;
        if (weakSelf.selectedTagsArr) {
            [vc.tagStrArr addObjectsFromArray:weakSelf.selectedTagsArr];
        }
        vc.publishTagsClick = ^(NSArray *tempArr) {
            [weakSelf.selectedTagsArr removeAllObjects];
            [weakSelf.selectedTagsArr addObjectsFromArray:tempArr];
            weakSelf.otherView.tagsLabel.text = [weakSelf calculateTagsArrName:tempArr];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }else{
        //提示只有某些情况下生效
        [WYUtility showAlertWithTitle:@"此功能暂在可见范围选择公开时开放"];
    }
    
}


-(void)remindAction{
    __weak WYAddVideoViewController*weakSelf = self;
    if (self.publishVisibleScopeType == 1 || self.publishVisibleScopeType == 2) {
        //朋友表
        WYRemindFriendsVC *vc = [WYRemindFriendsVC new];
        vc.naviTitle = @"与谁一起";
        NSArray *remindArr;
        if (self.remindDic && [self.remindDic.allKeys.firstObject isEqualToString:WYRemindTypeOfFriends]) {
            remindArr = [weakSelf.remindDic objectForKey:WYRemindTypeOfFriends];
        }
        if (remindArr.count > 0) {
            [vc.selectedMember addObjectsFromArray:[weakSelf.remindDic objectForKey:WYRemindTypeOfFriends]];
        }
        vc.remindFriends = ^(NSArray *friendsArr) {
            weakSelf.remindDic = [NSDictionary dictionaryWithObject:[friendsArr copy] forKey:WYRemindTypeOfFriends];
            weakSelf.otherView.remindLabel.text = [weakSelf calculateRemindName:friendsArr];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }else if(self.publishVisibleScopeType == 3){
        //群成员表
        WYRemindGroupMembersVC *vc = [WYRemindGroupMembersVC new];
        vc.naviTitle = @"与谁一起";
        vc.includeAdminList = YES;
        vc.group = self.group;
        NSArray *remindArr;
        if (self.remindDic && [self.remindDic.allKeys.firstObject isEqualToString:WYRemindTypeOfGroup]) {
            remindArr = [weakSelf.remindDic objectForKey:WYRemindTypeOfGroup];
        }
        if (remindArr.count > 0) {
            [vc.selectedMember addObjectsFromArray:[weakSelf.remindDic objectForKey:WYRemindTypeOfGroup]];
        }
        vc.remindFriends = ^(NSArray *friendsArr) {
            weakSelf.remindDic = [NSDictionary dictionaryWithObject:[friendsArr copy] forKey:WYRemindTypeOfGroup];
            weakSelf.otherView.remindLabel.text = [weakSelf calculateRemindName:friendsArr];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }else{
        //提示只有某些情况下生效
        [WYUtility showAlertWithTitle:@"可见范围选择指定朋友或者自己可见时，此功能不可使用"];
    }
}
#pragma selectScopeSecondTime
-(void)selectScopeSecondTime{
    __weak WYAddVideoViewController *weakSelf = self;
    WYselectScopeSecondTimePageVC *vc = [WYselectScopeSecondTimePageVC new];
    vc.myBlock = ^(int publishVisibleScopeType, NSString *targetUuid,NSString*title,WYGroup *group) {
        
        
        if (publishVisibleScopeType == 1 || publishVisibleScopeType == 2) {
            //如果类型是自己可见 或者公开可见
            if (self.publishVisibleScopeType != 1 && self.publishVisibleScopeType != 2) {
                //换范围了
                weakSelf.otherView.remindLabel.text = @"";
                weakSelf.remindDic = [NSDictionary dictionary];
            }
        }else if (publishVisibleScopeType == 3){
            //如果类型是群组可见
            if (![weakSelf.targetUuid isEqualToString:targetUuid]) {
                //换范围
                weakSelf.otherView.remindLabel.text = @"";
                weakSelf.remindDic = [NSDictionary dictionary];
            }
        }else{
            weakSelf.otherView.remindLabel.text = @"";
            weakSelf.remindDic = [NSDictionary dictionary];
        }
        
        //切换范围回来 标签将消失
        if (publishVisibleScopeType == 1 && weakSelf.publishVisibleScopeType == 1) {
            
        }else{
            weakSelf.otherView.tagsLabel.text = @"";
            weakSelf.selectedTagsArr = [NSMutableArray array];
        }
        
        weakSelf.group = group;
        weakSelf.publishVisibleScopeType = publishVisibleScopeType;
        weakSelf.targetUuid = targetUuid;
        weakSelf.otherView.rangeLabel.text = title;
        
        
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)addRightBarButtonItem
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishAction)];
    self.navigationItem.rightBarButtonItem = item;
    
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}
#pragma mark -
- (void)newPhotoBtnClickAction
{
    //    if ([AVCaptureDevice respondsToSelector:@selector(requestAccessForMediaType: completionHandler:)]) {
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        // Will get here on both iOS 7 & 8 even though camera permissions weren't required
        // until iOS 8. So for iOS 7 permission will always be granted.
        if (granted) {
            // Permission has been granted. Use dispatch_async for any UI updating
            // code because this block may be executed in a thread.
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    
                    if(status == PHAuthorizationStatusAuthorized)
                    {
//                        [WYUtility takeNewPictureWithDelegate:self];
                        [WYUtility showAlertWithTitle:@"shoot a video"];
                    }
                    else
                    {
                        [[[UIAlertView alloc] initWithTitle:@"无法存储拍摄内容！"
                                                    message:@"您未授权我们使用相册功能，应用无法存储拍摄的内容，如需重新设置，请在系统中打开相关权限"
                                           cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
                            return;
                        }]
                                           otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^{
                            
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                            
                        }], nil] show];
                        
                        
                    }
                }];
                
                
            });
            
        } else {
            
            [[[UIAlertView alloc] initWithTitle:@"无法拍摄！"
                                        message:@"您未授权我们使用相机功能，应用无法拍摄，如需重新设置，请在系统中打开相关权限"
                               cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
                return;
            }]
                               otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^{
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                
            }], nil] show];
            
        }
    }];
    
    //    }
    
}

- (void)choosePhotoBtnClickAction
{
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
        if(status == PHAuthorizationStatusAuthorized)
        {
            [WYUtility chooseVideoFromAlbumWithDelegate:self];
            
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"无法获取照片！"
                                        message:@"您未授权我们使用相册功能，应用无法获取本地视频，如需重新设置，请在系统中打开相关权限"
                               cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
                return;
            }]
                               otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^{
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                
            }], nil] show];
        }
    }];
    
}
- (void)addTextAction{
    
    
    WYAddTextVC *vc = [WYAddTextVC new];
    vc.defaultText = _textView.text;
    vc.myBlock = ^(NSString *text) {
        _textView.text = text;
        if(!text || [text isEqualToString:@""])
        {
            if(![_placeHolder isDescendantOfView:_textView])
            {
                [_textView addSubview:_placeHolder];
            }
        }
        else
        {
            if([_placeHolder isDescendantOfView:_textView])
            {
                [_placeHolder removeFromSuperview];
            }
            
        }

    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)publishAction
{
    //validate text
    if(!self.videoToPublish)
    {
        [WYUtility showAlertWithTitle:@"尚未选择视频"];
        return;
    }
    NSString *text = _textView.text ? _textView.text : @"";
    self.myBlock(self.videoToPublish, text, _mention,self.publishVisibleScopeType,self.targetUuid,_address,self.remindDic.allValues.firstObject,self.selectedTagsArr);
    if (self) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)backAction
{
    NSString *str = [_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (str.length > 3 || _imageView.image) {
        //三个字或以上的，需要弹出些东西来保存，否则就直接退出就好
        
        [[[UIAlertView alloc] initWithTitle:@"确定退出?"
                                    message:@"有视频或文字尚未发布，确定退出?"
                           cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
            // Handle "Cancel"
            return;
        }]
                           otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^{
            
            [self.navigationController popViewControllerAnimated:YES];
            
            // Handle "Delete"
        }], nil] show];
        
    }
    else {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }
}
#pragma mark -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
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
                self.videoToPublish = asset;
                
            }
            else {
                NSLog(@"write error : %@",error);
                [WYUtility showAlertWithTitle:@"图片未成功保存"];
                self.videoToPublish = nil;
                return;
                
            }
        }];
    }
    else
    {
        NSURL *alAssetUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithALAssetURLs:@[alAssetUrl] options:nil];
        asset = [fetchResult firstObject];
        self.videoToPublish = asset;
    }
    
    if(asset.duration > 10*60){
        [WYUtility showAlertWithTitle:@"视频长度暂只支持10分钟, 请编辑后选择"];
        return;
    }
    //应该是随着获取到的视频的大小，来调整预览图的view的大小
    [self adjustUIForChosenVideo:asset];
}
- (void)adjustUIForChosenVideo:(PHAsset *)asset{
    
    //比较一下宽占比例多少
    //比较一下高占比多少
    
    //aspect fit
    //宽先到顶 用宽的比例
    
    CGFloat width;
    CGFloat heigth;
    if (asset.pixelWidth/kAppScreenWidth >= asset.pixelHeight/KvedioH) {
        width = kAppScreenWidth;
        heigth = KvedioH *asset.pixelWidth/kAppScreenWidth;
    }else{
    //高先到顶
        heigth = KvedioH;
        width = kAppScreenWidth *asset.pixelHeight/KvedioH;
    }
    
    //根据这个结果添加 相机图标  暂时不用

    
        PHImageRequestOptions *cropToSquare = [[PHImageRequestOptions alloc] init];
        cropToSquare.resizeMode = PHImageRequestOptionsResizeModeExact;
    
        CGRect rect = CGRectMake(0, 0, width, heigth);

        CGRect cropRect = CGRectApplyAffineTransform(rect,
                                                     CGAffineTransformMakeScale(1.0 / asset.pixelWidth,
                                                                                1.0 / asset.pixelHeight));
        cropToSquare.normalizedCropRect = cropRect;
        
        [[PHImageManager defaultManager]
         requestImageForAsset:(PHAsset *)asset
         targetSize:rect.size
         contentMode:PHImageContentModeAspectFit
         options:cropToSquare
         resultHandler:^(UIImage *result, NSDictionary *info) {
             _imageView.image = result;
             [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.left.equalTo(0);
                 make.top.equalTo(0);
                 make.width.equalTo(kAppScreenWidth);
                 make.height.equalTo(KvedioH);
                 
             }];
         }];
}

@end
