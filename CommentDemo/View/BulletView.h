//
//  BulletView.h
//  CommentDemo
//
//  Created by Kingsleeeey on 2020/9/8.
//  Copyright © 2020 Kingsleeeey. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MoveStatus) {
    Start,
    Enter,
    End
};

@interface BulletView : UIView

/// 弹道
@property (nonatomic, assign) int trajectory;
/// 弹幕状态回调
@property (nonatomic, copy) void (^moveStatusBlock)(MoveStatus status);

/// 初始化弹幕
- (instancetype)initWithComment:(NSString *)comment;
/// 开始动画
- (void)startAnimation;
/// 结束动画
- (void)stopAnimation;

@end

NS_ASSUME_NONNULL_END
