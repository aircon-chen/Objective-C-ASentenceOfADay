//
//  UserGuideViewController.h
//  ASentenceOfADay
//
//  Created by Chen Hsin Hsuan on 2015/3/19.
//  Copyright (c) 2015年 aircon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserGuideViewController : UIViewController<UIPageViewControllerDataSource>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageImages;
@end
