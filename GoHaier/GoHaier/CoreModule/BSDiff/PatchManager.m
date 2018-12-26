//
//  PatchManaer.m
//  GoHaier
//
//  Created by niuxinghua on 2018/12/11.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "PatchManager.h"
#import "Haier_Bsdiff.h"
#import "GHaierH5Context.h"
#import "SSZipArchive.h"
#import "H5Downloader.h"
#import "H5FilePathManager.h"
static NSString* const PATCHVERSIONDIDAPPLY = @"PATCHVERSIONDIDAPPLY";
static PatchManager * sharedInstance = nil;
@implementation PatchManager
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PatchManager alloc]init];
    });
    return sharedInstance;
}
- (BOOL)mergePatch:(NSString *)oldFilePath differFilePath:(NSString*)differFilePath appName:(NSString*)appName versionName:(NSString*)versionName
{
    
    const char *argv[4];
    argv[0] = "bspatch";
    // oldPath
    argv[1] = [oldFilePath UTF8String];
    // newPath
//    argv[2] = [[[H5FilePathManager sharedInstance] createFileWithFileName:@"Haier_Result.zip" appName:@"GoHaierPatch" versionName:versionName] UTF8String];
//    // patchPath
//    argv[3] = [differFilePath UTF8String];
//    int result = BsdiffUntils_bspatch(4, argv);
//   [self deleteFolder:[[H5Downloader sharedInstance] getBaseZipSavePath:appName]];
//    NSString *patchLastZIPFile = [NSString stringWithFormat:@"%@/%@",[[GHaierH5Context sharedContext] getBaseZipSavePath:@"GoHaierPatch" versionName:versionName],@"Haier_Result.zip"];
//    [self doSaveAndUnzipLastPatchToPath:[[GHaierH5Context sharedContext] getBaseZipSavePath:appName versionName:versionName] appName:appName zipUrl:patchLastZIPFile versionName:versionName];

    return YES;
}
- (void)doSaveAndUnzipLastPatchToPath:(NSString *)path appName:(NSString *)appName zipUrl:(NSString *)zipUrl versionName:(NSString *)versionName
{
    [SSZipArchive unzipFileAtPath:zipUrl toDestination:path];
    [[GHaierH5Context sharedContext].h5Mapper setValue:@"1" forKey:[NSString stringWithFormat:@"%@%@%@",appName,versionName,PATCHVERSIONDIDAPPLY]];
    [self saveH5Context];
}

//-(NSString *)createFileWithFileName:(NSString *)fileName appName:(NSString*)appName versionName:(NSString*)versionName
//{
// NSString* filePath = [[GHaierH5Context sharedContext] getBaseZipSavePath:appName versionName:versionName];
//    filePath = [filePath stringByAppendingPathComponent:fileName];
//    [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
//    return filePath;
//}
- (void)deleteFolder:(NSString *)filePath
{
    NSError *error;
      [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
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

@end