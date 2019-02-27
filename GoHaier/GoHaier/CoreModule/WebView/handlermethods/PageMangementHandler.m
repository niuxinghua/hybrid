//
//  PageMangementHandler.m
//  GoHaier
//
//  Created by niuxinghua on 2019/1/15.
//  Copyright © 2019年 com.haier. All rights reserved.
//

#import "PageMangementHandler.h"
#import "VersionController.h"
#import "HaierH5ViewController.h"
#import "ViewControllerUtil.h"
static PageMangementHandler* sharedInstance;
@implementation PageMangementHandler
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super alloc]init];
    });
    return sharedInstance;
}
- (NSString *)handlerKey
{
    return @"ghaier_pushnewpage";
}
- (void)handlerMethod:(id)data
{
    NSLog(@"handler key %@ method called",[self handlerKey]);
    NSArray *args = (NSArray *)data;
    if (args.count < 2) {
        return;
    }
    NSString *title = [args objectAtIndex:0];
    NSString *pageName = [args objectAtIndex:1];

    dispatch_async(dispatch_get_main_queue(), ^{
        [HaierH5ViewController showContentWithAPPName:[VersionController sharedInstance].currentAppName navigationMode:YES fullScreenMode:NO animated:NO titleName:title rootController:[[ViewControllerUtil sharedInstance] topViewController] pageName:pageName];
    });
}
@end
