//
//  WYUserVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/5/11.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYUserVC.h"
#import "WYPagerTabView.h"
#import "WYUserShareVC.h"
#import "WYUserPhotoVC.h"
#import "WYUserDetailVC.h"
#import "WYUserDetailHeaderView.h"
#import "WYSelfSettingsVC.h"
#import "WYFollowerListVC.h"
#import "WYInflucerListVC.h"
#import "WYGroupsVC.h"
#import "WYUserDetail.h"
#import "WYUserExtra.h"
#import "WYPublishVC.h"
#import "YZChatList.h"
#import "WYFollow.h"
#import "WYUserFriendsListVC.h"
#import "WYCommonFriendsListVC.h"
#import "WYPrivacySettingsVC.h"
#import "WYSelfDetailEditing.h"
#import "WYSelfFriendListsVC.h"
#import "WYUserDetailApi.h"
#import "WYUserApi.h"
#import "WYUserChangeIconView.h"


@interface WYUserVC () <WYPagerTabViewDelegate, UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property(nonatomic, strong) WYUserDetailHeaderView *headView;
@property(nonatomic, strong) NSMutableArray *allVC;
@property(nonatomic, strong) WYPagerTabView *pagerTabView;
@property(nonatomic, strong) WYUserShareVC *shareVC;
@property(nonatomic, strong) WYUserPhotoVC *photoVC;
@property(nonatomic, strong) WYUserDetailVC *detailVC;
@property(nonatomic, assign) CGFloat headerHeight;
@property(nonatomic, strong) UIView *titleView;
@property(nonatomic, assign) BOOL stop;
@property(nonatomic, assign) CGFloat naviAlpha;
@property(nonatomic, strong) NSMutableArray *postArr;
@property(nonatomic, strong) WYUserDetail *userInfo;
@property(nonatomic, strong) NSMutableArray *photoArr;
@property(nonatomic, strong) WYUserExtra *userExtra;
@property(nonatomic, strong) WYUserChangeIconView *changIconView;


@property(nonatomic, assign) BOOL shouldShowHUD;

@end

@implementation WYUserVC

#define imageHeight (kAppScreenWidth*17/32.0)

- (NSMutableArray *)postArr {
    if (_postArr == nil) {
        _postArr = [NSMutableArray array];
    }
    return _postArr;
}

- (NSMutableArray *)photoArr {
    if (_photoArr == nil) {
        _photoArr = [NSMutableArray array];
    }
    return _photoArr;
}


- (void)initData {
    __weak WYUserVC *weakSelf = self;
    if (!self.userUuid)
        self.userUuid = self.user.uuid;
    [weakSelf setUpNavigationView];

    [WYUserDetail queryUserDetailFromCache:self.userUuid Block:^(NSArray *postArr, WYUserDetail *userInfo, NSArray *photoArr, WYUserExtra *userExtra, BOOL hasDetail) {
        if (hasDetail == YES) {
            if (postArr.count > 0) {
                [weakSelf.postArr addObjectsFromArray:postArr];
            }
            if (photoArr.count > 0) {
                [weakSelf.photoArr addObjectsFromArray:photoArr];
            }
            weakSelf.userInfo = userInfo;
            weakSelf.userExtra = userExtra;
            [weakSelf calculateHeaderHeight];
            [weakSelf pagerTabView];
            [weakSelf headView];
        } else {
            [weakSelf setUpPreview];
        }
    }];
}

//计算高度
- (void)calculateHeaderHeight {
    self.headerHeight = [WYUserDetailHeaderView calculateHeaderHeight:self.userInfo];
}

//第一次没有缓冲的时候
- (void)setUpPreview {
    //以后可以做一个占位图
    _shouldShowHUD = YES;
    self.view.backgroundColor = UIColorFromHex(0xf5f5f5);

}

