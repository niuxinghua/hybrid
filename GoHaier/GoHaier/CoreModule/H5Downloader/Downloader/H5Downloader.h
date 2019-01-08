//
//  H5Downloader.h
//  GoHaier
//
//  Created by niuxinghua on 2018/12/11.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^FileDownLoadResultBlock)(BOOL issuccess);
extern NSString* const H5ContextKey;

@interface H5Downloader : NSObject
+(instancetype)sharedInstance;
- (void)downLoadZipFile:(NSString*)fileUrl toPath:(NSString *)savePath withZipName:(NSString *)appName versionName:(NSString *)versionName versionCode:(NSInteger)versionCode resultBlock:(FileDownLoadResultBlock)downloadBlock;
- (void)downLoadPatchFile:(NSString*)fileUrl toPath:(NSString *)savePath withPatchName:(NSString *)appName CurrentVersion:(NSString *)currentversion targetVersion:(NSString *)targetVersion;
@end
