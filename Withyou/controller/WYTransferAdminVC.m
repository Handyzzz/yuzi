//
//  WYTransferAdminVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/4/12.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYTransferAdminVC.h"
#import "WYGroupsVC.h"
#import "WYGroupApi.h"
@interface WYTransferAdminVC ()
@end

@implementation WYTransferAdminVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviItem];
    self.tableView.editing = YES;
    self.title = @"委任管理员";
}
-(void)setNaviItem{
    UIImage *backImg = [[UIImage imageNamed:@"naviLeftBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认转让管理员吗？" message:@"转让管理员后，你将无法管理群组，请谨慎操作！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"继续转让" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        WYUser *user = self.resultList[indexPath.row];
        //转让群
        __weak WYTransferAdminVC *weakSelf = self;
        [WYGroupApi transferAdmin:self.group.uuid userUuid:user.uuid Block:^(WYGroup *group) {
            if (group) {
                //转让成功 退群
                if (weakSelf.needQuite) {
                    [weakSelf quitGroup];
                }else{
                    [OMGToast showWithText:@"管理员权限转让成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateGroupDataSource object:self userInfo:@{@"group":group}];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }else{
                if (weakSelf.needQuite) {
                    [OMGToast showWithText:@"未能成功转让管理员,你将继续留在该群组!"];
                }else{
                    [OMGToast showWithText:@"未能成功转让管理员！"];
                }
            }
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"放弃转让" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }];
    [alert addAction:done];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)quitGroup{
    __weak WYTransferAdminVC *weakSelf = self;
    //准备退群的时候已经判断过了
    [WYGroupApi requestQuitGroup:self.group.uuid groupName:self.group.name Block:^(long status) {
        if (status == 200) {
            //然后退回到groups页面
            [OMGToast showWithText:@"管理员权限转让成功,你已经成功退出该群！"];
            //发通知更新内存数据
            [[NSNotificationCenter defaultCenter] postNotificationName:kQuitGroup object:weakSelf userInfo:@{@"group":self.group}];
            //从各个入口可以退群 所以不能只退回到某个VC 退群 和转让退群 返回的层级不一样
            NSInteger index = [self.navigationController.viewControllers count] - 1;
            [self.navigationController popToViewController:self.navigationController.viewControllers[index - 4] animated:YES];
        }else{
            [OMGToast showWithText:@"管理员权限转让成功,但你未能退出该群，请稍后再试！"];
        }
    }];
}

// 选择模式
- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
