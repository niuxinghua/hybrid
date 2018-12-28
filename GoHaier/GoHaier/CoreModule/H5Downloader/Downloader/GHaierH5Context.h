//
//  GHaierH5Context.h
//  GoHaier
//
//  Created by niuxinghua on 2018/12/11.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <Foundation/Foundation.h>
@class H5Downloader;
extern NSString * const CURRENTVERSION;
@interface GHaierH5Context : NSObject
+ (instancetype)sharedContext;
@property(atomic,strong)NSDictionary *h5Mapper;
+ (BOOL)isExitResource:(NSString *)appName appVersion:(NSString *)appversion;
- (NSString *)currentVersionWithAPPname:(NSString *)name;
- (NSString *)targetVersionWithAPPname:(NSString *)name;
- (void)setObject:(id)object forKey:(NSString *)key;
- (NSString *)valueForKey:(NSString *)key;
@end
