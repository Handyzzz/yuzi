//
//  SMPagerTabView.h
//  SMPagerTab
//
//  Created by ming on 15/7/4.
//  Copyright (c) 2015年 starming. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WYPagerTabViewDelegate;

@interface WYPagerTabView : UIView<UIScrollViewDelegate>

@property (nonatomic, weak) id<WYPagerTabViewDelegate> delegate;

@property (nonatomic, assign) CGFloat tabFrameHeight; //头部tab高
@property (nonatomic, strong) UIColor* tabBackgroundColor; //头部tab背景颜色
@property (nonatomic, assign) CGFloat tabButtonFontSize; //头部tab按钮字体大小
@property (nonatomic, assign) CGFloat tabMargin; //头部tab左右两端和边缘的间隔
@property (nonatomic, strong) UIColor* tabButtonTitleColorForNormal;
@property (nonatomic, strong) UIColor* tabButtonTitleColorForSelected;
@property (nonatomic, strong) UIColor* selectedLineColor;
@property (nonatomic, assign) CGFloat selectedLineWidth; //下划线的宽
@property (nonatomic, strong) UIView* tabView;

@property (nonatomic, assign) NSInteger currentTabSelected;
@property (nonatomic, strong) NSMutableArray *viewsArray;

/*!
 * @brief 自定义完毕后开始build UI
 */
- (void)buildUI;
/*!
 * @brief 控制选中tab的button
 */
- (void)selectTabWithIndex:(NSUInteger)index animate:(BOOL)isAnimate;
@end

@protocol WYPagerTabViewDelegate <NSObject>
@required
- (NSUInteger)numberOfPagers:(WYPagerTabView *)view;
- (UIViewController *)pagerViewOfPagers:(WYPagerTabView *)view indexOfPagers:(NSUInteger)number;
@optional
/*!
 * @brief 切换到不同pager可执行的事件
 */
- (void)whenSelectOnPager:(NSUInteger)number;
- (void)bodyScrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)bodyScrollViewDidEndDecelerating:(UIScrollView *)scrollView;
@end
