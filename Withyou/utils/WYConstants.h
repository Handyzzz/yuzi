//
//  WYConstants.h
//  Withyou
//
//  Created by Tong Lu on 7/30/14.
//  Copyright (c) 2014 Withyou Inc. All rights reserved.
//

#import "WYUIDTool.h"

#pragma mark - Dimensions
// dimensions

#define kBottomToolbarHeight 44
#define kHeightNavigationItemAndStatusBar 64
#define kPostIconWidth 36.0

/**
 * layout
 */
#define kContentLineSpacing 25.0f
#define kContentLineSpacingForPicturedText 31.0f
//#define kContentFontForPicturedText [UIFont systemFontOfSize:19]
//#define kContentFontForPicturedText [UIFont systemFontOfSize:17]


//
#define kCellStartMargin 10
#define kCellMargin 10

#pragma mark - Counts
// counts

#define kCountLoadNewMessages @20
#define kCountLoadMoreMessages @20
#define kCountLoadMessageLargerNumber @40
#define kMaxWordCountAllowed 10000



#pragma mark - Websites & API

#define kNormalBaseURL @"https://yuziapp.com"
#define kTestBaseURL @"https://ditushuo.me"
#define kLocalTestBaseURL @"http://192.168.3.21:8000"
#define kHandyURL @"http://127.0.0.1:8000"
#define kBaseURL kNormalBaseURL


#define kApiVersion @"api/v1/"

#define kApiSendVCodeAddress @"send_v_code/"
#define kApiLoginAddress @"login/"
//phone, vcode
//return {"token" : "key"}, 200

#define kApiQiniuUploadCallbackAddress @"up_qn_cb/"

//get, post, put, patch, delete
#define kApiPostAddress @"post/"

#define kApiFollowAddress @"follow/"

#define kApiStarAddress @"star/"


//profile update,  only update, need append uuid
#define kApiProfileUpdateAddress @"profile/"
//user retrieve update view, need append uuid
#define kApiUserRetrieveUpdateAddress @"user/"
#define kApiUserSelfDetailAddress @"user/self/"

#define kApiObtainVerificationSMSCodeAddress @"vcode/"
#define kApiLoginAddress @"login/"
#define kqiniuRequestUploadTokenAddress @"uploadToken/"


/**
 with the query param uuid, which is scanned from the code

 @param 248 uuid
 @return nothing, but will set a database entry, will be requested in series by the web for 3 minutes
 */
#define kqrCodeScanAddress @"qrcode_scan/"

#pragma mark - Fonts and Color
//content font and color

//Post
//作者头像
#define kPostAuthorNameFont [UIFont systemFontOfSize:15 weight:0.4]

//帖子主体内容
#define kPostContentFont [UIFont systemFontOfSize:16]
#define kPostContentLineHeight (19 + 1/3.f)
//帖子标题
#define kPostTitleFont [UIFont systemFontOfSize:18 weight:0.4]
#define kPostTitleLineHeight 23
//帖子内的链接
#define kPostLinkTitleFont [UIFont systemFontOfSize:16 weight:0.4]
#define kPostLinkTitleLineHeight 21
//与谁一起
#define kPostWithWhomFont [UIFont systemFontOfSize:14 weight:0.4]
#define kPostCommentFont [UIFont systemFontOfSize:13]
//附件区域
#define kPostAttachmentFont [UIFont systemFontOfSize:14]
#define kMsgTitleFontSize 15

#define kPostSeparationLineHeight 8


#define kFont_16 [UIFont systemFontOfSize:16]
#define kFont_15 [UIFont systemFontOfSize:15]
#define kFont_14 [UIFont systemFontOfSize:14]
#define kFont_13 [UIFont systemFontOfSize:13]
#define kFont_12 [UIFont systemFontOfSize:12]
#define kFont_11 [UIFont systemFontOfSize:11]
#define kCellSmallLabelFont [UIFont systemFontOfSize:11.0f]

#define kMediumGrayTextColor60 [UIColor colorWithWhite:0 alpha:0.60]
#define kMediumGrayTextColor40 [UIColor colorWithWhite:0 alpha:0.40]

