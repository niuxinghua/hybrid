//
//  RemoveStorageHandler.m
//  GoHaier
//
//  Created by niuxinghua on 2019/2/27.
//  Copyright © 2019年 com.haier. All rights reserved.
//

#import "RemoveStorageHandler.h"
static RemoveStorageHandler *sharedInstance;
@implementation RemoveStorageHandler
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
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (removeKey && removeKey.length > 0 && [[NSUserDefaults standardUserDefaults] objectForKey:removeKey]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:removeKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    });
}
@end
