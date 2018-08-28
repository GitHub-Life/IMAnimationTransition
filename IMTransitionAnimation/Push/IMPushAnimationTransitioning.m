//
//  IMPushAnimationTransitioning.m
//  Bullseye
//
//  Created by 万涛 on 2018/6/29.
//  Copyright © 2018年 niuyan.com. All rights reserved.
//

#import "IMPushAnimationTransitioning.h"
#import "UIView+IMRect.h"

@implementation IMPushAnimationTransitioning

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
    toVC.view.frame = CGRectMake(containerView.width, 0, containerView.width, containerView.height);

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        presentingSnapshot.transform = CGAffineTransformMakeScale(0.95, 0.95);
        toVC.view.transform = CGAffineTransformMakeTranslation(-toVC.view.width, 0);
        maskView.alpha = 1;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
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
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        maskView.alpha = 0;
        fromVC.view.transform = CGAffineTransformIdentity;
        presentingSnapshot.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
        } else {
            [transitionContext completeTransition:YES];
            if (presentingSnapshot) {
                toVC.view.frame = presentingSnapshot.frame;
            }
            toVC.view.hidden = NO;
            [maskView removeFromSuperview];
            [presentingSnapshot removeFromSuperview];
        }
    }];
}

#pragma mark - 手势
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGr {
    CGFloat transitionX = [panGr translationInView:panGr.view].x;
    CGFloat percent = transitionX / UIScreen.mainScreen.bounds.size.width;
    switch (panGr.state) {
        case UIGestureRecognizerStateBegan: {
            [self updateTransitionPercent:percent state:IMTransitionPercentStateBegin];
        } break;
        case UIGestureRecognizerStateChanged: {
            [self updateTransitionPercent:percent state:IMTransitionPercentStateChanged];
        } break;
        case UIGestureRecognizerStateEnded: {
            [self updateTransitionPercent:percent state:IMTransitionPercentStateEnded];
        } break;
        default:
            break;
    }
}

@end
