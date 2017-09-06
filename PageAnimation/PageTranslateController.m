//
//  PageTranslateController.m
//  PageAnimation
//
//  Created by zhaoxin_dev on 2017/9/6.
//  Copyright © 2017年 zhaoxin_dev. All rights reserved.
//

#import "PageTranslateController.h"
#import "PageAnimation.h"

@interface PageTranslateController ()
@property (nonatomic, strong) UILabel *toView;
@end

@implementation PageTranslateController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (UILabel *)toView {
    if (!_toView) {
        _toView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT)];
        _toView.backgroundColor = [UIColor blueColor];
        _toView.text = @"123";
        _toView.textColor = [UIColor blackColor];
        _toView.font = [UIFont systemFontOfSize:20];
        _toView.textAlignment = NSTextAlignmentCenter;
    }
    return _toView;
}

- (void)setUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *fromView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT)];
    fromView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:fromView];
    
    [PageAnimation convertViewFromView:fromView toView:self.toView finished:^(BOOL isFnished) {
        
    }];
}


@end
