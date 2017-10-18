//
//  selectSystemScopeSecondTimeVC.m
//  Withyou
//
//  Created by Handyzzz on 2017/4/25.
//  Copyright © 2017年 Withyou Inc. All rights reserved.
//

#import "WYselectSystemScopeSecondTimeVC.h"

@interface WYselectSystemScopeSecondTimeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArr;
@end

@implementation WYselectSystemScopeSecondTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initdata];
    [self creatTableView];
}
    
-(void)initdata{
    self.titleArr = [@[@"公开可见",@"朋友可见"] mutableCopy];
}
-(void)creatTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.tableFooterView = [UIView new];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.sectionIndexColor = [UIColor blueColor];
    _tableView.sectionIndexTrackingBackgroundColor = UIColorFromHex(0xf5f5f5);
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 70.f;
    // 编辑模式
    _tableView.editing = YES;
    // 允许多选
    _tableView.allowsMultipleSelection = NO;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}

    
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        self.myBlock(1, @"00000000-0000-0000-0000-000000000000",self.titleArr[indexPath.row]);
        break;
        
        case 1:
        self.myBlock(2, @"11111111-1111-1111-1111-111111111111",self.titleArr[indexPath.row]);
        break;
        
        case 2:
        self.myBlock(5, kuserUUID,self.titleArr[indexPath.row]);
        break;
        
        default:
        break;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
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
