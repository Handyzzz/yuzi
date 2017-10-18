//
//  WYCellPostFrame.m
//  Withyou
//
//  Created by Tong Lu on 8/5/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import "WYCellPostFrame.h"
#import "UIImage+WYUtils.h"

@interface WYCellPostFrame()
{
    BOOL noHeightLimitForDetailView;
// ========== new ui ==============
    CGFloat headerHeight;
    CGFloat marginHeader;
    CGFloat marginHorizontal;
    CGFloat contentWidth;
    
    CGFloat infoViewHeight;
    CGFloat infoBtnHW;
    CGFloat photosItemWH;
    CGFloat leftToContentLeft;
    CGFloat photoMargin;
}

@end

@implementation WYCellPostFrame

// 分享页
- (instancetype)initWithPost:(WYPost *)post
{
    if (self = [super init]) {
        self.post = post;
        noHeightLimitForDetailView = NO;
        [self setupFramesWithHeightLimit:NO];
    }
    return self;
}
// 详情页 全部展示 没有高度限制
- (instancetype)initWithPostWithNoHeightLimit:(WYPost *)post
{
    if (self = [super init]) {
        self.post = post;
        noHeightLimitForDetailView = YES;
        [self setupFramesWithHeightLimit:YES];
    }
    return self;    
}

- (void)setupFramesWithHeightLimit:(BOOL)noLimit {
    // 默认值
    [self setCommonDimensions];
    // 根据cell类型设置frame
    switch (self.post.type) {
        case WYPostTypeOnlyText:
            [self setPostTextFrames];
            break;
        case WYPostTypeAlbum:
            [self setAlbumFrames];
            break;
        case WYPostTypeSingleImage:
            [self setSingleImageFrames];
            break;
        case WYPostTypeLink:
            [self setLinkFrames];
            break;
        case WYPostTypeVideo:
            [self setVideoFrames];
            break;
    }
    
    //end
    [self setCommonFrame];
}

- (void)setCommonDimensions
{
    // changed
    headerHeight = 32.0;
    marginHeader = 10.0;
    marginHorizontal = 15.0;
    leftToContentLeft = 25;
    contentWidth = kAppScreenWidth - 2 * marginHorizontal;
    infoViewHeight = 54;
    photoMargin = 15.f;
}

// 计算纯文本
- (void)setPostTextFrames {
    
    if(self.post.title && [self.post.title isEqualToString:@""] == NO) {
        // setup2 custome
        CGSize titleSize = [self.post.title sizeWithFont:kPostTitleFont maxSize:CGSizeMake(contentWidth, CGFLOAT_MAX) minimumLineHeight:0];
        
        // height 16 最多2行
        if(noHeightLimitForDetailView == NO && titleSize.height > kPostTitleLineHeight * 2) {
            titleSize.height = kPostTitleLineHeight * 2;
        }
        
        //给title加margin
        self.textTitleFrame = CGRectMake(0, marginHeader, contentWidth, titleSize.height + 5);
    }else {
        self.textTitleFrame = CGRectMake(0, 4, contentWidth, 0);
    }
    
    CGSize contentSize = [self.post.content sizeWithFont:kPostContentFont maxSize:CGSizeMake(contentWidth, CGFLOAT_MAX) minimumLineHeight:4];
    //16号字 高度19+1/3.f
    if(noHeightLimitForDetailView == NO && contentSize.height > kPostContentLineHeight * 6 + 4 * 6){
        contentSize.height = kPostContentLineHeight * 6 + 4 * 6;
    }
    self.textContentFrame = CGRectMake(0,CGRectGetMaxY(self.textTitleFrame) + 6, contentWidth, contentSize.height);
    
    if (self.post.images.count > 0) {
        CGFloat photosHeight;
        NSInteger num = (self.post.images.count + 2)/3;
         photosItemWH = ((kAppScreenWidth - (15 * 2 + 2 * 4))/3.0);
        CGFloat space = 4.0;
        photosHeight = num *photosItemWH + (num-1)*space;
        self.photosFrame = CGRectMake(0, CGRectGetMaxY(self.textContentFrame) + 12, contentWidth, photosHeight);
    }else{
        self.photosFrame = CGRectMake(0, CGRectGetMaxY(self.textContentFrame), 0, 0);
    }
    
    //分享页
    if (!noHeightLimitForDetailView) {
        if(self.post.extension.pdfs.count > 0 ) {
            self.textAttachmentFrame = CGRectMake(25, CGRectGetMaxY(self.photosFrame) + 12, 100, 20);
        }else {
            self.textAttachmentFrame = CGRectMake(0, CGRectGetMaxY(self.photosFrame), 0, 0);
        }

    }else{
        //详情页
        if(self.post.extension.pdfs.count > 0 ) {
            NSInteger num = self.post.extension.pdfs.count;
            CGFloat space = 10.0;
            CGFloat itemH = 50.0;
            CGFloat attH = num *itemH + (num - 1)*space;
            self.textAttachmentFrame = CGRectMake(0, CGRectGetMaxY(self.photosFrame) + 12, contentWidth, attH);
        }else {
            self.textAttachmentFrame = CGRectMake(0, CGRectGetMaxY(self.photosFrame), 0, 0);
        }
    }
    
    self.bodyFrame = CGRectMake(marginHorizontal, CGRectGetMaxY(self.headerFrame), contentWidth, CGRectGetMaxY(self.textAttachmentFrame));
}

