//
//  WYAddLinkVC.m
//  Withyou
//
//  Created by Tong Lu on 8/2/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import "WYAddLinkVC.h"
#import "TFHpple.h"
#import "YZLink.h"
#import <ImageIO/ImageIO.h>
#import "WYAddTextVC.h"
#import "WYselectScopeSecondTimePageVC.h"
#import "YZLoadingBtn.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "WYPublishOtherView.h"
#import "WYLocationViewController.h"
#import "WYRemindFriendsVC.h"
#import "WYRemindGroupMembersVC.h"
#import "WYPublishAddTagsVC.h"
#import "UIImage+EMGIF.h"


#define  WYRemindTypeOfFriends  @"typeOfFriend"
#define  WYRemindTypeOfGroup @"typeOfGroup"

//同时也是存储自己的收藏的地方
@interface WYAddLinkVC()<UIScrollViewDelegate>
{
    UITextView *_tv, *_tv2;
    YZLoadingBtn *_btn;
    UIImageView *_iconView;
    UIView *_preview, *_commentView;
    UILabel *_label;
    YZLink *linkToPublish;
    UIBarButtonItem *publishBtn;
    NSArray *mentionToPublish;
    UILabel *_secondSelectLb;
    UITextView *_textView;
    UIScrollView *_scrollView;
    YZAddress *_address;
}
@property (nonatomic, strong) WYPublishOtherView *otherView;
@property (nonatomic, copy) NSDictionary *remindDic;
@property (nonatomic, strong) NSMutableArray *selectedTagsArr;

@end

@implementation WYAddLinkVC
#define textH  (112.f)

-(NSMutableArray*)selectedTagsArr{
    if (_selectedTagsArr == nil) {
        _selectedTagsArr = [NSMutableArray array];
    }
    return _selectedTagsArr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    linkToPublish = [[YZLink alloc] init];
    
    // default
    linkToPublish.title = @"无标题链接";
    _label.text = @"无标题链接";
    
    [self setupUI];

    // url
    // title, original_thumbnail_url
}
- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"链接";
    
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;

    
    _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.bounces = YES;
    _scrollView.contentSize = CGSizeMake(kAppScreenWidth, kAppScreenHeight +100);
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];

    
    UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(10, kStatusAndBarHeight + 10, kAppScreenWidth - 20, 150)];
    [tv becomeFirstResponder];
    tv.layer.borderColor = kBorderLightColor.CGColor;
    tv.layer.borderWidth = 1;
    tv.layer.cornerRadius = 3;
    tv.font = [UIFont systemFontOfSize:15.0f];
    tv.backgroundColor = [UIColor whiteColor];
    tv.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    tv.textColor = UIColorFromHex(0x333333);
    tv.selectable = YES;
    tv.editable = YES;
    tv.bounces = YES;
    tv.alwaysBounceVertical = NO;
    tv.userInteractionEnabled = YES;
    tv.textAlignment = NSTextAlignmentLeft;
    [_scrollView addSubview:tv];
    _tv = tv;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    YZLoadingBtn *button = [[YZLoadingBtn alloc] initWithFrame:CGRectMake(10, kStatusAndBarHeight + 10 + 150, kAppScreenWidth - 20, 44)];
    [button setTitle:@"预  览" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
    
    UIImage *normalImg = [self imageWithColor:UIColorFromHex(0xffc462)];
    UIImage *highLightImg = [self imageWithColor:UIColorFromHex(0xfdbb4e)];
    [button setBackgroundImage:normalImg forState:UIControlStateNormal];
    [button setBackgroundImage:highLightImg forState:UIControlStateHighlighted];

    [button addTarget:self action:@selector(previewAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:button];
    _btn = button;

    [self addPreview];
//    [self addCommentView];
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishAction)];
    self.navigationItem.rightBarButtonItem = btn;
    publishBtn = btn;
    publishBtn.enabled = false;
    
    if(self.scopeTitle)
    _secondSelectLb.text = self.scopeTitle;
}

//将颜色转换成图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}



#pragma selectScopeSecondTime

