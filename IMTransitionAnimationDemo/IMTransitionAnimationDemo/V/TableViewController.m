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
#import "ViewController.h"

static NSString * const CellIdentifier = @"CellIdentifier";

@interface TableViewController ()

@property (nonatomic, strong) IMMiddleAnimationTransitioning *middleAnimationTransitioning;
@property (nonatomic, strong) IMPresentAnimationTransitioning *presentAnimationTransitioning;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    [self.tableView setBackgroundColor:UIColor.groupTableViewBackgroundColor];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:CellIdentifier];
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (indexPath.row % 2) {
            UINavigationController *naviVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationVC"];
            self.presentAnimationTransitioning = [[IMPresentAnimationTransitioning alloc] initWithGestureVC:naviVC];
            [self.presentAnimationTransitioning addPanGerstureForTarget:naviVC.navigationBar];
            self.presentAnimationTransitioning.topOffset = UIApplication.sharedApplication.statusBarFrame.size.height;
            self.presentAnimationTransitioning.cornerRadius = 10;
            naviVC.transitioningDelegate = self.presentAnimationTransitioning;
            //            [self.navigationController presentViewController:naviVC animated:YES completion:nil];
            [self presentViewController:naviVC animated:YES completion:nil];
        } else {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            CGRect cellFrame = [cell convertRect:cell.bounds toView:self.navigationController.view];
            UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
            self.middleAnimationTransitioning = [[IMMiddleAnimationTransitioning alloc] initWithGestureVC:vc];
            self.middleAnimationTransitioning.segmentationPoint = CGPointMake(0, CGRectGetMidY(cellFrame));
            self.middleAnimationTransitioning.segmentationVerticalOffset = UIEdgeInsetsMake(CGRectGetHeight(cellFrame) / 2, 0, CGRectGetHeight(cellFrame) / 2, 0);
            [self.middleAnimationTransitioning addPanGerstureForTarget:vc.view];
            vc.transitioningDelegate = self.middleAnimationTransitioning;
            //            [self.navigationController presentViewController:naviVC animated:YES completion:nil];
            [self presentViewController:vc animated:YES completion:nil];
        }
    });
}

@end
