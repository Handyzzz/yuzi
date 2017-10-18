//
//  WYBaseMentionTextVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/6/12.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYBaseMentionTextVC.h"
#import "WYMarkMapVC.h"
#import "YZMarkText.h"
#import "WYRemindFriendsVC.h"
#import "WYRemindGroupMembersVC.h"

//高德地图基础SDK头文件 与key的宏
#define KeyForGaoDe @"d3d23094f663fae3e9ae26dbae992b17"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface WYBaseMentionTextVC ()<UITextViewDelegate,UIScrollViewDelegate>

@property (nonatomic ,strong)UISegmentedControl *segment;
@property (nonatomic ,strong) NSMutableArray* marks;
// 标记@ 文字
@property (nonatomic, strong) NSMutableArray *markArr;

@property (nonatomic, strong) UILabel *secondSelectLb;
//
@property (nonatomic, assign) BOOL shouldShowKeyBoard;

@property (nonatomic, assign) CGFloat canEditH;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIToolbar *toolBarView;

@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation WYBaseMentionTextVC

#define toolH  54.0

-(NSMutableArray*)markArr {
    if (_markArr == nil) {
        _markArr = [NSMutableArray array];
    }
    return _markArr;
}

-(NSMutableArray *)marks{
    if (_marks == nil) {
        _marks = [NSMutableArray array];
    }
    return _marks;
}

- (UILabel *)placeHolder {
    if (_placeHolder == nil) {
        _placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, kAppScreenWidth - 30, 30)];
        [self.textView addSubview:_placeHolder];
        _placeHolder.numberOfLines = 0;
        _placeHolder.textColor = UIColorFromHex(0xc5c5c5);
        _placeHolder.font = _textView.font;
    }
    
    if(!self.placeHolderText)
        _placeHolder.text = @"输入正文";
    else
        _placeHolder.text = self.placeHolderText;
    return _placeHolder;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self setupUI];
    [self setNaviBar];
    [self creatToolBarView];
    
    _shouldShowKeyBoard = self;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AMapPOIKeywordsSearchReponse:) name:kAMapPOIKeywordsSearchReponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AMapPOIAroundSearchReponse:) name:kAMapPOIAroundSearchReponse object:nil];
}

//push到此页面的时候 不会闪的一下
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_shouldShowKeyBoard == YES){
        [_textView becomeFirstResponder];
        _shouldShowKeyBoard = NO;
    }
}
//pop回来的时候 可以防止界面刚滑动到显示一半的时候 键盘就全部显示出来了 导致两个页面都可以看得到键盘

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];
    [_textView resignFirstResponder];
}


- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    if(!self.navigationTitle)
        self.navigationTitle = @"添加文字";
    self.title = self.navigationTitle;
    [self createView];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)createView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kStatusAndBarHeight, kAppScreenWidth, kAppScreenHeight - kStatusAndBarHeight - kDefaultBarHeight)];
    _scrollView.bounces = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.contentSize = CGSizeMake(kAppScreenWidth,kAppScreenHeight - kStatusAndBarHeight - kDefaultBarHeight + 150);
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];

    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 15, kAppScreenWidth - 30, 166)];
     [_scrollView addSubview:_textView];
    
    _textView.font = [UIFont systemFontOfSize:14.0f];
    _textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _textView.textColor = UIColorFromHex(0x333333);
    _textView.selectable = YES;
    _textView.editable = YES;
    _textView.bounces = NO;
    _textView.scrollEnabled = NO;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.userInteractionEnabled = YES;
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.delegate = self;
}

- (void)setNaviBar
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(publishAction)];
    self.navigationItem.rightBarButtonItem = item;
    item.enabled = NO;
    
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

