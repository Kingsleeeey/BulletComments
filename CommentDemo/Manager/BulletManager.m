//
//  BulletManager.m
//  CommentDemo
//
//  Created by Kingsleeeey on 2020/9/8.
//  Copyright © 2020 Kingsleeeey. All rights reserved.
//

#import "BulletManager.h"
#import "BulletView.h"

@interface BulletManager ()

@property (nonatomic, strong) NSMutableArray *dataSource;// 弹幕的数据来源
@property (nonatomic, strong) NSMutableArray *bulletComments;// 弹幕使用过程中的数组变量
@property (nonatomic, strong) NSMutableArray *bulletViews;// 储存弹幕View的数组变量

@property BOOL bStopAnimation;

@end

@implementation BulletManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bStopAnimation = YES;
    }
    return self;
}

/// 弹幕开始执行
- (void)start {
    if (!self.bStopAnimation) {
        return;
    }
    self.bStopAnimation = NO;
    [self.bulletComments removeAllObjects];
    [self.bulletComments addObjectsFromArray:self.dataSource];
    
    [self initBulletComment];
}

// 初始化弹幕，随机分配弹幕轨迹
- (void)initBulletComment {
    NSMutableArray *trajectorys = [NSMutableArray arrayWithArray:@[@(0),@(1),@(2)]];
    for (int i = 0; i < 3; i++) {
        if ([self.bulletComments count] > 0) {
            // 通过随机数获取到弹幕的轨迹
            NSInteger index = arc4random()%trajectorys.count;
            int trajectory = [[trajectorys objectAtIndex:index] intValue];
            [trajectorys removeObjectAtIndex:index];
            
            // 从弹幕数组中逐一取出弹幕数据
            NSString *comment = [self.bulletComments firstObject];
            [self.bulletComments removeObjectAtIndex:0];
            
            // 创建弹幕View
            [self createBulletView:comment trajectory:trajectory];
        }
    }
}

// 通过评论和弹道轨迹创建弹幕View
- (void)createBulletView:(NSString *)comment trajectory:(int)trajectory {
    if (self.bStopAnimation) {
        return;
    }
    
    BulletView *view = [[BulletView alloc] initWithComment:comment];
    view.trajectory = trajectory;
    [self.bulletViews addObject:view];
    
    __weak typeof (view) weakView = view;
    __weak typeof (self) weakSelf = self;
    view.moveStatusBlock = ^(MoveStatus status) {
        if (self.bStopAnimation) {
            return;
        }
        switch (status) {
            case Start: {
                // 弹幕开始进入屏幕，将view加入弹幕管理的变量bulletViews中
                [self.bulletViews addObject:weakView];
                break;
            }
            case Enter: {
                // 弹幕完全进入屏幕，判断是否还有其它内容，如果有则在该弹幕轨迹中创建一个弹幕
                NSString *comment = [weakSelf nextComment];
                if (comment) {
                    [weakSelf createBulletView:comment trajectory:trajectory];
                }
                break;
            }
            case End: {
                // 弹幕移出屏幕后，从bulletViews移除，销毁弹幕并释放资源
                if ([weakSelf.bulletViews containsObject:weakView]) {
                    [weakView stopAnimation];
                    [weakSelf.bulletViews removeObject:weakView];
                }
                
                if ([weakSelf.bulletViews count] == 0) {
                    // 说明屏幕上已经没有弹幕了，开始循环滚动
                    self.bStopAnimation = YES;
                    [weakSelf start];
                }
                break;
            }
            default:
                break;
        }
    };
    
    if (self.generateViewBlock) {
        self.generateViewBlock(view);
    }
}

/// 弹幕停止执行
- (void)stop {
    if (self.bStopAnimation) {
        return;
    }
    self.bStopAnimation = YES;
    
    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BulletView *view = obj;
        [view stopAnimation];
        view = nil;
    }];
    [self.bulletViews removeAllObjects];
}

- (NSString *)nextComment {
    if ([self.bulletComments count] == 0) {
        return nil;
    }
    NSString *comment = [self.bulletComments firstObject];
    if (comment) {
        [self.bulletComments removeObjectAtIndex:0];
    }
    return comment;
}

#pragma mark -
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithArray:@[@"弹幕1~~~~~~~~~~~~",
                                                       @"弹幕2~~~~~~~~~~~~~~~~~~",
                                                       @"弹幕3~~~~~~",
                                                       @"弹幕4~~~~~~~~~~~~~~~~~~~~~",
                                                       @"弹幕5~~~~~~~~~~~~~~",
                                                       @"弹幕6~~~~~~~~~~~~~~~~~~~~~~~~",
                                                       @"弹幕7~~~",
                                                       @"弹幕8~~~~~~~~~~~~~~~~~~",
                                                       @"弹幕9~~~~~~~~~~",]];
    }
    return _dataSource;
}

- (NSMutableArray *)bulletComments {
    if (_bulletComments == nil) {
        _bulletComments = [NSMutableArray array];
    }
    return _bulletComments;
}

- (NSMutableArray *)bulletViews {
    if (_bulletViews == nil) {
        _bulletViews = [NSMutableArray array];
    }
    return _bulletViews;
}

@end
