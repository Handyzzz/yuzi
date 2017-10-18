//
//  WYZoomImage.m
//  Withyou
//
//  Created by Handyzzz on 2017/8/15.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYZoomImage.h"
static WYZoomImage *instance = nil;

@interface WYZoomImage() <UIScrollViewDelegate>
{
    CGAffineTransform _transform;
}

@property(nonatomic, strong)UIScrollView *scrollview;

@property(nonatomic, strong)UIImageView *imageView;

@property(nonatomic, strong)UIImage  *image;

@property(nonatomic, strong)NSString *imageURL;

@end
@implementation WYZoomImage
+ (void)showWithImage:(UIImage *)image  imageURL:(NSString *)imageURL{
    if(instance) {
        instance.imageURL = imageURL;
        instance.image = image;
    }else {
        instance = [[WYZoomImage alloc]initWithImage:image imageURL:imageURL];
    }
}
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

     //设置 UIScrollView的位置与屏幕大小相同
     _scrollview=[[UIScrollView alloc]initWithFrame:self.bounds];
     // 隐藏滚动条
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.showsVerticalScrollIndicator = NO;
    //设置UIScrollView的滚动范围和图片的真实尺寸一致
    _scrollview.contentSize = CGSizeMake(kAppScreenWidth, kAppScreenHeight + 1);
    // 增加额外的滚动区域
    _scrollview.contentInset = UIEdgeInsetsMake(0, 0, 1, 0);
    //设置代理scrollview的代理对象
    _scrollview.delegate=self;
    //设置最大伸缩比例
    _scrollview.maximumZoomScale=2.0;
    //设置最小伸缩比例
    _scrollview.minimumZoomScale=1;
    //设置弹性
    _scrollview.bounces = YES;

    _transform = _scrollview.transform;
     [self addSubview:_scrollview];
    
    _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollview addSubview:_imageView];
    if (self.image) {
        _imageView.image = self.image;
    }else{
        [_imageView sd_setImageWithURL:[NSURL URLWithString:self.imageURL]];
    }
    // 移动手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [_scrollview addGestureRecognizer:tapGestureRecognizer];
    
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    //缩小不合适的原因是因为minimumZoomScale = 1 是靠弹性来缩小的
    
    //当scrollView自身的宽度或者高度大于其contentSize的时候, 增量为:自身宽度或者高度减去contentSize宽度或者高度除以2,或者为0
    
    //当scrollView自身的宽度或者高度大于其contentSize的时候, 增量为:自身宽度或者高度减去contentSize宽度或者高度除以2,或者为0
    
    //条件运算符
    CGFloat delta_x= scrollView.bounds.size.width > scrollView.contentSize.width ? (scrollView.bounds.size.width-scrollView.contentSize.width)/2 : 0;
    CGFloat delta_y= scrollView.bounds.size.height > scrollView.contentSize.height ? (scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0;
    
    //让imageView一直居中
    //实时修改imageView的center属性 保持其居中
    
    _imageView.center=CGPointMake(scrollView.contentSize.width/2 + delta_x, scrollView.contentSize.height/2 + delta_y);
}

-(void)tapView:(UITapGestureRecognizer*)tap{
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.zoomScale == 1) {
        if (scrollView.contentOffset.y < 100 && scrollView.contentOffset.y > -100) {
            _scrollview.center = self.center;
            _scrollview.transform = CGAffineTransformScale(_transform, 1, 1);
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
        }else{
            [UIView transitionWithView:instance
                              duration:0.4
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
@end