#pragma mark -

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.attributedText == nil || textView.attributedText.length == 0) {
        if(self.allowEmptyText){
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [_placeHolder removeFromSuperview];
        }
        else{
            [textView addSubview:self.placeHolder];
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [_placeHolder removeFromSuperview];
    }
    // 在没有候选框的状态 才去检测颜色变化 && 如果没有@ 也要去恢复颜色
    if(textView.markedTextRange == nil) {
        [self changeTextViewAttributedString:textView.attributedText.string withSelectedRang:textView.selectedRange];
    }
    
    //改变自身的大小 14号字 6个行间距 左右15 最小高度166
    CGFloat height = [textView.text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(kAppScreenWidth - 30, MAXFLOAT) minimumLineHeight:6].height;
    
   ;
    
    //因为有上下边距
    CGFloat margin = 20.0;
    
    CGPoint offset = self.scrollView.contentOffset;
    if (height < _canEditH - margin) {
        CGRect frame = _textView.frame;
        frame.size.height = _canEditH;
        _textView.frame = frame;
        
        self.scrollView.contentSize = CGSizeMake(kAppScreenWidth, kAppScreenHeight - kStatusAndBarHeight - kDefaultBarHeight + 150);
    }else{
        CGRect frame = _textView.frame;
        frame.size.height = height + margin;
        _textView.frame = frame;
        
        offset.y = (height - (_canEditH - margin));
        self.scrollView.contentOffset = offset;
        
        
        self.scrollView.contentSize = CGSizeMake(kAppScreenWidth, kAppScreenHeight - kStatusAndBarHeight - kDefaultBarHeight + 150 + (height - (_canEditH - margin)));
    }
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    // 在中文或者其他输入 完成时候才执行
    // 有@存在 才去遍历
    if(self.markArr.count > 0) {
        // 如果正在中文输入 markedTextRange 有值,
        if(textView.markedTextRange == nil) {
            if([text isEqualToString:@" "]) {
                NSRange beforeRange = NSMakeRange(range.location, 1);
                if(beforeRange.location > 0) {
                    beforeRange.location = range.location - 1;
                }
                NSString *beforeS = [textView.text substringWithRange:beforeRange];
                if([beforeS isEqualToString:@" "]) {
                    NSMutableString *str = [textView.text mutableCopy];
                    [str replaceCharactersInRange:range withString:text];
                    [self changedMarkedTextRange:range text:text];
                    [self changeTextViewAttributedString:str withSelectedRang:NSMakeRange(range.location + 1, 0)];
                    return NO;
                }
            }
            BOOL shouldChnage = [self changedMarkedTextRange:range text:text];
            if(shouldChnage == NO) {
                return NO;
            }
        }else {
            // 输入结束才在这里更新rang
            NSInteger length = [textView offsetFromPosition:textView.markedTextRange.start toPosition:textView.markedTextRange.end];
            NSInteger location = [textView offsetFromPosition:textView.beginningOfDocument toPosition:textView.markedTextRange.start];
            if(range.location == location && range.length == length) {
                NSString *sub = [textView.text substringWithRange:range];
                NSLog(@"结束中文输入 text: %@  sub:%@",text,sub);
                [self changedMarkedTextRange:NSMakeRange(location, 1) text:text];
            }
        }
    }
    
    return YES;
}

// 返回textview shouldChangeTextInRange 的参数
- (BOOL)changedMarkedTextRange:(NSRange)range text:(NSString *)text {
    
    NSArray *temp = [NSArray arrayWithArray:self.markArr];
    BOOL shouldChange = YES;
    NSString *changedStr = nil;
    // mark 是location 从小到大 排列的
    for (YZMarkText *mark in temp) {
        // 如果是rane.location在@xxx后面
        if(range.location > (mark.range_start + mark.range_length - 1)) continue;
        // 如果是在@前面操作
        if((range.location + range.length) <= mark.range_start) {
            NSUInteger location = mark.range_start + text.length -  range.length;
            mark.range_start = location;
            continue;
        }
        //如果是在@末尾 且text 为@"" ,或者被全部选中了 那么就是整体删除
        if(range.location == (mark.range_start + mark.range_length - 1) ||
           (range.location == mark.range_start && range.length == mark.range_length)) {
            if(text.length == 0 || [text isEqualToString:@""]) {
                [self.markArr removeObject:mark];
                WYLog(@"remove: %@",mark.content_name);
                
                // 字符串已经被改变了, 后面的@要根据此次改变更新range
                range = NSMakeRange(mark.range_start, mark.range_length);
                shouldChange = NO;
                NSMutableString * str = [self.textView.attributedText.string mutableCopy];
                [str replaceCharactersInRange:range withString:text];
                changedStr = str;
                continue;
            }
        }
        // 如果是在@中间
        if((range.location + range.length)  > mark.range_start ) {
            // 让他全选,被确认是否删除
            self.textView.selectedRange = NSMakeRange(mark.range_start, mark.range_length);
            return NO;
        }
    }
    if(shouldChange == NO && changedStr != nil) {
        [self changeTextViewAttributedString:changedStr withSelectedRang:NSMakeRange(range.location, 0)];
    }
    return shouldChange;
}

- (void)changeTextViewAttributedString:(NSString *)str withSelectedRang:(NSRange )rage{

    _textView.attributedText = [YZMarkText convert:str toAtStringWith:self.markArr];
    _textView.selectedRange = rage;
}