// 计算单照片
- (void)setSingleImageFrames {
    if(noHeightLimitForDetailView) {
        CGFloat height = (self.post.mainPic.height / self.post.mainPic.width) * kAppScreenWidth;
        self.singleImageFrame = CGRectMake(0, marginHeader, kAppScreenWidth, height);
    }else {
        if (self.post.mainPic.height > self.post.mainPic.width) {
            //长图
            CGFloat height = kAppScreenWidth - 2 * photoMargin;
            CGFloat width = (self.post.mainPic.width / self.post.mainPic.height)*height;
            self.singleImageFrame = CGRectMake(photoMargin, marginHeader, width, height);

        }else{
            //扁图
            CGFloat width = kAppScreenWidth;
            CGFloat height = (self.post.mainPic.height/ self.post.mainPic.width)*kAppScreenWidth;
            if (height < kAppScreenWidth/3.0) {
                height = kAppScreenWidth/3.0;
            }
            self.singleImageFrame = CGRectMake(0, marginHeader, width, height);
            
        }
    }
    if(self.post.content.length > 0) {
        CGSize contentSize = [self.post.content sizeWithFont:kPostContentFont maxSize:CGSizeMake(contentWidth, CGFLOAT_MAX) minimumLineHeight:6];
        // height 15 line height 21 最多3行 为63
        if(noHeightLimitForDetailView == NO && contentSize.height > kPostContentLineHeight * 3) {
            contentSize.height = kPostContentLineHeight * 3;
        }
        self.singleImageTextFrame = CGRectMake(marginHorizontal,CGRectGetMaxY(self.singleImageFrame) + 8, contentWidth, contentSize.height);
    }else {
        self.singleImageTextFrame = CGRectMake(marginHorizontal,CGRectGetMaxY(self.singleImageFrame), 0, 0);
    }
    
    self.bodyFrame = CGRectMake(0, CGRectGetMaxY(self.headerFrame), kAppScreenWidth, CGRectGetMaxY(self.singleImageTextFrame));
}

