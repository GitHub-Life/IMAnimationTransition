//
//  TableViewController.m
//  IMTransitionAnimationDemo
//
//  Created by 万涛 on 2018/6/21.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "TableViewController.h"
#import "IMPresentAnimationTransitioning.h"
#import "IMMiddleAnimationTransitioning.h"
#import "IMPresentListAnimationTransitioning.h"
#import "IMSpecialTag.h"
#import "ViewController.h"
#import "UIView+IMRect.h"

static NSString * const CellIdentifier = @"CellIdentifier";

@interface TableViewController ()

@property (nonatomic, assign) BOOL didAppear;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.tableView.tag = IMTransitionAnimationRecognizeSimultaneouslyGestureViewTag;
    [self.tableView setBackgroundColor:UIColor.groupTableViewBackgroundColor];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:CellIdentifier];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self animationTransitioning] && !_didAppear) {
        [self animationTransitioning].dismissScrollThreshold = self.tableView.contentOffset.y;
        _didAppear = YES;
    }
}

#pragma mark - UITaleView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.textLabel.text = [NSString stringWithFormat:@"row - %d", (int)indexPath.row];
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([self animationTransitioning]) {
        if (indexPath.row % 2) {
            TableViewController *tableVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TableViewController"];
            [self.navigationController pushViewController:tableVC animated:YES];
        } else {
            UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (indexPath.row % 3 == 0) {
            UINavigationController *naviVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationVC"];
            TableViewController *tableVC = (TableViewController *)naviVC.topViewController;
            tableVC.presentAnimationTransitioning = [[IMPresentAnimationTransitioning alloc] init];
            [tableVC.presentAnimationTransitioning addPanGerstureForTargetView:naviVC.view dismissVC:naviVC];
            tableVC.presentAnimationTransitioning.topOffset = UIApplication.sharedApplication.statusBarFrame.size.height;
            tableVC.presentAnimationTransitioning.cornerRadius = 10;
            naviVC.transitioningDelegate = tableVC.presentAnimationTransitioning;
            //            [self.navigationController presentViewController:naviVC animated:YES completion:nil];
            [self presentViewController:naviVC animated:YES completion:nil];
        } else if (indexPath.row % 3 == 1) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            CGRect cellFrame = [cell convertRect:cell.bounds toView:self.navigationController.view];
            UINavigationController *naviVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationVC"];
            TableViewController *tableVC = (TableViewController *)naviVC.topViewController;
            tableVC.middleAnimationTransitioning = [[IMMiddleAnimationTransitioning alloc] init];
            tableVC.middleAnimationTransitioning.segmentationPoint = CGPointMake(0, CGRectGetMaxY(cellFrame));
//            tableVC.middleAnimationTransitioning.segmentationVerticalOffset = UIEdgeInsetsMake(CGRectGetHeight(cellFrame) / 2, 0, CGRectGetHeight(cellFrame) / 2, 0);
            [tableVC.middleAnimationTransitioning addPanGerstureForTargetView:naviVC.view dismissVC:naviVC];
            naviVC.transitioningDelegate = tableVC.middleAnimationTransitioning;
            //            [self.navigationController presentViewController:naviVC animated:YES completion:nil];
            [self presentViewController:naviVC animated:YES completion:nil];
        } else {
            UINavigationController *naviVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationVC"];
            TableViewController *tableVC = (TableViewController *)naviVC.topViewController;
            tableVC.presentListAnimationTransitioning = [[IMPresentListAnimationTransitioning alloc] init];
            [tableVC.presentListAnimationTransitioning addPanGerstureForTargetView:naviVC.navigationBar dismissVC:naviVC];
            [tableVC.presentListAnimationTransitioning addPanGerstureForTargetView:tableVC.tableView dismissVC:naviVC];
            tableVC.presentListAnimationTransitioning.topOffset = UIApplication.sharedApplication.statusBarFrame.size.height;
            tableVC.presentListAnimationTransitioning.cornerRadius = 10;
            naviVC.transitioningDelegate = tableVC.presentListAnimationTransitioning;
            //            [self.navigationController presentViewController:naviVC animated:YES completion:nil];
            [self presentViewController:naviVC animated:YES completion:nil];
        }
    });
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self animationTransitioning].interactive) {
        [scrollView setContentOffset:CGPointMake(0, [self animationTransitioning].dismissScrollThreshold)];
    }
}

- (IMBaseAnimationTransitioning *)animationTransitioning {
    return _presentAnimationTransitioning ?: (_middleAnimationTransitioning ?: _presentListAnimationTransitioning);
}

@end
