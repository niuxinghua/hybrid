//
//  VersionController.m
//  GoHaier
//
//  Created by niuxinghua on 2018/12/26.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "VersionController.h"
#import "H5FilePathManager.h"
#import "H5Downloader.h"
#import "PPNetworkHelper.h"
#import "GHaierH5Context.h"
#import "PatchManager.h"
#import "SSZipArchive.h"
static VersionController *sharedInstance;
NSString* const DidDownloadH5BaseZipSuccess = @"DidDownloadH5BaseZipSuccess";
NSString* const DidDownloadH5PatchSuccess = @"DidDownloadH5PatchSuccess";
NSString *const WidgetUrl = @"http://mobilebackend.qdct-lsb.haier.net/api/v1/getAllAppVersions";
NSString *const AppsUrl = @"http://mobilebackend.qdct-lsb.haier.net/api/v1/getAllAppinfos";
NSString *const DiffsUrl = @"http://mobilebackend.qdct-lsb.haier.net/api/v1/diffs/";
@interface VersionController()
@property(nonatomic,copy)NSString * patchUrl;
@property(nonatomic,copy)NSString * zipUrl;
@end
@implementation VersionController
+(instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super alloc]init];
    });
    
    return sharedInstance;
}
- (void)updataAll
{
    [PPNetworkHelper GET:AppsUrl parameters:nil success:^(id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([[result valueForKey:@"code"] integerValue] == 200) {
            NSArray *results = [result objectForKey:@"result"];
            for (int i=0; i<results.count; i++) {
                NSDictionary *result = results[i];
                [self autoUpateApp:[result objectForKey:@"appId"]];
            }
        }
            
            
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - patch管理
-(void)updateToLatestVersion:(NSString*)appName isSuccess:(VersionUpdateBlcok)updateBlock;
{
    
    
}

- (BOOL)autoUpateApp:(NSString *)appName
{
    if (![PPNetworkHelper isNetwork]) {
        return NO;
    }
    NSString *currentCode = [[GHaierH5Context sharedContext] currentVersionCodeWithAPPname:appName];
     NSString *currentVersionName = [[GHaierH5Context sharedContext] currentVersionNameWithAPPname:appName];
    NSInteger currentVersion = currentCode.integerValue;
    if (currentCode.length == 0 || !currentCode) {
        currentCode = 0;
    }
    //去服务器拉去现在app的所有版本找到最大的版本
    NSDictionary *params = @{@"appId":appName};
    [PPNetworkHelper GET:WidgetUrl parameters:params success:^(id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([[result valueForKey:@"code"] integerValue] == 200) {
            NSArray *results = [result objectForKey:@"result"];
            NSDictionary *bestVersion = [self findHighestVersionCode:results];
            NSInteger bestVersionCode = 0;
            NSString *bestVersionName = @"";
            NSString *bestDownloadUrl = @"";
            if (bestVersion && (![bestVersion isKindOfClass:[NSNull class]])) {
                bestVersionCode = [[bestVersion valueForKey:@"versionCode"] integerValue];
                bestVersionName = [bestVersion valueForKey:@"versionName"];
                bestDownloadUrl = [bestVersion valueForKey:@"downloadUrl"];
            }
            if ((bestVersionCode > currentVersion)) {
                if (currentVersion == 0 || [bestVersion valueForKey:@"isforceupdate"]) {
                    //直接下载bestversion的zip
                    NSString *realVersion = [NSString stringWithFormat:@"%@_%li",bestVersionName,(long)bestVersionCode];
                    NSString *savePath = [[H5FilePathManager sharedInstance] baseZipSavePathwithappName:appName andAppversion:realVersion];
                    [[H5Downloader sharedInstance] downLoadZipFile:bestDownloadUrl toPath:savePath withZipName:appName versionName:bestVersionName versionCode:bestVersionCode resultBlock:^(BOOL issuccess) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (issuccess) {
                                //需要将这个广播发送出去给corewebview重新加载
                                NSDictionary *notificationObject = @{@"appName":appName,@"versionName":bestVersionName,@"versionCode":@(bestVersionCode)};
                                [[NSNotificationCenter defaultCenter] postNotificationName:DidDownloadH5BaseZipSuccess object:notificationObject];
                            }
                            
                        });
                        
                        
                    }];
                    
                }else{
                    //需要下载这个bestversion与currentversion的diff文件，并merge
//                   NSString *patchUrl = DiffsUrl + appName + @"/" + currentVersionName + @"_" + currentCode + @"/" + bestVersionName + @"_" + bestVersionCode;
                    NSString *realCurrent = [NSString stringWithFormat:@"%@_%@",currentVersionName,currentCode];
                    NSString *realTarget = [NSString stringWithFormat:@"%@_%li",bestVersionName,bestVersionCode];
                    NSString *patchUrl = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%li",DiffsUrl ,appName,@"/" ,currentVersionName,@"_",currentCode,@"/", bestVersionName,@"_",bestVersionCode];
                    NSString *path = [[H5FilePathManager sharedInstance] basePatchSavePathwithappName:appName andCurrentversion:[NSString stringWithFormat:@"%@_%@",currentVersionName,currentCode] targetVersion:[NSString stringWithFormat:@"%@_%li",bestVersionName,bestVersionCode]];
                    [[H5Downloader sharedInstance] downLoadPatchFile:patchUrl toPath:path withPatchName:appName CurrentVersion:[NSString stringWithFormat:@"%@_%@",currentVersionName,currentCode] targetVersion:[NSString stringWithFormat:@"%@_%li",bestVersionName,bestVersionCode] resultBlock:^(BOOL issuccess) {
                        if (issuccess) {
                            [self mergeDiffWithCurrentRealversion:realCurrent AndRealTarget:realTarget AppName:appName];
                            [[GHaierH5Context sharedContext]setCurrentVersionCode:[NSString stringWithFormat:@"%li",bestVersionCode] forApp:appName];
                            [[GHaierH5Context sharedContext]setCurrentVersionName:bestVersionName forApp:appName];
                            NSDictionary *notificationObject = @{@"appName":appName,@"versionName":bestVersionName,@"versionCode":@(bestVersionCode)};
                            [[NSNotificationCenter defaultCenter] postNotificationName:DidDownloadH5BaseZipSuccess object:notificationObject];
                        }
                    }];
                    
                    
                }
            }
        }
    } failure:^(NSError *error) {
        
        
    }];
    
    return NO;
    
}
- (void)mergeDiffWithCurrentRealversion:(NSString *)realCurrentVersion AndRealTarget:(NSString *)realTargetVersion AppName:(NSString *)appName
{
    
        NSString *currentZipPath = [[H5FilePathManager sharedInstance] baseZipSavePathwithappName:appName andAppversion:realCurrentVersion];
        currentZipPath = [currentZipPath stringByAppendingPathComponent:appName];
    
        NSString *patchPath = [[H5FilePathManager sharedInstance] basePatchSavePathwithappName:appName andCurrentversion:realCurrentVersion targetVersion:realTargetVersion];
        patchPath = [patchPath stringByAppendingPathComponent:appName];
        [[PatchManager sharedInstance] mergePatch:currentZipPath differFilePath:patchPath appName:appName versionName:realCurrentVersion targetVersion:realTargetVersion mergeResult:^(BOOL result) {
            if (result) {
                //需要将merge的zip替换到新的目录，覆盖这个目录，并将这个zip解压到新的目录更新界面
                NSString *newPath = [[H5FilePathManager sharedInstance] baseZipSavePathwithappName:appName andAppversion:realTargetVersion];
                [[H5FilePathManager sharedInstance]createFileDirectories:newPath isRedo:YES];
                newPath = [newPath stringByAppendingPathComponent:appName];
                NSString *mergedPath = [[H5FilePathManager sharedInstance] baseMergedZipSavePathwithappName:appName andCurrentversion:realCurrentVersion targetVersion:realTargetVersion];
                [[H5FilePathManager sharedInstance] moveFile:[mergedPath stringByAppendingPathComponent:appName] toNewPath:newPath recreate:YES];
                //已经移到zip新的目录，需要解压
                NSString *finalPath = [[H5FilePathManager sharedInstance] baseSavePathwithappName:appName andAppversion:realTargetVersion];
                [SSZipArchive unzipFileAtPath:newPath toDestination:finalPath overwrite:YES password:@"" error:NULL];
              
            }
        }];
    
    
}
- (NSDictionary *)findHighestVersionCode:(NSArray *)results
{
    NSInteger bestVersion = 0;
    NSDictionary *dic;
    for (int i=0; i<results.count; i++) {
        NSDictionary *result = results[i];
        NSInteger versionCode = [[result valueForKey:@"versionCode"] integerValue];
        if (versionCode > bestVersion) {
            bestVersion = versionCode;
            dic = [result copy];
        }
    }
    return dic;
}
@end
