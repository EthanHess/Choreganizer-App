//
//  AppDelegate.m
//  Choreganizer
//
//  Created by Ethan Hess on 6/5/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ScheduledNotificationsListViewController.h"
#import "QuestionsViewController.h"
#import "ChoreController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self configureTabBar]; 

    [self setUpCoreData];
    
   /* UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    */
    return YES;
}
     
- (void)setUpCoreData {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasLaunched"])
    {
         
    [[ChoreController sharedInstance]addDayWithName:@"Monday"];
    [[ChoreController sharedInstance]addDayWithName:@"Tuesday"];
    [[ChoreController sharedInstance]addDayWithName:@"Wednesday"];
    [[ChoreController sharedInstance]addDayWithName:@"Thursday"];
    [[ChoreController sharedInstance]addDayWithName:@"Friday"];
    [[ChoreController sharedInstance]addDayWithName:@"Saturday"];
    [[ChoreController sharedInstance]addDayWithName:@"Sunday"];
        
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLaunched"];
    [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
         
}

- (void)configureTabBar {
    
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    tabBarController.tabBar.barTintColor = [UIColor blackColor];
    tabBarController.tabBar.tintColor = [UIColor whiteColor];
    
    ViewController *mainVC = [[ViewController alloc]init];
    ScheduledNotificationsListViewController *notificationsVC = [[ScheduledNotificationsListViewController alloc]init];
    QuestionsViewController *qVC = [[QuestionsViewController alloc]init];
    
    UINavigationController *mainNav = [[UINavigationController alloc]initWithRootViewController:tabBarController];
    
    UIImage *imageOne = [UIImage imageNamed:@"CTab"];
    UIImage *imageTwo = [UIImage imageNamed:@"NTab"];
    UIImage *imageThree = [UIImage imageNamed:@"STab"];
    
    mainVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Chores" image:imageOne tag:0];
    notificationsVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Notifications" image:imageTwo tag:1];
    qVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Settings" image:imageThree tag:2];
    
    [tabBarController setViewControllers:@[mainVC, notificationsVC, qVC]];
    
    self.window.rootViewController = mainNav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
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
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //iOS 8
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:nil]];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
