//
//  YZPostCellBase.m
//  Withyou
//
//  Created by ping on 2017/5/20.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "YZPostCellBase.h"

@interface YZPostCellBase()

@property (nonatomic, weak)YZPostViewBase *postView;

@end

@implementation YZPostCellBase

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        YZPostViewBase *content = [self getContentView];
        [self.contentView addSubview:content];
        self.postView = content;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

// subclass overload
- (YZPostViewBase *)getContentView {
    return nil;
}

- (void)setPostFrame:(WYCellPostFrame *)postFrame {
    _postFrame = postFrame;
    self.postView.postFrame = postFrame;
}

- (void)setDetailLayout:(WYCellPostFrame *)postFrame {
    _postFrame = postFrame;
    [self.postView setDetailLayout:postFrame];
}

- (void)setDelegate:(id<WYCellPostDelegate>)delegate {
    _delegate = delegate;
    self.postView.delegate = delegate;
}

- (void)setPlayBlock:(void (^)(WYPost *, UIView *))playBlock {
    _playBlock = playBlock;
    self.postView.playBlock = playBlock;
}

@end
