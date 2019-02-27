//
//  GetStorageHandler.m
//  GoHaier
//
//  Created by niuxinghua on 2019/2/27.
//  Copyright © 2019年 com.haier. All rights reserved.
//

#import "GetStorageHandler.h"
static GetStorageHandler *sharedInstance;
@implementation GetStorageHandler
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
    return @"ghaier_getStorage";
}
- (void)handlerMethod:(id)data
{
    NSLog(@"handler key %@ method called",[self handlerKey]);
    NSString *getKey = (NSString *)data;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([[NSUserDefaults standardUserDefaults] objectForKey:removeKey]) {
            [self respondToWeb:[[NSUserDefaults standardUserDefaults] objectForKey:removeKey]]
        }else{
            [self respondToWeb:@""];
        }
    };
}
@end
