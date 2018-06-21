//
//  IMMiddleAnimationTransitioning.m
//  TransitionAnimationDemo
//
//  Created by 万涛 on 2018/6/20.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMMiddleAnimationTransitioning.h"
#import "UIImage+View.h"
#import "UIView+IMRect.h"

@implementation IMMiddleAnimationTransitioning

//#pragma mark - UIViewControllerAnimatedTransitioning
//- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
//    return 5;
//}

#pragma mark - present 动画
- (void)presentAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIImage *tempImg = [UIImage imageWithView:fromVC.view];
    fromVC.view.hidden = YES;
    UIImageView *topImgView = [[UIImageView alloc] initWithImage:tempImg];
    topImgView.clipsToBounds = YES;
    topImgView.tag = 100;
    [topImgView setContentMode:UIViewContentModeTop];
    topImgView.frame = CGRectMake(0, 0, fromVC.view.width, self.segmentationPoint.y - self.segmentationVerticalOffset.top);
    
    UIImageView *bottomImgView = [[UIImageView alloc] initWithImage:tempImg];
    bottomImgView.clipsToBounds = YES;
    bottomImgView.tag = 101;
    [bottomImgView setContentMode:UIViewContentModeBottom];
    bottomImgView.frame = CGRectMake(0, self.segmentationPoint.y + self.segmentationVerticalOffset.bottom, fromVC.view.width, fromVC.view.height - self.segmentationPoint.y - self.segmentationVerticalOffset.bottom);
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:topImgView];
    [containerView addSubview:toVC.view];
    [containerView addSubview:bottomImgView];
    
    toVC.view.frame = CGRectMake(0, self.segmentationPoint.y - self.segmentationVerticalOffset.top, containerView.width, containerView.height);
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toVC.view.transform = CGAffineTransformMakeTranslation(0, -topImgView.height);
        topImgView.transform = CGAffineTransformMakeTranslation(0, -topImgView.height);
        bottomImgView.transform = CGAffineTransformMakeTranslation(0, bottomImgView.height);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {
            fromVC.view.hidden = NO;
            [topImgView removeFromSuperview];
            [bottomImgView removeFromSuperview];
        }
    }];
}

#pragma mark - dismiss 动画
- (void)dismissAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *topImgView;
    UIView *bottomImgView;
    for (UIView *subV in [transitionContext containerView].subviews) {
        if (subV.tag == 100) {
            topImgView = subV;
        } else if (subV.tag == 101) {
            bottomImgView = subV;
        }
    }
    [bottomImgView.superview bringSubviewToFront:bottomImgView];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.transform = CGAffineTransformIdentity;
        topImgView.transform = CGAffineTransformIdentity;
        bottomImgView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
        }else{
            [transitionContext completeTransition:YES];
            toVC.view.hidden = NO;
            [topImgView removeFromSuperview];
            [bottomImgView removeFromSuperview];
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
            }else{
                [self cancelInteractiveTransition];
            }
        } break;
        default:
            break;
    }
}

@end
