//
//  GetStorageInfo.m
//  GoHaier
//
//  Created by niuxinghua on 2019/2/27.
//  Copyright © 2019年 com.haier. All rights reserved.
//

#import "GetStorageInfo.h"
static GetStorageInfo *sharedInstance;
@implementation GetStorageInfo
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
    return @"ghaier_getStorageInfo";
}
- (void)handlerMethod:(id)data
{
    NSLog(@"handler key %@ method called",[self handlerKey]);
    if ([[NSUserDefaults standardUserDefaults]dictionaryRepresentation].allKeys) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray *keys = [[[NSUserDefaults standardUserDefaults]dictionaryRepresentation].allKeys copy];
            NSDictionary *res = @{@"keys":keys};
            [self respondToWeb:res];
        });
    }
    
}
@end
