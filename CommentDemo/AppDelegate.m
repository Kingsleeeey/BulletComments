//
//  AppDelegate.m
//  CommentDemo
//
//  Created by Kingsleeeey on 2020/9/8.
//  Copyright © 2020 Kingsleeeey. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 设置主窗口,并设置根控制器
    self.window = [[UIWindow alloc] init];
    self.window.frame = [[UIScreen mainScreen] bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window setRootViewController:[ViewController new]];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
