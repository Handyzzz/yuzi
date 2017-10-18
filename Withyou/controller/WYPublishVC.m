//
//  WYPublishVC.m
//  Withyou
//
//  Created by Tong Lu on 7/28/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import "WYPublishVC.h"
#import "WYPublishTextVC.h"
#import "WYPhotoListVC.h"
#import "WYAddLinkVC.h"
#import "WYAddSinglePhotoVC.h"
#import "WYAddVideoViewController.h"
#import "WYClassifyCollectionViewCell.h"
#import "WYSelectGroupsOrFriendsVC.h"
#import "WYPublishClassesView.h"
#import "WYAddArticleVC.h"


#define classifyViewHeight 0

#define publishViewHeight (kAppScreenHeight - classifyViewHeight - 64)

#define PublishKey     [NSString stringWithFormat:@"PublishKey_%@",(kuserUUID)]

static NSString *cellIdentifier = @"cellIdentifier";

@interface WYPublishVC () <UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate> {
    NSArray *_selectorArray;
    NSArray *_visibilityArray;
}

@end

@implementation WYPublishVC

- (void)loadData {
    _visibilityArray = @[@"公开", @"好友", @"群组", @"指定朋友", @"自己"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"发布";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNaviItem];
    [self loadData];
    [self addLongpressGestureRecognize];
    [self addPublishClassesView];
    [self.view addSubview:self.classifyCollectionView];
}


- (void)setNaviItem {

    if (self.navigationController.viewControllers.count > 1) {
        UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];

        self.navigationItem.leftBarButtonItem = leftBtnItem;
    }
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addPublishClassesView {
    CGFloat topMargin = 64 + classifyViewHeight;
    WYPublishClassesView *view = [[WYPublishClassesView alloc] initWithFrame:CGRectMake(0, topMargin, kAppScreenWidth, publishViewHeight)];
    view.backgroundColor = kRGB(232, 240, 244);
    [view setViewData];
    view.contentClick = ^(PublishType Type) {
        switch (Type) {
            case 1:
                [self addVideoAction];
                break;
            case 2:
                [self addAlbumAction];
                break;
            case 3:
                [self addLinkAction];
                break;
            case 4:
                [self addSingleImageAction];
                break;
            case 5:
                [self addPureTextAction];
                break;
            case 6:
                [self addArticleAction];
                break;

            default:
                break;
        }
    };
    [self.view addSubview:view];
}

