//
//  AppDelegate.m
//  ASentenceOfADay
//
//  Created by Chen Hsin Hsuan on 2015/3/3.
//  Copyright (c) 2015年 aircon. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "Reachability.h"
UIAlertView *confirmAlert;
UIAlertView *alertView;
@interface AppDelegate ()
{
    
}
@end
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.backgroundColor = [UIColor blackColor];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(BOOL) didLinkFromTodayExtention
{
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc]initWithSuiteName:@"group.aircon.ASentenceOfADay"];
    

    if ([sharedDefaults boolForKey:@"fromTodayExtention"]) {
        [sharedDefaults setBool:NO forKey:@"fromTodayExtention"];
        [sharedDefaults synchronize];
        return YES;
    }
    return NO;
}


+ (void)setShadow:(id)sender withRange:(CGSize)size {
    UIView *view = (UIView *)sender;
    
    view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    
    view.clipsToBounds = NO;
    view.layer.masksToBounds = NO;
    view.layer.shadowRadius = 6;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 0.5;
    view.layer.shadowOffset = size;
}


+ (void)showConfirmWithMessage:(NSString *)message withTitle:(NSString *) title deletgate:(id)delegate{
    
    confirmAlert = [[UIAlertView alloc]initWithTitle:title
                                             message:message
                                            delegate:delegate
                                   cancelButtonTitle:@"取消"
                                   otherButtonTitles:@"確定", nil];
    [confirmAlert show];

}

+ (void)showAlertWithMessage:(NSString *)message withTitle:(NSString *) title{
    alertView = [[UIAlertView alloc]initWithTitle:title
                                           message:message
                                          delegate:nil
                                 cancelButtonTitle:@"確定"
                                 otherButtonTitles:nil];
    
    [alertView show];
    
}


+ (BOOL)isConnectInternet
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable){
        [reachability stopNotifier];
        return NO;
    }
    [reachability stopNotifier];
    return YES;
}


@end
