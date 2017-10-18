//
//  WYPublicTextVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/15.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYPublishTextVC.h"
#import "WYPublishTextOtherView.h"
#import "WYLocationViewController.h"
#import "WYselectScopeSecondTimePageVC.h"
#import "WYRemindFriendsVC.h"
#import "WYRemindGroupMembersVC.h"
#import "WYDocumentLibaryVC.h"
#import "WYPreviewPhotoListVC.h"
#import "WYPublishAddTagsVC.h"

#define  WYRemindTypeOfFriends  @"typeOfFriend"
#define  WYRemindTypeOfGroup @"typeOfGroup"
#define  ktextH 166.f

@interface WYPublishTextVC ()<UITextViewDelegate,QBImagePickerControllerDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *textViewPlaceholderLabel;
@property (nonatomic, strong) UITextField *titltTextField;
@property (nonatomic, strong) WYPublishTextOtherView *otherView;
@property (nonatomic, strong) YZAddress *address;
@property (nonatomic, copy)   NSDictionary *remindDic;
@property (nonatomic, copy) NSMutableArray *selectedPdfArr;
//九张图
@property (nonatomic, copy) NSMutableArray *selectedAssetArr;
@property (nonatomic, copy) NSMutableArray *selectedImageArr;

@property (nonatomic, strong) NSMutableArray *selectedTagsArr;
@end

@implementation WYPublishTextVC

-(NSMutableArray*)selectedTagsArr{
    if (_selectedTagsArr == nil) {
        _selectedTagsArr = [NSMutableArray array];
    }
    return _selectedTagsArr;
}

-(NSMutableArray *)selectedAssetArr{
    if (_selectedAssetArr == nil) {
        _selectedAssetArr = [NSMutableArray array];
    }
    return _selectedAssetArr;
}

-(NSMutableArray *)selectedImageArr{
    if (_selectedImageArr == nil) {
        _selectedImageArr = [NSMutableArray array];
    }
    return _selectedImageArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布文字";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setNaviBar];
    [self setUpTextView];
}

-(void)viewDidAppear:(BOOL)animated{
    [_textView becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.view endEditing:YES];
}

