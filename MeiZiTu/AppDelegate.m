//
//  AppDelegate.m
//  MeiZiTu
//
//  Created by Vokie on 5/31/16.
//  Copyright © 2016 Vokie. All rights reserved.
//

#import "AppDelegate.h"
#import "DatabaseManager.h"
#import <UMMobClick/MobClick.h>

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //UMeng 相关配置
    //统计分析SDK
    UMConfigInstance.appKey = @"5761f76167e58ed255001d23";
    UMConfigInstance.channelId = @"Debug";
    [MobClick startWithConfigure:UMConfigInstance];
    
    //创建数据库
    [[DatabaseManager sharedManager] createDatabaseWithName:@"mzt.db"];
    [[DatabaseManager sharedManager] createTable];
    [[DatabaseManager sharedManager] insertWebsite]; //App生命周期有且仅执行一次
    [[DatabaseManager sharedManager] autoUpgrade];
    
    //定义导航条的颜色
    [[UINavigationBar appearance] setBarTintColor:COLOR_THEME];
    //定义导航条上文字的颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //设置导航的标题的颜色
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    CGFloat sysVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (sysVersion >= 8.0) {
        //当系统版本低于8.0时，下面代码会引起App Crash
        [[UINavigationBar appearance] setTranslucent:NO];
    }

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

@end
