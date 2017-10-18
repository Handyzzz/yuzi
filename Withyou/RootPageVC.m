//
//  RootPageVC.m
//  Withyou
//
//  Created by lx on 17/3/16.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "RootPageVC.h"
#import "WYPostApi.h"
#import "WYNavigationVC.h"
@interface RootPageVC ()<UIScrollViewDelegate>

@property (nonatomic, strong)WYNavigationVC *nav;
@end

@implementation RootPageVC

- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return _scrollView;
}

- (instancetype)init {
    if(self = [super init]){
        // 创建 tabbarvc
        RootTabBarController *tabBarVC = [[RootTabBarController alloc] init];
        tabBarVC.navDelegate = self;
        
        self.tabBarVC = tabBarVC;
        // left vc
        WYPublishVC * publishVC = [[WYPublishVC alloc] init];
        self.publishVC = publishVC;
        __weak typeof(self) this = self;
        publishVC.publishInfoBlock = ^(NSDictionary *dict) {
            [this onPublishPostAction:dict];
        };
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViewControllers];
}


- (void)initViewControllers {
    self.index = 1;
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.tabBarVC.view];
    
    _nav = [[WYNavigationVC alloc] initWithRootViewController:self.publishVC];
    _nav.delegate = self;
    [self addChildViewController:_nav];
    [self.scrollView addSubview:_nav.view];
    
    self.publishVC.view.frame = CGRectMake(0, 0, kAppScreenWidth, kAppScreenHeight);
    self.tabBarVC.view.frame = CGRectMake(kAppScreenWidth, 0, kAppScreenWidth, kAppScreenHeight);
    
    self.scrollView.contentSize = CGSizeMake(kAppScreenWidth * 2, kAppScreenHeight);
    self.scrollView.contentOffset = CGPointMake(kAppScreenWidth * self.index, 0);
}

- (void)onPublishPostAction:(NSDictionary *)dict {
    [self scrollToIndex:1];
    NSInteger type = (NSInteger)[dict objectForKey:@"target_type"];
    if ( type == 3) {
        [WYUtility requireSetAccountNameOrAlreadyHasName:^{
            [WYPostApi addPostFromDict:dict WithBlock:^(WYPost *post) {
                if(post){
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewPublishPostAction object:post];
                }
            }];
        } navigationController:self.tabBarVC.viewControllers[self.tabBarVC.selectedIndex]];
    }else{
        [WYUtility requireSetAccountNameOrAlreadyHasName:^{
            [WYPostApi addPostFromDict:dict WithBlock:^(WYPost *post) {
                if(post){
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewPublishPostAction object:post];
                }
            }];
        } navigationController:self.tabBarVC.viewControllers[self.tabBarVC.selectedIndex]];
    }
}

- (void)setScrollViewEnable:(BOOL)enable {
    self.scrollView.scrollEnabled = enable;
}

#pragma mark- 在切换页面的时候 如果正在播放视频 需要暂停 处理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int pageIndex = scrollView.contentOffset.x / kAppScreenWidth;

    if(pageIndex == self.index) {
        return;
    }
    self.index = pageIndex;
}

- (void)scrollToIndex:(int)index {
    self.scrollView.contentOffset = CGPointMake(kAppScreenWidth * index, 0);
    //有时候是对的 有时候是错的
    debugLog(@"%f",self.scrollView.contentOffset.x);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark UINavigationControllerDelegate
//push的时候是不希望侧滑的
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if ([_nav respondsToSelector:@selector(interactivePopGestureRecognizer)])
        _nav.interactivePopGestureRecognizer.enabled = NO;
    
    [(UINavigationController *)(_nav.parentViewController) pushViewController:viewController animated:animated];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    return [(UINavigationController *)(_nav.parentViewController)  popViewControllerAnimated:YES];
}

//viewController出现了 才让边缘侧滑手势生效
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    // Enable the gesture again once the new controller is shown
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        _nav.interactivePopGestureRecognizer.enabled = YES;
    
    if(navigationController.viewControllers.count == 1) {
        if(self.publishVC == viewController || [[WYUtility tabVC] isChildVC:viewController]) {
            if ([[WYUtility tabVC] selectedIndex] == 0) {
                [self setScrollViewEnable:YES];
            }else{
                [self setScrollViewEnable:NO];
            }
        }else {
            [self setScrollViewEnable:NO];
        }
    }else {
        [self setScrollViewEnable:NO];
    }
}

@end
