//
//  SetSyncStorageHandler.m
//  GoHaier
//
//  Created by niuxinghua on 2019/2/27.
//  Copyright © 2019年 com.haier. All rights reserved.
//

#import "SetSyncStorageHandler.h"
static SetSyncStorageHandler *sharedInstance;
@implementation SetSyncStorageHandler
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
    return @"ghaier_setStorageSync";
}
- (void)handlerMethod:(id)data
{
    NSLog(@"handler key %@ method called",[self handlerKey]);
    NSDictionary *syncDic = (NSDictionary *)data;
    if (syncDic && syncDic.allKeys.count > 0) {
        if([syncDic.allKeys containsObject:@"key"] && [syncDic.allKeys containsObject:@"value"])
        {
            NSString *key = [syncDic objectForKey:@"key"];
            NSString *value = [syncDic objectForKey:@"value"];
            [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self respondToWeb:@{}];

        }
    }
}
@end
