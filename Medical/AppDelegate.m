//
//  AppDelegate.m
//  Medical
//
//  Created by zhangnan on 6/11/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "AppDelegate.h"
#import "APIHeader.h"
#import "MedicalLoginViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [self registerNotification];
    [self customAppearence];
    return YES;
}

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showLogin:) name:kNotificationShowLogin object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logout:) name:kNotificationLogout object:nil];
}

- (void)customAppearence
{
//    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:33/255.0 green:241/255.0 blue:231/255.0 alpha:1]];
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    
    [[UIBarButtonItem appearance]
     setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000, -1000)
     forBarMetrics:UIBarMetricsDefault];
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"icon_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 18, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavigaionBarBackground"]
//                       forBarPosition:UIBarPositionAny
//                           barMetrics:UIBarMetricsDefault];
    
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc]init]];
    
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)showLogin:(NSNotification *)note
{
    UITabBarController *tabController =
    (UITabBarController *)self.window.rootViewController;
    
    [tabController performSegueWithIdentifier:@"showLogin" sender:nil];
}

- (void)logout:(NSNotification *)note
{
    [ShareData shareInstance].curUser = [[User alloc]init];
    UIViewController* initialScene = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    self.window.rootViewController = initialScene;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