// 计算相册
- (void)setAlbumFrames {
    
    CGFloat height = kAppScreenWidth + 16 + 2;
    self.singleImageFrame = CGRectMake(0, marginHeader, kAppScreenWidth, height);

    if(self.post.albumTitle && [self.post.albumTitle isEqualToString:@""] == NO) {
        // setup2 custome
        CGSize titleSize = [self.post.albumTitle sizeWithFont:kPostTitleFont maxSize:CGSizeMake(contentWidth, CGFLOAT_MAX) minimumLineHeight:0];
        // height 16 最多2行
        if(noHeightLimitForDetailView == NO && titleSize.height > kPostTitleLineHeight * 2) {
            titleSize.height = kPostTitleLineHeight * 2;
        }
        self.albumTitleFrame = CGRectMake(marginHorizontal, CGRectGetMaxY(self.singleImageFrame) + 8 , contentWidth, titleSize.height);
    }else {
        self.albumTitleFrame = CGRectMake(marginHorizontal, CGRectGetMaxY(self.singleImageFrame) , contentWidth, 0);
    }
    
    if(self.post.content.length > 0) {
        CGSize contentSize = [self.post.content sizeWithFont:kPostContentFont maxSize:CGSizeMake(contentWidth, CGFLOAT_MAX) minimumLineHeight:6];
        // height 15 line height 21 最多3行 为63
        if(noHeightLimitForDetailView == NO && contentSize.height > kPostContentLineHeight * 3) {
            contentSize.height = kPostContentLineHeight * 3;
        }
        self.singleImageTextFrame = CGRectMake(marginHorizontal,CGRectGetMaxY(self.albumTitleFrame) + 8, contentWidth, contentSize.height);
    }else {
        self.singleImageTextFrame = CGRectMake(marginHorizontal,CGRectGetMaxY(self.albumTitleFrame), 0, 0);
    }
    
    self.bodyFrame = CGRectMake(0, CGRectGetMaxY(self.headerFrame), kAppScreenWidth, CGRectGetMaxY(self.singleImageTextFrame));
}
// 计算视频
- (void)setVideoFrames {
    self.videoImageFrame = CGRectMake(0, marginHeader, kAppScreenWidth, kAppScreenWidth * (2.0/3.0));
    if(self.post.content.length > 0) {
        CGSize contentSize = [self.post.content sizeWithFont:kPostContentFont maxSize:CGSizeMake(contentWidth, CGFLOAT_MAX) minimumLineHeight:6];
        // height 15 line height 21 最多3行 为63
        if(noHeightLimitForDetailView == NO && contentSize.height > kPostContentLineHeight * 3) {
            contentSize.height = kPostContentLineHeight * 3;
        }
        self.videoTextFrame = CGRectMake(marginHorizontal,CGRectGetMaxY(self.videoImageFrame) + 8, contentWidth, contentSize.height);
    }else {
        self.videoTextFrame = CGRectMake(marginHorizontal,CGRectGetMaxY(self.videoImageFrame), 0, 0);
    }
    
    self.bodyFrame = CGRectMake(0, CGRectGetMaxY(self.headerFrame), kAppScreenWidth, CGRectGetMaxY(self.videoTextFrame));
}


