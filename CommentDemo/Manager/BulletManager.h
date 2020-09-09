//
//  BulletManager.h
//  CommentDemo
//
//  Created by Kingsleeeey on 2020/9/8.
//  Copyright © 2020 Kingsleeeey. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BulletView;
@interface BulletManager : NSObject

@property (nonatomic, copy) void (^generateViewBlock)(BulletView *view);

/// 弹幕开始执行
- (void)start;

/// 弹幕停止执行
- (void)stop;

@end

NS_ASSUME_NONNULL_END
