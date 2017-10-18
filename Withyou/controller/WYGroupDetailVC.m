//
//  WYGroupDetailVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/4/1.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYGroupDetailVC.h"
#import "WYGroupDetailView.h"
#import "WYPost.h"
#import "WYCellPostFrame.h"
#import "WYTipTypeOne.h"
#import "WYGroupSettingVC.h"
#import "WYAddFollowToMeJoinGroupVC.h"
#import "WYInViteFollowFromMeJoinGroupVC.h"
#import "WYGroupMemberList.h"
#import "WYPublishVC.h"
#import "WYGroup.h"
#import "WYGroupApi.h"
#import "WYGroupQRcodeVC.h"

@interface WYGroupDetailVC ()

@property(nonatomic, strong) UILabel *titleLb;
@property(nonatomic, strong) WYGroupDetailView *groupDetailView;
@property(nonatomic, strong) UIView *headView;
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, assign) CGFloat navAlpha;
@property(nonatomic, assign) CGFloat headAlpha;
@property(nonatomic, strong) UIBarButtonItem *myRightBarButtonItem;
@property(nonatomic, strong) UIImageView *placeHolderView;

@end

@implementation WYGroupDetailVC


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _titleLb.hidden = YES;
    self.navigationController.navigationBar.subviews[0].alpha = _navAlpha;
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithWhite:1.0 - _navAlpha alpha:1.0]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithWhite:1.0 - _navAlpha alpha:1.0]];
    self.headView.alpha = _headAlpha;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    _titleLb.hidden = NO;
    self.navigationItem.titleView = _titleLb;
    self.navigationController.navigationBar.subviews[0].alpha = _navAlpha;
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithWhite:1.0 - _navAlpha alpha:1.0]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithWhite:1.0 - _navAlpha alpha:1.0]];
    _titleLb.alpha = _navAlpha;
    self.headView.alpha = _headAlpha;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.subviews[0].alpha = 1;
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.placeHolderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"group_detail_placeholder"]];
    self.placeHolderView.frame = self.view.bounds;
    [self.view addSubview:self.placeHolderView];

    //从消息页面过来的时候 可以看到消息页面的 下拉刷新图标 当行栏是透明的 可以用一个View挡住
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -kStatusAndBarHeight, kAppScreenWidth, kStatusAndBarHeight)];
    view.backgroundColor = UIColorFromRGBA(0xffffff, 1);
    [self.view addSubview:view];

    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self setNaviItem];
    [self initDataAndAddHUD];

    //观察群组资料有没有改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGroupDatasource:) name:kUpdateGroupDataSource object:nil];
}

