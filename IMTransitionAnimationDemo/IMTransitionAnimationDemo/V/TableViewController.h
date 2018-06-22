//
//  TableViewController.h
//  IMTransitionAnimationDemo
//
//  Created by 万涛 on 2018/6/21.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IMPresentAnimationTransitioning;
@class IMMiddleAnimationTransitioning;

@interface TableViewController : UITableViewController

@property (nonatomic, strong) IMPresentAnimationTransitioning *presentAnimationTransitioning;
@property (nonatomic, strong) IMMiddleAnimationTransitioning *middleAnimationTransitioning;

@end
