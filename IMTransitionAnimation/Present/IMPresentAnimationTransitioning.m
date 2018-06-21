//
//  IMPresentAnimationTransitioning.m
//  TransitionAnimationDemo
//
//  Created by 万涛 on 2018/6/21.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMPresentAnimationTransitioning.h"
#import "UIView+IMRect.h"

@implementation IMPresentAnimationTransitioning

//#pragma mark - UIViewControllerAnimatedTransitioning
//- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
//    return 5;
//}

#pragma mark - present 动画
- (void)presentAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    UIView *presentingSnapshot = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    presentingSnapshot.tag = 100;
    presentingSnapshot.frame = fromVC.view.frame;
    fromVC.view.hidden = YES;
    [containerView addSubview:presentingSnapshot];
    
    UIView *maskView = [[UIView alloc] initWithFrame:containerView.bounds];
    maskView.tag = 200;
    [maskView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    maskView.alpha = 0;
    [containerView addSubview:maskView];
    
    [containerView addSubview:toVC.view];
    toVC.view.frame = CGRectMake(0, containerView.height, containerView.width, containerView.height - self.topOffset);
    if (self.cornerRadius > 0) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:toVC.view.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = toVC.view.bounds;
        maskLayer.path = maskPath.CGPath;
        toVC.view.layer.mask = maskLayer;
    }
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toVC.view.transform = CGAffineTransformMakeTranslation(0, -toVC.view.height);
        maskView.alpha = 1;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        NSLog(@" - %@ - %@", fromVC.view, NSStringFromCGRect(fromVC.view.frame));
    }];
}

#pragma mark - dismiss 动画
- (void)dismissAnimateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *maskView;
    UIView *presentingSnapshot;
    for (UIView *subV in [transitionContext containerView].subviews) {
        if (subV.tag == 100) {
            presentingSnapshot = subV;
        } else if (subV.tag == 200) {
            maskView = subV;
        }
    }
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        maskView.alpha = 0;
        fromVC.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
        } else {
            [transitionContext completeTransition:YES];
            toVC.view.frame = presentingSnapshot.frame;
            toVC.view.hidden = NO;
            [maskView removeFromSuperview];
            [presentingSnapshot removeFromSuperview];
        }
    }];
}

#pragma mark - 手势
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGr {
    CGFloat transitionY = [panGr translationInView:panGr.view].y;
    CGFloat percent = transitionY / UIScreen.mainScreen.bounds.size.height;
    switch (panGr.state) {
        case UIGestureRecognizerStateBegan: {
            self.interactive = YES;
            [self.gestureVC dismissViewControllerAnimated:YES completion:nil];
        } break;
        case UIGestureRecognizerStateChanged: {
            [self updateInteractiveTransition:percent];
        } break;
        case UIGestureRecognizerStateEnded: {
            self.interactive = NO;
            if (percent > 0.5) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
        } break;
        default:
            break;
    }
}

@end
