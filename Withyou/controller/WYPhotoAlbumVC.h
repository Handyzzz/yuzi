//
//  WYMorePhotosVC.h
//  Withyou
//
//  Created by Tong Lu on 8/8/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPost.h"

@interface WYPhotoAlbumVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (nonatomic, strong) WYPost *post;
@property (nonatomic, weak) id delegate;

@end