- (UICollectionView *)classifyCollectionView {
    if (_classifyCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        CGFloat width = (long) (([UIScreen mainScreen].bounds.size.width) / 3.0);
        CGFloat height = classifyViewHeight;
        layout.itemSize = CGSizeMake(width, height);

        _classifyCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kAppScreenWidth, classifyViewHeight) collectionViewLayout:layout];
        _classifyCollectionView.backgroundColor = [UIColor whiteColor];
        _classifyCollectionView.delegate = self;
        _classifyCollectionView.dataSource = self;
        _classifyCollectionView.scrollsToTop = NO;
        [_classifyCollectionView registerClass:[WYClassifyCollectionViewCell class] forCellWithReuseIdentifier:@"WYClassifyCollectionViewCell"];
        _classifyCollectionView.scrollEnabled = NO;
        _classifyCollectionView.bounces = NO;
    }
    return _classifyCollectionView;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //暂时不用后边两个
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    WYClassifyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WYClassifyCollectionViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.classifyIV.hidden = YES;
    cell.classifyLb.text = _visibilityArray[indexPath.row];
    cell.leftLineView.hidden = indexPath.row == 0 ? YES : NO;

    //有预选的情况下另外 优先
    if (self.extraAppointType > 0) {
        if (indexPath.row == self.extraAppointType - 1) {
            _sectionName = self.extraAppointName;
            cell.classifyLb.text = self.sectionName;
            cell.classifyLb.textColor = kRGB(51, 51, 51);
            cell.classifyLb.font = [UIFont systemFontOfSize:15 weight:0.4];
            self.publishVisibleScopeType = self.extraAppointType;
            self.targetUuid = self.extraAppointUuid;
            cell.classifyIV.hidden = NO;
        }
    } else {

        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        switch (indexPath.row) {
            case 0:
                if ([[user objectForKey:PublishKey] isEqual:@1]) {
                    _sectionName = @"公开";
                    cell.classifyLb.text = self.sectionName;
                    cell.classifyLb.textColor = kRGB(51, 51, 51);
                    cell.classifyLb.font = [UIFont systemFontOfSize:15 weight:0.4];
                    self.publishVisibleScopeType = 1;
                    self.targetUuid = @"00000000-0000-0000-0000-000000000000";
                    cell.classifyIV.hidden = NO;
                } else if (![[user objectForKey:PublishKey] isEqual:@2] && ![[user objectForKey:PublishKey] isEqual:@5]) {
                    _sectionName = @"公开";
                    cell.classifyLb.text = self.sectionName;
                    cell.classifyLb.textColor = kRGB(51, 51, 51);
                    cell.classifyLb.font = [UIFont systemFontOfSize:15 weight:0.4];
                    self.publishVisibleScopeType = 1;
                    self.targetUuid = @"00000000-0000-0000-0000-000000000000";
                    cell.classifyIV.hidden = NO;
                }
                break;
            case 1:
                if ([[user objectForKey:PublishKey] isEqual:@2]) {
                    _sectionName = @"好友";
                    cell.classifyLb.text = self.sectionName;
                    cell.classifyLb.textColor = kRGB(51, 51, 51);
                    cell.classifyLb.font = [UIFont systemFontOfSize:15 weight:0.4];
                    self.targetUuid = @"11111111-1111-1111-1111-111111111111";
                    self.publishVisibleScopeType = 2;
                    cell.classifyIV.hidden = NO;
                }
                break;
            case 4:
                if ([[user objectForKey:PublishKey] isEqual:@5]) {
                    _sectionName = @"自己";
                    cell.classifyLb.text = self.sectionName;
                    cell.classifyLb.textColor = kRGB(51, 51, 51);
                    cell.classifyLb.font = [UIFont systemFontOfSize:15 weight:0.4];
                    self.targetUuid = kLocalSelf.uuid;
                    self.publishVisibleScopeType = 5;
                    cell.classifyIV.hidden = NO;
                }
                break;
            default:
                break;
        }
    }
    return cell;
}

