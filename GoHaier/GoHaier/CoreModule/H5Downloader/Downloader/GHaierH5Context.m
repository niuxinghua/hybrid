//
//  GHaierH5Context.m
//  GoHaier
//
//  Created by niuxinghua on 2018/12/11.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "GHaierH5Context.h"
#import "H5Downloader.h"
static GHaierH5Context *sharedContext = nil;

@implementation GHaierH5Context
+ (instancetype)sharedContext
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedContext = [[GHaierH5Context alloc]init];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:H5ContextKey] && ![[[NSUserDefaults standardUserDefaults] objectForKey:H5ContextKey] isKindOfClass:[NSNull class]]) {
            sharedContext.h5Mapper = [[[NSUserDefaults standardUserDefaults] objectForKey:H5ContextKey] mutableCopy];
        }else
        {
            sharedContext.h5Mapper = [[NSMutableDictionary alloc]init];

        }
    });
    return sharedContext;
}

+ (BOOL)isExitResource:(NSString *)appName appVersion:(NSString *)appversion
{
    NSString *saveKey = [NSString stringWithFormat:@"%@%@",appName,appversion];
    if ([[GHaierH5Context sharedContext].h5Mapper valueForKey:saveKey]) {
        return YES;
    }
    
    return NO;
}
- (NSString *)currentVersionWithAPPname:(NSString *)name;
{
    NSString *key = [NSString stringWithFormat:@"%@-currentVersion",name];
    if ([self.h5Mapper objectForKey:key]) {
        return [self.h5Mapper objectForKey:key];
    }
    return @"";
}
- (NSString *)targetVersionWithAPPname:(NSString *)name;
{
    NSString *key = [NSString stringWithFormat:@"%@-targetVersion",name];
    if ([self.h5Mapper objectForKey:key]) {
        return [self.h5Mapper objectForKey:key];
    }
    return @"";
}
- (NSString *)currentVersionNameWithAPPname:(NSString *)name
{
    NSString *key = [NSString stringWithFormat:@"%@-currentVersionName",name];
    if ([self.h5Mapper objectForKey:key]) {
        return [self.h5Mapper objectForKey:key];
    }
    return @"";
}
- (NSString *)currentVersionCodeWithAPPname:(NSString *)name
{
    NSString *key = [NSString stringWithFormat:@"%@-currentVersionCode",name];
    if ([self.h5Mapper objectForKey:key]) {
        return [self.h5Mapper objectForKey:key];
    }
    return @"";
}
- (void)setCurrentVersionName:(NSString*)name forApp:(NSString *)appId
{
    NSString *key = [NSString stringWithFormat:@"%@-currentVersionName",appId];
    [self setObject:name forKey:key];
}
- (void)setCurrentVersionCode:(NSString*)code forApp:(NSString *)appId
{
    NSString *key = [NSString stringWithFormat:@"%@-currentVersionName",appId];
    [self setObject:code forKey:key];
}
- (void)syncToLocal
{
    @synchronized (self) {
        [[NSUserDefaults standardUserDefaults] setObject:self.h5Mapper forKey:H5ContextKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
- (void)setObject:(id)object forKey:(NSString *)key
{
    @synchronized (self) {
        [self.h5Mapper setValue:object forKey:key];
        [self syncToLocal];
    }
}
- (NSString *)valueForKey:(NSString *)key
{
    if ([self.h5Mapper valueForKey:key]) {
        return [self.h5Mapper valueForKey:key];
    }
    return @"";
}
@end
