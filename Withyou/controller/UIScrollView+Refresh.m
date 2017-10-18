//
//  UIScrollView+Refresh.m
//  
//
//  Created by 夯大力 on 16/9/9.
//  Copyright © 2016年 Handyzzz. All rights reserved.
//


#import "UIScrollView+Refresh.h"

@implementation UIScrollView (Refresh)
- (void)addHeaderRefresh:(void(^)())handler{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:handler];
}

- (void)beginHeaderRefresh{
    [self.mj_header beginRefreshing];
}
- (void)endHeaderRefresh{
    [self.mj_header endRefreshing];
}



- (void)addFooterRefresh:(void(^)())handler{
    
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:handler];
}

- (void)endFooterRefresh{
    
    [self.mj_footer endRefreshing];
}
//结束刷新并且显示没有更多数据
- (void)endRefreshWithNoMoreData{
    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)resetNoMoreData{
    [self.mj_footer resetNoMoreData];
}
@end




