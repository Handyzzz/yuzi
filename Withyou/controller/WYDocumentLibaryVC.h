//
//  WYDocumentLibaryVC.h
//  Withyou
//
//  Created by Handyzzz on 2017/7/22.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYDocumentLibaryVC : UIViewController
@property (nonatomic, copy) void(^selectedFdfs)(NSArray *selectedPdfArr);
@property (nonatomic, strong) NSMutableArray *selectedPdfArr;

@end
