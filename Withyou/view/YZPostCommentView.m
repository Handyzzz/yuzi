//
//  YZPostCommentView.m
//  Withyou
//
//  Created by ping on 2017/5/14.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZPostCommentView.h"

@interface YZPostCommentView()<UITextViewDelegate>

@end

@implementation YZPostCommentView

- (void)setupWith:(WYCellPostFrame *)postFrame delegateObject:(id)object{
    self.frame = postFrame.commentBodyFrame;
    int  i = 0;
    // 最多显示三条评论
    while (i < 3) {
        if(i < postFrame.commentFrames.count ){
            CGRect frame = [(NSValue *)postFrame.commentFrames[i] CGRectValue];
            UITextView *commentTextView = [self getCommentLabelWithIndex:i];
            commentTextView.delegate = object;
            commentTextView.tag = i;
            YZPostComment *data = postFrame.post.comments[i];
            
            NSMutableAttributedString *mutableS  = [[NSMutableAttributedString alloc] initWithString:data.author.fullName];
            [mutableS addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kPostCommentFont.pointSize weight:UIFontWeightMedium] range:NSMakeRange(0, data.author.fullName.length)];
            
            // 是否有回复 某某
            if(data.replied_author != nil && data.replied_author.uuid != nil) {
                NSString *repliedName = [NSString stringWithFormat:@"回复%@",data.replied_author.fullName];
                NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:repliedName];
                [attr addAttribute:NSFontAttributeName value:kPostCommentFont range:NSMakeRange(0, 2)];
                [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kPostCommentFont.pointSize weight:UIFontWeightMedium] range:NSMakeRange(2, repliedName.length -2)];
                
                [mutableS appendAttributedString:attr];
            }
            [mutableS appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
            
            //带mention
            NSMutableAttributedString *atString = [YZMarkText convert:data.content abilityToTapStringWith:data.mention FontSize:kPostCommentFont.pointSize];
            [mutableS appendAttributedString:atString];
            
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 5;
            paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
            [mutableS addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, mutableS.length)];
            [mutableS addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x333333) range:NSMakeRange(0, mutableS.length)];
            commentTextView.attributedText = mutableS;
            commentTextView.linkTextAttributes = @{NSParagraphStyleAttributeName : paragraphStyle,NSForegroundColorAttributeName : UIColorFromHex(0x2ba1d4)};
            commentTextView.frame = frame;
        }else {
            UITextView *commentTextView = [self getCommentLabelWithIndex:i];
            commentTextView.delegate = object;
            commentTextView.frame = CGRectZero;
            commentTextView.tag = i;
        }
        i++;
    }
}

- (UITextView *)getCommentLabelWithIndex:(int)index {
    if(self.subviews.count == 3) {
        return (UITextView *)self.subviews[index];
    }
    UITextView *comment = [[UITextView alloc] initWithFrame:CGRectZero];
    comment.font = kPostCommentFont;
    comment.textColor = UIColorFromHex(0x999999);
    comment.userInteractionEnabled = YES;
    comment.scrollEnabled = NO;
    comment.editable = NO;
    comment.delegate = self;
    comment.textContainer.lineFragmentPadding = 0;
    comment.textContainerInset = UIEdgeInsetsZero;
    comment.dataDetectorTypes = UIDataDetectorTypeAll;

    [self addSubview:comment];
    return comment;
}

@end
