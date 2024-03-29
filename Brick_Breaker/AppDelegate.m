//
//  AppDelegate.m
//  p07-scagnelli
//
//  Created by Eric Scagnelli on 4/19/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import "AppDelegate.h"
#import "Universe.h"
#import "LevelReader.h"
#import "Block.h"
#import "Level.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    LevelReader *levelReader = [[LevelReader alloc] init];
    [levelReader startParsing];
    
    //Add levels from the XML file to Universe levels
    [Universe sharedInstance].levels = [[NSArray alloc] initWithArray:levelReader.levels];
    [Universe sharedInstance].NUM_LEVELS = levelReader.numLevels;
    [[Universe sharedInstance] load];
    NSLog(@"Num levels is %d", levelReader.numLevels);
    
    /*
    UIViewController *gameViewController = [self.window rootViewController];
    [[Universe sharedInstance] setGameViewController:(GameViewController *)gameViewController];
    [[Universe sharedInstance] setLevel];
     */
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [[Universe sharedInstance] save];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