// 计算链接
- (void)setLinkFrames {
    
    if ([self.post.link.url containsString:@"https://yuziapp.com"]) {
        //内部
        CGRect linkContainer = CGRectZero;
        if(self.post.content.length > 0) {
            CGSize contentSize = [self.post.content sizeWithFont:kPostContentFont maxSize:CGSizeMake(contentWidth, CGFLOAT_MAX) minimumLineHeight:6];
            // height 15, line height 21, 最多4行
            if(noHeightLimitForDetailView == NO && contentSize.height > kPostContentLineHeight * 4) {
                contentSize.height = kPostContentLineHeight * 4;
            }
            
            self.linkContentFrame = CGRectMake(0, marginHeader, contentWidth, contentSize.height);
            linkContainer = CGRectMake(0, CGRectGetMaxY(self.linkContentFrame) + 15, contentWidth, 0);
        }else {
            linkContainer = CGRectMake(0, marginHeader, contentWidth, 0);
        }
        
        CGFloat containerMargin = 10.0;
        
        self.linkImageFrame = CGRectMake(0, 0, contentWidth, contentWidth * (9.0/20.0));
        CGSize size = [self.post.link.title sizeWithFont:kPostLinkTitleFont maxSize:CGSizeMake(contentWidth - 20, 40) minimumLineHeight:6];
        self.linkTitleFrame = CGRectMake(containerMargin, CGRectGetMaxY(self.linkImageFrame) + 8, contentWidth - containerMargin * 2, size.height);
        
        //单行文字 12号字  给定14pt高度
        if(self.post.link.keywords.length > 0) {
            self.linkKeyWordFrame = CGRectMake(containerMargin, CGRectGetMaxY(self.linkTitleFrame) + 8, contentWidth - containerMargin * 2, 14);
        }else {
            self.linkKeyWordFrame = CGRectMake(containerMargin, CGRectGetMaxY(self.linkTitleFrame), 0, 0);
        }
        if(self.post.link.source.length > 0) {
            self.linkSourceFrame = CGRectMake(containerMargin, CGRectGetMaxY(self.linkKeyWordFrame) + 16, contentWidth - containerMargin * 2, 14);
        }else {
            self.linkSourceFrame = CGRectMake(containerMargin, CGRectGetMaxY(self.linkKeyWordFrame), 0, 0);
        }
        
        linkContainer.size.height = CGRectGetMaxY(self.linkSourceFrame) + 10;
        self.linkContinerFrame = linkContainer;
        
        self.bodyFrame = CGRectMake(marginHorizontal, CGRectGetMaxY(self.headerFrame), contentWidth, CGRectGetMaxY(self.linkContinerFrame));
    }else{
        //外部链接
        CGRect linkContainer = CGRectZero;
        if(self.post.content.length > 0) {
            CGSize contentSize = [self.post.content sizeWithFont:kPostContentFont maxSize:CGSizeMake(contentWidth, CGFLOAT_MAX) minimumLineHeight:6];
            // height 15, line height 21, 最多4行
            if(noHeightLimitForDetailView == NO && contentSize.height > kPostContentLineHeight * 4) {
                contentSize.height = kPostContentLineHeight * 4;
            }
            
            self.linkContentFrame = CGRectMake(0, marginHeader, contentWidth, contentSize.height);
            linkContainer = CGRectMake(0, CGRectGetMaxY(self.linkContentFrame) + 15, contentWidth, 0);
        }else {
            linkContainer = CGRectMake(0, marginHeader, contentWidth, 0);
        }
        
        linkContainer.size.height = 80;
        self.linkContinerFrame = linkContainer;
        
        self.bodyFrame = CGRectMake(marginHorizontal, CGRectGetMaxY(self.headerFrame), contentWidth, CGRectGetMaxY(self.linkContinerFrame));
    }
}

// 公用部分
- (CGRect)headerFrame {
    return CGRectMake(0, marginHeader, kAppScreenWidth, headerHeight);
}
- (void)setCommonFrame {
    //setup1
    [self setTagsFrameWithOriginY: CGRectGetMaxY(self.bodyFrame)];
    //setup2
    [self setLocationFrameWithOriginY: CGRectGetMaxY(self.tagsFrame)];
    
    //setup3
    [self setRemindFrameWithOriginY:CGRectGetMaxY(self.locationFrame)];
    
    //setup4
    [self setInfoViewWithOriginY:CGRectGetMaxY(self.remindFrame)];
    
    
    //setup5
    [self setCommentWithOriginY:CGRectGetMaxY(self.infoFrame)];
    
    if(noHeightLimitForDetailView) {
        //setup6
        self.timeLabelFrame = CGRectMake(kAppScreenWidth - marginHorizontal - 100, self.headerFrame.origin.y +  (headerHeight - 10)/2 , 100, 10);
        
        //setup7
        self.starViewFrame = CGRectMake(0, CGRectGetMaxY(self.infoFrame) + 20, kAppScreenWidth, 72);
        
        //setup8
        self.cellHeight =  CGRectGetMaxY(self.starViewFrame) + kPostSeparationLineHeight;
    }else {
        
        //setup6
        self.timeLabelFrame = CGRectMake(marginHorizontal, CGRectGetMaxY(self.commentBodyFrame) + 10, 100, 12);
        //setup7
        self.cellHeight =  CGRectGetMaxY(self.timeLabelFrame) + 15 + kPostSeparationLineHeight;
    }
    
}

