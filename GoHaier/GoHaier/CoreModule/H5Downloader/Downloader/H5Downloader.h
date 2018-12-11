//
//  H5Downloader.h
//  GoHaier
//
//  Created by niuxinghua on 2018/12/11.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString* const DidDownloadH5Success;
extern NSString* const H5ContextKey;

@interface H5Downloader : NSObject
+(instancetype)sharedInstance;
- (BOOL)downLoadZipFile:(NSString*)filePath fileName:(NSString*)appName unZipToPathwithVersion:(NSString*)version;
@end
