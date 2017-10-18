//
//  RootTabBarController.m
//  Withyou
//
//  Created by ping on 2016/12/27.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import "RootTabBarController.h"
#import "RootPageVC.h"
#import "YZMessageApi.h"
#import "WYMsgCategoryListVC.h"
#import "WYPostListVC.h"
#import "WYGroup.h"
#import "WYGroupListApi.h"
#import "WYFollow.h"
#import "YZChatList.h"
#import "WYPostRecommend.h"
#import "WYNavigationVC.h"
#import "WYGroupClasses.h"
#import "WYDiscovers.h"
#import "WYMessageCategory.h"
#import "YZPostListApi.h"
#import "WYAccountApi.h"
#import "WYProfileApi.h"


@interface RootTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, weak) WYPostListVC *postVC;
@property (nonatomic, weak) WYDiscovers *discoverVC;
@property (nonatomic, weak) WYMsgCategoryListVC *msgCategoryListVC;
@property (nonatomic, weak) YZChatList *chatVC;

@end

@implementation RootTabBarController

- (instancetype)init {
    if(self = [super init]) {
        [self setupViewControllers];
    }
    return  self;
}
- (BOOL)isChildVC:(UIViewController *)vc {
    if(   vc == self.postVC
       || vc == self.msgCategoryListVC
       || vc == self.chatVC
       || vc == self.discoverVC) {
        return YES;
    }else {
        return NO;
    }
}
-(void)setNavDelegate:(id<UINavigationControllerDelegate>)navDelegate {
    for (UIViewController *vc in self.viewControllers) {
        if([vc isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)vc setDelegate:navDelegate];
        }
    }
}

- (void)setupViewControllers {
    WYPostListVC *vc1 = [[WYPostListVC alloc] init];
    self.postVC = vc1;

    WYDiscovers *vc2 = [[WYDiscovers alloc] init];
    self.discoverVC = vc2;
    
    WYMsgCategoryListVC *vc3 = [[WYMsgCategoryListVC alloc] init];
    self.msgCategoryListVC = vc3;
    
    YZChatList *vc4 = [[YZChatList alloc] init];
    self.chatVC = vc4;

    
    
    NSArray *vcs = @[vc1,
                     vc2,
                     vc3,
                     vc4
                     ];
    
    NSArray *images = @[
                        @"tablebarShare",
                        @"tablebarDiscover",
                        @"tablebarMessage",
                        @"tablebarChat",
                        ];
    
    NSArray *selectedImages = @[
                        @"tablebarShareHighlight",
                        @"tablebarDiscoverHighlight",
                        @"tablebarMessageHighlight",
                        @"tablebarChatHighlight",
                        ];
    NSArray *names = @[
                       @"分享",
                       @"发现",
                       @"消息",
                       @"聊天",
                       ];
    
    NSMutableArray *tabbarVCs = [[NSMutableArray alloc] init];
    
    for(int i=0; i<vcs.count; i++){
        UIViewController *vc = vcs[i];
        
        // 设置未选中的title颜色
        // [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromHex(0x777777)} forState:UIControlStateNormal];
        
        //设置选中和未选中的两种图片 且不受tintColor影响
        UIImage *image = [UIImage imageNamed:images[i]];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.image = image;
        //设为相反数 防止发生形变
        [vc.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];

        UIImage *selectedImage = [UIImage imageNamed:selectedImages[i]];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage = selectedImage;
        
        WYNavigationVC *nav = [[WYNavigationVC alloc] initWithRootViewController:vc];
        vc.navigationItem.title = names[i];

        [tabbarVCs addObject:nav];
    }
    // 间接通过tintColor设置title选中时候颜色
    // self.tabBar.tintColor = UIColorFromHex(0x2ba1d4);
    
    [self setViewControllers:tabbarVCs];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNotifications];
    self.delegate = self;
    
    if([[WYUIDTool sharedWYUIDTool] isLoggedIn]){

        [self updateSelfProfile];
        [self updateGroupInfo];
        [self updateMsgCategory];
        [self checkMessage:nil];
        [self requestForNewFollowsAndUsers];
        [self requestAndCacheRecommendedPost];
        [self delayUpdateVersion];
    }
}

- (void)loginAction {

    [self updateSelfProfile];
    [self updateGroupInfo];
    [self updateMsgCategory];
    [self checkMessage:nil];
    [self requestForNewFollowsAndUsers];
    [self requestAndCacheRecommendedPost];
    [self delayUpdateVersion];
}

- (void)logoutAction {
    //在需要的时候 可以清空缓存
}

- (void)dealloc {
    [self deregisterNotifications];
}

#pragma mark -
- (void)registerNotifications
{   //用户登录登出的时候回做一些数据上的处理
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginAction) name:kNotificationUserLoggedIn object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutAction) name:kNotificationUserLoggedOut object:nil];
}

- (void)deregisterNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationUserLoggedIn object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationUserLoggedOut object:nil];
}
#pragma mark - update Actions

