//
//  WYFollowListCell.h
//  Withyou
//
//  Created by Handyzzz on 2017/6/21.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYFollowListCell : UITableViewCell
@property(nonatomic,strong)UIImageView *iconIV;

@property(nonatomic, strong)UILabel *nameLb;

@property(nonatomic, strong)UILabel *friendLb;
@property(nonatomic,strong)UILabel *relationLb;

-(void)setCellData:(WYUser *)user relationShip:(NSInteger )statu;
//不带双方关系的
-(void)setCellData:(WYUser *)user;
@end
