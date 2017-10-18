//
//  WYPhotoListVC.m
//  Withyou
//
//  Created by Tong Lu on 7/28/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import "WYPhotoListVC.h"
#import <QBImagePickerController/QBImagePickerController.h>
#import "WYFixedImageSizeTableViewCell.h"
#import "WYselectScopeSecondTimePageVC.h"
#import "WYAddTextVC.h"
#import "WYPublishOtherView.h"
#import "WYLocationViewController.h"
#import "WYRemindFriendsVC.h"
#import "WYRemindGroupMembersVC.h"
#import "WYPublishAddTagsVC.h"

#define  WYRemindTypeOfFriends  @"typeOfFriend"
#define  WYRemindTypeOfGroup @"typeOfGroup"
#define  ktextH 166.f

static NSString *cellIdentifier1 = @"cellIdentifier1";
static NSString *cellIdentifier2 = @"cellIdentifier2";
static NSString *cellIdentifier3 = @"cellIdentifier3";
static NSString *cellIdentifier4 = @"cellIdentifier4";




@interface WYPhotoListVC() <UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate, QBImagePickerControllerDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    UIToolbar *_toolBar;
    UILabel * _subtitleLabel;
    UITextField *_textField;
    CGFloat _introduceHeight;
    UITextView *_introductionTV;
    YZAddress *_address;

}
@property (nonatomic, strong) NSString *textToPublish;
@property (nonatomic, strong) NSString *titleToPublish;
@property (nonatomic, strong) NSArray *mentionToPublish;
@property (nonatomic, strong) NSMutableArray *arrayToPublish;
@property (nonatomic, strong) WYPublishOtherView *otherView;
@property (nonatomic, copy) NSDictionary *remindDic;
@property (nonatomic, strong) NSMutableArray *selectedTagsArr;
@end

@implementation WYPhotoListVC