-(void)requestAndCacheRecommendedPost{
    
    //请求一下 方法体内 做了本地缓存
    [YZPostListApi recommendPostListHandler:^(NSArray *eventArr, NSArray *groupArr, NSArray *postArr) {
        if (groupArr.count > 0 || postArr.count > 0) {
            
        }else{
            //加载失败
//            [WYUtility showAlertWithTitle:@"加载失败!"];
        }
    }];
}

// 检查是否有新消息
- (void)checkMessage:(void(^)(BOOL result))cb {
    
    // 请求数据
    [YZMessageApi requestMessageListWith:^(NSArray<YZMessage *> *list) {
        if(list) {
            // 查询数据库 返回存在的数量
            // TODO: 这个在 重新启动后 就没有新消息了  需要处理
            [YZMessage isExist:list callback:^(int count) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 当前未读消息数量
                    int newCount = (int)list.count - count;
                    if(newCount > 0) {
//                        UITabBarItem * item = [self.tabBar.items objectAtIndex:2];
//                        item.badgeValue = [NSString stringWithFormat:@"%d",newCount];
                    }
                });
            }];
            if(cb){
                cb(YES);
            }
        }else {
            if(cb){
                cb(NO);
            }
        }
    }];
}

// 更新群组信息
- (void)updateGroupInfo {
    [WYGroupListApi requestGroupListWithBlock:^(NSArray *groups) {}];
}

//请求更新follow关系
- (void)requestForNewFollowsAndUsers{
    [WYFollow listFollowBlock:nil];
}

-(void)updateMsgCategory{

    [WYMessageCategory listMsgCategory:0 Block:^(NSInteger total_unread_num, NSArray *categoryArr) {
        if (categoryArr) {            
            //不能存自定义数据类型，也不能存可变数组
            UITabBarItem * item = [self.tabBar.items objectAtIndex:2];
            if(total_unread_num > 0) {
                item.badgeValue = [NSString stringWithFormat:@"%ld", total_unread_num];
            }
            else{
                [item setBadgeValue:nil];
            }
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:categoryArr];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:kMsgCategoryListKey];
            [[NSUserDefaults standardUserDefaults] synchronize];

           [[NSNotificationCenter defaultCenter] postNotificationName:kMsgCategoryList object:nil userInfo:@{@"cateArr":categoryArr}];
        }else{
            [OMGToast showWithText:@"网络不给力，请检查网络设置！"];
        }
    }];
}

//tabVC 如果视图没有加载完成 alert是无法present出来的 延时执行
-(void)delayUpdateVersion{
    
    //此方法是一种非阻塞的执行方式
    //0830, 苹果审核，要求不可以用这种弹出提示，我们只好去掉。Tony added
//    [self performSelector:@selector(upDateVersion) withObject:nil afterDelay:3.0];
}

-(void)upDateVersion{
    
    //版本更新提示
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kPushDeviceTokenKey];
    if (token) {
        [WYAccountApi versionShouldUapdate:token Block:^(BOOL ignored, NSString *versionCode, NSArray *versionDesc, NSString *downloadUrl) {
            
            if ((versionCode != nil)&&(versionCode.length > 0) && (!ignored)) {
                
                //未忽略 弹窗
                NSString *title = [NSString stringWithFormat:@"%@版本",versionCode];
                //加标号  加\n
                NSMutableString *ms = [NSMutableString string];
                for (int i = 0; i < versionDesc.count; i ++) {
                    NSString *s = versionDesc[i];
                    NSString *tempStr = [NSString stringWithFormat:@"%d.%@\n",i+1,s];
                    [ms appendString:tempStr];
                }
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:ms preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *later = [UIAlertAction actionWithTitle:@"以后再说" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //do nothing
                }];
                
                UIAlertAction *skip = [UIAlertAction actionWithTitle:@"忽略此版本" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [WYAccountApi skipVersionTeptOfiPhoneBlock:^(BOOL haveSkip) {
                        if (!haveSkip) {
                            [OMGToast showWithText:@"未能成功忽略此版本更新"];
                        }
                    }];
                }];
                
                UIAlertAction *done = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadUrl]];
                }];
                [alert addAction:later];
                [alert addAction:skip];
                [alert addAction:done];
                
                /**
                 Presenting view controllers on detached view controllers is discouraged
                 选择用了当前VC
                 */
                [[WYUtility getCurrentVC] presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
}

//更新自己详细资料
-(void)updateSelfProfile{
    [WYProfileApi retrieveSelfProfileBlock:^(WYProfile *profile) {
        //已经到了数据库中
    }];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    RootPageVC *rootPageVC = [WYUtility rootPageVC];
    
    if (tabBarController.selectedIndex == 0) {
        rootPageVC.scrollView.scrollEnabled = YES;
    }else{
        rootPageVC.scrollView.scrollEnabled = NO;
    }

}
@end