//将当前选中Cell的颜色变成蓝色
- (void)ChangeTheCellBlueColor:(UICollectionView *)collectionView :(NSIndexPath *)indexPath {
    WYClassifyCollectionViewCell *cell = (WYClassifyCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.section == 0 && indexPath.row == 2) {
        self.lastGroupIsLight = YES;
    } else {
        self.lastGroupIsLight = NO;
    }
    if (indexPath.section == 0 && indexPath.row == 3) {
        self.lastFriendIsLight = YES;
    } else {
        self.lastFriendIsLight = NO;
    }
    cell.classifyIV.hidden = NO;
    cell.classifyLb.text = self.sectionName;
    cell.classifyLb.textColor = kRGB(51, 51, 51);
    cell.classifyLb.font = [UIFont systemFontOfSize:15 weight:0.4];

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WYSelectGroupsOrFriendsVC *VC;
    __weak WYPublishVC *weakSelf = self;
    if (indexPath.row == 0) {
        _sectionName = @"公开";
        [self CleanAllCellColor];
        self.publishVisibleScopeType = 1;
        self.targetUuid = @"00000000-0000-0000-0000-000000000000";
        [self ChangeTheCellBlueColor:collectionView :indexPath];
    } else if (indexPath.row == 1) {
        _sectionName = @"好友";
        [self CleanAllCellColor];
        self.targetUuid = @"11111111-1111-1111-1111-111111111111";
        self.publishVisibleScopeType = 2;
        [self ChangeTheCellBlueColor:collectionView :indexPath];
    } else if (indexPath.row == 2) {
        VC = [WYSelectGroupsOrFriendsVC new];
        VC.selectType = APPOINTGROUPSTYPE;
        VC.hidesBottomBarWhenPushed = YES;
        VC.visiableScopeBlock = ^(NSString *targetUuid, NSString *name, WYGroup *group, BOOL haveSelected) {
            if (haveSelected == YES) {
                weakSelf.group = group;
                weakSelf.sectionName = name;
                [weakSelf CleanAllCellColor];
                weakSelf.targetUuid = targetUuid;
                weakSelf.publishVisibleScopeType = 3;
                [weakSelf ChangeTheCellBlueColor:collectionView :indexPath];
            } else {
                //如果没有任何选择 并且上一次不是按的群组按钮  说明它是并没有在群组列表中选择 只是过去(按同一个按钮然后取消 或者什么都没干)那么我们几不做任何操作

                //如果没有任何选择  并且上一次点击过群组按钮并且选择过某个群组(第三个按钮高亮的情况) 我们就让它回到第一个按钮 这说明是它之前选择过了 这次没有返回选择 是说明他这次过去的做的是取消了上次的选择 (进入到群组邀请的时候还有默认选择的 那个时候也应该返回选择 虽然不是你选的)
                if (weakSelf.lastGroupIsLight) {
                    weakSelf.sectionName = @"公开";
                    [weakSelf CleanAllCellColor];
                    weakSelf.publishVisibleScopeType = 1;
                    [weakSelf ChangeTheCellBlueColor:collectionView :[NSIndexPath indexPathForRow:0 inSection:0]];
                }
            }
        };
        //uid什么时候传过去 上次是高亮的时候
        if (_lastGroupIsLight) {
            VC.Uuid = self.targetUuid;
        }
        [self.navigationController pushViewController:VC animated:YES];

    } else if (indexPath.row == 3) {
        VC = [WYSelectGroupsOrFriendsVC new];
        VC.selectType = APPOINTFRIENDSTYPE;
        VC.hidesBottomBarWhenPushed = YES;
        VC.visiableScopeBlock = ^(NSString *targetUuid, NSString *name, WYGroup *group, BOOL haveSelectd) {
            if (haveSelectd) {
                weakSelf.sectionName = name;
                [weakSelf CleanAllCellColor];
                weakSelf.targetUuid = targetUuid;
                weakSelf.publishVisibleScopeType = 4;
                [weakSelf ChangeTheCellBlueColor:collectionView :indexPath];
            } else {
                //如果没有任何选择 并且上一次不是按的群组按钮  说明它是并没有在群组列表中选择 只是过去(按同一个按钮然后取消 或者什么都没干)那么我们几不做任何操作

                //如果没有任何选择  并且上一次点击过群组按钮并且选择过某个群组(第三个按钮高亮的情况) 我们就让它回到第一个按钮 这说明是它之前选择过了 这次没有返回选择 是说明他这次过去的做的是取消了上次的选择 (进入到群组邀请的时候还有默认选择的 那个时候也应该返回选择 虽然不是你选的)
                if (weakSelf.lastFriendIsLight) {
                    weakSelf.sectionName = @"公开";
                    [weakSelf CleanAllCellColor];
                    weakSelf.publishVisibleScopeType = 1;
                    [weakSelf ChangeTheCellBlueColor:collectionView :[NSIndexPath indexPathForRow:0 inSection:0]];
                }

            }

        };

        //uid什么时候传过去 上次是高亮的时候
        if (_lastFriendIsLight) {
            VC.Uuid = self.targetUuid;
        }
        [self.navigationController pushViewController:VC animated:YES];
    } else if (indexPath.row == 4) {
        _sectionName = @"自己";
        [self CleanAllCellColor];
        self.targetUuid = kLocalSelf.uuid;
        self.publishVisibleScopeType = 5;
        [self ChangeTheCellBlueColor:collectionView :indexPath];
    }
}

