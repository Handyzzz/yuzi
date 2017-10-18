//
//  WYPublishClassesView.m
//  Withyou
//
//  Created by Handyzzz on 2017/3/27.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYPublishClassesView.h"
@interface WYPublishClassesView ()<UIGestureRecognizerDelegate>
@end
@implementation WYPublishClassesView

#define viewWidth ((kAppScreenWidth - 10)/2)
#define goldenRatio 3.303
#define viewHight1 (kAppScreenHeight - 64 - 50)/goldenRatio
#define viewHight2 (kAppScreenHeight - 64 - 50 - viewHight1)/goldenRatio
#define viewHight3 (kAppScreenHeight - 64 - 50 - viewHight1 - viewHight2)
#define imageH 56

-(UIButton *)videoBtn{
    if (_videoBtn == nil) {
        _videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _videoBtn.backgroundColor = [UIColor whiteColor];
        [_videoBtn setTintColor:[UIColor clearColor]];
        [self addTapClick:_videoBtn];
        [self addSubview:_videoBtn];
        [_videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(15);
            make.width.equalTo(viewWidth);
            make.height.equalTo(viewHight1);
        }];
        UILabel *title = [UILabel new];
        title.text = @"视频";
        title.font = [UIFont systemFontOfSize:12];
        title.textColor = kRGB(51, 51, 51);
        [_videoBtn addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo((viewHight1)/2 + (imageH + 14)/2.0 - 13);
        }];
    }
    return _videoBtn;
}

-(UIButton *)linkBtn{
    if (_linkBtn == nil) {
        _linkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _linkBtn.backgroundColor = [UIColor whiteColor];
        [_linkBtn setTintColor:[UIColor clearColor]];
        [self addTapClick:_linkBtn];
        [self addSubview:_linkBtn];
        [_linkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(self.videoBtn.mas_bottom).equalTo(10);
            make.width.equalTo(viewWidth);
            make.height.equalTo(viewHight2);
        }];
        UILabel *title = [UILabel new];
        title.text = @"链接";
        title.font = [UIFont systemFontOfSize:12];
        title.textColor = kRGB(51, 51, 51);
        [_linkBtn addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo((viewHight2)/2 + (imageH + 14)/2.0 - 13);
        }];
    }
    return _linkBtn;
}
-(UIButton *)articleBtn{
    if (_articleBtn == nil) {
        _articleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _articleBtn.backgroundColor = [UIColor whiteColor];
        [_articleBtn setTintColor:[UIColor clearColor]];
        [self addTapClick:_articleBtn];
        [self addSubview:_articleBtn];
        [_articleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(self.linkBtn.mas_bottom).equalTo(10);
            make.width.equalTo(viewWidth);
            make.height.equalTo(viewHight3);
        }];
        UILabel *title = [UILabel new];
        title.text = @"文章";
        title.font = [UIFont systemFontOfSize:12];
        title.textColor = kRGB(51, 51, 51);
        [_articleBtn addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo((viewHight3)/2 + (imageH + 14)/2.0 - 13);
        }];
    }
    return _articleBtn;
}


-(UIButton *)photoBtn{
    if (_photoBtn == nil) {
        _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoBtn.backgroundColor = [UIColor whiteColor];
        [_photoBtn setTintColor:[UIColor clearColor]];
        [self addTapClick:_photoBtn];
        [self addSubview:_photoBtn];
        [_photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(0);
            make.top.equalTo(15);
            make.width.equalTo(viewWidth);
            make.height.equalTo(viewHight3);
        }];
        UILabel *title = [UILabel new];
        title.text = @"图片";
        title.font = [UIFont systemFontOfSize:12];
        title.textColor = kRGB(51, 51, 51);
        [_photoBtn addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo((viewHight3)/2 + (imageH + 14)/2.0 - 13);
        }];
    }
    return _photoBtn;
}

-(UIButton *)photoAlbumBtn{
    if (_photoAlbumBtn == nil) {
        _photoAlbumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoAlbumBtn.backgroundColor = [UIColor whiteColor];
        [_photoAlbumBtn setTintColor:[UIColor clearColor]];
        [self addTapClick:_photoAlbumBtn];
        [self addSubview:_photoAlbumBtn];
        [_photoAlbumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(0);
            make.top.equalTo(self.photoBtn.mas_bottom).equalTo(10);
            make.width.equalTo(viewWidth);
            make.height.equalTo(viewHight2);
        }];
        UILabel *title = [UILabel new];
        title.text = @"相册";
        title.font = [UIFont systemFontOfSize:12];
        title.textColor = kRGB(51, 51, 51);
        [_photoAlbumBtn addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo((viewHight2)/2 + (imageH + 14)/2.0 - 13);
        }];
    }
    return _photoAlbumBtn;
}

