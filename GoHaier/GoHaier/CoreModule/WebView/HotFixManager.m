//
//  HotFixManager.m
//  GoHaier
//
//  Created by niuxinghua on 2019/3/22.
//  Copyright © 2019年 com.haier. All rights reserved.
//

#import "HotFixManager.h"
#import <BuglyHotfix/Bugly.h>
#import <BuglyHotfix/BuglyMender.h>
#import "JPEngine.h"
@interface HotFixManager()<BuglyDelegate>
{
    
}

@end
static HotFixManager *sharedInstance;
@implementation HotFixManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super alloc] init];
    });
    return sharedInstance;
}
- (void)setUp
{
    
    //初始化 Bugly 异常上报
    BuglyConfig *config = [[BuglyConfig alloc] init];
    config.delegate = self;
    config.debugMode = YES;
    config.reportLogLevel = BuglyLogLevelInfo;
    [Bugly startWithAppId:@"dcc5eaab25" developmentDevice:YES config:config];
    
    //捕获 JSPatch 异常并上报
    [JPEngine handleException:^(NSString *msg) {
        NSException *jspatchException = [NSException exceptionWithName:@"Hotfix Exception" reason:msg userInfo:nil];
        [Bugly reportException:jspatchException];
    }];
    //检测补丁策略
    [[BuglyMender sharedMender] checkRemoteConfigWithEventHandler:^(BuglyHotfixEvent event, NSDictionary *patchInfo) {
        //有新补丁或本地补丁状态正常
        if (event == BuglyHotfixEventPatchValid || event == BuglyHotfixEventNewPatch) {
            //获取本地补丁路径
            NSString *patchDirectory = [[BuglyMender sharedMender] patchDirectory];
            if (patchDirectory) {
                //指定执行的 js 脚本文件名
                NSString *patchFileName = @"main.js";
                NSString *patchFile = [patchDirectory stringByAppendingPathComponent:patchFileName];
                //执行补丁加载并上报激活状态
                if ([[NSFileManager defaultManager] fileExistsAtPath:patchFile] &&
                    [JPEngine evaluateScriptWithPath:patchFile] != nil) {
                    BLYLogInfo(@"evaluateScript success");
                    [[BuglyMender sharedMender] reportPatchStatus:BuglyHotfixPatchStatusActiveSucess];
                }else {
                    BLYLogInfo(@"evaluateScript failed");
                    [[BuglyMender sharedMender] reportPatchStatus:BuglyHotfixPatchStatusActiveFail];
                }
            }
        }
    }];
}
@end