#define kMediumGrayTextColor [UIColor colorWithWhite:0 alpha:0.67]
#define kGrayColor214 kRGB(214, 214, 214)
#define kGrayColor19 [UIColor colorWithWhite:0 alpha:0.19]
#define kGrayColor23 [UIColor colorWithWhite:0 alpha:0.23]
#define kGrayColor25 [UIColor colorWithWhite:0 alpha:0.25]
#define kGrayColor30 [UIColor colorWithWhite:0 alpha:0.30]
#define kGrayColor50 [UIColor colorWithWhite:0 alpha:0.50]
#define kGrayColor60 [UIColor colorWithWhite:0 alpha:0.60]
#define kGrayColor75 [UIColor colorWithWhite:0 alpha:0.75]
#define kGrayColor85 [UIColor colorWithWhite:0 alpha:0.85]
//#define kGrayColorForPostButtons [UIColor colorWithWhite:0 alpha:0.19]
//#define kGrayColorForPostButtons [UIColor colorWithWhite:0 alpha:0.23]
//#define kGrayColorForPostButtons kRGB(199, 210, 219)
//#define kGrayColorForPostButtons [UIColor darkGrayColor]
#define kGrayColorForPostButtonTitles kGrayColor50
#define kGrayColorForPostButtons kRGB(180, 190, 198)
#define kGrayColorForPostVisibilityIcon kGrayColor30

#define SeparateLineColor  UIColorFromHex(0xf2f2f2)


#define kLightGrayTextColor [UIColor colorWithWhite:0 alpha:0.55]

#define kYZLightBlue kRGB(98, 150, 239)

#define kTagColor [UIColor colorWithWhite:0.1 alpha:0.9]
#define kCellSmallLabelColor [UIColor colorWithWhite:0.3 alpha:0.6]
#define kCellBarViewBgColor kGetColor(248, 248,248)
#define kCellBarViewLineColor kGetColor(230, 230, 230)

#define kCellBtnTintColorLight kGetColor(170, 170, 170)
#define kCellBtnTintColor kGetColor(88, 88, 88)
#define kCellStarBtnTintColor kGetColor(88, 146, 232)

#define kLightGrayColor [UIColor lightGrayColor]

#define kCellBtnTextColor kGetColor(120, 120, 120)
#define kCellBtnTextColorHighlight [UIColor orangeColor]
#define kCellTimeColor kGetColor(150, 150, 150)

#define kBigButtonColor kRGB(60, 122, 230)
#define kBorderLightColor kGetColor(200, 200, 200)
#define kDarkBlueColor [UIColor colorWithRed:0 green:114/255.0 blue:183/255.0 alpha:1]
#define kBlueColor2 kRGB(23, 79, 180)
#define kHeighLightedVisibilityTagColor kRGB(23, 79, 180)


//#define kAuthorNameBackgroundColor kRGB(39, 85, 163)
#define kAuthorNameBackgroundColor kRGB(40, 40, 40)
//#define kAuthorNameBackgroundColor kRGB(255, 91, 91)
//#define kAuthorNameBackgroundColor [UIColor darkGrayColor]

//#define kPublishBtnColor kRGB(65, 105, 255)
#define kPublishBtnColor kRGB(80, 129, 244)
#define kPublishBtnColorInDiscover kRGB(47, 114, 249)

#pragma mark - Strings

//高德地图基础SDK头文件 与key的宏
#define kGaoDeAppKey @"37f12a81029aca5f8c9470c22ce68404"

#define kDictKeyImageWillBePublished @"imageWillBePublished"
#define kDictKeyTextWillBePublished @"textWillBePublished"
#define kDictKeyTextWillBePublishedInInteraction @"textWillBePublishedInInteraction"

#define kPushDeviceTokenKey @"pushDeviceTokenSavedLocally"
#define kPushDeviceTokenKeyLastUpdatedTime @"kPushDeviceTokenKeyLastUpdatedTime"


//for backend
#define kGroupListNewestLastUpdatedTime @"groupListNewestLastUpdatedTime"

//for frontend interval check
#define kGroupListIntervalRequestTime @"groupListIntervalRequestTime"

#define kLocalContactsUpdatedTime @"localContactsUpdatedTime"


#define kSelfTopicListRequestTime @"selfTopicRequestTime"
#define kGroupTopicListRequestTime @"groupTopicListRequestTime"

