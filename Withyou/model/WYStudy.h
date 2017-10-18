//
//  WYStudy.h
//  Withyou
//
//  Created by Tong Lu on 2016/11/4.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYStudy : NSObject

@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString* user; //uuid
@property (strong, nonatomic) NSString *school;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *direction;
@property (assign, nonatomic) int start_date_int;
@property (assign, nonatomic) int finish_date_int;
@property (nonatomic, strong) NSString *start_date;
@property (nonatomic, strong) NSString *finish_date;
@property (assign, nonatomic) float created_at_float;


-(NSString *)start_year_month;
-(NSString *)finish_year_month;

@end