-(void)setNaviBar{
    
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(publishAction)];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)setUpTextView{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, kAppScreenHeight)];
    _scrollView.bounces = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.contentSize = CGSizeMake(kAppScreenWidth,kAppScreenHeight);
    _scrollView.delegate = self;
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15,15, kAppScreenWidth - 30, ktextH)];
    [_scrollView addSubview:_textView];
    [self.view addSubview:_scrollView];
    _textView.font = [UIFont systemFontOfSize:14.0f];
    _textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _textView.textColor = UIColorFromHex(0x333333);
    _textView.selectable = YES;
    _textView.editable = YES;
    _textView.bounces = NO;
    _textView.scrollEnabled = YES;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.userInteractionEnabled = YES;
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.delegate = self;
    
    //PlaceholderLabel
    _textViewPlaceholderLabel = [UILabel new];
    _textViewPlaceholderLabel.text = @"请输入内容";
    _textViewPlaceholderLabel.textColor = UIColorFromHex(0xc5c5c5);
    _textViewPlaceholderLabel.font = [UIFont systemFontOfSize:14];
    [_textView addSubview:_textViewPlaceholderLabel];
    [_textViewPlaceholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(5);
        make.top.equalTo(8);
    }];
    
    UIView *groundView = [UIView new];
    groundView.backgroundColor = [UIColor whiteColor];
    groundView.layer.borderWidth = 1;
    groundView.layer.borderColor = UIColorFromHex(0xf5f5f5).CGColor;
    [self.scrollView addSubview:groundView];
    [groundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(-1);
        make.width.equalTo(kAppScreenWidth + 2);
        make.top.equalTo(self.textView.mas_bottom);
        make.height.equalTo(50);
    }];
    
    self.titltTextField = [UITextField new];
    self.titltTextField.placeholder = @"标题";
    self.titltTextField.font = [UIFont systemFontOfSize:15 weight:0.23];
    [groundView addSubview:self.titltTextField];
    [self.titltTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.top.bottom.equalTo(0);
    }];
    
    
    self.otherView = [WYPublishTextOtherView new];
    self.otherView.rangeLabel.text = self.scopeTitle;
    if (self.tagName) {
        [self.selectedTagsArr addObject:self.tagName];
        self.otherView.tagsLabel.text = [self calculateTagsArrName:@[self.tagName]];
    }
    
    
    [self.scrollView addSubview:self.otherView];
    [self.otherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(-1);
        make.width.equalTo(kAppScreenWidth + 2);
        make.height.equalTo(300);
        make.top.equalTo(groundView.mas_bottom);
    }];
    
    __weak WYPublishTextVC *weakSelf = self;
    
    self.otherView.photoClick = ^{
        //添加图片
        [weakSelf addPhotoAction];
    };
    
    self.otherView.visiableRangeViewClick = ^{
        [weakSelf selectScopeSecondTime];
    };
    
    self.otherView.tagsClick = ^{
        [weakSelf tagsAction];
    };
    
    self.otherView.LocationClick = ^{
        WYLocationViewController *vc = [WYLocationViewController new];
        vc.locationClick = ^(YZAddress*address) {
            weakSelf.address = address;
            weakSelf.otherView.locationLabel.text = address.name;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    self.otherView.accessoryClick = ^{
        WYDocumentLibaryVC *vc = [WYDocumentLibaryVC new];
        vc.selectedPdfArr = weakSelf.selectedPdfArr;
        vc.selectedFdfs = ^(NSArray *selectedPdfArr) {
            weakSelf.selectedPdfArr = [[NSMutableArray alloc]initWithArray:selectedPdfArr];
            if (selectedPdfArr.count > 0) {
                weakSelf.otherView.accessoryLabel.text = [NSString stringWithFormat:@"已选%ld个pdf",selectedPdfArr.count];
            }else{
                weakSelf.otherView.accessoryLabel.text = @"";
            }
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    self.otherView.remindClick = ^{
        [weakSelf remindAction];
    };

}

-(void)addPhotoAction{
    //如果没有图片去系统相册选择页面 有图片去往图片页面
    
    __weak WYPublishTextVC *weakSelf = self;
    if (self.selectedAssetArr && self.selectedAssetArr.count > 0) {
        
        WYPreviewPhotoListVC *vc = [WYPreviewPhotoListVC new];
        vc.selectedAssetArr = self.selectedAssetArr;
        vc.selectedPhotos = ^(NSArray *selectedAssetArr, NSArray *selectedImageArr) {
            [weakSelf.selectedAssetArr removeAllObjects];
            [weakSelf.selectedImageArr removeAllObjects];
            [weakSelf.selectedAssetArr addObjectsFromArray:selectedAssetArr];
            [weakSelf.selectedImageArr addObjectsFromArray:selectedImageArr];
            if (weakSelf.selectedAssetArr.count > 0) {
                weakSelf.otherView.photoLabel.text = [NSString stringWithFormat:@"已选%ld张图片",self.selectedAssetArr.count];
            }else{
                weakSelf.otherView.photoLabel.text = @"";
            }

        };
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //去往系统相册 选择图片
        [WYUtility chooseMultiplePhotoFromAlbumWithDelegateQB:self];
    }
}

-(void)tagsAction{
    
    if (self.publishVisibleScopeType == 1){
        __weak WYPublishTextVC *weakSelf = self;
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
    __weak WYPublishTextVC *weakSelf = self;
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
-(void)selectScopeSecondTime{
    __weak WYPublishTextVC *weakSelf = self;
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
- (void)publishAction{
    
    if(_textView.text.length < 1){
        
        [OMGToast showWithText:@"请输入文字内容再发布"];
        return;
    }
    
    NSArray *metion = nil;
    // 如果有@存在 则转换文本
    NSMutableArray *ma = [NSMutableArray array];
    for (int i =0 ; i < self.selectedAssetArr.count; i ++) {
        PHAsset *asset = self.selectedAssetArr[i];
        UIImage *image = self.selectedImageArr[i];
        NSMutableDictionary *md = [NSMutableDictionary dictionary];
        [md setObject:asset forKey:@"asset"];
        [md setObject:image forKey: @"image"];
        [ma addObject:md];
    }
    self.myBlock(self.textView.text, metion,self.publishVisibleScopeType,self.targetUuid,self.titltTextField.text,self.address,self.remindDic.allValues.firstObject,[self.selectedPdfArr copy],ma,self.selectedTagsArr);
    
    if (self) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)backAction
{
    NSString *str = [_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (str.length >= 1) {
        //三个字或以上的，需要弹出些东西来保存，否则就直接退出就好
        
        [[[UIAlertView alloc] initWithTitle:@"放弃修改?"
                                    message:@"放弃文字修改，确定退出?"
                           cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
            // Handle "Cancel"
            return;
        }]
                           otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^{
            
            [self.navigationController popViewControllerAnimated:YES];
            
            // Handle "Delete"
        }], nil] show];
        
    }else {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}


#pragma mark -
- (void)textViewDidChange:(UITextView *)textView{
    _textView.textColor = [UIColor blackColor];
    if (textView.text == nil || textView.attributedText.length == 0) {
        _textViewPlaceholderLabel.hidden = NO;
    }else {
        _textViewPlaceholderLabel.hidden = YES;
    }
}
//滑动收键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITextView class]]) {
        return;
    }
    [self.view endEditing:YES];
    
}

#pragma mark - ImagePicker Delegates
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets{
    
    [imagePickerController dismissViewControllerAnimated:YES completion:^{}];
    
    if (assets.count > 0) {
        [self.selectedAssetArr addObjectsFromArray:assets];

        PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
        requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        requestOptions.synchronous = true;
        
        PHImageManager *manager = [PHImageManager defaultManager];
        
        __weak WYPublishTextVC *weakSelf = self;
        [self.view showHUDNoHide];
        
        [weakSelf.selectedImageArr removeAllObjects];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (int i = 0; i < weakSelf.selectedAssetArr.count; i ++) {
                PHAsset *asset = weakSelf.selectedAssetArr[i];
                [manager requestImageForAsset:asset
                                   targetSize:CGSizeMake(2000, 2000)
                                  contentMode:PHImageContentModeAspectFit
                                      options:requestOptions
                                resultHandler:^void(UIImage *image, NSDictionary *info) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [weakSelf.selectedImageArr addObject:image];
                                    });
                                }];
            }
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [weakSelf.view hideAllHUD];
            });
        });

    }
    if (self.selectedAssetArr.count > 0) {
        self.otherView.photoLabel.text = [NSString stringWithFormat:@"已选%ld张图片",self.selectedAssetArr.count];
    }else{
        self.otherView.photoLabel.text = @"";
    }
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [imagePickerController dismissViewControllerAnimated:YES completion:^{}];
}

@end