-(void)tagsAction{
    
    if (self.publishVisibleScopeType == 1){
        __weak WYAddLinkVC *weakSelf = self;
        WYPublishAddTagsVC *vc = [[WYPublishAddTagsVC alloc]initWithType:AddTagFromPublish];
        vc.contentStr = _textView.text;
        if (weakSelf.selectedTagsArr) {
            [vc.tagStrArr addObjectsFromArray:weakSelf.selectedTagsArr];
        }
        vc.publishTagsClick = ^(NSArray *tempArr) {
            [weakSelf.selectedTagsArr removeAllObjects];
            [weakSelf.selectedTagsArr addObjectsFromArray:tempArr];
            weakSelf.otherView.tagsLabel.text = [weakSelf calculateTagsArrName:tempArr];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }else{
        //提示只有某些情况下生效
        [WYUtility showAlertWithTitle:@"此功能暂在可见范围选择公开时开放"];
    }
    
}


-(void)remindAction{
    __weak WYAddLinkVC*weakSelf = self;
    if (self.publishVisibleScopeType == 1 || self.publishVisibleScopeType == 2) {
        //朋友表
        WYRemindFriendsVC *vc = [WYRemindFriendsVC new];
        vc.naviTitle = @"与谁一起";
        NSArray *remindArr;
        if (self.remindDic && [self.remindDic.allKeys.firstObject isEqualToString:WYRemindTypeOfFriends]) {
            remindArr = [weakSelf.remindDic objectForKey:WYRemindTypeOfFriends];
        }
        if (remindArr.count > 0) {
            [vc.selectedMember addObjectsFromArray:[weakSelf.remindDic objectForKey:WYRemindTypeOfFriends]];
        }
        vc.remindFriends = ^(NSArray *friendsArr) {
            weakSelf.remindDic = [NSDictionary dictionaryWithObject:[friendsArr copy] forKey:WYRemindTypeOfFriends];
            weakSelf.otherView.remindLabel.text = [weakSelf calculateRemindName:friendsArr];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }else if(self.publishVisibleScopeType == 3){
        //群成员表
        WYRemindGroupMembersVC *vc = [WYRemindGroupMembersVC new];
        vc.naviTitle = @"与谁一起";
        vc.includeAdminList = YES;
        vc.group = self.group;
        NSArray *remindArr;
        if (self.remindDic && [self.remindDic.allKeys.firstObject isEqualToString:WYRemindTypeOfGroup]) {
            remindArr = [weakSelf.remindDic objectForKey:WYRemindTypeOfGroup];
        }
        if (remindArr.count > 0) {
            [vc.selectedMember addObjectsFromArray:[weakSelf.remindDic objectForKey:WYRemindTypeOfGroup]];
        }
        vc.remindFriends = ^(NSArray *friendsArr) {
            weakSelf.remindDic = [NSDictionary dictionaryWithObject:[friendsArr copy] forKey:WYRemindTypeOfGroup];
            weakSelf.otherView.remindLabel.text = [weakSelf calculateRemindName:friendsArr];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }else{
        //提示只有某些情况下生效
        [WYUtility showAlertWithTitle:@"可见范围选择指定朋友或者自己可见时，此功能不可使用"];
    }
}
#pragma selectScopeSecondTime
-(void)selectScopeSecondTime{
    __weak WYAddLinkVC *weakSelf = self;
    WYselectScopeSecondTimePageVC *vc = [WYselectScopeSecondTimePageVC new];
    vc.myBlock = ^(int publishVisibleScopeType, NSString *targetUuid,NSString*title,WYGroup *group) {
        
        
        if (publishVisibleScopeType == 1 || publishVisibleScopeType == 2) {
            //如果类型是自己可见 或者公开可见
            if (self.publishVisibleScopeType != 1 && self.publishVisibleScopeType != 2) {
                //换范围了
                weakSelf.otherView.remindLabel.text = @"";
                weakSelf.remindDic = [NSDictionary dictionary];
            }
        }else if (publishVisibleScopeType == 3){
            //如果类型是群组可见
            if (![weakSelf.targetUuid isEqualToString:targetUuid]) {
                //换范围
                weakSelf.otherView.remindLabel.text = @"";
                weakSelf.remindDic = [NSDictionary dictionary];
            }
        }else{
            weakSelf.otherView.remindLabel.text = @"";
            weakSelf.remindDic = [NSDictionary dictionary];
        }
        //切换范围回来 标签将消失
        if (publishVisibleScopeType == 1 && weakSelf.publishVisibleScopeType == 1) {
            
        }else{
            weakSelf.otherView.tagsLabel.text = @"";
            weakSelf.selectedTagsArr = [NSMutableArray array];
        }

        weakSelf.group = group;
        weakSelf.publishVisibleScopeType = publishVisibleScopeType;
        weakSelf.targetUuid = targetUuid;
        weakSelf.otherView.rangeLabel.text = title;
        
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)addPreview
{
    
    UIView *preview = [[UIView alloc]initWithFrame:CGRectMake(0, kStatusAndBarHeight + 10 + 150 + 44 +25 , kAppScreenWidth, 112)];
    [_scrollView addSubview:preview];
    _preview = preview;
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 112)];
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    iconView.clipsToBounds = YES;
    [preview addSubview:iconView];
    _iconView = iconView;
    
    UILabel *label = [UILabel new];
    label.numberOfLines = 0;
    [preview addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(8);
        make.left.equalTo(_iconView.mas_right).equalTo(10);
        make.right.equalTo(-5);
        make.height.lessThanOrEqualTo(96);
    }];
    _label = label;
}

- (void)addCommentView
{
    if([_commentView isDescendantOfView:_scrollView]){
        return;
    }
    
    UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(10, kStatusAndBarHeight + 10 + 150 + 44 + 25 + 112, kAppScreenWidth - 30, textH)];
    [_scrollView addSubview:commentView];
    _commentView.layer.borderColor = UIColorFromHex(0xc5c5c5).CGColor;
    _commentView.layer.borderWidth = 1;
    _commentView = commentView;
    
    _textView = [UITextView new];
    _textView.text = @"";
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.textColor = UIColorFromHex(0xc5c5c5);
    _textView.userInteractionEnabled = YES;
    [_commentView addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(10);
        make.right.equalTo(0);
        make.bottom.equalTo(-10);
    }];
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addCommentAction)];
    
    [_textView addGestureRecognizer:gr];
    
    _otherView = [[WYPublishOtherView alloc]initWithFrame:CGRectMake(-1, CGRectGetMaxY(commentView.frame), kAppScreenWidth + 2, 200)];
    _otherView.rangeLabel.text = self.scopeTitle;
    if (self.tagName) {
        [self.selectedTagsArr addObject:self.tagName];
        self.otherView.tagsLabel.text = [self calculateTagsArrName:@[self.tagName]];
    }

    [_scrollView addSubview:_otherView];
    
    __weak WYAddLinkVC *weakSelf = self;
    _otherView.visiableRangeViewClick = ^{
        [weakSelf selectScopeSecondTime];
    };
    
    self.otherView.tagsClick = ^{
        [weakSelf tagsAction];
    };
    
    _otherView.LocationClick = ^{
        WYLocationViewController *vc = [WYLocationViewController new];
        vc.locationClick = ^(YZAddress*address) {
            _address = address;
            weakSelf.otherView.locationLabel.text = address.name;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
     _otherView.remindClick = ^{
         [weakSelf remindAction];
    };
}



-(NSMutableString *)calculateRemindName:(NSArray *)friendsArr{
    if (!friendsArr || friendsArr.count == 0) {
        return [NSMutableString stringWithString:@""];
    }
    NSMutableString *mStr = [NSMutableString stringWithString:[friendsArr[0] fullName]];
    for (int i = 1; i < friendsArr.count; i ++) {
        WYUser *user = friendsArr[i];
        NSString *s = [NSString stringWithFormat:@",%@",user.fullName];
        [mStr appendString:s];
    }
    return mStr;
}

-(NSMutableString *)calculateTagsArrName:(NSArray *)tagsArr{
    if (!tagsArr || tagsArr.count == 0) {
        return [NSMutableString stringWithString:@""];
    }
    NSMutableString *mStr = [NSMutableString stringWithString:[NSString stringWithFormat:@"#%@",tagsArr[0]]];
    for (int i = 1; i < tagsArr.count; i ++) {
        NSString *s = tagsArr[i];
        [mStr appendString:[NSString stringWithFormat:@"  #%@",s]];
    }
    return mStr;
}

- (NSString *)convertGB:(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
    return retStr;
}

#pragma mark- UIWebViewDelegate

- (void)parseHtml:(NSString *)url{

    NSURL *targetUrl = [NSURL URLWithString:url];
    if (!(targetUrl && targetUrl.scheme && targetUrl.host))
    {
        //the url looks ok, do something with it
        [WYUtility showAlertWithTitle:@"无法识别链接中的内容，请包含http等字段"];
        return;
    }
    NSURLRequest* request = [NSURLRequest requestWithURL:targetUrl cachePolicy:0 timeoutInterval:7];
    [_btn startLoading];
    /*
     发布链接时，点击预览，应该出现一个圈圈在转，提示用户他的点击是有反应的。如果解析时间太长的话，比如说超过7秒，应该终止解析，提示用户说网络条件不好，在网络信号强的地方再发布。另外，加解析一些不好识别的url的话，解析后，整个页面的点击也不能操作。
     添加异步 
     */
   
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        [_btn stopLoading];
        if(connectionError) {
            [WYUtility showAlertWithTitle:@"网络连接失败"];
            return;
        }

        TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:data];
        
        NSString *tutorialsXpathQueryString = @"//title";
        
        NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
        
        linkToPublish.url = url;
        _preview.layer.borderColor = kBorderLightColor.CGColor;
        _preview.layer.borderWidth = 1;
        
        // default
        linkToPublish.title = @"无标题链接";
        _label.text = @"无标题链接";
        for (TFHppleElement *element in tutorialsNodes) {
            NSString * title = [[element firstChild] content];
            if(title && [title isEqualToString:@""] == NO) {
                linkToPublish.title = [[element firstChild] content];
                _label.text = [[element firstChild] content];
                break;
            }
        }
        
        NSString *imgXpath = @"//img";
        NSArray *imgNodes = [tutorialsParser searchWithXPathQuery:imgXpath];
        NSMutableArray *imageUrlArray = [NSMutableArray array];
        
        for(TFHppleElement *element in imgNodes)
        {
            NSString *src = element.attributes[@"data-src"];
            if(src == nil || src.length == 0) {
                src = element.attributes[@"src"];
            };
            if(src == nil || src.length == 0) continue;
            if([src hasPrefix:@"http"]) {
                [imageUrlArray addObject:src];
            }else if([src hasPrefix:@"//"]) {
                [imageUrlArray addObject:[NSString stringWithFormat:@"http:%@",src]];
            }else if([src hasPrefix:@"/"]){
                [imageUrlArray addObject:[NSString stringWithFormat:@"%@://%@%@",targetUrl.scheme,targetUrl.host,src]];
            }
        }

        [self pickFirstProperImageFromStringArray:[imageUrlArray copy]];
    }];
    
    
}
- (void)pickFirstProperImageFromStringArray:(NSArray *)strArray
{
    if(!strArray)
    {
        [_iconView setImage:[UIImage imageNamed:@"link_big"]];
        publishBtn.enabled = YES;
        [self addCommentView];
        linkToPublish.image = @"";
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        float w, h;
        float maxW = 200.f, maxH = 200.f;
        __block NSString *properImageUrl;

        for(NSString *s in strArray){
            
            NSDictionary *dict = [self getImageDimension:s];
            h = [[dict objectForKey:@"PixelHeight"] doubleValue];
            w = [[dict objectForKey:@"PixelWidth"] doubleValue];
            
            if( w>= 600 && h>= 600){
                properImageUrl = s;
                break;
            }else{
                if (w > maxW && h > maxH) {
                    maxW = w;
                    maxH = h;
                    properImageUrl = s;
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(properImageUrl)
            {
                [_iconView sd_setImageWithURL:[NSURL URLWithString:properImageUrl] placeholderImage:[UIImage imageNamed:@"link_big"]];
                linkToPublish.image = properImageUrl;
                [self addCommentView];
                publishBtn.enabled = YES;
            }
            else
            {
                [_iconView setImage:[UIImage imageNamed:@"link_big"]];
                [self addCommentView];
                publishBtn.enabled = YES;
                linkToPublish.image = @"";
            }
        });
    });
}
- (NSDictionary *)getImageDimension:(NSString *)imageUrlStr
{
    NSMutableString *imageURL = [NSMutableString stringWithString:imageUrlStr];
    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)[NSURL URLWithString:imageURL], NULL);
    NSDictionary* imageHeader = (__bridge NSDictionary*) CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
    return imageHeader;
    
}
#pragma mark -
- (void)previewAction
{
    [_tv resignFirstResponder];
    if(_tv.text)
        [self parseHtml:_tv.text];
    else{
        [WYUtility showAlertWithTitle:@"请先输入或粘贴一个网址"];
    }
}
- (void)addCommentAction{
    
    WYAddTextVC *vc = [WYAddTextVC new];
    
    if (CGColorEqualToColor(_textView.textColor.CGColor, UIColorFromHex(0x333333).CGColor)){
        vc.defaultText = _textView.text;
    }
    
    vc.myBlock = ^(NSString *text) {
        _textView.textColor = UIColorFromHex(0x333333);
        _textView.text = text;
    };
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)publishAction
{
    if(_btn.isLoading) {
        [OMGToast showWithText:@"网页加载中..."];
        return;
    };
    debugLog(@"publish %@, %@, %@, %@", _textView.text, linkToPublish.image, linkToPublish.title, linkToPublish.url);
    self.myBlock(_textView.text, mentionToPublish, linkToPublish.image, linkToPublish.title, linkToPublish.url,self.publishVisibleScopeType,self.targetUuid,_address,self.remindDic.allValues.firstObject,self.selectedTagsArr);
    if (self) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)backAction
{
    NSString *str = [_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (str.length > 3) {
        //三个字或以上的，需要弹出些东西来保存，否则就直接退出就好
        [[[UIAlertView alloc] initWithTitle:@"确定退出?"
                                    message:@"链接内容尚未发布，确定退出?"
                           cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{
            // Handle "Cancel"
            return;
        }]
                           otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^{
            
            [self.navigationController popViewControllerAnimated:YES];
            
            // Handle "Delete"
        }], nil] show];
        
    }
    else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
