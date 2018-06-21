//
//  UIImage+View.m
//  NiuYan
//
//  Created by 万涛 on 2018/4/10.
//  Copyright © 2018年 niuyan.com. All rights reserved.
//

#import "UIImage+View.h"

@implementation UIImage (View)

+ (instancetype)imageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
