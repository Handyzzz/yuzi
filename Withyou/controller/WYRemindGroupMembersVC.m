//
//  WYRemindGroupMembersVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/7/17.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYRemindGroupMembersVC.h"

@interface WYRemindGroupMembersVC ()
@property(nonatomic, copy)NSMutableArray *remindArr;
@end

@implementation WYRemindGroupMembersVC
#pragma mark - lazy
- (NSMutableArray *)selectedMember {
    if(_selectedMember == nil) {
        _selectedMember = [NSMutableArray array];
    }
    return _selectedMember;
}
-(NSMutableArray *)remindArr{
    if (_remindArr == nil) {
        _remindArr = [NSMutableArray array];
    }
    return _remindArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviItem];
    self.tableView.editing = YES;
    self.title = self.naviTitle;
    [self.remindArr addObjectsFromArray:self.selectedMember];
}

-(void)setNaviItem{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick:)];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneClick:(UIBarButtonItem *)btn {
    self.remindFriends(self.remindArr);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateCellContent:(NSIndexPath *)indexPath{
    //预选
    WYUser *user;
    if (indexPath.section == 0) {
        user = self.adminList[indexPath.row];
    }else{
        user = self.resultList[indexPath.row];
    }
    for (int i = 0; i < self.selectedMember.count; i ++) {
        WYUser *selectedUser = self.selectedMember[i];
        if ([selectedUser.uuid isEqualToString:user.uuid]) {
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            break;
        }

    }
}
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.remindArr.count < 10) {
        return indexPath;
    }else{
        //提示最多可以@10位朋友
        [OMGToast showWithText:@"你最多可以@10位群成员"];
        return nil;
    }
}

//手选的时候才会调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WYUser *user;
    if (indexPath.section == 0) {
         user = self.adminList[indexPath.row];
    }else{
         user = self.resultList[indexPath.row];
    }
    BOOL exist = NO;
    for (WYUser *selectedUser in self.remindArr) {
        if([selectedUser.uuid isEqualToString:user.uuid]) {
            exist = YES;
            break;
        }
    }
    if(exist == NO) {
        [self.remindArr addObject:user];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WYUser *user;
    if (indexPath.section == 0) {
        user = self.adminList[indexPath.row];
    }else{
        user = self.resultList[indexPath.row];
    }
    for (int i = 0; i < self.remindArr.count; i ++) {
        WYUser *tempUser = self.remindArr[i];
        if ([tempUser.uuid isEqualToString:user.uuid]) {
            [self.remindArr removeObjectAtIndex:i];
            break;
        }
    }
}

// 选择模式
- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

@end
