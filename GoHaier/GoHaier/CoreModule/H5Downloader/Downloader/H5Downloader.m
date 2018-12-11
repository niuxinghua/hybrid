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
static H5Downloader *sharedInstance = nil;
NSString* const DidDownloadH5Success = @"DidDownloadH5Success";
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
- (BOOL)downLoadZipFile:(NSString*)filePath fileName:(NSString*)appName unZipToPathwithVersion:(NSString*)version
{
    [self downLoadZipToPah:[self getBaseZipSavePath:appName versionName:version] zipFileUrl:filePath appName:appName versionName:version];
    
    return YES;
}

- (void)downLoadZipToPah:(NSString*)path zipFileUrl:(NSString*)zipUrl appName:(NSString*)appName versionName:(NSString*)versionName
{
    //TODO 校验字符串是否合法
    
    dispatch_queue_t queue = dispatch_get_global_queue(
                                                       DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:zipUrl];
        NSError *error = nil;
        // 2
        NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
        if(!error)
        {
            /*得到要保存zip的路径*/
            NSString *zipPath = [path copy];
            [self createFileDirectories:zipPath];
            /*把zip文件放入路径中*/
            NSString *zipFileName = [zipPath stringByAppendingPathComponent:appName];
            [data writeToFile:zipFileName options:0 error:&error];
            if(!error)
            {
                //解压zip文件
                [SSZipArchive unzipFileAtPath:zipFileName toDestination:zipPath];
                [[GHaierH5Context sharedContext].h5Mapper setValue:@"1" forKey:[NSString stringWithFormat:@"%@%@",appName,versionName]];
                [self saveH5Context];
                [[NSNotificationCenter defaultCenter] postNotificationName:DidDownloadH5Success object:zipUrl];
            }
        }
        
        else
        {
            NSLog(@"Error downloading zip file: %@", error);
        }
    });
}

#pragma mark private methods
- (NSString*)getBaseZipSavePath:(NSString*)appName versionName:(NSString *)versionName
{
    NSString *sandboxPath = NSHomeDirectory();
    NSString *path = [sandboxPath  stringByAppendingPathComponent:@"Library/Caches"];//将Documents
    NSString *zipPath = [path stringByAppendingPathComponent:appName];
    zipPath =  [zipPath stringByAppendingPathComponent:versionName];
    return zipPath;
}

- (void)createFileDirectories:(NSString *)targetPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:targetPath isDirectory:&isDir];
    if (isDirExist) {
        if (isDir) {
            NSLog(@"该文件是一个目录");
        }else{
            NSLog(@"该文件不是目录");
        }
    }else{
        BOOL bCreateDir = [fileManager createDirectoryAtPath:targetPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"Create Audio Directory Failed.");
        }
    }
}
- (void)removeFile:(NSString *)targetPath
{
    // 判断存放音频、视频的文件夹是否存在，不存在则创建对应文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:targetPath isDirectory:&isDir];
    
    if (isDirExist) {
        [fileManager removeItemAtPath:targetPath error:nil];
    }
}

- (void)saveH5Context
{
    [[NSUserDefaults standardUserDefaults] setObject:[GHaierH5Context sharedContext].h5Mapper forKey:H5ContextKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)dealloc
{

}

@end