-(void)reSetText:(NSMutableArray *)marks{
    _textView.allowsEditingTextAttributes = YES;
    //需要先将placeholeder去掉
    [_placeHolder removeFromSuperview];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    //将mark中的每个名字 添加一个@符号空格 然后让其高亮
    if (marks.count > 0) {
        // 去除输入的@符号
        NSRange selectedRange = _textView.selectedRange;
        NSMutableString *str = [_textView.attributedText.string mutableCopy];
        BOOL beforeIsAt = NO;
        if(selectedRange.location > 0 ) {
            // 光标前一个str
            NSString *beforeStr = [str substringWithRange:NSMakeRange(selectedRange.location - 1, 1)];
            if([beforeStr isEqualToString:@"@"]) {
                beforeIsAt = YES;
            }
        }
        
        
        //在有@ 存在的时候unknown
        for (id  unknown in marks) {
            
            YZMarkText *mark = nil;
            NSString *linkStr = nil;
            if ([unknown isMemberOfClass:[WYUser class]]) {
                WYUser *user = (WYUser*)unknown;
                linkStr = [NSString stringWithFormat:@"@%@",user.fullName];
                mark = [YZMarkText markWithType:1 name:linkStr uuid:user.uuid latitude:0 longitude:0 range_start:0 range_length:linkStr.length];
            }
            else if ([unknown isMemberOfClass:[AMapPOI class]]){
                AMapPOI *map = (AMapPOI*)unknown;
                linkStr = [NSString stringWithFormat:@"@%@",map.name];
                mark = [YZMarkText markWithType:2 name:linkStr uuid:@"" latitude:map.location.latitude longitude:map.location.longitude range_start:0 range_length:linkStr.length];
            }
            if(mark == nil) continue;
            // 前面一个字符是@的情况
            if(beforeIsAt == YES) {
                beforeIsAt = NO;
                // 移动到前面@的位置
                selectedRange.location = selectedRange.location - 1;
                // 更新range length = 1,因为替换了前面的@
                NSRange changedRange = NSMakeRange(selectedRange.location, 1);
                [str replaceCharactersInRange:changedRange withString:linkStr];
                [self changedMarkedTextRange:changedRange text:linkStr];
            }else {
                [str insertString:linkStr atIndex:selectedRange.location];
                // 更新range
                [self changedMarkedTextRange:NSMakeRange(selectedRange.location, 0) text:linkStr];
            }
            // 更新range
            mark.range_start = selectedRange.location;
            
            // 添加到缓存 避免重复操作
            [self addMarkToMarkArray:mark];
            // 记录当前循环后的 location
            selectedRange.location = selectedRange.location + linkStr.length;
            
        }
        // 改变str 并且光标移动到@xxx之后
        [self changeTextViewAttributedString:str withSelectedRang:selectedRange];
    }
}
// 向缓存中添加 mark 避免重复的
- (void)addMarkToMarkArray:(YZMarkText *)mark {
    // markArr == 0 时 不会执行
    for (YZMarkText *value in self.markArr) {
        // 存在@名称一样的 和 携带的数据类型一样 就不添加
        // 如果名字一样 携带数据的类型不一样 那么是可以添加到缓存中的
        if([value.content_name isEqualToString:mark.content_name] && mark.content_type == value.content_type) {
            return;
        }
    }
    [self.markArr addObject:mark];
    // 排序 location 从小到大 因为某个@整体被删除了之后, range.location之后的的@都要被重新计算range
    NSArray *temp = [self.markArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        YZMarkText *mark1 = (YZMarkText *)obj1;
        YZMarkText *mark2 = (YZMarkText *)obj2;
        if(mark1.range_start == mark2.range_start) {
            return NSOrderedSame;
        }else if(mark1.range_start < mark2.range_start){
            return NSOrderedAscending;
        }else {
            return NSOrderedDescending;
        }
    }];
    [self.markArr removeAllObjects];
    [self.markArr addObjectsFromArray:temp];
}



-(CGRect)backPopUpRect{
    //获取光标的位置
    CGRect rect = CGRectNull;
    CGPoint p = [_textView caretRectForPosition:_textView.selectedTextRange.start].origin;
    if (p.y > _textView.bounds.size.height) {
        p.y = _textView.bounds.size.height;
    }
    if (p.x >= 100 && p.x <= kAppScreenWidth -100) {
        
        rect = CGRectMake(p.x -100, p.y, 200, 40);
    }
    if (p.x < 100) {
        rect = CGRectMake(0, p.y, 200, 40);
    }
    if (p.x > kAppScreenWidth -100) {
        rect = CGRectMake(kAppScreenWidth-200, p.y, 200, 40);
    }
    return rect;
}

