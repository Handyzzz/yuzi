//
//  BWaterflowLayout.h
//  BingoWaterfallFlowDemo
//
//  Created by Bing on 16/3/17.
//  Copyright © 2016年 Bing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WYWaterflowLayout;

@protocol WYWaterflowLayoutDelegate <NSObject>
- (CGFloat)waterflowLayout:(WYWaterflowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;
@end

@interface WYWaterflowLayout : UICollectionViewLayout

@property (nonatomic, assign) UIEdgeInsets sectionInset;
/** 段头的size */
@property (nonatomic, assign) CGSize headerReferenceSize;

/** 每一列之间的间距 */
@property (nonatomic, assign) CGFloat columnMargin;
/** 每一行之间的间距 */
@property (nonatomic, assign) CGFloat rowMargin;
/** 显示多少列 */
@property (nonatomic, assign) int columnsCount;

@property (nonatomic, weak) id<WYWaterflowLayoutDelegate> delegate;

@end
