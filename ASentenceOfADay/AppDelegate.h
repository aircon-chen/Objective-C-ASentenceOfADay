//
//  AppDelegate.h
//  ASentenceOfADay
//
//  Created by Chen Hsin Hsuan on 2015/3/3.
//  Copyright (c) 2015年 aircon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (void)setShadow:(id)sender withRange:(CGSize)size;
+ (void)showConfirmWithMessage:(NSString *)message withTitle:(NSString *) title deletgate:(id)delegate;

+ (void)showAlertWithMessage:(NSString *)message withTitle:(NSString *) title;
+ (BOOL)isConnectInternet;
@end

