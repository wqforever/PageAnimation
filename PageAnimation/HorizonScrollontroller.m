//
//  HorizonScrollontroller.m
//  PageAnimation
//
//  Created by zhaoxin_dev on 2017/10/19.
//  Copyright © 2017年 zhaoxin_dev. All rights reserved.
//

#import "HorizonScrollontroller.h"
#import "UILabel+scroll.h"

@interface HorizonScrollontroller ()

@end

@implementation HorizonScrollontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 200, MAINWIDTH - 40, 30)];
    lblTitle.text = @"1好多好多的字啊好多好多的字啊好多好多的字啊好多好多的字啊好多好多的字啊好多好多的字啊好多好多的字啊好多好多的字啊0";
    lblTitle.textColor = [UIColor redColor];
    lblTitle.font = [UIFont systemFontOfSize:16];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.backgroundColor = [UIColor blueColor];
    lblTitle.isCanScroll = YES;
    [self.view addSubview:lblTitle];
}



@end
