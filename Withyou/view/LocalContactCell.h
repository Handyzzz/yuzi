//
//  LocalContactCell.h
//  Withyou
//
//  Created by CH on 2017/6/24.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalContactCell : UITableViewCell

@property(nonatomic,strong)UIImageView *headIV;
@property(nonatomic,strong)UILabel *nameLb;
@property(nonatomic,strong)UIButton *controlBTN;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UILabel *headTitleLb;

@property(nonatomic,strong)WYUser *user;

@property (nonatomic, copy) void(^controlBlcok)(WYUser *user);

@end