#pragma action
- (void)actionFriend{
    __weak WYBaseMentionTextVC *weakSelf = self;
    WYRemindFriendsVC *vc = [WYRemindFriendsVC new];
    vc.naviTitle = @"提及";
    vc.remindFriends = ^(NSArray *friendsArr) {
        weakSelf.marks = [friendsArr mutableCopy];
        [weakSelf reSetText:self.marks];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)actionGroupMembers{
    __weak WYBaseMentionTextVC *weakSelf = self;
    WYRemindGroupMembersVC *vc = [WYRemindGroupMembersVC new];
    vc.naviTitle = @"提及";
    vc.includeAdminList = YES;
    vc.group = [WYGroup selectGroupDetail:self.post.targetUuid];

    vc.remindFriends = ^(NSArray *membersArr) {
        weakSelf.marks = [membersArr mutableCopy];
        [weakSelf reSetText:self.marks];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

# pragma mark -  notification
//关键字查找
-(void)AMapPOIKeywordsSearchReponse:(NSNotification*)sender{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        AMapPOI * POI = [sender.userInfo objectForKey:kAMapPOIKeywordsSearchReponse];
        [self reSetText:[@[POI] mutableCopy]];
    });
}

//周边查找
-(void)AMapPOIAroundSearchReponse:(NSNotification*)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *pois = [sender.userInfo objectForKey:kAMapPOIAroundSearchReponse];
        NSMutableArray *poiNames = [NSMutableArray array];
        for (AMapPOI * POI in pois) {
            [poiNames addObject:POI];
        }
        [self reSetText:poiNames];
    });
    
    
}


# pragma mark - keyboard notification

-(void)creatToolBarView{
    _toolBarView = [UIToolbar new];
    _toolBarView.frame = CGRectMake(0, kAppScreenHeight-toolH, kAppScreenWidth, toolH);
    _toolBarView.translucent = NO;
    //半透明层遮挡 会导致背景色不显示或者卡顿
    //_toolBarView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_toolBarView];
    //给toolBar添加一些按钮
    
    UIImage *markBtnImg = [[UIImage imageNamed:@"Publish text-ante-default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *markBtnHighlightImg = [[UIImage imageNamed:@"Publish text-ante-pressed"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    
    UIButton *markBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [markBtn setImage:markBtnImg forState:UIControlStateNormal];
    [markBtn setImage:markBtnHighlightImg forState:UIControlStateHighlighted];
    [markBtn sizeToFit];
    
    [markBtn addTarget:self action:@selector(markBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *markView = [[UIView alloc]initWithFrame:markBtn.bounds];
    [markView addSubview:markBtn];
    UIBarButtonItem *markItem = [[UIBarButtonItem alloc]initWithCustomView:markView];
    
    self.toolBarView.items = @[markItem];
}

-(void)markBtnClick:(id)sender{
    if ([self.post.targetType intValue] == 3) {
        [self actionGroupMembers];
    }else{
        [self actionFriend];
    }
}

- (void)keyBoardWillChangeFrame:(NSNotification*)notification{
    
    //获取frame
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //动画时间和键盘的动画时间是一样的 然后高度也是计算的一样的  所以工具条和键盘的动画会同步起来
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if (frame.origin.y == kAppScreenHeight) { // 没有弹出键盘
        
        [UIView animateWithDuration:duration animations:^{
            
            self.toolBarView.transform =  CGAffineTransformIdentity;
        }];
    }else{
        // 弹出键盘
        CGFloat height = [_textView.text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(kAppScreenWidth - 30, MAXFLOAT) minimumLineHeight:6].height;
        CGFloat margin = 20.0;
        if (height < _canEditH - margin) {
            CGRect frame = _textView.frame;
            frame.size.height = _canEditH;
            _textView.frame = frame;
        }
        // 工具条往上移动258
        [UIView animateWithDuration:duration animations:^{
            self.toolBarView.transform = CGAffineTransformMakeTranslation(0, -frame.size.height);
        }];
    }
}

-(void)keyBoardWillShow:(NSNotification*)notification{
    //获取高度
    // 键盘显示\隐藏完毕的frame
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //调整文本框的大小为刚好到 键盘上边
    _canEditH = kAppScreenHeight - kStatusAndBarHeight - kDefaultBarHeight -15 - frame.size.height;
}



- (void)publishAction
{
    
    //validate text
    NSString *s = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(s.length < 1 && !self.allowEmptyText)
    {
        [OMGToast showWithText:@"请输入文字内容再发布"];
        return;
    }
    
    NSArray *metion = nil;
    // 如果有@存在 则转换文本
    if(self.markArr.count > 0) {
        metion = [YZMarkText convertMarkArrayToJSONArray:self.markArr];
    }
    self.myBlock(self.textView.attributedText, metion);
    if (self) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)backAction
{
    NSString *str = [_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (str.length > 2) {
        //三个字或以上的，需要弹出些东西来保存，否则就直接退出就好
        
        [[[UIAlertView alloc] initWithTitle:@"放弃修改?"
                                    message:@"放弃文字修改，确定退出?"
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

//滑动收键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITextView class]]) {
        return;
    }
    [self.view endEditing:YES];

}

@end