//这个页面一定要请求的
- (void)initDataAndAddHUD {
    __weak WYGroupDetailVC *weakSelf = self;
    //本来留两个接口 如果有group就可以不用请求 现在必须要请求要不然group的apply_status可能不是正确的
    if (self.groupUuid == nil) {
        self.groupUuid = self.group.uuid;
    }
    [WYGroupApi retrieveGroupDetail:self.groupUuid Block:^(WYGroup *group, long status) {
        if (group) {
            weakSelf.group = group;
            [weakSelf prepareShowView];
        } else if (status == 403) {
            [OMGToast showWithText:@"该群组对外不可见！"];

        } else if (status == 404) {
            [OMGToast showWithText:@"该群组已不存在！"];

        } else if (status >= 500) {
            [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
        }
    }];

}


- (void)resetTableView {
    //这个页面的透明度为0 导致self.view变大了 tableView又是和view一样大的（基类中这样设置的）
    CGRect frame = self.tableView.frame;
    frame.size.height = kAppScreenHeight - kStatusAndBarHeight;
    self.tableView.frame = frame;

    self.tableView.alpha = 0.0;
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.tableView.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {

                     }];

    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    self.tableView.showsVerticalScrollIndicator = NO;
    // 去掉 分割线
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setNaviItem {

    _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    _titleLb.textAlignment = NSTextAlignmentCenter;
    _navAlpha = self.navigationController.navigationBar.subviews[0].alpha = 0;
    _headAlpha = 1;

    UIImage *leftImage = [[UIImage imageNamed:@"grouppage_back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBtn;

    UIImage *rightImage = [[UIImage imageNamed:@"group page_setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(settingAction)];

    _myRightBarButtonItem = rightBtn;

    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithWhite:1.0 - _navAlpha alpha:1.0]];
    [_myRightBarButtonItem setTintColor:[UIColor colorWithWhite:1.0 - _navAlpha alpha:1.0]];
}

- (void)prepareShowView {

    [UIView animateWithDuration:0.4
                     animations:^{
                         self.placeHolderView.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [self.placeHolderView removeFromSuperview];
                     }];

    [self resetTableView];
    [self createHead];
    [self settingTabHeadView];

    //如果我是群成员
    if ([self.group meIsMemberOfGroupFromPartialMemberList]) {
        [self desiginNoti];
        // 获取post
        [self initDataForEnterGroupDetailAsMember];

        //非得是自己的群组，才显示群组设置按钮
        self.navigationItem.rightBarButtonItem = _myRightBarButtonItem;
    }
}

//创建头部视图
- (void)createHead {

    if (self.headView == nil) {
        self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, -64, self.tableView.frame.size.width, 200)];
        [self.view addSubview:self.headView];

        self.iconImageView = [[UIImageView alloc] initWithFrame:self.headView.bounds];
        self.iconImageView.clipsToBounds = YES;
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.headView addSubview:self.iconImageView];


        CAGradientLayer *blackLayer = [CAGradientLayer layer];
        blackLayer.frame = CGRectMake(0, 130, kAppScreenWidth, 70);
        blackLayer.colors = @[(__bridge id) UIColorFromRGBA(0x333333, 0).CGColor, (__bridge id) UIColorFromRGBA(0x000000, 0.28).CGColor];
        blackLayer.locations = @[@(0.0), @(1.0)];
        blackLayer.startPoint = CGPointMake(0, 0);
        blackLayer.endPoint = CGPointMake(0, 1.0);
        [self.headView.layer addSublayer:blackLayer];

        [self.view bringSubviewToFront:self.tableView];
        self.tableView.backgroundColor = [UIColor clearColor];
    }
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.group.group_icon]];

}

//群组资料改变
- (void)updateGroupDatasource:(NSNotification *)noti {

    WYGroup *group = [noti.userInfo objectForKey:@"group"];
    self.group = group;

    //下边的帖子里边 会有群名称 所以也要更新一下数据
    //tony added. 0806, 这里有去更新帖子有问题，意味着群组设置更改后，发来通知，前面就只有10条帖子了，这是不合理的
    //用户可能已经刷到100多条帖子了，然后就只有10条了
    //群组改名字这个，我们暂且不要更新帖子的名字了

    [self settingTabHeadView];
    [self createHead];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpdateGroupDataSource object:nil];
}


//重写清空一下 去除下拉功能 (避免父类下拉影响)
- (void)createRefreshView {
}

- (void)initDataForEnterGroupDetailAsMember {
    //作为群组成员，进来群组时，是有first_ten_post的这个字段的，不需要再去请求列表

    [self.dataSource removeAllObjects];
    if (self.group.first_ten_post.count > 0) {
        NSArray *postList = [NSArray yy_modelArrayWithClass:[WYPost class] json:self.group.first_ten_post];

        for (WYPost *post in postList) {
            WYCellPostFrame *frame = [[WYCellPostFrame alloc] initWithPost:post];
            [self.dataSource addObject:frame];
        }
        [self.tableView reloadData];
    }

    if (self.group.first_ten_post.count < 4) {
        self.navigationController.navigationBar.subviews[0].alpha = _navAlpha;
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithWhite:1.0 - _navAlpha alpha:1.0]];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithWhite:1.0 - _navAlpha alpha:1.0]];
        _titleLb.alpha = _navAlpha;
    }

    __weak WYGroupDetailVC *weakSelf = self;
    [self.tableView addFooterRefresh:^{
        if (self.dataSource.count == 0) {
            [weakSelf.tableView endFooterRefresh];
            return;
        }
        WYCellPostFrame *frame = weakSelf.dataSource.lastObject;
        NSNumber *t = frame.post.createdAtFloat;
        [YZPostListApi postListForGroup:weakSelf.group.uuid lastTime:t Block:^(NSArray *postList) {
            if (postList.count > 0) {
                for (WYPost *post in postList) {
                    WYCellPostFrame *frame = [[WYCellPostFrame alloc] initWithPost:post];
                    [weakSelf.dataSource addObject:frame];
                }
                [weakSelf.tableView reloadData];
            }
            [weakSelf.tableView endFooterRefresh];
        }];
    }];
}

