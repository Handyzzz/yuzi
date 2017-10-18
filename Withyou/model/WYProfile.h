//
//  WYProfile.h
//  Withyou
//
//  Created by Tong Lu on 2016/10/19.
//  Copyright © 2016年 Withyou Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYJob.h"
#import "WYStudy.h"
#import "WYBook.h"
#import "WYMovie.h"
#import "WYMusic.h"
#import "WYEvent.h"
#import "WYNickName.h"


@interface WYProfile : NSObject <YYModel>
@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *city;
@property (assign, nonatomic) int relationship_status;
@property (nonatomic, assign) int birth_year;
@property (nonatomic, assign) int birth_month;
@property (nonatomic, assign) int birth_day;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) WYJob *current_work;
@property (nonatomic, strong) NSArray <WYNickName*> *nick_names;
@property (nonatomic, strong) NSArray <WYJob *> *work_experience;
@property (nonatomic, strong) NSArray <WYStudy *>*study_experience;

@property (nonatomic, strong) NSArray <WYBook *> *books;
@property (nonatomic, strong) NSArray <WYMovie *> *movies;
@property (nonatomic, strong) NSArray <WYMusic *> *music;
@property (nonatomic, strong) NSArray <WYEvent *> *events;
@property (nonatomic, strong) NSNumber* experience_degree;
@property (nonatomic, strong) NSString *intro;

/*************************************计算属性*********************************************/
-(NSMutableArray *)interests;

- (NSString *)relationshipStr;
/*************************************计算属性*********************************************/

+ (WYProfile *)queryProfileFromUuid:(NSString *)uuid;
+ (BOOL)saveProfileToDB:(WYProfile *)profile;
@end