-(void)setTagsFrameWithOriginY:(int)y{
    NSMutableAttributedString *mas;
    if (!noHeightLimitForDetailView) {
        mas = [self calculateTagsName:self.post type:1];

    }else{
        mas = [self calculateTagsName:self.post type:2];
    }
    
    CGFloat h = [mas.string sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(contentWidth - leftToContentLeft, kAppScreenHeight) minimumLineHeight:5.0].height;
    
    if (mas.length > 0) {
        self.tagsFrame = CGRectMake(marginHorizontal, y + 15, contentWidth, h);
    }else{
        self.tagsFrame = CGRectMake(0, y, contentWidth, 0);
    }
}

- (void)setLocationFrameWithOriginY:(int)y {
    if(self.post.address && self.post.address.name) {
        self.locationFrame = CGRectMake(marginHorizontal, y + 15, contentWidth, 16);
    }else {
        self.locationFrame = CGRectMake(0, y, 0, 0);
    }
}

- (void)setRemindFrameWithOriginY:(CGFloat)y{
    //计算文本高度
    NSMutableAttributedString *mas = [self calculateRemindName:self.post.with_people];
    CGFloat h = [mas.string sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(contentWidth - leftToContentLeft, kAppScreenHeight) minimumLineHeight:5.0].height;
    if (self.post.with_people && self.post.with_people.count > 0) {
        self.remindFrame = CGRectMake(marginHorizontal, y + 15, contentWidth, h);
    }else{
        self.remindFrame = CGRectMake(0, y, contentWidth, 0);
    }
}

// 公用部分 info
- (void)setInfoViewWithOriginY:(CGFloat)y {
    if(noHeightLimitForDetailView == NO) {
        self.infoFrame = CGRectMake(0, y + 5, kAppScreenWidth, infoViewHeight);
    }else {
        // 详情页不显示
        self.infoFrame = CGRectMake(0, y + 5, kAppScreenWidth, infoViewHeight);
    }
}


// 公用部分 评论
- (void)setCommentWithOriginY:(CGFloat)y {

    if(self.post.comments.count > 0 && noHeightLimitForDetailView == NO) {
        CGRect last = CGRectZero;
        NSMutableArray *temp = [NSMutableArray array];
        for (YZPostComment *comment in self.post.comments) {
            NSString *str = nil;
            if(comment.replied_author != nil && comment.replied_author.uuid != nil) {
                str = [NSString stringWithFormat:@"%@回复%@ %@",comment.author.fullName,comment.replied_author.fullName,comment.content];
            }else {
                str = [NSString stringWithFormat:@"%@ %@",comment.author.fullName,comment.content];
            }
            CGSize size = [str sizeWithFont:kPostCommentFont maxSize:CGSizeMake(contentWidth, CGFLOAT_MAX) minimumLineHeight:5];
            // 暂定最高2行 font 12 lineh 17 最多2行 为34
            if(size.height > 34) {
                size.height = 34;
            }
            //07.29暂定最高1行，Font 13，LineH 17
            if(size.height > 17) {
                size.height = 17;
            }
            
            CGRect frame = CGRectMake(0, CGRectGetMaxY(last), contentWidth, size.height);
            [temp addObject:[NSValue valueWithCGRect:frame]];
            last = frame;
            last.origin.y = last.origin.y + 3;
            
        }
        self.commentFrames = temp;
        self.commentBodyFrame = CGRectMake(marginHorizontal, y + 15, contentWidth, CGRectGetMaxY(last) - 10);
    }else {
        self.commentBodyFrame = CGRectMake(marginHorizontal, y, 0, 0);
    }
    
}
-(NSMutableAttributedString *)calculateRemindName:(NSArray *)userArr{
    
    NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:@"与"];
    [mStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kPostWithWhomFont.pointSize] range:NSMakeRange(0, 1)];
    [mStr addAttribute:NSForegroundColorAttributeName value:kRGB(67, 198, 172) range:NSMakeRange(0, 1)];
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    NSDictionary *attrsDictionary1 = @{NSFontAttributeName:kPostWithWhomFont,NSForegroundColorAttributeName:kRGB(67, 198, 172),
                                       NSParagraphStyleAttributeName:paragraphStyle};
    
    for (int i = 0; i < userArr.count; i ++) {
        WYUser *user = userArr[i];
        if (i == 0) {
            NSAttributedString *aName = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",user.fullName]];
            NSMutableAttributedString *maName = [[NSMutableAttributedString alloc]initWithAttributedString:aName];
            //加粗
            [maName addAttributes:attrsDictionary1 range:NSMakeRange(0, maName.length)];
            
            //加点击事件
            NSString * value = [NSString stringWithFormat:@"remind://%d",i];
            [maName addAttribute:NSLinkAttributeName value:value range:[[maName string] rangeOfString:user.fullName]];
            [mStr appendAttributedString:maName];
            
        }else{
            NSAttributedString *aName = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@", %@",user.fullName]];
            NSMutableAttributedString *maName = [[NSMutableAttributedString alloc]initWithAttributedString:aName];
            //加粗
            [maName addAttributes:attrsDictionary1 range:NSMakeRange(0, maName.length)];
            //加点击事件
            NSString * value = [NSString stringWithFormat:@"remind://%d",i];
            [maName addAttribute:NSLinkAttributeName value:value range:[[maName string] rangeOfString:user.fullName]];

            [mStr appendAttributedString:maName];
        }
    }
    return mStr;
}

