//
//  WYPublishAddTagsVC.h
//  Withyou
//
//  Created by Handyzzz on 2017/8/19.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, AddPostTagType) {
    AddTagFromPublish = 1,
    AddTagFromPost = 2,
};
@interface WYPublishAddTagsVC : UIViewController

//AddTagFromPublish
@property(nonatomic, strong)NSMutableArray *tagStrArr;
@property(nonatomic, copy)NSString *contentStr;
@property(nonatomic, copy)void(^publishTagsClick)(NSArray *tempArr);

//AddTagFromPost
@property(nonatomic,strong)WYPost *post;

-(instancetype)initWithType:(AddPostTagType)Type;

@end
