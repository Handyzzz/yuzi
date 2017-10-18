
//
//  WYUserBaseVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/5/20.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYUserBaseVC.h"

@interface WYUserBaseVC ()<UIScrollViewDelegate>
//是否是手指滑动的
@property (nonatomic, assign)CGFloat isUseDragging;

@end

@implementation WYUserBaseVC


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isUseDragging = YES;
}

//方法调用的时候 时间的间距还是比较明显的
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isUseDragging == YES) {
        //发通知
        CGFloat y = scrollView.contentOffset.y;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"tableViewScroll" object:self userInfo:@{@"contenty":@(y)}];
    }
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (_isUseDragging == YES) {
        //发通知
        CGFloat y = scrollView.contentOffset.y;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"tableViewScroll" object:self userInfo:@{@"contenty":@(y)}];
    }
    _isUseDragging = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isUseDragging = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noti:) name:@"tableViewScroll" object:nil];
}

-(void)noti:(NSNotification *)sender{
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"tableViewScroll" object:nil];
}


@end