//清除所有CollectionVeiwCell的颜色
- (void)CleanAllCellColor {
    for (int i = 0; i < 5; i++) {
        NSIndexPath *clearIndexPath = [NSIndexPath indexPathForItem:i inSection:0];
        WYClassifyCollectionViewCell *cell = (WYClassifyCollectionViewCell *) [self.classifyCollectionView cellForItemAtIndexPath:clearIndexPath];
        cell.classifyIV.hidden = YES;
        cell.classifyLb.textColor = kRGB(140, 149, 153);
        cell.classifyLb.font = [UIFont systemFontOfSize:14];
    }
}

- (void)addLongpressGestureRecognize {
    // attach long press gesture to collectionView
    UILongPressGestureRecognizer *lpgr
            = [[UILongPressGestureRecognizer alloc]
                    initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.delegate = self;
    lpgr.delaysTouchesBegan = YES;
    [self.classifyCollectionView addGestureRecognizer:lpgr];
}


- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }

    CGPoint p = [gestureRecognizer locationInView:self.classifyCollectionView];

    NSIndexPath *indexPath = [self.classifyCollectionView indexPathForItemAtPoint:p];
    if (indexPath == nil) {
        NSLog(@"couldn't find index path");
    } else {
        WYSelectGroupsOrFriendsVC *VC;
        __weak WYPublishVC *weakSelf = self;

        if (indexPath.row == 0) {
            _sectionName = @"公开";
            [self CleanAllCellColor];
            [self ChangeTheCellBlueColor:self.classifyCollectionView :indexPath];
            [self addAlertView:1];
        } else if (indexPath.row == 1) {
            _sectionName = @"好友";
            [self CleanAllCellColor];
            [self ChangeTheCellBlueColor:self.classifyCollectionView :indexPath];
            [self addAlertView:2];
        } else if (indexPath.row == 2) {
            VC = [WYSelectGroupsOrFriendsVC new];
            VC.selectType = APPOINTGROUPSTYPE;
            VC.hidesBottomBarWhenPushed = YES;
            VC.visiableScopeBlock = ^(NSString *targetUuid, NSString *name, WYGroup *group, BOOL haveSelected) {
                if (haveSelected) {
                    weakSelf.group = group;
                    weakSelf.sectionName = name;
                    [weakSelf CleanAllCellColor];
                    [weakSelf ChangeTheCellBlueColor:weakSelf.classifyCollectionView :indexPath];
                    weakSelf.targetUuid = targetUuid;
                    weakSelf.publishVisibleScopeType = 3;
                } else {
                    //如果没有任何选择 并且上一次不是按的群组按钮  说明它是并没有在群组列表中选择 只是过去(按同一个按钮然后取消 或者什么都没干)那么我们几不做任何操作

                    //如果没有任何选择  并且上一次点击过群组按钮并且选择过某个群组(第三个按钮高亮的情况) 我们就让它回到第一个按钮 这说明是它之前选择过了 这次没有返回选择 是说明他这次过去的做的是取消了上次的选择 (进入到群组邀请的时候还有默认选择的 那个时候也应该返回选择 虽然不是你选的)
                    if (weakSelf.lastGroupIsLight) {
                        weakSelf.sectionName = @"公开";
                        [weakSelf CleanAllCellColor];
                        weakSelf.publishVisibleScopeType = 1;
                        [weakSelf ChangeTheCellBlueColor:weakSelf.classifyCollectionView :[NSIndexPath indexPathForRow:0 inSection:0]];
                    }

                }

            };
            if (_lastGroupIsLight) {
                VC.Uuid = self.targetUuid;
            }
            [self.navigationController pushViewController:VC animated:YES];
        } else if (indexPath.row == 3) {
            VC = [WYSelectGroupsOrFriendsVC new];
            VC.selectType = APPOINTFRIENDSTYPE;
            VC.hidesBottomBarWhenPushed = YES;
            VC.visiableScopeBlock = ^(NSString *targetUuid, NSString *name, WYGroup *group, BOOL haveSelected) {
                if (haveSelected) {
                    weakSelf.sectionName = name;
                    [weakSelf CleanAllCellColor];
                    [weakSelf ChangeTheCellBlueColor:weakSelf.classifyCollectionView :indexPath];
                    weakSelf.targetUuid = targetUuid;
                    weakSelf.publishVisibleScopeType = 3;
                } else {
                    //如果没有任何选择 并且上一次不是按的群组按钮  说明它是并没有在群组列表中选择 只是过去(按同一个按钮然后取消 或者什么都没干)那么我们几不做任何操作

                    //如果没有任何选择  并且上一次点击过群组按钮并且选择过某个群组(第三个按钮高亮的情况) 我们就让它回到第一个按钮 这说明是它之前选择过了 这次没有返回选择 是说明他这次过去的做的是取消了上次的选择 (进入到群组邀请的时候还有默认选择的 那个时候也应该返回选择 虽然不是你选的)
                    if (weakSelf.lastFriendIsLight) {
                        weakSelf.sectionName = @"公开";
                        [weakSelf CleanAllCellColor];
                        weakSelf.publishVisibleScopeType = 1;
                        [weakSelf ChangeTheCellBlueColor:weakSelf.classifyCollectionView :[NSIndexPath indexPathForRow:0 inSection:0]];
                    }
                }
            };
            if (_lastFriendIsLight) {
                VC.Uuid = self.targetUuid;
            }
            [self.navigationController pushViewController:VC animated:YES];
        } else if (indexPath.row == 4) {
            _sectionName = @"自己";
            [self CleanAllCellColor];
            [self ChangeTheCellBlueColor:self.classifyCollectionView :indexPath];
            [self addAlertView:5];
        }
    }
}

