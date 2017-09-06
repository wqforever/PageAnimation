//
//  AppDelegate.h
//  PageAnimation
//
//  Created by zhaoxin_dev on 2017/9/6.
//  Copyright © 2017年 zhaoxin_dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

