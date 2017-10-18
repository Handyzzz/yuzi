//
//  WYMorePhotoCell.h
//  Withyou
//
//  Created by Tong Lu on 8/8/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPhoto.h"

@interface WYMorePhotoCell : UITableViewCell

@property (strong, nonatomic)  UIImageView *myImageView;
@property (strong, nonatomic)  UITextView *myTextView;
@property (nonatomic, strong)  UILabel *countLb;

- (CGFloat)setupCellFromPhoto:(WYPhoto *)photo :(NSInteger)currrntIndex;

@end
