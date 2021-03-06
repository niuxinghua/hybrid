//
//  AppDelegate.m
//  GoHaier
//
//  Created by niuxinghua on 2018/11/23.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "AppDelegate.h"
#import "PAirSandbox.h"
#import "VersionController.h"
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
#import "HotFixManager.h"
#import "UMCommonModule.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
#ifdef DEBUG
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[PAirSandbox sharedInstance] enableSwipe];
    });
#endif
//    NSArray *arr = @[];
//    NSString *f = [arr objectAtIndex:1];
    [[VersionController sharedInstance] updataAll];
    
    //初始化友盟统计sdk,这里面的appkey得在打包的时候动态打进来
    
   // [UMConfigure initWithAppkey:@"5c85d1bb61f5649846000565" channel:nil];

    //以下是配成友盟hybrid模式
    [UMConfigure setLogEnabled:YES]; // 开发调试时可在console查看友盟 志显示,发布产
    [MobClick setScenarioType:E_UM_NORMAL];
    [UMCommonModule initWithAppkey:@"5c85d1bb61f5649846000565" channel:nil];
    
    
    [[HotFixManager sharedManager] setUp];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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
