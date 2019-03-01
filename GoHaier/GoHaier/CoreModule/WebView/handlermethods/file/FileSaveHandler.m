//
//  FileSaveHandler.m
//  GoHaier
//
//  Created by niuxinghua on 2019/2/27.
//  Copyright © 2019年 com.haier. All rights reserved.
//

#import "FileSaveHandler.h"
#import "TimeUtils.h"
static FileSaveHandler *sharedInstance;
@implementation FileSaveHandler
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc]init];
    });
    return sharedInstance;
}
- (NSString *)handlerKey
{
    return @"ghaier_saveFile";
}
- (void)handlerMethod:(id)data
{
    NSLog(@"handler key %@ method called",[self handlerKey]);
    NSString *fileName = [TimeUtils currenttimeStaps];
    NSDictionary *dic = (NSDictionary *)data;
    NSString *fileurl = [dic objectForKey:@"tempFilePath"];
    if (fileurl && fileurl.length > 0) {
        NSString *sandboxPath = NSHomeDirectory();
        NSString *path = [sandboxPath  stringByAppendingPathComponent:@"Documents"];//将Documents
        NSString *filePath = [path stringByAppendingPathComponent:@"GoHaier"];
        filePath = [filePath stringByAppendingPathComponent:@"files"];
        NSString *newPath = [filePath stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        [fileManager copyItemAtPath:fileurl toPath:newPath error:&error];
        if (!error) {
            [self respondToWeb:@{@"savedFilePath":newPath}];
        }
    }
}
@end