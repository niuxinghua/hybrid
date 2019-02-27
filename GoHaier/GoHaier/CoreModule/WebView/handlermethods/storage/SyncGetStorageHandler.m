//
//  SyncGetStorageHandler.m
//  GoHaier
//
//  Created by niuxinghua on 2019/2/27.
//  Copyright © 2019年 com.haier. All rights reserved.
//

#import "SyncGetStorageHandler.h"
static SyncGetStorageHandler *sharedInstance;
@implementation SyncGetStorageHandler
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc]init];
    });
    return sharedInstance;
}
- (NSString *)handlerKey
{
    return @"ghaier_getStorageSync";
}
- (void)handlerMethod:(id)data
{
    NSLog(@"handler key %@ method called",[self handlerKey]);
    NSString *getKey = (NSString *)data;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:getKey]) {
        [self respondToWeb:[[NSUserDefaults standardUserDefaults] objectForKey:getKey]];
    }else{
        [self respondToWeb:@""];

    }
}
@end
