//
//  GRAppDelegate.m
//  GRDualSlider
//
//  Created by rost on 11.12.14.
//  Copyright (c) 2014 Rost. All rights reserved.
//

#import "GRAppDelegate.h"
#import "GRSliderViewController.h"


@implementation GRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    GRSliderViewController *sliderVC = [[GRSliderViewController alloc] init];
    self.window.rootViewController = sliderVC;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
