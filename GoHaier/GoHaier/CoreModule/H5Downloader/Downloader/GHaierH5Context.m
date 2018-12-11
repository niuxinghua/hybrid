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
- (NSString*)getBaseZipSavePath:(NSString*)appName versionName:(NSString *)versionName
{
    NSString *sandboxPath = NSHomeDirectory();
    NSString *path = [sandboxPath  stringByAppendingPathComponent:@"Library/Caches"];//将Documents
    NSString *zipPath = [path stringByAppendingPathComponent:appName];
    zipPath =  [zipPath stringByAppendingPathComponent:versionName];
    return zipPath;
}
- (NSString*)getBaseZipSavePath:(NSString*)appName
{
    NSString *sandboxPath = NSHomeDirectory();
    NSString *path = [sandboxPath  stringByAppendingPathComponent:@"Library/Caches"];//将Documents
    NSString *zipPath = [path stringByAppendingPathComponent:appName];
    return zipPath;
}
@end