- (void)settingTabHeadView {

    _groupDetailView = [[WYGroupDetailView alloc] initWithGroup:self.group];
    [_groupDetailView.inviteButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postAction)];
    [_groupDetailView.shareView addGestureRecognizer:tap1];

    UITapGestureRecognizer *contentGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(groupMemberListClick)];
    [_groupDetailView.allIconSV addGestureRecognizer:contentGesture];

    __weak typeof(self) weakSelf = self;
    _groupDetailView.onApplyClick = ^(UIButton *applyBtm, NSString *text) {
        [WYUtility requireSetAccountNameOrAlreadyHasName:^{
            [weakSelf applyJoinGroup:text];
        }                           navigationController:weakSelf.navigationController];
    };
    self.tableView.tableHeaderView = _groupDetailView;
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat offset = scrollView.contentOffset.y;

    if (offset >= 64 && offset <= 200) {
        CGFloat headAlpha = 1 - (scrollView.contentOffset.y - 64) / (200.f - 64);
        CGFloat navAlpha = (scrollView.contentOffset.y - 64) / (200.f - 64);

        if (navAlpha > 1) {
            navAlpha = 1;
        }
        //设置导航栏的透明度
        _navAlpha = self.navigationController.navigationBar.subviews[0].alpha = navAlpha;
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithWhite:1.0 - _navAlpha alpha:1.0]];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithWhite:1.0 - _navAlpha alpha:1.0]];
        _titleLb.alpha = navAlpha;
        _titleLb.text = self.group.name;
        _headAlpha = self.headView.alpha = headAlpha;

    } else if (offset < 64) {

        _navAlpha = self.navigationController.navigationBar.subviews[0].alpha = 0;
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithWhite:1.0 - _navAlpha alpha:1.0]];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithWhite:1.0 - _navAlpha alpha:1.0]];
        _titleLb.alpha = 0;
        _headAlpha = self.headView.alpha = 1;

    } else {
        _navAlpha = self.navigationController.navigationBar.subviews[0].alpha = 1;
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithWhite:1.0 - _navAlpha alpha:1.0]];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithWhite:1.0 - _navAlpha alpha:1.0]];
        _titleLb.alpha = 1;
        _headAlpha = self.headView.alpha = 0;
    }

    if (offset < 64) {
        CGRect rect = self.headView.frame;
        rect.origin.y = -offset;
        self.headView.frame = rect;
    } else {
        if (self.headView.frame.origin.y != -64) {
            CGRect rect = self.headView.frame;
            rect.origin.y = -64;
            self.headView.frame = rect;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    CGFloat offset = scrollView.contentOffset.y;

    if (offset < 0) {
        CGRect rect = self.headView.frame;
        rect.origin.y = -64 - offset;
        self.headView.frame = rect;
    } else {
        if (self.headView.frame.origin.y != -64) {
            CGRect rect = self.headView.frame;
            rect.origin.y = -64;
            self.headView.frame = rect;
        }
    }
}

#pragma mark - actions

//返回
- (void)backAction {
    if (_isPresent == YES) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//群成员列表
- (void)groupMemberListClick {
    WYGroupMemberList *vc = [WYGroupMemberList new];
    vc.includeAdminList = YES;
    vc.group = self.group;
    [self.navigationController pushViewController:vc animated:YES];
}

//设置
- (void)settingAction {
    if (![self.group meIsMemberOfGroupFromPartialMemberList]) {
        return;
    }
    WYGroupSettingVC *vc = [WYGroupSettingVC new];
    vc.group = self.group;
    [self.navigationController pushViewController:vc animated:YES];
}

//添加
- (void)addAction {

    __weak WYGroupDetailVC *weakSelf = self;

    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:self.group.name message:[NSString stringWithFormat:@"群号%@", self.group.number] preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"添加关注我的人" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {

        WYAddFollowToMeJoinGroupVC *vc = [WYAddFollowToMeJoinGroupVC new];
        vc.group = weakSelf.group;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"邀请我关注的人" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        WYInViteFollowFromMeJoinGroupVC *vc = [WYInViteFollowFromMeJoinGroupVC new];
        vc.group = weakSelf.group;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"通过群链接邀请" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [weakSelf.view showHUDNoHide];
        [WYGroupApi requestGroupLink:weakSelf.groupUuid Block:^(NSString *s) {
            [weakSelf.view hideAllHUD];
            if (s.length > 0) {
                //icon
                NSURL *iconUrl = [NSURL URLWithString:weakSelf.group.group_icon];
                NSData *data = [NSData dataWithContentsOfURL:iconUrl];
                UIImage *image = [UIImage imageWithData:data];
                //标题
                WYUser *user = kLocalSelf;
                NSString *text = @"邀请你加入与子";
                NSString *linkTitle = [NSString stringWithFormat:@"%@%@%@", user.fullName, text, weakSelf.group.name];
                //url
                NSURL *urlToShare = [NSURL URLWithString:s];

                NSArray *activityItems = @[linkTitle, urlToShare, image];

                UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
                activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
                [self presentViewController:activityVC animated:TRUE completion:nil];
            } else {
                [OMGToast showWithText:@"请求群链接失败" duration:1.0];
            }
        }];
    }];

    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"群组二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        WYGroupQRcodeVC *vc = [WYGroupQRcodeVC new];
        vc.navigationTitle = @"群组二维码";
        vc.group = weakSelf.group;
        vc.targetUrl = [NSString stringWithFormat:@"%@/add/g/%@/", kBaseURL, self.group.number];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];

    if (([self.group meIsMemberOfGroupFromPartialMemberList] && [self.group.allow_member_invite boolValue]) || [self.group meIsAdmin]) {
        [actionSheet addAction:cancel];
        [actionSheet addAction:action1];
        [actionSheet addAction:action2];
        [actionSheet addAction:action3];
        [actionSheet addAction:action4];
    } else {
        [actionSheet addAction:cancel];
        [actionSheet addAction:action3];
        [actionSheet addAction:action4];
    }

    [self presentViewController:actionSheet animated:YES completion:nil];
}

