//
//  ViewController.m
//  CommentDemo
//
//  Created by Kingsleeeey on 2020/9/8.
//  Copyright © 2020 Kingsleeeey. All rights reserved.
//

#import "ViewController.h"
#import "BulletView.h"
#import "BulletManager.h"

@interface ViewController ()

@property (nonatomic, strong) BulletManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [[BulletManager alloc] init];
    __weak typeof(self) weakSelf = self;
    self.manager.generateViewBlock = ^(BulletView * _Nonnull view) {
        [weakSelf addBulletView:view];
    };
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitle:@"start" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(100, 100, 100, 40)];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitle:@"stop" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(250, 100, 100, 40)];
    [btn addTarget:self action:@selector(btnStopClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnClick {
    [self.manager start];
}

- (void)btnStopClick {
    [self.manager stop];
}

- (void)addBulletView:(BulletView *)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(width, 300 + view.trajectory * 50, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    [self.view addSubview:view];
    
    [view startAnimation];
}

@end
