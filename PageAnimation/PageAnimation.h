//
//  PageAnimation.h
//  reactivecocoa
//
//  Created by zhaoxin_dev on 2017/9/5.
//  Copyright © 2017年 zhaoxin_dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PageAnimation : NSObject

+ (void)convertViewFromView:(UIView *)fView toView:(UIView *)tView finished:(void(^)(BOOL isFnished))finished;

@end
