//
//  selectScopeSecondTimePageVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/4/25.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import"WYselectScopeSecondTimePageVC.h"
#import "WYselectSystemScopeSecondTimeVC.h"
#import "WYselectGroopOrFriendScopeSecondtimeVC.h"

@interface WYselectScopeSecondTimePageVC ()
@property(nonatomic, strong)UIColor *menuBGColor;
@end

@implementation WYselectScopeSecondTimePageVC
-(instancetype)init{
    if (self=[super init]) {
        self.menuBGColor = [UIColor clearColor];
        self.titleColorSelected = UIColorFromHex(0x2BA1D4);
        self.menuViewStyle = 1;
        self.progressColor = UIColorFromHex(0x2BA1D4);
        self.progressViewIsNaughty = YES;
        self.automaticallyCalculatesItemWidths=YES;
        //item之间的间隙
        self.itemMargin=0;
        
    }
    return self;
}
- (NSArray<NSString *> *)titles{
    return @[@"系统",@"群组"];
}

    
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return self.titles.count;
}
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    __weak WYselectScopeSecondTimePageVC *weakSelf = self;
    if (index == 0) {
        WYselectSystemScopeSecondTimeVC *vc = [WYselectSystemScopeSecondTimeVC new];
        vc.myBlock = ^(int publishVisibleScopeType, NSString *targetUuid,NSString*title) {
            debugLog(@"publish visible scope type is %d, %@, %@", publishVisibleScopeType, targetUuid, title);
            weakSelf.myBlock(publishVisibleScopeType, targetUuid,title,nil);
        };
        return vc;
    }
        WYselectGroopOrFriendScopeSecondtimeVC *vc = [WYselectGroopOrFriendScopeSecondtimeVC new];
        vc.selectType = 1;
        vc.myBlock = ^(int publishVisibleScopeType, NSString *targetUuid,NSString*title,WYGroup*group) {
            weakSelf.myBlock(publishVisibleScopeType, targetUuid,title,group);
        };
        return vc;
    /**
     WYselectGroopOrFriendScopeSecondtimeVC *vc = [WYselectGroopOrFriendScopeSecondtimeVC new];
     vc.selectType = 2;
     vc.myBlock = ^(int publishVisibleScopeType, NSString *targetUuid,NSString*title,WYGroup *group) {
     weakSelf.myBlock(publishVisibleScopeType, targetUuid,title,group);
     };
     return vc;
     */
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
}
-(void)setNavigationBar{
    self.title = @"发布范围";
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
