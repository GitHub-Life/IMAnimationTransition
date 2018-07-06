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
    topImgView.frame = CGRectMake(0, fromVC.view.y, fromVC.view.width, self.segmentationPoint.y - self.segmentationVerticalOffset.top);

    UIImageView *bottomImgView = [[UIImageView alloc] initWithImage:tempImg];
    bottomImgView.clipsToBounds = YES;
    bottomImgView.tag = 101;
    [bottomImgView setContentMode:UIViewContentModeBottom];
    bottomImgView.frame = CGRectMake(0, fromVC.view.y + self.segmentationPoint.y + self.segmentationVerticalOffset.bottom, fromVC.view.width, fromVC.view.height - self.segmentationPoint.y - self.segmentationVerticalOffset.bottom);
    UIView *bottomImgMaskView = [[UIView alloc] initWithFrame:bottomImgView.bounds];
    bottomImgMaskView.backgroundColor = UIColor.blackColor;
    bottomImgMaskView.alpha = 0;
    [bottomImgView addSubview:bottomImgMaskView];
    
    UIView *containerView = [transitionContext containerView];
    containerView.backgroundColor = UIColor.blackColor;
    [containerView addSubview:topImgView];
    [containerView addSubview:toVC.view];
    [containerView addSubview:bottomImgView];
    
    toVC.view.frame = CGRectMake(0, fromVC.view.y + self.segmentationPoint.y - self.segmentationVerticalOffset.top, containerView.width, fromVC.view.height);
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toVC.view.transform = CGAffineTransformMakeTranslation(0, -topImgView.height);
        topImgView.transform = CGAffineTransformMakeTranslation(0, -topImgView.height);
        bottomImgView.transform = CGAffineTransformMakeTranslation(0, bottomImgView.height);
        topImgView.alpha = 0;
        bottomImgMaskView.alpha = 1;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

#pragma mark - dismiss 动画
- (void)dismissAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *topImgView;
    UIView *bottomImgView;
    UIView *bottomImgMaskView;
    for (UIView *subV in [transitionContext containerView].subviews) {
        if (subV.tag == 100) {
            topImgView = subV;
        } else if (subV.tag == 101) {
            bottomImgView = subV;
            bottomImgMaskView = bottomImgView.subviews.lastObject;
        }
    }
    [bottomImgView.superview bringSubviewToFront:bottomImgView];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.transform = CGAffineTransformIdentity;
        topImgView.transform = CGAffineTransformIdentity;
        bottomImgView.transform = CGAffineTransformIdentity;
        topImgView.alpha = 1;
        bottomImgMaskView.alpha = 0;
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
        } else {
            [transitionContext completeTransition:YES];
            toVC.view.y = topImgView.y;
            toVC.view.hidden = NO;
            [topImgView removeFromSuperview];
            [bottomImgView removeFromSuperview];
        }
    }];
}

#pragma mark - 手势
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGr {
    if (self.noResponseGesture) return;
    CGFloat transitionY = [panGr translationInView:panGr.view].y;
    CGFloat percent = transitionY / UIScreen.mainScreen.bounds.size.height * 2;
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
