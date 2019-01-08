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
static VersionController *sharedInstance;
NSString* const DidDownloadH5BaseZipSuccess = @"DidDownloadH5BaseZipSuccess";
NSString* const DidDownloadH5PatchSuccess = @"DidDownloadH5PatchSuccess";
NSString *const WidgetUrl = @"http://mobilebackend.qdct-lsb.haier.net/api/v1/getAllAppVersions";
NSString *const AppsUrl = @"http://mobilebackend.qdct-lsb.haier.net/api/v1/getAllAppinfos";
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
#pragma mark - patch管理
-(void)updateToLatestVersion:(NSString*)appName isSuccess:(VersionUpdateBlcok)updateBlock;
{
    
    
}
- (void)v2t0v3downLoadPatch
{
    _patchUrl = @"http://mobilebackend.qdct-lsb.haier.net/api/v1/diffs/hwork/v2/v3";
    NSString *path = [[H5FilePathManager sharedInstance] basePatchSavePathwithappName:@"Hwork" andCurrentversion:@"v2" targetVersion:@"v3"];
    [[H5Downloader sharedInstance] downLoadPatchFile:_patchUrl toPath:path withPatchName:@"Hwork" CurrentVersion:@"v2" targetVersion:@"v3"];
    
}
- (void)v1t0v2downLoadPatch
{
    _patchUrl = @"http://mobilebackend.qdct-lsb.haier.net/api/v1/diffs/hwork/v1/v2";
    NSString *path = [[H5FilePathManager sharedInstance] basePatchSavePathwithappName:@"Hwork" andCurrentversion:@"v1" targetVersion:@"v2"];
    [[H5Downloader sharedInstance] downLoadPatchFile:_patchUrl toPath:path withPatchName:@"Hwork" CurrentVersion:@"v1" targetVersion:@"v2"];
    
}
- (BOOL)autoUpateApp:(NSString *)appName
{
    if (![PPNetworkHelper isNetwork]) {
        return NO;
    }
    NSString *currentCode = [[GHaierH5Context sharedContext] currentVersionCodeWithAPPname:appName];
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
                if (currentVersion == 0) {
                    //直接下载bestversion的zip
                    NSString *realVersion = [NSString stringWithFormat:@"%@_%li",bestVersionName,(long)bestVersionCode];
                    NSString *savePath = [[H5FilePathManager sharedInstance] baseZipSavePathwithappName:appName andAppversion:realVersion];
                    [[H5Downloader sharedInstance] downLoadZipFile:bestDownloadUrl toPath:savePath withZipName:appName versionName:bestVersionName versionCode:bestVersionCode resultBlock:^(BOOL issuccess) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //
                            if (issuccess) {
                                //需要将这个广播发送出去给corewebview重新加载
                                NSDictionary *notificationObject = @{@"appName":appName,@"versionName":bestVersionName,@"versionCode":@(bestVersionCode)};
                                [[NSNotificationCenter defaultCenter] postNotificationName:DidDownloadH5BaseZipSuccess object:notificationObject];
                            }
                            
                        });
                        
                        
                    }];
                    
                    
                    
                    
                    
                }else{
                    //需要下载这个bestversion与currentversion的diff文件，并merge
                    
                }
            }
        }
    } failure:^(NSError *error) {
        
        
    }];
    
    return NO;
    
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
