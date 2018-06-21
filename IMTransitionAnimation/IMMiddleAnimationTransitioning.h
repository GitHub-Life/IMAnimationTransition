//
//  IMMiddleAnimationTransitioning.h
//  TransitionAnimationDemo
//
//  Created by 万涛 on 2018/6/20.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMBaseAnimationTransitioning.h"

@interface IMMiddleAnimationTransitioning : IMBaseAnimationTransitioning

/** 截图分割点(相对于fromVC.view的坐标)，取y值(即Y值有效) */
@property (nonatomic, assign) CGPoint segmentationPoint;
/** 截图分割点偏移量，取垂直方向(即top/bottom有效) */
@property (nonatomic, assign) UIEdgeInsets segmentationVerticalOffset;

@end