-(UIButton *)characterBtn{
    if (_characterBtn == nil) {
        _characterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _characterBtn.backgroundColor = [UIColor whiteColor];
        [_characterBtn setTintColor:[UIColor clearColor]];
        [self addTapClick:_characterBtn];
        [self addSubview:_characterBtn];
        [_characterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(0);
            make.top.equalTo(self.photoAlbumBtn.mas_bottom).equalTo(10);
            make.width.equalTo(viewWidth);
            make.height.equalTo(viewHight1);
        }];
        UILabel *title = [UILabel new];
        title.text = @"文字";
        title.font = [UIFont systemFontOfSize:12];
        title.textColor = kRGB(51, 51, 51);
        [_characterBtn addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo((viewHight1)/2 + (imageH + 14)/2.0 - 13);
        }];
    }
    return _characterBtn;
}

-(void)setViewData{

    UIImage *videoIVImage = [[UIImage imageNamed:@"publishVideo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.videoBtn setImage:videoIVImage forState:UIControlStateNormal];
    [self setImageInsert:self.videoBtn :viewHight1];
    [self setBtnGroundImg:self.videoBtn];

    UIImage *linkIVImage = [[UIImage imageNamed:@"publishLink"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.linkBtn setImage:linkIVImage forState:UIControlStateNormal];
    [self setImageInsert:self.linkBtn :viewHight2];
    [self setBtnGroundImg:self.linkBtn];
    
    UIImage *articleIVImage = [[UIImage imageNamed:@"publishArticle"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.articleBtn setImage:articleIVImage forState:UIControlStateNormal];
    [self setImageInsert:self.articleBtn :viewHight3];
    [self setBtnGroundImg:self.articleBtn];
    
    UIImage *photoIVImage = [[UIImage imageNamed:@"publishImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.photoBtn setImage:photoIVImage forState:UIControlStateNormal];
    [self setImageInsert:self.photoBtn :viewHight3];
    [self setBtnGroundImg:self.photoBtn];
    
    UIImage *photoAlbumIVImage = [[UIImage imageNamed:@"publishAlbum"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.photoAlbumBtn setImage:photoAlbumIVImage forState:UIControlStateNormal];
    [self setImageInsert:self.photoAlbumBtn :viewHight2];
    [self setBtnGroundImg:self.photoAlbumBtn];
    
    UIImage *characterIVImage = [[UIImage imageNamed:@"publishWords"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.characterBtn setImage:characterIVImage forState:UIControlStateNormal];
    [self setImageInsert:self.characterBtn :viewHight1];
    [self setBtnGroundImg:self.characterBtn];
}

-(void)setImageInsert:(UIButton *)btn :(CGFloat)height{
    int top = (height - imageH - 14)/2;
    int left = (viewWidth - imageH)/2;
    [btn setImageEdgeInsets:UIEdgeInsetsMake(top, left, height - top - imageH, left)];
}

-(void)setBtnGroundImg:(UIButton *)btn{
    UIImage *normalImg = [self imageWithColor:[UIColor whiteColor]];
    UIImage *highLightImg = [self imageWithColor:UIColorFromRGBA(0x333333, 0.1)];
    [btn setBackgroundImage:normalImg forState:UIControlStateNormal];
    [btn setBackgroundImage:highLightImg forState:UIControlStateHighlighted];

}
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
-(void)addTapClick:(UIButton *)Btn{
    
    [Btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}




-(void)btnClick:(UIButton *)btn{
    btn.backgroundColor = [UIColor whiteColor];
    if (btn == self.videoBtn) {
        self.Type = videoType;
        
    }else if (btn == self.photoAlbumBtn){
        self.Type = photoAlbumYype;
        
    }else if (btn == self.linkBtn){
        self.Type = linkType;
        
    }else if (btn == self.photoBtn){
        self.Type = photoType;
        
    }else if (btn == self.characterBtn){
        self.Type = characterType;
    }else if (btn == self.articleBtn){
        self.Type = articleType;
    }
    if(self.contentClick) {
        self.contentClick(self.Type);
    }
    
}
@end
