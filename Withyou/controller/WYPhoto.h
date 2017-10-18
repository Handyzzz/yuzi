//
//  WYPhoto.h
//  Withyou
//
//  Created by Tong Lu on 8/8/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <YYModel.h>

@interface WYPhoto : NSObject<YYModel>


@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *url;
@property (assign, nonatomic) float height;
@property (assign, nonatomic) float width;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSNumber *createdAtFloat;

@property (strong, nonatomic) NSNumber *isMainPic; //only available for public photos for post
@property (strong, nonatomic) NSNumber *order;
@property (strong, nonatomic) NSString *groud_uuid;
@property (strong, nonatomic) NSString *post;
@property (strong, nonatomic) NSString *uploader;

@property (strong, nonatomic) NSString *thumbnail;

@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSNumber *starNum;
@property (strong, nonatomic) NSNumber *starred;

// there is a uploader as well


+ (void)savePhotosToLocalDB:(NSArray *)photoArray Block:(void (^)(BOOL result))block;
+ (void)deletePhotosFromUuidList:(NSArray *)uuidList Block:(void (^)(BOOL result))block;

+ (void)savePhotoToLocalDB:(WYPhoto *)photo;
+ (void)deletePhotoFromLocalDB:(NSString *)photoUuid;

+ (void)queryAllSelfPhotosWithBlock:(void (^)(NSArray *photos))block;
+ (void)queryAllGroup:(NSString *)groupUuid PhotosWithBlock:(void (^)(NSArray *photos))block;

+ (NSNumber *)queryNewestSelfAlbumCreatedTimeInPhotoDB;
+ (NSNumber *)queryNewestGroupAlbumCreatedTimeInPhotoDB:(NSString *)groupUuid;


//both self and group photos
+ (void)deletePhotoTableInDB;

@end
