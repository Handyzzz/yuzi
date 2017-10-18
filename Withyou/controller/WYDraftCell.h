//
//  WYDraftCell.h
//  Withyou
//
//  Created by Handyzzz on 2017/6/17.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYDraftCell : UITableViewCell
@property(nonatomic, strong)UITextView *textView;
@property(nonatomic, strong)UILabel *timeLb;
@property(nonatomic, copy)void(^removeDraftBlock)();

-(void)setCellData:(NSArray *)contentArr :(NSArray *)timeArr :(NSIndexPath *)indexPath;
+(CGFloat)caculateCellHeight:(NSString *)contentStr;
@end
