//
//  IMBaseAnimationTransitioning.m
//  TransitionAnimationDemo
//
//  Created by 万涛 on 2018/6/20.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMBaseAnimationTransitioning.h"

@implementation IMBaseAnimationTransitioning

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.transitionType) {
        case TransitionTypePresent: {
            [self presentAnimateTransition:transitionContext];
        } break;
        case TransitionTypeDismiss: {
            [self dismissAnimateTransition:transitionContext];
        } break;
    }
}

/** present动画 【需要子类实现】 */
- (void)presentAnimateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    @throw [NSException exceptionWithName:@"Unimplemented Methods" reason:[NSString stringWithFormat:@"The \"%@\" method has not yet been implemented in \"%@\"", NSStringFromSelector(_cmd), NSStringFromClass(self.class)] userInfo:nil];
}
/** dismiss动画 【需要子类实现】 */
- (void)dismissAnimateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    @throw [NSException exceptionWithName:@"Unimplemented Methods" reason:[NSString stringWithFormat:@"The \"%@\" method has not yet been implemented in \"%@\"", NSStringFromSelector(_cmd), NSStringFromClass(self.class)] userInfo:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.transitionType = TransitionTypePresent;
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.transitionType = TransitionTypeDismiss;
    return self;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return self.interactive ? self : nil;
}

#pragma mark - 添加手势
- (instancetype)initWithGestureVC:(UIViewController *)gestureVC {
    if (self = [super init]) {
        self.gestureVC = gestureVC;
    }
    return self;
}

- (void)addPanGerstureForTarget:(UIView *)target {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [target addGestureRecognizer:pan];
}

/** 手势回调 【需要子类实现】 */
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGr {
    @throw [NSException exceptionWithName:@"Unimplemented Methods" reason:[NSString stringWithFormat:@"The \"%@\" method has not yet been implemented in \"%@\"", NSStringFromSelector(_cmd), NSStringFromClass(self.class)] userInfo:nil];
}

@end
