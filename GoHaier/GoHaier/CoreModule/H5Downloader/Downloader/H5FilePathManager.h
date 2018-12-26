//
//  H5FilePathManager.h
//  GoHaier
//
//  Created by niuxinghua on 2018/12/26.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface H5FilePathManager : NSObject
+ (instancetype)sharedInstance;
- (NSString *)baseZipSavePathwithappName:(NSString*)appName andAppversion:(NSString*)appVersion;
- (NSString *)baseSavePathwithappName:(NSString*)appName andAppversion:(NSString*)appVersion;
- (NSString *)baseSavePathwithappName:(NSString*)appName andCurrentversion:(NSString*)appVersion targetVersion:(NSString *)targetVersion;
- (void)createFileDirectories:(NSString *)targetPath isRedo:(BOOL)redo;
@end

NS_ASSUME_NONNULL_END
