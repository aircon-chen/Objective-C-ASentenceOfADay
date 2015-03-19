//
//  PageContentViewController.h
//  ASentenceOfADay
//
//  Created by Chen Hsin Hsuan on 2015/3/19.
//  Copyright (c) 2015年 aircon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *guideImageView;
@property NSUInteger pageIndex;
@property NSString *imageFile;
@end
