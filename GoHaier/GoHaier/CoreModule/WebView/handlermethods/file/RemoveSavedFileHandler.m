//
//  RemoveSavedFileHandler.m
//  GoHaier
//
//  Created by niuxinghua on 2019/2/27.
//  Copyright © 2019年 com.haier. All rights reserved.
//

#import "RemoveSavedFileHandler.h"
static RemoveSavedFileHandler *sharedInstance;
@implementation RemoveSavedFileHandler
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
    return @"ghaier_removeSavedFile";
}
- (void)handlerMethod:(id)data
{
    NSLog(@"handler key %@ method called",[self handlerKey]);
    NSDictionary *dic = (NSDictionary *)data;
    NSString *fileurl = [dic objectForKey:@"filePath"];
    if (fileurl && fileurl.length > 0) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        [fileManager removeItemAtPath:fileurl error:&error];
        if (!error) {
            [self respondToWeb:@{@"deletedFilePath":fileurl}];
        }
    }
}
@end
