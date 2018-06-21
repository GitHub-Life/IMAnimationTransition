//
//  IMBaseAnimationTransitioning.h
//  TransitionAnimationDemo
//
//  Created by 万涛 on 2018/6/20.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TransitionType) {
    TransitionTypePresent = 0,
    TransitionTypeDismiss
};

@protocol IMAnimationTransitioningDelegate

/** present动画【需要子类实现】 */
- (void)presentAnimateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext;
/** dismiss动画【需要子类实现】 */
- (void)dismissAnimateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext;

@optional
/** 手势回调【需要子类实现】 */
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGr;

@end

@interface IMBaseAnimationTransitioning : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, IMAnimationTransitioningDelegate>

/** 转场动画类型 Present / Dismiss */
@property (nonatomic, assign) TransitionType transitionType;

/** 手势响应的ViewController */
@property (nonatomic, weak) UIViewController *gestureVC;
/** 是否开始响应转场动画手势 */
@property (nonatomic, assign) BOOL interactive;
- (instancetype)initWithGestureVC:(UIViewController *)gestureVC;
- (void)addPanGerstureForTarget:(UIView *)target;

@end
