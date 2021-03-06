//
//  H5Downloader.m
//  GoHaier
//
//  Created by niuxinghua on 2018/12/11.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "H5Downloader.h"
#import "SSZipArchive.h"
#import "GHaierH5Context.h"
#import "H5FilePathManager.h"
static H5Downloader *sharedInstance = nil;


NSString* const H5ContextKey = @"H5ContextKey";
@implementation H5Downloader
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[H5Downloader alloc]init];
    });
    return sharedInstance;
}
-(void)downLoadZipFile:(NSURL*)fileUrl toPath:(NSString *)savePath withZipName:(NSString *)appName versionName:(NSString *)versionName versionCode:(NSInteger)versionCode resultBlock:(FileDownLoadResultBlock)downloadBlock;
{
    //TODO 校验字符串是否合法
    
    dispatch_queue_t queue = dispatch_get_global_queue(
                                                       DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL *url = [fileUrl copy];
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
        if(!error)
        {
            /*得到要保存zip的路径*/
            NSString *zipPath = [savePath copy];
            [[H5FilePathManager sharedInstance] createFileDirectories:zipPath isRedo:YES];
            /*把zip文件放入路径中*/
            NSString *zipFileName = [zipPath stringByAppendingPathComponent:appName];
            [data writeToFile:zipFileName options:0 error:&error];
            if (error) {
                downloadBlock(NO);
                return ;
            }
            //解压zip到另外的目录
            NSString *realVersion = [NSString stringWithFormat:@"%@_%li",versionName,(long)versionCode];
            [self uncompressZipfile:zipFileName toPath:[[H5FilePathManager sharedInstance] baseSavePathwithappName:appName andAppversion:realVersion]];
            [[GHaierH5Context sharedContext]setCurrentVersionCode:[NSString stringWithFormat:@"%li",versionCode] forApp:appName];
            [[GHaierH5Context sharedContext]setCurrentVersionName:versionName forApp:appName];
            downloadBlock(YES);
        }
        else
        {
            NSLog(@"Error downloading zip file: %@", error);
            downloadBlock(NO);
        }
    });
}

- (void)downLoadPatchFile:(NSString*)fileUrl toPath:(NSString *)savePath withPatchName:(NSString *)appName CurrentVersion:(NSString *)currentversion targetVersion:(NSString *)targetVersion resultBlock:(FileDownLoadResultBlock)downloadBlock
{
    dispatch_queue_t queue = dispatch_get_global_queue(
                                                       DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:fileUrl];
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
        if(!error)
        {
            /*得到要保存zip的路径*/
            NSString *zipPath = [savePath copy];
            [[H5FilePathManager sharedInstance] createFileDirectories:zipPath isRedo:YES];
            /*把zip文件放入路径中*/
            NSString *zipFileName = [zipPath stringByAppendingPathComponent:appName];
            [data writeToFile:zipFileName options:0 error:&error];
            if (error) {
                downloadBlock(NO);
            }else{
                downloadBlock(YES);
            }
        }
        else
        {
            NSLog(@"Error downloading zip file: %@", error);
            downloadBlock(NO);
        }
    });
}
- (BOOL)uncompressZipfile:(NSString *)filePath toPath:(NSString *)savePath
{
    
    [[H5FilePathManager sharedInstance] createFileDirectories:savePath isRedo:NO];
    //解压zip文件
    [SSZipArchive unzipFileAtPath:filePath toDestination:savePath overwrite:YES password:@"" error:NULL];
    
    return YES;
    
    
    
}


@end
