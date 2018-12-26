//
//  H5FilePathManager.m
//  GoHaier
//
//  Created by niuxinghua on 2018/12/26.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "H5FilePathManager.h"
static H5FilePathManager *instance = nil;
@implementation H5FilePathManager
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc]init];
    });
    
    return instance;
}
#pragma mark private methods
- (NSString*)getBaseZipSavePath:(NSString*)appName versionName:(NSString *)versionName
{
    NSString *sandboxPath = NSHomeDirectory();
    NSString *path = [sandboxPath  stringByAppendingPathComponent:@"Library/Caches"];//将Documents
    NSString *zipPath = [path stringByAppendingPathComponent:@"GoHaier"];
    zipPath = [zipPath stringByAppendingPathComponent:@"zips"];
    zipPath = [zipPath stringByAppendingPathComponent:appName];
    zipPath =  [zipPath stringByAppendingPathComponent:versionName];
    return zipPath;
}
- (NSString *)getBaseSavePath:(NSString *)appName versionName:(NSString *)versionName
{
    NSString *sandboxPath = NSHomeDirectory();
    NSString *path = [sandboxPath  stringByAppendingPathComponent:@"Library/Caches"];//将Documents
    NSString *zipPath = [path stringByAppendingPathComponent:@"GoHaier"];
    zipPath = [zipPath stringByAppendingPathComponent:appName];
    zipPath =  [zipPath stringByAppendingPathComponent:versionName];
    return zipPath;
}
- (NSString*)getPatchSavePath:(NSString*)appName currentversionName:(NSString *)versionName targetVersionName:(NSString *)targetVersion
{
    NSString *sandboxPath = NSHomeDirectory();
    NSString *path = [sandboxPath  stringByAppendingPathComponent:@"Library/Caches"];//将Documents
    NSString *zipPath = [path stringByAppendingPathComponent:@"GoHaier"];
    zipPath = [zipPath stringByAppendingPathComponent:@"Patchs"];
    zipPath = [zipPath stringByAppendingPathComponent:appName];
    NSString *patchFolder = [NSString stringWithFormat:@"%@-%@",versionName,targetVersion];
    zipPath =  [zipPath stringByAppendingPathComponent:patchFolder];
    return zipPath;
}

- (void)createFileDirectories:(NSString *)targetPath isRedo:(BOOL)redo
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:targetPath isDirectory:&isDir];
    if (isDirExist) {
        if (isDir) {
            NSLog(@"该文件是一个目录");
            if (redo) {
                
                NSArray *contents = [fileManager contentsOfDirectoryAtPath:targetPath error:NULL];
                NSEnumerator *e = [contents objectEnumerator];
                NSString *filename;
                while ((filename = [e nextObject])) {
                    [fileManager removeItemAtPath:[targetPath stringByAppendingPathComponent:filename] error:NULL];
                }
            }
            
        }else{
            NSLog(@"该文件不是目录");
            if (redo) {
                [fileManager removeItemAtPath:targetPath error:NULL];
            }
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


- (NSString *)baseZipSavePathwithappName:(NSString*)appName andAppversion:(NSString*)appVersion
{
    return [self getBaseZipSavePath:appName versionName:appVersion];
}
- (NSString *)baseSavePathwithappName:(NSString*)appName andAppversion:(NSString*)appVersion
{
    return [self getBaseSavePath:appName versionName:appVersion];
}
- (NSString *)basePatchSavePathwithappName:(NSString*)appName andCurrentversion:(NSString*)appVersion targetVersion:(NSString *)targetVersion
{
    return [self getPatchSavePath:appName currentversionName:appVersion targetVersionName:targetVersion];
}

@end