//网络请求
- (void)initDataAddHUD {
    __weak WYUserVC *weakSelf = self;
    if (!self.userUuid)
        self.userUuid = self.user.uuid;

    //数据库中没有缓存的时候给个菊花
    if (_shouldShowHUD == YES) [self.view showHUDNoHide];

    [WYUserDetailApi retrieveUserDetail:self.userUuid Block:^(NSArray *postArr, WYUserDetail *userInfo, NSArray *photoArr, WYUserExtra *userExtra, BOOL hasDetail) {
        if (hasDetail == YES) {
            if (postArr.count > 0) {
                [weakSelf.postArr removeAllObjects];
                [weakSelf.postArr addObjectsFromArray:postArr];
            }
            if (photoArr.count > 0) {
                [weakSelf.photoArr removeAllObjects];
                [weakSelf.photoArr addObjectsFromArray:photoArr];
            }
            weakSelf.userInfo = userInfo;
            weakSelf.userExtra = userExtra;
            [weakSelf calculateHeaderHeight];
            [weakSelf resetPagerTabView];
            [weakSelf resetHeaderView];
            if (_shouldShowHUD == YES) {
                [weakSelf.view hideAllHUD];
                _shouldShowHUD = NO;
            }
        } else {
            [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
        }
    }];
}


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    _stop = NO;
    self.navigationController.navigationBar.subviews[0].alpha = _naviAlpha;
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.subviews[0].alpha = 1;
    self.navigationController.navigationBar.translucent = YES;
    _stop = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -kStatusAndBarHeight, kAppScreenWidth, kStatusAndBarHeight)];
    view.backgroundColor = UIColorFromRGBA(0xffffff, 1);
    [self.view addSubview:view];

    _naviAlpha = 0;
    _stop = YES;
    [self initData];
    [self initDataAddHUD];
    [self addNotification];

}

- (void)addNotification {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewScroll:) name:@"tableViewScroll" object:nil];

    //观察用户资料有没有改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfoDatasource:) name:KUpdateUserInfoDataSource object:nil];
}

