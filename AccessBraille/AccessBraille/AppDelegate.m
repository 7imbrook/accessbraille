//
//  AppDelegate.m
//  AccessBraille
//
//  Created by Michael on 12/5/12.
//  Copyright (c) 2012 RIT. All rights reserved.
//

#import "AppDelegate.h"
#import "ABSpeak.h"
#import "NavigationContainer.h"
#import "BrailleTyperController.h"
#import "SettingsViewController.h"
#import "InstructionsViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"firstRun"]) {
        // Prevent running again
        [defaults setObject:[NSDate date] forKey:@"firstRun"];
        
        // Set user defaults
        [defaults setBool:YES forKey:GradeTwoSet];
        [defaults setFloat:0.4 forKey:KeyboardTransparency];
        [defaults setFloat:17.0 forKey:ABFontSize];
        
        // Launch About controller on first run
        NavigationContainer *root = [NavigationContainer new];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        [root switchToController:[storyboard instantiateViewControllerWithIdentifier:InstructionsStoryBoardID] animated:NO withMenu:YES];
        self.window.rootViewController = root;
        
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Call once to stop lag and crash in main menu
    [ABSpeak sharedInstance];
    
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
    
}

@end
