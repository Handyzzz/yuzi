//
//  YZPostCellBase.m
//  Withyou
//
//  Created by ping on 2017/5/14.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZPostViewBase.h"

@interface YZPostViewBase()

@property (nonatomic, assign)BOOL isDetail;

@end

@implementation YZPostViewBase

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (instancetype)init {
    if(self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (YZPostHeader *)header {
    if(!_header) {
        YZPostHeader *header = [[YZPostHeader alloc] initWithFrame:CGRectZero];
        [self addSubview:header];
        if(self.isDetail == NO) {
            [header.moreButton addTarget:self action:@selector(moreActions:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClick:)];
        [header.iconImage addGestureRecognizer:tap];
        header.iconImage.userInteractionEnabled = YES;
        
        _header = header;
    }
    return _header;
}

- (YZPostInfoView *)infoView {
    if(!_infoView) {
        YZPostInfoView *infoView = [[YZPostInfoView alloc] initWithFrame:CGRectZero];
//        infoView.backgroundColor = [UIColor redColor];
        [self addSubview:infoView];
        if(self.isDetail == NO) {
            [infoView.starButton addTarget:self action:@selector(starAction:) forControlEvents:UIControlEventTouchUpInside];
            [infoView.commentButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        _infoView = infoView;
    }
    return _infoView;
}

- (YZPostStarView *)starView {
    if(!_starView) {
        YZPostStarView * starView = [[YZPostStarView alloc] initWithFrame:CGRectZero];
        [self addSubview:starView];
        [starView.starBtn addTarget:self action:@selector(starAtDetailPage:) forControlEvents:UIControlEventTouchUpInside];
        __weak typeof(self) this = self;
        starView.onIconClick = ^(WYUser *user) {
            if([this.delegate respondsToSelector:@selector(iconClick:)]) {
                [this.delegate iconClick:user];
            }
        };
        _starView = starView;
    }
    return _starView;
}

- (YZPostCommentView *)commentView {
    if(!_commentView) {
        YZPostCommentView *commentView = [[YZPostCommentView alloc] initWithFrame:CGRectZero];
        [self addSubview:commentView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentAction:)];
        [commentView addGestureRecognizer:tap];
        _commentView = commentView;
    }
    return _commentView;
}
- (YZPostLocationView *)locationView {
    if(_locationView == nil) {
        YZPostLocationView *locationView = [[YZPostLocationView alloc] initWithFrame:CGRectZero];
        [self addSubview:locationView];
        _locationView = locationView;
        _locationView.addressLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressLabelClick:)];
        [_locationView.addressLabel addGestureRecognizer:tap];
    }
    return _locationView;
}

-(UIView *)remindView{
    if (_remindView == nil) {
        _remindView = [YZPostRemindView new];
        [self addSubview:_remindView];
        _remindView.remindTV.delegate = self;
    }
    return _remindView;
}
//优化可以加 link 变成段
-(UIView *)tagView{
    if (_tagView == nil) {
        _tagView = [[WYPostTagView alloc] initWithFrame:CGRectZero];
        [self addSubview:_tagView];
        _tagView.tagTextView.delegate = self;
    }
    return _tagView;
}

- (UIView *)bodyView {
    if(!_bodyView) {
        UIView *body = [UIView new];
        [self addSubview:body];
        _bodyView = body;
    }
    return _bodyView;
}

- (UILabel *)timeLabel {
    if(!_timeLabel) {
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        timeLabel.font = [UIFont systemFontOfSize:11];
        timeLabel.textColor = UIColorFromHex(0x999999);
        _timeLabel = timeLabel;
        [self addSubview:timeLabel];
    }
    return _timeLabel;
}


-(void)setPostFrame:(WYCellPostFrame *)postFrame {
    _postFrame = postFrame;
    self.isDetail = NO;
    WYPost *post = postFrame.post;
    [self setFrame:CGRectMake(0, 0, kAppScreenWidth, postFrame.cellHeight)];
    self.header.frame = postFrame.headerFrame;
    [self.header setupWith:post];
    [self.infoView setupWith:postFrame isDetail:NO];
    [self.commentView setupWith:postFrame delegateObject:self];
    
    self.bodyView.frame = postFrame.bodyFrame;
    
    self.timeLabel.frame = postFrame.timeLabelFrame;
    self.timeLabel.text = [NSString stringWithCreatedAt:[post.createdAtFloat doubleValue]];
    
    //标签
    NSMutableAttributedString *mas = [self calculateTagsName:post type:1];
    if (mas.length > 0) {
        self.tagView.frame = postFrame.tagsFrame;
        self.tagView.tagTextView.attributedText = mas;
        //改变link 的文本颜色 其他的是没有用的
        self.tagView.tagTextView.linkTextAttributes = @{NSForegroundColorAttributeName : kRGB(43, 161, 212) ,NSFontAttributeName :kPostWithWhomFont};
        [self.tagView iconIV];
        
        self.tagView.hidden = NO;
    }else{
        //宽为0 影响自动布局
        self.tagView.frame = postFrame.tagsFrame;
        self.tagView.height = 0;
        self.tagView.hidden = YES;
    }
    
    //地址
    if(post.address && post.address.name) {
        self.locationView.frame = postFrame.locationFrame;
        self.locationView.addressLabel.text = post.address.name;
        self.locationView.iconImage.hidden = NO;
        self.locationView.addressLabel.hidden = NO;
    }else {
        self.locationView.frame = CGRectZero;
        self.locationView.addressLabel.hidden = YES;
        self.locationView.iconImage.hidden = YES;
    }
    
    //提及
    if (post.with_people && post.with_people.count > 0) {
        self.remindView.frame = postFrame.remindFrame;
        NSMutableAttributedString *mas = [self calculateRemindName:post.with_people];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5.0f;
        [mas addAttributes:@{NSParagraphStyleAttributeName : paragraphStyle} range:NSMakeRange(0, mas.length)];
        self.remindView.remindTV.attributedText = mas;
        //改变link 的文本颜色 其他的是没有用的
        self.remindView.remindTV.linkTextAttributes = @{NSForegroundColorAttributeName:kRGB(67, 198, 172), NSFontAttributeName:kPostWithWhomFont};
        [self.remindView iconIV];
        
        self.remindView.hidden = NO;
    }else{
        //宽为0 影响自动布局
        self.remindView.frame = postFrame.remindFrame;
        self.remindView.height = 0;
        self.remindView.hidden = YES;
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

//详情页
- (void)setDetailLayout:(WYCellPostFrame *)postFrame {
    _postFrame = postFrame;
    self.isDetail = YES;
    WYPost *post = postFrame.post;
    [self setFrame:CGRectMake(0, 0, kAppScreenWidth, postFrame.cellHeight)];
    self.header.frame = postFrame.headerFrame;
    [self.header setupWith:post];
    self.header.moreButton.hidden = YES;
    
    [self.infoView setupWith:postFrame isDetail:YES];
    [self setupStarView:postFrame];
    
    self.bodyView.frame = postFrame.bodyFrame;
    
    self.timeLabel.frame = postFrame.timeLabelFrame;
    self.timeLabel.text = [NSString stringWithCreatedAt:[post.createdAtFloat doubleValue]];
    self.timeLabel.textAlignment = NSTextAlignmentRight;

    //标签
    NSMutableAttributedString *mas = [self calculateTagsName:post type:2];

    if (mas.length > 0) {
        self.tagView.frame = postFrame.tagsFrame;
        self.tagView.tagTextView.attributedText = mas;
        //改变link 的文本颜色 其他的是没有用的
        self.tagView.tagTextView.linkTextAttributes = @{NSForegroundColorAttributeName : kRGB(43, 161, 212) ,NSFontAttributeName :kPostWithWhomFont};
        [self.tagView iconIV];
        
        self.tagView.hidden = NO;
    }else{
        //宽为0 影响自动布局
        self.tagView.frame = postFrame.tagsFrame;
        self.tagView.height = 0;
        self.tagView.hidden = YES;
    }
    
    //地址
    if(post.address && post.address.name) {
        self.locationView.frame = postFrame.locationFrame;
        self.locationView.addressLabel.text = post.address.name;
        self.locationView.iconImage.hidden = NO;
        self.locationView.addressLabel.hidden = NO;
    }else {
        self.locationView.frame = CGRectZero;
        self.locationView.addressLabel.hidden = YES;
        self.locationView.iconImage.hidden = YES;
    }
    //提及
    if (post.with_people && post.with_people.count > 0) {
        self.remindView.frame = postFrame.remindFrame;
        NSMutableAttributedString *mas = [self calculateRemindName:post.with_people];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5.0f;
        [mas addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, mas.length)];
        self.remindView.remindTV.attributedText = mas;
        //改变link 的文本颜色 其他的是没有用的
        self.remindView.remindTV.linkTextAttributes = @{NSForegroundColorAttributeName:kRGB(67, 198, 172), NSFontAttributeName:kPostWithWhomFont};
        [self.remindView iconIV];
        self.remindView.hidden = NO;
    }else{
        //宽为0 影响自动布局
        self.remindView.frame = postFrame.remindFrame;
        self.remindView.height = 0;
        self.remindView.hidden = YES;
    }
}

-(void) setupStarView:(WYCellPostFrame *)postFrame {
    self.starView.frame = postFrame.starViewFrame;
    [self.starView setStaredUsers:postFrame.post.starred_users];
    self.starView.starNumberLabel.text = [NSString getNumberStringWith:(int)postFrame.post.starred_users.count andMaxNumber:99];
    NSString *starImg = nil;
    if(postFrame.post.starred) {
        starImg = @"shareDetailpageStarHighlight";
    }else {
        starImg = @"shareDetailpageStar";
    }
    [self.starView.starBtn setImage:[UIImage imageNamed:starImg] forState:UIControlStateNormal];
    _postFrame = postFrame;
}

#pragma mark- actions
- (void)iconClick:(UITapGestureRecognizer *)tap {
    if([self.delegate respondsToSelector:@selector(iconClick:)]) {
        [self.delegate iconClick:self.postFrame.post.author];
    }
}
- (void)moreActions:(UIButton *)btn {
    btn.selected = YES;
    if([self.delegate respondsToSelector:@selector(moreActions:btn:)]) {
        [self.delegate moreActions:self.postFrame.post btn:btn];
    }
}

- (void)starAction:(UIButton *)btn {
    if([self.delegate respondsToSelector:@selector(star:)]) {
        [self.delegate star:self.postFrame.post];
    }
}
- (void)starAtDetailPage:(UIButton *)btn {
    if([self.delegate respondsToSelector:@selector(starAtDetailPage:)]) {
         [self.delegate starAtDetailPage:self.postFrame.post];
    }else {
        [self starAction:btn];
    }
}

- (void)commentAction:(UIButton *)btn {
    if([self.delegate respondsToSelector:@selector(detail:)]) {
        [self.delegate detail:self.postFrame.post];
    }
}

// 点击地址信息
- (void)addressLabelClick:(UITapGestureRecognizer *)tap {
    if([self.delegate respondsToSelector:@selector(addressClick:)]) {
        [self.delegate addressClick:self.postFrame.post.address];
    }
}


# pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    
    //点击与谁一起的信息
    if ([textView isEqual:_remindView.remindTV]) {
        if ([[URL scheme] isEqualToString:@"remind"]) {
            int index = [[URL host] intValue];
            if (index < self.postFrame.post.with_people.count) {
                WYUser *user = self.postFrame.post.with_people[index];
                if ([self.delegate respondsToSelector:@selector(remindClick:)]) {
                    [self.delegate remindClick:user];
                }
            }
        }
    }else if([textView isEqual:_tagView.tagTextView]){
        if ([[URL scheme] isEqualToString:@"tags"]) {
            int index = [[URL host] intValue];
            //有一个我的标签 不在数组内
            if (index <= self.postFrame.post.tag_list.count) {
                if ([self.delegate respondsToSelector:@selector(tagsClick:index:)]) {
                    [self.delegate tagsClick:self.postFrame.post index:index];
                }
            }
        }
    }else{
        //textVeiw文本框的contentTV
        if([[URL scheme] isEqualToString:@"marked"]) {
            int index = [[URL host] intValue];
            YZPostComment*comment = self.postFrame.post.comments[textView.tag];
            if(comment!= nil && index < comment.mention.count) {
                YZMarkText *mark = comment.mention[index];
                if([self.delegate respondsToSelector:@selector(atStringClick:)])
                {
                    [self.delegate atStringClick:mark];
                }
            }
        }
    }
    return YES;
}

@end