- (void)updateUserInfoDatasource:(NSNotification *)noti {
    WYUserDetail *userInfo = [noti.userInfo objectForKey:@"userInfo"];
    //直接修改内存 头像 姓名 性别 地址

    self.userInfo = userInfo;
    [self resetHeaderView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tableViewScroll" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KUpdateUserInfoDataSource object:nil];
}

#pragma lazy

- (WYPagerTabView *)pagerTabView {
    if (!_pagerTabView) {
        _pagerTabView = [[WYPagerTabView alloc] initWithFrame:CGRectMake(0, -64, self.view.width, kAppScreenHeight)];

        [self.view addSubview:_pagerTabView];

        _shareVC = [WYUserShareVC new];
        _shareVC.userInfo = self.userInfo;
        _shareVC.postArr = [self.postArr mutableCopy];


        _photoVC = [WYUserPhotoVC new];
        _photoVC.imageArr = [self.photoArr mutableCopy];
        _photoVC.userInfo = self.userInfo;

        _detailVC = [WYUserDetailVC new];
        _detailVC.userInfo = self.userInfo;
        _detailVC.userExtra = self.userExtra;

        [self addChildViewController:_shareVC];
        [self addChildViewController:_photoVC];
        [self addChildViewController:_detailVC];

        _allVC = [NSMutableArray array];
        [_allVC addObjectsFromArray:@[_shareVC, _photoVC, _detailVC]];

        self.pagerTabView.delegate = self;

        //自定义
        _pagerTabView.tabButtonTitleColorForSelected = kRGB(51, 51, 51);
        _pagerTabView.selectedLineColor = kRGB(51, 51, 51);
        _pagerTabView.tabButtonTitleColorForNormal = kRGB(51, 51, 51);
        _pagerTabView.tabMargin = 0;
        _pagerTabView.selectedLineWidth = kAppScreenWidth / 3.0;
        _pagerTabView.tabFrameHeight = 40;
        //开始构建UI
        [_pagerTabView buildUI];

        //设置位置
        _pagerTabView.tabView.frame = CGRectMake(0, _headerHeight, kAppScreenWidth, 40);
        //起始选择一个tab
        [_pagerTabView selectTabWithIndex:0 animate:YES];

    }
    return _pagerTabView;
}

//tableView rebulid会闪一下 reset 另外的3个tableView又要做刷新
//但是header的高度本来是不固定的 而且用户可能在下拉 这个时候reset如果新数据算的高度不一样 那么table的contentOfset也是错的 无论如何还是需要闪一下 除非header的高度永远是一样高 才能保证位置不变 只刷新数据  所以并不能保证在用户界面已存在的位置状态下只刷新数据
- (void)resetPagerTabView {
    //设置位置
    [self.pagerTabView removeFromSuperview];
    _pagerTabView = nil;
    [self pagerTabView];

    //这种情况下位置不变是一般性的 但不是必然的  这种方案还需要重新计算tableView的contentOfset 把那一栏偏差加上
//    _pagerTabView.tabView.frame = CGRectMake(0, _headerHeight, kAppScreenWidth, 40);
//    [[_allVC[0] tableView] reloadData];
//    [[_allVC[1] collectionView]reloadData];
//    [[_allVC[2] tableView] reloadData];
}

- (WYUserDetailHeaderView *)headView {

    if (_headView == nil) {
        _headView = [[WYUserDetailHeaderView alloc] initWithFrame:CGRectMake(0, -(_headerHeight + 40), kAppScreenWidth, _headerHeight)];
        _headView.backgroundColor = [UIColor whiteColor];

        //将当前的tableView上放上 _headerView

        NSInteger index = self.pagerTabView.currentTabSelected;
        if (index == 1) {
            [[_allVC[index] collectionView] addSubview:_headView];
        } else {
            [[_allVC[index] tableView] addSubview:_headView];
        }

        [_headView setUpHeadView:self.userInfo :self.userExtra];
        [self setHeaderViewClick];
    }
    return _headView;
}

//只有一处调用 只会执行一次 可以重载
- (void)resetHeaderView {
    [self.headView removeFromSuperview];
    _headView = nil;
    [self headView];
}

- (void)setHeaderViewClick {
    __weak WYUserVC *weakSelf = self;

    _headView.viewClick = ^(NSInteger tag, UIImageView *iv, UILabel *Lb) {

        //是他
        if (self.userInfo.rel_to_me != 4) {
            if (tag == 500) {
                //他的好友
                if (self.userExtra.allow_check_friends == YES) {
                    WYUserFriendsListVC *vc = [WYUserFriendsListVC new];
                    vc.userUuid = weakSelf.userInfo.uuid;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            } else if (tag == 501) {
                //我们共同的好友
                WYCommonFriendsListVC *vc = [WYCommonFriendsListVC new];
                vc.userUuid = weakSelf.userInfo.uuid;
                [weakSelf.navigationController pushViewController:vc animated:YES];

            } else if (tag == 502) {
                [weakSelf relationBtnClick:iv label:Lb];
            } else {
                //子聊
                YZChatList *chat = [YZChatList new];
                [chat startChatWithUser:weakSelf.userInfo.user pushBy:weakSelf.navigationController];
            }

        } else {
            if (tag == 500) {
                WYSelfFriendListsVC *vc = [WYSelfFriendListsVC new];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else if (tag == 501) {
                //我关注的人
                WYInflucerListVC *vc = [WYInflucerListVC new];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else if (tag == 502) {
                //我的关注者
                WYFollowerListVC *vc = [WYFollowerListVC new];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else {
                WYGroupsVC *vc = [WYGroupsVC new];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }
    };

    _headView.buttonClick = ^{
        //去往发布页
        WYPublishVC *vc = [WYPublishVC new];
        vc.extraAppointType = 4;
        vc.extraAppointUuid = weakSelf.userInfo.uuid;
        vc.extraAppointName = weakSelf.userInfo.fullName;

        __weak WYPublishVC *weakVC = vc;
        vc.publishInfoBlock = ^(NSDictionary *dict) {
            //这行代码 比发布5中类型的VC的myBlock的 popViewController先执行
            [weakVC.navigationController popToViewController:weakSelf animated:YES];
            [WYPostApi addPostFromDict:dict WithBlock:^(WYPost *post) {
                if (post) {
                    //当前页更新数据 然后刷新
                    WYCellPostFrame *frame = [[WYCellPostFrame alloc] initWithPost:post];
                    [weakSelf.shareVC.dataSource insertObject:frame atIndex:0];
                    [weakSelf.shareVC.tableView reloadData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewPublishPostAction object:post];
                } else {
                    [OMGToast showWithText:@"未发布成功，请检查网络设置"];
                }
            }];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };

    _headView.iconClick = ^{
        if (self.userInfo.rel_to_me == 4) {
            weakSelf.changIconView = [[WYUserChangeIconView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [weakSelf.changIconView.iconIV sd_setImageWithURL:[NSURL URLWithString:weakSelf.userInfo.icon_url]];
            [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.changIconView];
            weakSelf.changIconView.cameraClick = ^{
                [weakSelf chooseImage:UIImagePickerControllerSourceTypeCamera];
            };
            weakSelf.changIconView.albumClick = ^{
                [weakSelf chooseImage:UIImagePickerControllerSourceTypePhotoLibrary];
            };
        } else {
            [WYZoomImage showWithImage:nil imageURL:weakSelf.userInfo.icon_url];
        }
    };

    _headView.goToSelfEditingClick = ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"姓名未设定" message:@"添加关注需要完善个人资料" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *actionEdit = [UIAlertAction actionWithTitle:@"立即完善" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            //前往个人资料编辑页
            [weakSelf goToSelfEditing];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {

        }];
        [alert addAction:actionEdit];
        [alert addAction:cancel];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    };
}


#pragma mark - UIImagePickerControllerDelegate


- (void)chooseImage:(UIImagePickerControllerSourceType)type {
    //将自己移除
    [_changIconView removeFromSuperview];

    //创建图片编辑控制器
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    //设置编辑类型
    imagePickerController.sourceType = type;
    //允许编辑器编辑图片
    imagePickerController.allowsEditing = YES;
    //设置代理
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {

    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *chosenImage = [info valueForKey:UIImagePickerControllerEditedImage];

    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        __block PHAssetChangeRequest *_mChangeRequest = nil;
        __block PHObjectPlaceholder *assetPlaceholder;

        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{

            _mChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:chosenImage];
            assetPlaceholder = _mChangeRequest.placeholderForCreatedAsset;

        }                                 completionHandler:^(BOOL success, NSError *error) {
            if (success) {
                PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetPlaceholder.localIdentifier] options:nil];

                __weak WYUserVC *weakSelf = self;
                [WYUserApi changeUser:self.userUuid ImageWith:[result firstObject] callback:^(WYUser *user) {
                    if (user) {
                        //更换头像
                        if (user.sex == 1) {
                            [_headView.iconIV sd_setImageWithURL:[NSURL URLWithString:user.icon_url] placeholderImage:[UIImage imageNamed:@"userMalePlaceholder"]];
                        } else {
                            [_headView.iconIV sd_setImageWithURL:[NSURL URLWithString:user.icon_url] placeholderImage:[UIImage imageNamed:@"userFemalePlaceholder"]];
                        }
                        weakSelf.userInfo.icon_url = user.icon_url;
                        //发送通知
                        [WYUser saveUserToDB:self.userInfo.user];
                        [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateUserInfoDataSource object:nil userInfo:@{@"userInfo": weakSelf.userInfo}];

                    } else {
                        [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
                    }
                }];

            } else {
                NSLog(@"write error : %@", error);
                [OMGToast showWithText:@"更换头像失败"];
                return;

            }
        }];
    } else {
        NSURL *alAssetUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithALAssetURLs:@[alAssetUrl] options:nil];

        __weak WYUserVC *weakSelf = self;
        [WYUserApi changeUser:self.userUuid ImageWith:[fetchResult firstObject] callback:^(WYUser *user) {
            if (user) {
                //更换头像
                if (user.sex == 1) {
                    [_headView.iconIV sd_setImageWithURL:[NSURL URLWithString:user.icon_url] placeholderImage:[UIImage imageNamed:@"userMalePlaceholder"]];
                } else {
                    [_headView.iconIV sd_setImageWithURL:[NSURL URLWithString:user.icon_url] placeholderImage:[UIImage imageNamed:@"userFemalePlaceholder"]];
                }
                weakSelf.userInfo.icon_url = user.icon_url;
                //发送通知
                [WYUser saveUserToDB:self.userInfo.user];
                [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateUserInfoDataSource object:nil userInfo:@{@"userInfo": weakSelf.userInfo}];

            } else {
                [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
            }
        }];

    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

//别人页面的第三个按钮
- (void)relationBtnClick:(UIImageView *)iv label:(UILabel *)Lb {

    __weak WYUserVC *weakSelf = self;

    //关注关系
    if (self.userInfo.rel_to_me == 1) {
        //相互关注
        [self showAlertView:1 imageView:iv label:Lb];

    } else if (self.userInfo.rel_to_me == 2) {
        //我关注这个人 显示的是已关注 to 100
        [self showAlertView:2 imageView:iv label:Lb];

    } else if (self.userInfo.rel_to_me == 3) {
        //这个人关注了我 显示添加
        [WYUtility requireSetAccountNameOrAlreadyHasName:^{
            [WYFollow addFollowToUuid:self.userInfo.uuid Block:^(WYFollow *follow, NSInteger status) {
                if (follow) {
                    weakSelf.userInfo.rel_to_me = 1;
                    iv.image = [UIImage imageNamed:@"other page_Mutual attention"];
                    Lb.text = @"相互关注";
                    _headView.addAttentionView.userInteractionEnabled = NO;
                    _headView.addView.image = [UIImage imageNamed:@"other page_add friends_added"];
                    _headView.realtionShipLb.text = @"你们相互关注了哦!";
                } else {
                    [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
                }
            }];
        }                           navigationController:self.navigationController];

    } else if (self.userInfo.rel_to_me == 4) {
        //我 dothing 按钮是不存在的


    } else if (self.userInfo.rel_to_me == 100) {

        [WYUtility requireSetAccountNameOrAlreadyHasName:^{
            [WYFollow addFollowToUuid:self.userInfo.uuid Block:^(WYFollow *follow, NSInteger status) {
                if (follow) {
                    weakSelf.userInfo.rel_to_me = 2;
                    iv.image = [UIImage imageNamed:@"other_page_group_followed"];
                    Lb.text = @"已关注";
                } else {
                    [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
                }

            }];
        }                           navigationController:self.navigationController];
    }
}


- (void)goToSelfEditing {
    WYSelfDetailEditing *vc = [WYSelfDetailEditing new];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)showAlertView:(int)relToMe imageView:(UIImageView *)iv label:(UILabel *)Lb {

    __weak WYUserVC *weakSelf = self;

    WYFollow *follow = [WYFollow selectFollowUuidFollowerUuid:kuserUUID influcerUuid:self.userInfo.uuid];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"取消关注" message:@"真的不再关注TA了吗？" preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *action = [UIAlertAction actionWithTitle:@"不再关注" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        if (relToMe == 1) {
            [WYFollow delFollow:follow.uuid Block:^(BOOL res) {
                if (res) {
                    weakSelf.userInfo.rel_to_me = 3;
                    _headView.addAttentionView.userInteractionEnabled = YES;
                    _headView.realtionShipLb.text = @"ta关注了你哦,点击关注ta吧!";
                    _headView.addView.image = [UIImage imageNamed:@"other page_add friendsother page_add friends"];
                    iv.image = [UIImage imageNamed:@"other page_attention"];
                    Lb.text = @"添加关注";
                } else {
                    [OMGToast showWithText:@"未能成功取消关注"];
                }
            }];
        } else if (relToMe == 2) {
            [WYFollow delFollow:follow.uuid Block:^(BOOL res) {
                if (res) {
                    weakSelf.userInfo.rel_to_me = 100;
                    iv.image = [UIImage imageNamed:@"other page_attention"];
                    Lb.text = @"添加关注";
                } else {
                    [OMGToast showWithText:@"未能成功取消关注"];
                }
            }];
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {

    }];
    [alert addAction:action];
    [alert addAction:cancel];

    [self presentViewController:alert animated:YES completion:nil];
}

//判断是不是自己来决定右上角的按钮
- (BOOL)isSelf {
    if ([self.userUuid isEqualToString:kuserUUID]) return YES;
    return NO;
}

- (void)setUpNavigationView {

    UIImage *backImg = [[UIImage imageNamed:@"naviLeftWhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;


    UIImage *rightImage = [[UIImage imageNamed:@"naviRightWhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}


- (void)leftAction {
    if (_isPresent == YES) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (UIView *)titleView {

    if (_titleView == nil) {
        _titleView = [UIView new];
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
        _titleView.layer.borderColor = UIColorFromHex(0x4a90e2).CGColor;
        _titleView.layer.borderWidth = 1;
        _titleView.layer.cornerRadius = 17;
        _titleView.clipsToBounds = YES;
        _titleView.hidden = YES;
        UIImageView *icon = [UIImageView new];
        [_titleView addSubview:icon];
        icon.layer.borderWidth = 1;
        icon.layer.borderColor = [UIColor whiteColor].CGColor;
        icon.layer.cornerRadius = 16;
        icon.clipsToBounds = YES;
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(1, 1, 1, 1));
        }];

        [icon sd_setImageWithURL:[NSURL URLWithString:self.userInfo.icon_url]];
        self.navigationItem.titleView = _titleView;
    }

    return _titleView;
}

#pragma buttonClick

- (void)rightBtnClick {
    //更多
    if ([self isSelf] == YES) {
        WYSelfSettingsVC *vc = [WYSelfSettingsVC new];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        WYPrivacySettingsVC *vc = [WYPrivacySettingsVC new];
        vc.userUuid = self.userUuid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma notification

- (void)tableViewScroll:(NSNotification *)sender {

    if (_stop == YES) return;

    //40表示选项卡高度
    CGFloat y = [[sender.userInfo objectForKey:@"contenty"] floatValue];

    if (y > -40 - _headerHeight && y < -(40 + 64)) {

        CGPoint origin = self.pagerTabView.tabView.frame.origin;
        origin.y = -y - 40;
        self.pagerTabView.tabView.origin = origin;

    } else if (y >= -(40 + 64)) {

        //可能滑动的比较快 间隙比较大 将位置放准确
        self.pagerTabView.tabView.origin = CGPointMake(0, 64);

    } else {

        //头视图和tab 都要往下 做成下拉刷新的样子
        CGPoint origin = self.pagerTabView.tabView.frame.origin;
        origin.y = -y - 40;
        self.pagerTabView.tabView.origin = origin;

        CGRect headRect = CGRectMake(0, -(_headerHeight + 40) - (-y - (_headerHeight + 40)), kAppScreenWidth, -y - 40);
        self.headView.frame = headRect;

        CGRect frame = self.headView.groudIV.frame;
        frame.origin.y = 0;
        frame.size.height = imageHeight - y - _headerHeight - 40;
        self.headView.groudIV.frame = frame;
    }

    /*
     一直往上移动  图片高度-22-20
     */
    if ((y > -40 - _headerHeight) && (y < (-40 - _headerHeight + imageHeight - 22 - 20))) {

        CGFloat width = ((_headerHeight + 40) - (-y)) * (34 - 120) / (imageHeight - 42) + 120;
        self.headView.iconIV.transform = CGAffineTransformMakeScale(width / 120, width / 120);
        self.headView.iconIV.hidden = NO;
        self.titleView.hidden = YES;

    } else if (y >= -40 - _headerHeight + imageHeight - 22 - 20) {
        self.headView.iconIV.transform = CGAffineTransformMakeScale(34.0 / 120, 34.0 / 120);
        self.headView.iconIV.hidden = YES;
        self.titleView.hidden = NO;
    } else {
        self.headView.iconIV.transform = CGAffineTransformMakeScale(1, 1);
        self.headView.iconIV.hidden = NO;
        self.titleView.hidden = YES;
    }

    if ((y > -40 - _headerHeight + imageHeight - 22 - 20) && y < -(40 + 64)) {

        //换黑色
        self.navigationItem.leftBarButtonItem.image = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.rightBarButtonItem.image = [[UIImage imageNamed:@"naviRightBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //导航栏的透明度逐渐变化
        CGFloat h = -40 - _headerHeight + imageHeight - 22 - 20;
        _naviAlpha = self.navigationController.navigationBar.subviews[0].alpha = (y - h) / (-104 - h);

    } else if (y >= -(40 + 64)) {
        //换黑色
        self.navigationItem.leftBarButtonItem.image = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.rightBarButtonItem.image = [[UIImage imageNamed:@"naviRightBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _naviAlpha = self.navigationController.navigationBar.subviews[0].alpha = 1;
    } else {
        //换白色
        self.navigationItem.leftBarButtonItem.image = [[UIImage imageNamed:@"naviLeftWhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.rightBarButtonItem.image = [[UIImage imageNamed:@"naviRightWhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _naviAlpha = self.navigationController.navigationBar.subviews[0].alpha = 0;

    }


}


#pragma mark - WYPagerTabView Delegate

- (NSUInteger)numberOfPagers:(WYPagerTabView *)view {
    return [_allVC count];
}

- (UIViewController *)pagerViewOfPagers:(WYPagerTabView *)view indexOfPagers:(NSUInteger)number {
    return _allVC[number];
}


#pragma delegate

//为了安全 这两个方法在几个代理方法中调用了 所以判断一下父视图
- (void)bodyScrollViewWillBeginDragging:(UIScrollView *)scrollView {

    if (![_headView.superview isKindOfClass:[UIScrollView class]]) {
        return;
    }
    //将第一个tableView身上放置 _headerView
    [_headView removeFromSuperview];
    //根据content算出 位置
    CGPoint offset = scrollView.contentOffset;
    int index = offset.x / scrollView.frame.size.width;
    UIViewController *oldTableVC = self.allVC[index];

    CGPoint contentOffset;
    if (index == 0) {
        contentOffset = ((WYUserShareVC *) oldTableVC).tableView.contentOffset;
    } else if (index == 1) {
        contentOffset = ((WYUserPhotoVC *) oldTableVC).collectionView.contentOffset;
    } else {
        contentOffset = ((WYUserDetailVC *) oldTableVC).tableView.contentOffset;
    }

    CGPoint origin = _headView.origin;
    origin.y = -contentOffset.y - 40 - _headerHeight - 64;
    _headView.origin = origin;
    [self.view addSubview:_headView];

}

- (void)bodyScrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    if ([_headView.superview isKindOfClass:[UIScrollView class]]) {
        return;
    }
    //将第一个tableView身上放置 _headerView
    [_headView removeFromSuperview];

    CGPoint offset = scrollView.contentOffset;
    int index = offset.x / scrollView.frame.size.width;
    UIViewController *oldTableVC = self.allVC[index];

    CGPoint origin = _headView.origin;
    origin.y = -(_headerHeight + 40);
    _headView.origin = origin;

    if (index == 0) {
        [((WYUserShareVC *) oldTableVC).tableView addSubview:_headView];
    } else if (index == 1) {
        [((WYUserPhotoVC *) oldTableVC).collectionView addSubview:_headView];
    } else {
        [((WYUserDetailVC *) oldTableVC).tableView addSubview:_headView];
    }
}

- (void)whenSelectOnPager:(NSUInteger)number {

}
@end