//type 1 分享页 type 2 详情页
-(NSMutableAttributedString *)calculateTagsName:(WYPost *)post type:(NSInteger)type{
    
    NSArray *tagList = post.tag_list;
    
    NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc]init];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0f;
    NSDictionary *attrsDictionary1 = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                       NSParagraphStyleAttributeName:paragraphStyle};
    
    for (int i = 0; i < tagList.count; i ++) {
        WYTag *tag = tagList[i];
        NSString *tagName = tag.tag_name;
        if (i == 0) {
            NSAttributedString *aName = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"#%@",tagName]];
            NSMutableAttributedString *maName = [[NSMutableAttributedString alloc]initWithAttributedString:aName];
            //加粗
            [maName addAttributes:attrsDictionary1 range:NSMakeRange(0, maName.length)];
            //加点击事件
            [maName addAttribute:NSLinkAttributeName
                           value:[NSString stringWithFormat:@"tags://%d",i]
                           range:[[maName string] rangeOfString:maName.string]];
            [mStr appendAttributedString:maName];
            
        }else{
            NSAttributedString *aName = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"  #%@",tagName]];
            NSMutableAttributedString *maName = [[NSMutableAttributedString alloc]initWithAttributedString:aName];
            //加粗
            [maName addAttributes:attrsDictionary1 range:NSMakeRange(0, maName.length)];
            //加点击事件
            NSString * value = [NSString stringWithFormat:@"tags://%d",i];
            [maName addAttribute:NSLinkAttributeName value:value range:[[maName string] rangeOfString:maName.string]];
            [mStr appendAttributedString:maName];
        }
    }
    
    //如果是高级用户 或者是自己发的帖子 后边添加一个我的标签
    WYProfile *profile = [WYProfile queryProfileFromUuid:kuserUUID];
    if ((type == 2) && (([profile.experience_degree floatValue] >= 500.f) || [post.author.uuid isEqualToString:kuserUUID])) {
        //是高级用户
        NSAttributedString *aName = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"  %@",@"我的标签"]];
        NSMutableAttributedString *maName = [[NSMutableAttributedString alloc]initWithAttributedString:aName];
        //加粗
        [maName addAttributes:attrsDictionary1 range:NSMakeRange(0, maName.length)];
        //加点击事件
        NSString * value = [NSString stringWithFormat:@"tags://%lu",tagList.count];
        [maName addAttribute:NSLinkAttributeName value:value range:[[maName string] rangeOfString:maName.string]];
        [mStr appendAttributedString:maName];
    }
    
    return mStr;
}


@end