- (void)addAlertView:(int)i {
    [[[UIAlertView alloc] initWithTitle:@"可见范围"
                                message:@"是否记住此选项？"
                       cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
                           return;
                       }]
                       otherButtonItems:[RIButtonItem itemWithLabel:@"记住" action:^{

                           NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                           switch (i) {
                               case 1:
                                   self.publishVisibleScopeType = 1;
                                   self.targetUuid = @"00000000-0000-0000-0000-000000000000";
                                   [user setObject:@1 forKey:PublishKey];
                                   [[NSUserDefaults standardUserDefaults] synchronize];
                                   break;
                               case 2:
                                   self.targetUuid = @"11111111-1111-1111-1111-111111111111";
                                   self.publishVisibleScopeType = 2;
                                   [user setObject:@2 forKey:PublishKey];
                                   [[NSUserDefaults standardUserDefaults] synchronize];
                                   break;
                               case 5:
                                   self.targetUuid = kLocalSelf.uuid;
                                   self.publishVisibleScopeType = 5;
                                   [user setObject:@5 forKey:PublishKey];
                                   [[NSUserDefaults standardUserDefaults] synchronize];
                                   break;
                               default:
                                   break;
                           }

                       }], nil] show];
}

#pragma mark - Actions

- (void)addPureTextAction {
    __weak WYPublishVC *weakSelf = self;
    WYPublishTextVC *vc = [[WYPublishTextVC alloc] init];
    if (self.group) {
        vc.group = self.group;
    }

    vc.publishVisibleScopeType = self.publishVisibleScopeType;
    vc.scopeTitle = _sectionName;
    vc.myBlock = ^(NSString *text, NSArray *mention, int publishVisibleScopeType, NSString *targetUuid, NSString *title, YZAddress *address, NSArray *remindArr, NSArray *pdfs, NSArray *photos, NSArray *tagsArr) {
        if (!title) {
            title = @"";
        }

        NSMutableDictionary *md = [@{@"content": text, @"type": @1, @"title": title} mutableCopy];
        if (mention) {
            [md setObject:mention forKey:@"mention"];
        }
        if (address) {
            [md setObject:@{
                    @"name": address.name,
                    @"lat": address.lat,
                    @"lng": address.lng
            }      forKey:@"address"];
        }
        remindArr = [self calculateRemindUuidArr:remindArr];
        if (remindArr.count > 0) {
            [md setObject:remindArr forKey:@"with"];
        }
        pdfs = [self calculatePdfsUuidArr:pdfs];
        if (pdfs.count > 0) {
            [md setObject:pdfs forKey:@"pdfs"];
        }
        //需要 photo dic asset image
        if (photos.count > 0) {
            [md setObject:photos forKey:@"photos"];
        }
        if (tagsArr.count > 0) {
            [md setObject:tagsArr forKey:@"tags"];
        }

        [weakSelf publishPostInfo:[md copy] publishVisibleScopeType:publishVisibleScopeType targetUuid:targetUuid];
    };

    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addSingleImageAction {
    __weak WYPublishVC *weakSelf = self;

    WYAddSinglePhotoVC *vc = [[WYAddSinglePhotoVC alloc] init];
    if (self.group) {
        vc.group = self.group;
    }
    vc.publishVisibleScopeType = self.publishVisibleScopeType;
    vc.scopeTitle = _sectionName;
    vc.myBlock = ^(PHAsset *asset, NSString *text, NSArray *mention, int publishVisibleScopeType, NSString *targetUuid, YZAddress *address, NSArray *remindArr, NSArray *tagsArr) {

        remindArr = [self calculateRemindUuidArr:remindArr];
        NSMutableDictionary *md = [@{@"content": text, @"photos": @[asset], @"type": @2} mutableCopy];
        if (mention) {
            [md setObject:mention forKey:@"mention"];
        }
        if (address) {
            [md setObject:@{
                    @"name": address.name,
                    @"lat": address.lat,
                    @"lng": address.lng
            }      forKey:@"address"];
        }
        if (remindArr.count > 0) {
            [md setObject:remindArr forKey:@"with"];
        }
        if (tagsArr.count > 0) {
            [md setObject:tagsArr forKey:@"tags"];
        }
        [weakSelf publishPostInfo:[md copy] publishVisibleScopeType:publishVisibleScopeType targetUuid:targetUuid];


    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addAlbumAction {
    __weak WYPublishVC *weakSelf = self;
    WYPhotoListVC *vc = [WYPhotoListVC new];
    if (self.group) {
        vc.group = self.group;
    }
    vc.publishVisibleScopeType = self.publishVisibleScopeType;
    vc.scopeTitle = _sectionName;
    vc.myBlock = ^(NSArray *album, NSString *text, NSString *title, NSArray *mention, int publishVisibleScopeType, NSString *targetUuid, YZAddress *address, NSArray *remindArr, NSArray *tagsArr) {

        remindArr = [self calculateRemindUuidArr:remindArr];
        NSMutableDictionary *md = [@{@"content": text, @"photos": album, @"album_title": title, @"type": @3} mutableCopy];
        if (mention) {
            [md setObject:mention forKey:@"mention"];
        }
        if (address) {
            [md setObject:@{
                    @"name": address.name,
                    @"lat": address.lat,
                    @"lng": address.lng
            }      forKey:@"address"];
        }
        if (remindArr.count > 0) {
            [md setObject:remindArr forKey:@"with"];
        }
        if (tagsArr.count > 0) {
            [md setObject:tagsArr forKey:@"tags"];
        }
        [weakSelf publishPostInfo:[md copy] publishVisibleScopeType:publishVisibleScopeType targetUuid:targetUuid];

    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addLinkAction {
    __weak WYPublishVC *weakSelf = self;
    WYAddLinkVC *vc = [[WYAddLinkVC alloc] init];
    if (self.group) {
        vc.group = self.group;
    }
    vc.publishVisibleScopeType = self.publishVisibleScopeType;
    vc.scopeTitle = _sectionName;
    vc.myBlock = ^(NSString *comment, NSArray *mention, NSString *originalImageUrl, NSString *title, NSString *url, int publishVisibleScopeType, NSString *targetUuid, YZAddress *address, NSArray *remindArr, NSArray *tagsArr) {

        remindArr = [self calculateRemindUuidArr:remindArr];
        NSMutableDictionary *md = [@{@"content": comment, @"link": @{@"url": url, @"title": title, @"original_thumbnail_url": originalImageUrl}, @"type": @4} mutableCopy];
        if (mention) {
            [md setObject:mention forKey:@"mention"];
        }
        if (address) {
            [md setObject:@{
                    @"name": address.name,
                    @"lat": address.lat,
                    @"lng": address.lng
            }      forKey:@"address"];
        }
        if (remindArr.count > 0) {
            [md setObject:remindArr forKey:@"with"];
        }
        if (tagsArr.count > 0) {
            [md setObject:tagsArr forKey:@"tags"];
        }
        [weakSelf publishPostInfo:[md copy] publishVisibleScopeType:publishVisibleScopeType targetUuid:targetUuid];
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addVideoAction {
    __weak WYPublishVC *weakSelf = self;
    WYAddVideoViewController *vc = [[WYAddVideoViewController alloc] init];
    if (self.group) {
        vc.group = self.group;
    }
    vc.publishVisibleScopeType = self.publishVisibleScopeType;
    vc.scopeTitle = _sectionName;
    vc.myBlock = ^(PHAsset *asset, NSString *text, NSArray *mention, int publishVisibleScopeType, NSString *targetUuid, YZAddress *address, NSArray *remindArr, NSArray *tagsArr) {

        remindArr = [self calculateRemindUuidArr:remindArr];
        NSMutableDictionary *md = [@{@"content": text, @"video": asset, @"type": @5} mutableCopy];
        if (mention) {
            [md setObject:mention forKey:@"mention"];
        }
        if (address) {
            [md setObject:@{
                    @"name": address.name,
                    @"lat": address.lat,
                    @"lng": address.lng
            }      forKey:@"address"];
        }
        if (remindArr.count > 0) {
            [md setObject:remindArr forKey:@"with"];
        }
        if (tagsArr.count > 0) {
            [md setObject:tagsArr forKey:@"tags"];
        }
        [weakSelf publishPostInfo:[md copy] publishVisibleScopeType:publishVisibleScopeType targetUuid:targetUuid];
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)addArticleAction{
    WYAddArticleVC *vc = [[WYAddArticleVC alloc] init];
    [vc setDidReceiveBlock:^(NSString *result) {
        [self handleScannedResult:result];
    }];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
- (void)handleScannedResult:(NSString *)result{
    
    if([self handleLocalLoginTest:result])
        return;
    
    if([result hasPrefix:[kBaseURL stringByAppendingString:@"/api/v1/qrweb_login/"]])
    {
        NSURL *url = [NSURL URLWithString:result];
        NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
        NSArray *queryItems = [components queryItems];
        NSString *uuid;
        for (NSURLQueryItem *item in queryItems)
        {
            if([item.name isEqualToString:@"uuid"]){
                uuid = item.value;
                break;
            }
        }
        
        if(!uuid){
            return;
        }
        else{
            debugLog(@"web login uuid is %@", uuid);
            [[[UIAlertView alloc] initWithTitle:@"是否登录与子网页版"
                                        message:@"请选择下一步的操作"
                               cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^(){
                return;
            }]
                               otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^(){
                [self requestUrlWithUuid:uuid];
            }],
              nil] show];
        }
    }else if([result hasPrefix:[NSString stringWithFormat:@"%@/add/u/",kBaseURL]]) {
        debugLog(@"add u");
        [WYUtility handleAddFriendQrcodeUrl:[result escapedURL]];
    }
    else if([result hasPrefix:[NSString stringWithFormat:@"%@/add/g/",kBaseURL]]){
        //加入群组的操作
        debugLog(@"add g");
        [WYUtility handleAddGroupQrcodeUrl:[result escapedURL]];
    }
    else{
        [WYUtility openURL:[result escapedURL]];
    }
}

- (void)requestUrlWithUuid:(NSString *)uuid
{
    NSString *s = [NSString stringWithFormat:@"%@/%@%@", kBaseURL, kApiVersion, kqrCodeScanAddress];
    [[WYHttpClient sharedClient] GET:s parameters:@{@"uuid": uuid} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [WYUtility showAlertWithTitle:@"登录请求已成功发送"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [WYUtility showAlertWithTitle:@"请求未成功，请刷新二维码再试一次"];
    }];
}


- (BOOL)handleLocalLoginTest:(NSString *)result
{
    NSString *localBaseURL = @"http://192.168.3.21:8000";
    //    debugLog(@"local result %@", result);
    if([result hasPrefix:[localBaseURL stringByAppendingString:@"/api/v1/qrweb_login/"]])
    {
        debugLog(@"inside");
        NSURL *url = [NSURL URLWithString:result];
        NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
        NSArray *queryItems = [components queryItems];
        NSString *uuid;
        for (NSURLQueryItem *item in queryItems)
        {
            if([item.name isEqualToString:@"uuid"]){
                uuid = item.value;
                break;
            }
        }
        
        if(!uuid){
            [WYUtility showAlertWithTitle:@"no uuid found"];
        }
        else{
            debugLog(@"uuid is %@", uuid);
            [[[UIAlertView alloc] initWithTitle:@"是否登录与子网页版本地测试？"
                                        message:@"请选择下一步的操作"
                               cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^(){
                return;
            }]
                               otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^(){
                
                NSString *s = [NSString stringWithFormat:@"%@/%@%@", localBaseURL, kApiVersion, kqrCodeScanAddress];
                debugLog(@"api kkk %@", s);
                [[WYHttpClient sharedClient] GET:s parameters:@{@"uuid": uuid} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [WYUtility showAlertWithTitle:@"登录请求已成功发送"];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [WYUtility showAlertWithTitle:@"请求未成功，请刷新二维码再试一次"];
                }];
                
            }],
              nil] show];
        }
        
        return YES;
    }
    else
    {
        return NO;
    }
}

- (NSArray *)calculatePdfsUuidArr:(NSArray *)pdfs {
    NSMutableArray *ma = [NSMutableArray array];
    for (int i = 0; i < pdfs.count; i++) {
        YZPdf *pdf = pdfs[i];
        [ma addObject:pdf.uuid];
    }
    return [ma copy];
}

- (NSArray *)calculateRemindUuidArr:(NSArray *)remindArr {
    NSMutableArray *ma = [NSMutableArray array];
    for (int i = 0; i < remindArr.count; i++) {
        WYUser *user = remindArr[i];
        [ma addObject:user.uuid];
    }
    return [ma copy];
}

- (void)publishPostInfo:(NSDictionary *)dict publishVisibleScopeType:(int)publishVisibleScopeType targetUuid:(NSString *)targetUuid {

    //这里是将之前的不可变字典转换成可变字典 而不是一个新字典
    //在选择发布类型的时候 再set发布范围

    NSMutableDictionary *d = [[NSMutableDictionary alloc] initWithDictionary:dict];

    if (publishVisibleScopeType) {
        [d setObject:@(publishVisibleScopeType) forKey:@"target_type"];
    } else {
        [d setObject:@(self.publishVisibleScopeType) forKey:@"target_type"];
    }
    if (targetUuid) {
        [d setObject:targetUuid forKey:@"target_uuid"];
    } else {
        [d setObject:self.targetUuid forKey:@"target_uuid"];
    }
    //用block 可以在发完帖子后回到分享页面

    self.publishInfoBlock([d copy]);
}

@end
