//
//  WYImageZoomVC.m
//  Withyou
//
//  Created by Tong Lu on 1/15/15.
//  Copyright (c) 2015 Withyou Inc. All rights reserved.
//

#import "WYLookImage.h"
static WYLookImage *instance = nil;

@interface WYLookImage()
{
    CGAffineTransform _transform;
}
//二选一
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation WYLookImage

- (instancetype)initWithImage:(UIImage *)image  imageURL:(NSString *)imageURL{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.image = image;
        self.imageURL = imageURL;
        UIWindow *currentWindows = [UIApplication sharedApplication].keyWindow;
        self.backgroundColor = [UIColor blackColor];
        [self setUpView];
        
        //加个动画，让整个的过程更加顺畅些
        self.alpha = 0;
        [currentWindows addSubview:self];
        
        [UIView transitionWithView:self
                          duration:0.35
                           options:UIViewAnimationOptionTransitionNone //any animation
                        animations:^ {
                            self.alpha = 1;
                            ; }
                        completion:nil];
    }
    return self;
}
-(void)setUpView{
    _imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _transform = _imageView.transform;
    _imageView.userInteractionEnabled = YES;
    _imageView.alpha = 1;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self addGestureRecognizer:pinchGestureRecognizer];
    
    // 移动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self addGestureRecognizer:panGestureRecognizer];
    
    if (self.image) {
        
        [_imageView setImage:self.image];
        
    }
    else
    {
        
        [_imageView sd_setImageWithURL:[NSURL URLWithString:self.imageURL]
                      placeholderImage:[UIImage imageNamed:@"gray"]
                               options:SDWebImageRetryFailed | SDWebImageLowPriority];
    }
    
    [self addSubview:_imageView];
}


#pragma mark -
// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer{

    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        _imageView.transform = CGAffineTransformScale(_imageView.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
        if (_imageView.width < kAppScreenWidth || _imageView.height < kAppScreenHeight) {
            [UIView transitionWithView:_imageView
                              duration:0.35
                               options:UIViewAnimationOptionTransitionNone //any animation
                            animations:^ {
                                _imageView.transform = CGAffineTransformScale(_transform, 1, 1);
                                _imageView.center = self.center;
                            }
                            completion:nil];

        }
    }
}

// 处理拖拉手势
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;

    if (((_imageView.width > kAppScreenWidth) && (_imageView.width < 3*kAppScreenWidth)) || ((_imageView.height > kAppScreenHeight) && (_imageView.height < 3*kAppScreenHeight)) ) {
        if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged){
            CGPoint translation = [panGestureRecognizer translationInView:view.superview];
            //如果transFrom 大于
            [_imageView setCenter:(CGPoint){_imageView.center.x + translation.x, _imageView.center.y + translation.y}];
            [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
            
            if(_imageView.width >= 2*kAppScreenWidth || _imageView.height >= 2*kAppScreenHeight){
                [UIView transitionWithView:_imageView
                                  duration:0.35
                                   options:UIViewAnimationOptionTransitionNone //any animation
                                animations:^ {
                                  //不能出现黑边 
                                }
                                completion:nil];
            }
        }
    }else{
        if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [_imageView setCenter:(CGPoint){_imageView.center.x + translation.x, _imageView.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
              
            //计算缩放的比例
            CGFloat scale = 0.0;
            CGFloat alpha = 0.0;
            if (((_imageView.centerY - view.centerY)>200) || ((_imageView.centerY - view.centerY)<-200)) {
                scale = 1-200/500.0;
                alpha = 1- 200/200.0;
            }
            if (((_imageView.centerY - view.centerY)>=0)&&((_imageView.centerY - view.centerY)<=200)) {
                scale = 1-(_imageView.centerY - view.centerY)/500;
                alpha = 1-(_imageView.centerY - view.centerY)/200;
            }
            if (((_imageView.centerY - view.centerY)<0)&&((_imageView.centerY - view.centerY)>=-200)) {
                scale = 1-(view.centerY - _imageView.centerY)/500;
                alpha = 1-(view.centerY - _imageView.centerY)/200;
            }
            _imageView.transform = CGAffineTransformScale(_transform, scale, scale);
            alpha = 0.5*alpha + 0.5;
            view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alpha];
        }
        if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
            if (((_imageView.centerY - view.centerY)<100)&&((_imageView.centerY - view.centerY)>-100)) {
                //复原
                _imageView.center = self.center;
                _imageView.transform = CGAffineTransformScale(_transform, 1, 1);
                view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
                
            }else{
                [UIView transitionWithView:instance
                                  duration:0.2
                                   options:UIViewAnimationOptionTransitionNone //any animation
                                animations:^ {
                                    self.alpha = 0;
                                }
                                completion:^(BOOL finished) {
                                    if (finished) {
                                        instance = nil;
                                        [self removeFromSuperview];
                                    }
                                }];
            }
        }
    }
}

+ (void)showWithImage:(UIImage *)image  imageURL:(NSString *)imageURL{
    if(instance) {
        instance.imageURL = imageURL;
        instance.image = image;
    }else {
        instance = [[WYLookImage alloc]initWithImage:image imageURL:imageURL];
    }
}
@end
