//
//  GHaierH5Context.h
//  GoHaier
//
//  Created by niuxinghua on 2018/12/11.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <Foundation/Foundation.h>
@class H5Downloader;
@interface GHaierH5Context : NSObject
+ (instancetype)sharedContext;
@property(atomic,strong)NSDictionary *h5Mapper;
+ (BOOL)isExitResource:(NSString *)appName appVersion:(NSString *)appversion;
@end