-(NSMutableArray*)selectedTagsArr{
    if (_selectedTagsArr == nil) {
        _selectedTagsArr = [NSMutableArray array];
    }
    return _selectedTagsArr;
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    
    self.arrayToPublish = [NSMutableArray array];
    _introduceHeight = 0.0;
    [self createTableView];
    [self addRightBarButtonItem];
    [self addLeftBarButtonItem];
    [self createToolBar];
    
}
- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"图集";
    
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth, kAppScreenHeight - kBottomToolbarHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}
- (void)addLeftBarButtonItem
{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;

}
- (void)createToolBar
{
    
 
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
    
    UIImage *cameraBtnImg = [[UIImage imageNamed:@"Publish page_album_camera"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *cameraBtnHighlightImg = [[UIImage imageNamed:@"Publish page_album_camera_pressed"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraBtn setImage:cameraBtnImg forState:UIControlStateNormal];
    [cameraBtn setImage:cameraBtnHighlightImg forState:UIControlStateHighlighted];
    [cameraBtn
     sizeToFit];
    
    [cameraBtn addTarget:self action:@selector(newPhotoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *cameraView = [[UIView alloc]initWithFrame:cameraBtn.bounds];
    [cameraView addSubview:cameraBtn];
    UIBarButtonItem *cameraItem = [[UIBarButtonItem alloc]initWithCustomView:cameraView];

    
    UIImage *reorderBtnImg = [[UIImage imageNamed:@"Publish page_album_reorder_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *reorderBtnHighlightImg = [[UIImage imageNamed:@"Publish page_album_reorder_pressed"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIButton *reorderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [reorderBtn setImage:reorderBtnImg forState:UIControlStateNormal];
    [reorderBtn setImage:reorderBtnHighlightImg forState:UIControlStateHighlighted];
    [reorderBtn
     sizeToFit];
    
    [reorderBtn addTarget:self action:@selector(eidtOrderBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *reorderView = [[UIView alloc]initWithFrame:reorderBtn.bounds];
    [reorderView addSubview:reorderBtn];
    UIBarButtonItem *reorderItem = [[UIBarButtonItem alloc]initWithCustomView:reorderView];
    
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kAppScreenHeight - kBottomToolbarHeight, kAppScreenWidth, kBottomToolbarHeight)];

    UIBarButtonItem *placeHolderItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [_toolBar setItems:@[placeHolderItem, chooseItem, placeHolderItem, cameraItem, placeHolderItem, reorderItem, placeHolderItem,] animated:YES];
    
    [self.view addSubview:_toolBar];
}
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return self.arrayToPublish.count;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 135.0f;
    }else if (indexPath.section == 1 && indexPath.row == 0){
        
        if (_introduceHeight < ktextH - 30) {
            //确保最小有56的高度
            _introduceHeight = ktextH - 30;
        }
        
        if (_introduceHeight > MAXFLOAT) {
            _introduceHeight = MAXFLOAT;
        }
        return _introduceHeight + 30;
    }else if(indexPath.section == 1 && indexPath.row == 1){
        return 50;
    }
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WYFixedImageSizeTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
    UITableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
    UITableViewCell *cell4 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier4];


    if(indexPath.section == 0)
    {
        if (!cell1) cell1 = [[WYFixedImageSizeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImage *image = [[self.arrayToPublish objectAtIndex:indexPath.row] objectForKey:@"image"];
        NSString *description = [[self.arrayToPublish objectAtIndex:indexPath.row] objectForKey:@"description"];
        cell1.myImageView.userInteractionEnabled = YES;
        cell1.myImageView.tag = indexPath.row;
        cell1.myImageView.image = image;
        cell1.myLabel.text = description;
        cell1.accessoryType = UITableViewCellAccessoryNone;
        UITapGestureRecognizer *gs = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTappedAction:)];
        gs.numberOfTapsRequired = 1;
        [cell1.myImageView addGestureRecognizer:gs];
        
        return cell1;
    }
    else {
        if (!cell2) cell2 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;

        if(indexPath.row == 0)
        {
            _introductionTV = [cell2.contentView viewWithTag:1001];
            if (_introductionTV == nil) {
                _introductionTV = [UITextView new];
                _introductionTV.font = [UIFont systemFontOfSize:14];
                _introductionTV.userInteractionEnabled = NO;
                _introductionTV.textContainer.lineFragmentPadding = 0;
                _introductionTV.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
                _introductionTV.tag = 1001;
                [cell2.contentView addSubview:_introductionTV];
                [_introductionTV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(15);
                    make.top.equalTo(15);
                    make.right.equalTo(-15);
                    make.bottom.equalTo(-15);
                }];
            }
            //输入介绍 去下一页输入
            if(!self.textToPublish || [self.textToPublish isEqualToString:@""]){
                _introductionTV.text = @"相册介绍";
                _introductionTV.textColor = UIColorFromHex(0xc5c5c5);
            }else{
                _introductionTV.text = self.textToPublish;
            }
            return cell2;
            
        }else if (indexPath.row == 1){
            if (!cell3) cell3 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];
            cell3.selectionStyle = UITableViewCellSelectionStyleNone;

            //输入名称
            _textField = [cell3.contentView viewWithTag:1003];
            if (_textField == nil) {
                _textField = [UITextField new];
                _textField.delegate = self;
                _textField.textColor = UIColorFromHex(0x333333);
                _textField.tag = 1003;
                _textField.font = [UIFont systemFontOfSize:15 weight:0.23];
                [cell3.contentView addSubview:_textField];
                [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(15);
                    make.right.equalTo(-15);
                    make.centerY.equalTo(0);
                }];
            }
            _textField.placeholder = @"相册标题";
            if (self.titleToPublish != nil || ![self.titleToPublish isEqualToString:@""]) {
                _textField.text = self.titleToPublish;
            }
            
            return cell3;

        }else{
            if (cell4 == nil) cell4 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier4];
            cell4.selectionStyle = UITableViewCellSelectionStyleNone;

            _otherView = [cell4.contentView viewWithTag:1004];
            if (_otherView == nil) {
                _otherView = [[WYPublishOtherView alloc]initWithFrame:CGRectMake(-1, 0, kAppScreenWidth + 2,200)];
                _otherView.tag = 1004;
                [cell4 addSubview:_otherView];
            }
            _otherView.rangeLabel.text = self.scopeTitle;
            if (self.tagName) {
                [self.selectedTagsArr addObject:self.tagName];
                self.otherView.tagsLabel.text = [self calculateTagsArrName:@[self.tagName]];
            }

            __weak WYPhotoListVC *weakSelf = self;
            _otherView.visiableRangeViewClick = ^{
                [weakSelf selectScopeSecondTime];
            };
            
            self.otherView.tagsClick = ^{
                [weakSelf tagsAction];
            };
            
            _otherView.LocationClick = ^{
                WYLocationViewController *vc = [WYLocationViewController new];
                vc.locationClick = ^(YZAddress*address) {
                    _address = address;
                    weakSelf.otherView.locationLabel.text = address.name;
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            
            _otherView.remindClick = ^{
                [weakSelf remindAction];
            };
            cell4.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell4;
        }
        
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

-(void)tagsAction{
    
    if (self.publishVisibleScopeType == 1){
        __weak WYPhotoListVC *weakSelf = self;
        WYPublishAddTagsVC *vc = [[WYPublishAddTagsVC alloc]initWithType:AddTagFromPublish];
        vc.contentStr = _introductionTV.text;
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
    __weak WYPhotoListVC*weakSelf = self;
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
    __weak WYPhotoListVC *weakSelf = self;
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


//cell 分割线 两端封头 实现这个两个方法 1
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.titleToPublish = _textField.text;
    if(indexPath.section == 0)
    {
        [self addTextForImageForIndexPath:indexPath];
    }

    else if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            [self addTextForAlbum];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return YES;
    }else{
        return NO;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    CGPoint point = _tableView.contentOffset;
    point.y += 258;
    _tableView.contentOffset = point;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    _tableView.contentOffset = CGPointMake(0, -64);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (sourceIndexPath != destinationIndexPath ) {
        
        NSMutableDictionary *dict = [self.arrayToPublish objectAtIndex:sourceIndexPath.row];
        
        [tableView beginUpdates];
        [self.arrayToPublish removeObjectAtIndex:sourceIndexPath.row];
        [self.arrayToPublish insertObject:dict atIndex:destinationIndexPath.row];
        [tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
        [_tableView endUpdates];
    }
}


-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"设为封面" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //insert your editAction here
        for(NSMutableDictionary *mu in self.arrayToPublish)
        {
            [mu setObject:@(false) forKey:@"is_main_pic"];
        }
        
        [[self.arrayToPublish objectAtIndex:indexPath.row] setObject:@(true) forKey:@"is_main_pic"];
        [_tableView reloadData];
    }];
    
    editAction.backgroundColor = [UIColor blueColor];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //insert your deleteAction here
        [self.arrayToPublish removeObjectAtIndex:indexPath.row];
        [_tableView reloadData];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    return @[deleteAction,editAction];
}


#pragma mark -
- (void)publishAction
{
    if(self.arrayToPublish.count == 0)
    {
        [OMGToast showWithText:@"尚未添加图片"];
        return;
    }
    
    if(self.arrayToPublish.count == 1)
    {
        [WYUtility showAlertWithTitle:@"只有一张图片，我们无法为您建立相册，可以使用照片的发布方式"];
        return;
    }
    
    [self checkMainPicKey];
    
    NSString *text = self.textToPublish ? self.textToPublish : @"";
    NSString *title = _textField.text ? _textField.text : @"";
    
    self.myBlock([self.arrayToPublish copy], text, title,self.mentionToPublish,self.publishVisibleScopeType,self.targetUuid,_address,self.remindDic.allValues.firstObject,self.selectedTagsArr);
    
    if (self) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)checkMainPicKey
{
    //make sure a main pic key is
    int main_pic_count = 0;
    
    for(NSMutableDictionary *mu in self.arrayToPublish)
    {
        if([[mu objectForKey:@"is_main_pic"] isEqual:@(true)])
        {
            main_pic_count++;
        }
    }
    
    if(main_pic_count != 1){
        
        for(NSMutableDictionary *mu in self.arrayToPublish)
        {
            [mu setObject:@(false) forKey:@"is_main_pic"];
        }
        
        [[self.arrayToPublish firstObject] setObject:@(true) forKey:@"is_main_pic"];
    }
}


- (void)backAction{
    
    NSString *str = [_introductionTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (str.length > 0 || self.arrayToPublish.count > 0) {
        [[[UIAlertView alloc] initWithTitle:@"放弃编辑?"
                                    message:@"放弃编辑相册，确定退出?"
                           cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
            return;
        }]
                           otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^{
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }], nil] show];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)newPhotoBtnAction
{
    [WYUtility takeNewPictureWithDelegate:self];
}

- (void)addPhotosFromLibraryAction
{
    [WYUtility chooseMultiplePhotoFromAlbumWithDelegateQB:self];
}

- (void)eidtOrderBtnAction{
    if (self.arrayToPublish.count > 0) {
        [_tableView setEditing:YES animated:YES];
        [self addRightBarButtonItemDoneEditing];

    }else{
        [OMGToast showWithText:@"添加多张图片后可重新排序"];
    }
}

- (void)addRightBarButtonItem{
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishAction)];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)imageTappedAction:(id)sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    NSInteger row = gesture.view.tag;
    
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    requestOptions.synchronous = true;
    
    PHAsset *asset = [[self.arrayToPublish objectAtIndex:row] objectForKey:@"asset"];
    PHImageManager *manager = [PHImageManager defaultManager];
    
    // assets contains PHAsset objects.
