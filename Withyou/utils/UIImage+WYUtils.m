//
//  UIImage+WYUtils.m
//  Withyou
//
//  Created by Tong Lu on 7/22/16.
//  Copyright © 2016 Withyou Inc. All rights reserved.
//

#import "UIImage+WYUtils.h"

@implementation UIImage (WYUtils)

+ (CGFloat)getHeightOfWidth:(CGFloat)width Height:(CGFloat)height inWidth:(CGFloat)scaleWidth {
    
    if(height == 0 || width == 0) return 0;

    if(scaleWidth) {
        return ceil(scaleWidth * height / width);
    }else {
        return ceil(kAppScreenWidth * height / width);
    }
}
+ (CGFloat)getHeightOfImageViewForVideoFromPost:(WYPost *)post;
{
    if(!post.video)
    {
        return 0;
    }
    if(post.video.height.doubleValue == 0 || post.video.height.doubleValue == 0) return 0;

    CGFloat height = ceil((kAppScreenWidth * post.video.height.doubleValue / post.video.width.doubleValue));
    if(height < kAppScreenWidth){
        return height;
    }
    else{
        return kAppScreenWidth;
    }
}
+ (CGFloat)getHeightOfImageViewFromPost:(WYPost *)post;
{
    if(!post.mainPic)
    {
        return 0;
    }
    if(post.mainPic.height == 0 || post.mainPic.width == 0) return 0;

    CGFloat height = ceil((kAppScreenWidth * post.mainPic.height / post.mainPic.width));
//    if(height < kAppScreenHeight * 1.5){
//        return height;
//    }
//    else{
//        return kAppScreenHeight * 1.5;
//    }
    
//    高度不能高于屏幕宽度，也就是最大也就是个正方形
//    不能低于屏幕宽度的1/3，不至于比例太难看
    
//    debugLog(@"height %f, screen width %f", height, kAppScreenWidth);
    if(height < kAppScreenWidth * 0.33){
        return kAppScreenWidth * 0.33;
    }
    else if(height > kAppScreenWidth){
        return kAppScreenWidth;
    }
    else{
        return height;
    }
    
}
+ (CGFloat)getHeightOfImageViewFromPostWithNoLimit:(WYPost *)post;
{
    if(!post.mainPic)
    {
        return 0;
    }
    if(post.mainPic.height == 0 || post.mainPic.width == 0) return 0;
    
    return ceil((kAppScreenWidth * post.mainPic.height / post.mainPic.width));

}
+ (CGFloat)getHeightOfImageViewFromPost:(WYPost *)post WithInWidth:(CGFloat)width
{
    if(!post.mainPic)
    {
        return 0;
    }
    return ceil((width * post.mainPic.height / post.mainPic.width));
}

//+ (CGFloat)getLinkImageViewHeightFromPost:(WYPost *)post withinWidth:(CGFloat)width
//{
//    if(!post.mainPic)
//    {
//        return 0;
//    }
//    if(post.mainPic.height == 0 || post.mainPic.width == 0) return 0;
//
//    // todo, to update link image
//    CGFloat a = ceil((width * post.mainPic.height / post.mainPic.width));
//    CGFloat upper = ceil(kAppScreenWidth * 0.618);
//    
//    if(a > upper)
//        return upper;
//    else
//        return a;
//    
//}

+ (CGFloat)getHeightOfImageViewFromOriginalHeight:(CGFloat)height Width:(CGFloat)width WithInWidth:(CGFloat)widthLimit
{
    return ceil((widthLimit * height / width));

}

+ (void)removeImage:(NSString *)fileName{
    debugLog(@"file Path is %@",fileName);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:fileName error:&error];
        
        if (success) {
            NSLog(@"deleted file -:%@ ",fileName);
        }
        else
        {
            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
        }
        
    });
}
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
+ (BOOL)compareFirstimage:(UIImage *)image1 isEqualTo:(UIImage *)image2 {
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqualToData:data2];
}

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
