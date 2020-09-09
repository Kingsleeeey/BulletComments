//
//  BulletView.m
//  CommentDemo
//
//  Created by Kingsleeeey on 2020/9/8.
//  Copyright © 2020 Kingsleeeey. All rights reserved.
//

#import "BulletView.h"

#define Padding 10
#define PhotoHeight 30

@interface BulletView ()

@property (nonatomic, strong) UILabel *lbComment;// 弹幕Label
@property (nonatomic, strong) UIImageView *photoIgv;// 弹幕头像

@end

@implementation BulletView

/// 初始化弹幕
- (instancetype)initWithComment:(NSString *)comment {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        self.layer.cornerRadius = 15.f;
        
        // 计算弹幕的实际宽度
        NSDictionary *attrDic = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0]};
        CGFloat width = [comment sizeWithAttributes:attrDic].width;
        
        self.bounds = CGRectMake(0, 0, width + 2 * Padding + PhotoHeight, 30);
        
        self.lbComment.text = comment;
        self.lbComment.frame = CGRectMake(Padding + PhotoHeight, 0, width, 30);
        
        self.photoIgv.frame = CGRectMake(-Padding, -Padding, PhotoHeight + Padding, PhotoHeight + Padding);
        self.photoIgv.layer.cornerRadius = (PhotoHeight + Padding)/2;
        self.photoIgv.layer.borderColor = [UIColor redColor].CGColor;
        self.photoIgv.layer.borderWidth = 1.f;
        self.photoIgv.image = [UIImage imageNamed:@"PacMan 1024.png"];
    }
    return self;
}

/// 开始动画
- (void)startAnimation {
    
    // 根据弹幕长度执行动画效果
    // 根据 v = s/t, 时间相同的情况下，距离越长，速度就越快
    
    CGFloat screenWith = [UIScreen mainScreen].bounds.size.width;
    CGFloat duration = 4.0f;
    CGFloat wholeWith = screenWith + CGRectGetWidth(self.bounds);
    
    // 弹幕开始
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Start);
    }
    
    // t = s/v
    CGFloat speed = wholeWith/duration;
    CGFloat enterDuration = CGRectGetWidth(self.bounds)/speed;
    
    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterDuration];
    
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x -= wholeWith;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        if (self.moveStatusBlock) {
            self.moveStatusBlock(End);
        }
    }];
}

- (void)enterScreen {
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Enter);
    }
}

/// 结束动画
- (void)stopAnimation {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

#pragma mark - 懒加载
- (UILabel *)lbComment {
    if (!_lbComment) {
        _lbComment = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbComment.font = [UIFont systemFontOfSize:14.0];
        _lbComment.textColor = [UIColor whiteColor];
        _lbComment.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lbComment];
    }
    return _lbComment;
}

- (UIImageView *)photoIgv {
    if (!_photoIgv) {
        _photoIgv = [[UIImageView alloc] init];
        _photoIgv.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _photoIgv.clipsToBounds = YES;
        _photoIgv.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_photoIgv];
    }
    return _photoIgv;
}

@end