//发布
- (void)postAction {

    if (![self.group meIsMemberOfGroupFromPartialMemberList]) {
        [OMGToast showWithText:@"非群成员无法发布内容" duration:1.5];
        return;
    }

    WYPublishVC *vc = [WYPublishVC new];
    vc.extraAppointType = 3;
    vc.extraAppointUuid = self.group.uuid;
    vc.extraAppointName = self.group.name;
    vc.group = self.group;

    __weak WYPublishVC *weakVC = vc;
    __weak WYGroupDetailVC *weakSelf = self;
    vc.publishInfoBlock = ^(NSDictionary *dict) {
        //这行代码 比发布5中类型的VC的myBlock的 popViewController先执行
        [weakVC.navigationController popToViewController:self animated:YES];
        [WYUtility requireSetAccountNameOrAlreadyHasName:^{
            [WYPostApi addPostFromDict:dict WithBlock:^(WYPost *post) {
                if (post) {
                    //当前页更新数据 然后刷新
                    WYCellPostFrame *frame = [[WYCellPostFrame alloc] initWithPost:post];
                    [weakSelf.dataSource insertObject:frame atIndex:0];
                    [weakSelf.tableView reloadData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewPublishPostAction object:post];
                } else {
                    [OMGToast showWithText:@"未发布成功，请检查网络设置"];
                }
            }];
        }                           navigationController:self.navigationController];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - apply join

- (void)applyJoinGroup:(NSString *)text {

    __weak WYGroupDetailVC *weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"申请如果被管理员拒绝，须一周后才能再次申请。\n请确认自己的个人资料真实完善，且符合群介绍中的入群要求" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"继续申请" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        if ([weakSelf.group.applied_status integerValue] == 1) {
            [WYGroupApi requestJoinGroup:weakSelf.group.uuid comment:text callback:^(BOOL success) {
                if (success) {
                    weakSelf.group.applied_status = [NSNumber numberWithInt:3];
                    [weakSelf.groupDetailView didChangeAppliedStatus:3];
                    [WYTipTypeOne showWithMsg:@"群管理员已收到你的申请，请耐心等待审核结果" imageWith:WYTipTypeOneImageSuccess];
                } else {
                    [WYTipTypeOne showWithMsg:@"申请失败" imageWith:WYTipTypeOneImageFail];
                }
            }];
        }
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {

    }];
    [alert addAction:doneAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
