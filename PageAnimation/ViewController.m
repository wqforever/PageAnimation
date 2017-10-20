//
//  ViewController.m
//  PageAnimation
//
//  Created by zhaoxin_dev on 2017/9/6.
//  Copyright © 2017年 zhaoxin_dev. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
/** <#描述#> */
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)setUI {
    self.title = @"PageAnimation";
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT - 64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSArray alloc]initWithObjects:
  @{@"title":@"翻转动画-网易云音乐启动效果",@"vcName":@"PageTranslateController"},
  @{@"title":@"手动翻页动画-红版报效果",@"vcName":@"PanGuestureTranslateController"},
  @{@"title":@"滚动label",@"vcName":@"HorizonScrollontroller"}, nil];
    }
    return _dataSource;
}

#pragma mark - tableviewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"pageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.dataSource[indexPath.row][@"title"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *name = self.dataSource[indexPath.row][@"vcName"];
    Class class = NSClassFromString(name);
    if (class) {
        UIViewController *vc = class.new;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
