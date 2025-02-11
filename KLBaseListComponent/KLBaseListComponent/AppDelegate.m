//
//  AppDelegate.m
//  KLBaseListComponent
//
//  Created by admin on 2025/2/8.
//

#import "AppDelegate.h"

#import "KLNavigationController.h"
#import "KLTestListComponentController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[KLNavigationController alloc] initWithRootViewController:[KLTestListComponentController new]];
    
    return YES;
}


@end
