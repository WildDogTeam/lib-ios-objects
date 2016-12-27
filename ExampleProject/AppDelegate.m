//
//  AppDelegate.m
//  ExampleProject
//
//  Created by ImacLi on 9/23/15.
//  Copyright (c) 2015 The liwuyang. All rights reserved.
//

#import "AppDelegate.h"
#import "WilddogCollection.h"
#import <Wilddog/Wilddog.h>
#import "User.h"
#import "ViewController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    
    //初始化 WDGApp
    WDGOptions *option = [[WDGOptions alloc] initWithSyncURL:@"https://<YOUR-FIREBASE-APPID>wilddogio.com"];
    [WDGApp configureWithOptions:option];
    //获取一个指向根节点的 WDGSyncReference 实例
    WDGSyncReference *rootRef = [[WDGSync sync] reference];

    WDGSyncReference *refStaff = [rootRef child:@"stuff"];
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    WilddogCollection * collection = [[WilddogCollection alloc] initWithNode:refStaff dictionary:dictionary type:[User class]];

    [collection didAddChild:^(User * user) {
        // created remotely or locally, it is called here
        NSLog(@"New User %@", user);
    }];
    
    User * me = [User new];
    me.name = @"me";
    [collection addObject:me];


    ViewController *viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = viewController;

    return YES;
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