#define kSelfPhotosListIntervalRequestTime @"selfPhotosListIntervalRequestTime"
#define kSelfPhotosListBottomTime @"selfPhotosListBottomTime"

//推送页面的通知  8个通知中有4种类型
#define kNotificationNewPushUpdateUser @"receivedNewPushUpdateUser"
#define kNotificationNewPushUpdatePost @"receivedNewPushUpdatePost"
#define kNotificationNewPushUpdateMsg @"receivedNewPushUpdateMsg"
#define kNotificationNewPushUpdateGroup @"receivedNewPushUpdateGroup"


#define kDatabaseFileName @"_group.db"

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


//先不要做这个草稿箱的功能，不要紧的
#define alertViewMessageIfCancelEdit @"若退出，文字将保存草稿箱"
#define alertViewMessageForImageIfCancelEdit @"有附带照片，是否放弃编辑？"


# pragma mark - notifications


#define kNotificationUserLoggedIn @"userAndTokenHasBeenRegistered"
#define kNotificationUserLoggedOut @"userAndTokenHasBeenRemoved"

#define kNotificationNewGroupsReceived @"newGroupsReceived"
#define kUserHasChangedIconNotif @"userHasChangedIcon"

#define kNotificationNewFollowReceived @"notificationNewFollowReceived"
#define kNotificationNewCommentReceived @"notificationNewCommentReceived"




#define kNotificationYZChatBegin @"kNotificationYZChatBegin"
#define kNotificationYZChatSendMessage @"kNotificationYZChatSendMessage"


//新发布post的通知
#define kNotificationNewPublishPostAction @"kNotificationNewPublishPostAction"
//更改post的通知
#define kNotificationUpdatePublishPostAction @"kNotificationUpdatePublishPostAction"
//删除post的通知
#define kNotificationDeletePublishPostAction @"kNotificationDeletePublishPostAction"



//现在将关于群组资料改变都用的是一个通知 这个通知目前没有用
#define kNotificationGroupIconChanged @"notifGroupIconChanged"
//新建群组的通知
#define kNewGroupDataSource @"newGroupDataSource"
//群更改的通知
#define kUpdateGroupDataSource @"updateGroupDataSource"
//退群的通知
#define kQuitGroup @"kQuitGroup"

//所有群组的通知
#define kListGroupAll @"kListGroupAll"


//群组类别
#define kGroupCataGoryListTypeOfFour @"kGroupCataGoryListTypeOfFour"

//消息类别
#define kMsgCategoryList @"kMsgCategoryList"
//消息类别存储的key
#define kMsgCategoryListKey  [NSString stringWithFormat:@"kMsgCategoryListKey_%@",(kuserUUID)]

//用户资料修改的通知 只能用userInfo了
#define KUpdateUserInfoDataSource @"UpdateUserInfoDataSource"



//地图搜索的结果的 reponse
#define kAMapPOIKeywordsSearchReponse @"AMapPOIKeywordsSearchReponse"
#define kAMapPOIAroundSearchReponse @"AMapPOIAroundSearchReponse"
//地图搜索 关键字的选择地址 和周边搜索的地址 通知key
#define kAMapPOILocationResponse @"kAMapPOILocationResponse"



#pragma mark - Locations
/* =====================
 
        location
 ======================= */

#define kDefaultLat 31.305203
#define kDefaultlng 121.511931
#define kDefaultLatNum @31.305203
#define kDefaultlngNum @121.511931
#define kCurrentLocationSingleton [WYLocationTool sharedWYLocationTool].location
#define kHideLocationAddressString @""


/* =====================
 
        send or reply
 
 ======================= */


#pragma mark - WYUIDTool
/*  ======= WYUIDTool ========== */
#define kuserUUID [WYUIDTool sharedWYUIDTool].uid.uuid
#define kToken [WYUIDTool sharedWYUIDTool].uid.token
#define kLocalSelf [WYUser queryUserWithUuid:kuserUUID]

//8.7-Handy added   "user add type"
#define kExpectedDatabaseVersion 6


#define kDatabaseVersionInUserDefaultsKey @"databaseVersionInUserDefaults"

#pragma mark - Cache
/* ==============  Cache ============= */
//caches for storage of loaded messages, once loaded, then will use it for later
#define kCachesPath(p) [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:(p)]


#pragma mark - Device

/**
 * device choice
 */
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)



