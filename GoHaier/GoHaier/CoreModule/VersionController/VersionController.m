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
static VersionController *sharedInstance;
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
@end