//    __block UIImage *ima;
    
    [self.view showHUDNoHide];
    __weak WYPhotoListVC *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [manager requestImageForAsset:asset
                           targetSize:CGSizeMake(2000, 2000)
                          contentMode:PHImageContentModeAspectFit
                              options:requestOptions
                        resultHandler:^void(UIImage *image, NSDictionary *info) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakSelf.view hideAllHUD];
                                [WYZoomImage showWithImage:image imageURL:nil];
                            });
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
           
        });
    });
}

#pragma mark -
- (void)addTextForImageForIndexPath:(NSIndexPath *)indexPath{

    
    WYAddTextVC *vc = [WYAddTextVC new];
    vc.defaultText = [[self.arrayToPublish objectAtIndex:indexPath.row] objectForKey:@"description"];
    vc.myBlock = ^(NSString *text) {
        [[self.arrayToPublish objectAtIndex:indexPath.row] setObject:text forKey:@"description"];
        [_tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addTextForAlbum
{
    WYAddTextVC *vc = [WYAddTextVC new];
    vc.defaultText = self.textToPublish;
    vc.navigationTitle = @"相册介绍";
    vc.myBlock = ^(NSString *text) {
        self.textToPublish = text;
        //计算一下高度
        _introduceHeight = [self.textToPublish sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(kAppScreenWidth - 30, MAXFLOAT)].height;
        _introductionTV.textColor = UIColorFromHex(0x333333);
        [_tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addRightBarButtonItemDoneEditing
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditAction)];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)doneEditAction
{
    [_tableView setEditing:NO animated:YES];
    [self addRightBarButtonItem];
}


#pragma mark - ImagePicker Delegates
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *chosenImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    __block PHAsset *asset = nil;
    
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        __block PHAssetChangeRequest *_mChangeRequest = nil;
        __block PHObjectPlaceholder *assetPlaceholder;
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            _mChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:chosenImage];
            assetPlaceholder = _mChangeRequest.placeholderForCreatedAsset;
            
        } completionHandler:^(BOOL success, NSError *error) {
            if (success) {
                PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetPlaceholder.localIdentifier] options:nil];
                asset = [result firstObject];
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:@{@"asset": asset, @"image": chosenImage, @"description" : @"", @"is_main_pic": @(false) }];
                [self.arrayToPublish addObject:dict];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            }
            else {
                [OMGToast showWithText:@"图片未成功保存"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
                return;
            }
        }];
    }
    else
    {
        NSURL *alAssetUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithALAssetURLs:@[alAssetUrl] options:nil];
        asset = [fetchResult firstObject];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:@{@"asset": asset, @"image": chosenImage, @"description" : @"", @"is_main_pic": @(false) }];
        [self.arrayToPublish addObject:dict];
        [_tableView reloadData];

    }
    
    
}
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets{
    
    [imagePickerController dismissViewControllerAnimated:YES completion:^{}];

    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.resizeMode   = PHImageRequestOptionsResizeModeFast;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    requestOptions.synchronous = true;
    
    PHImageManager *manager = [PHImageManager defaultManager];
    
    // assets contains PHAsset objects.
    __block UIImage *ima;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        for (PHAsset *asset in assets) {
            [manager requestImageForAsset:asset
                               targetSize:CGSizeMake(300, 300)
                              contentMode:PHImageContentModeDefault
                                  options:requestOptions
                            resultHandler:^void(UIImage *image, NSDictionary *info) {
                                ima = image;
                                
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:@{@"asset": asset, @"image": ima, @"description" : @"", @"is_main_pic": @(false) }];
                                [self.arrayToPublish addObject:dict];
                                
                            }];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [_tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    
    });
    
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [imagePickerController dismissViewControllerAnimated:YES completion:^{}];
}

@end
