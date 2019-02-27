//
//  RemoveSyncStorageHandler.m
//  GoHaier
//
//  Created by niuxinghua on 2019/2/27.
//  Copyright © 2019年 com.haier. All rights reserved.
//

#import "RemoveSyncStorageHandler.h"
static RemoveSyncStorageHandler *sharedInstance;
@implementation RemoveSyncStorageHandler
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
    return @"ghaier_removeStorage";
}
- (void)handlerMethod:(id)data
{
    NSLog(@"handler key %@ method called",[self handlerKey]);
    NSString *removeKey = (NSString *)data;
    if (removeKey && removeKey.length > 0 && [[NSUserDefaults standardUserDefaults] objectForKey:removeKey]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:removeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
