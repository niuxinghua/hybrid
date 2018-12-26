//
//  H5Downloader.h
//  GoHaier
//
//  Created by niuxinghua on 2018/12/11.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString* const DidDownloadH5BaseZipSuccess;
extern NSString* const DidDownloadH5PatchSuccess;

extern NSString* const H5ContextKey;

@interface H5Downloader : NSObject
+(instancetype)sharedInstance;
- (void)downLoadZipFile:(NSString*)fileUrl toPath:(NSString *)savePath withZipName:(NSString *)appName versionName:(NSString *)versionName;
- (void)downLoadPatchFile:(NSString*)fileUrl toPath:(NSString *)savePath withPatchName:(NSString *)appName CurrentVersion:(NSString *)currentversion targetVersion:(NSString *)targetVersion;
@end
