//
//  WYHotTagListCell.h
//  Withyou
//
//  Created by Handyzzz on 2017/9/1.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYsingleHotTagView.h"
@interface WYHotTagListCell : UITableViewCell
@property(nonatomic,strong)WYsingleHotTagView *singleView;

-(void)setUpCellDetail:(NSDictionary *)dic img:(NSString *)img;
@end
