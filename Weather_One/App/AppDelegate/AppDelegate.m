//
//  AppDelegate.m
//  Weather_One
//
//  Created by Nick on 9/18/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import "AppDelegate.h"
#import "WeatherConditionsListViewController.h"
#import "WeatherConditionsProvider.h"
#import "WeatherConditionsService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    [self customizeAppearance];
    
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    WeatherConditionsListViewController *vc = (WeatherConditionsListViewController *)navController.viewControllers.firstObject;
    
    WeatherConditionsService *service = [[WeatherConditionsService alloc] init];
    WeatherConditionsProvider *dataProvider = [[WeatherConditionsProvider alloc] initWithWeathersService:service];
    vc.dataProvider = dataProvider;
    vc.dataProvider.fetchedResultsControllerDelegate = vc;
    
    return YES;
}

#pragma mark - CustomizeUI

- (void)customizeAppearance {
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.09 green:0.10 blue:0.13 alpha:1.00]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor],}];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

@end
