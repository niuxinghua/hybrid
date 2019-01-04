//
//  ViewController.m
//  GoHaier
//
//  Created by niuxinghua on 2018/11/23.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "ViewController.h"
#import "HaierCoreWebView.h"
#import "H5Downloader.h"
#import "GHaierH5Context.h"
#import "PatchManager.h"
#import "H5FilePathManager.h"
#import "SSZipArchive.h"
@interface ViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)HaierCoreWebView *webView;
@property(nonatomic,copy)NSString * patchUrl;
@property(nonatomic,copy)NSString * zipUrl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    _webView = [[HaierCoreWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    
    [self loadHtml];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleH5downLoad:) name:DidDownloadH5BaseZipSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleH5PatchdownLoad:) name:DidDownloadH5PatchSuccess object:nil];

    
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
- (void)loadHtml
{
    if ([[[GHaierH5Context sharedContext] valueForKey:[NSString stringWithFormat:@"%@-currentVersion",@"Hwork"]] isEqualToString:@"v3"]) {
        NSString *finalPath = [[H5FilePathManager sharedInstance] baseSavePathwithappName:@"Hwork" andAppversion:@"v3"];
        NSString *index = [[H5FilePathManager sharedInstance] pathForIndexHtmlinFolder:finalPath];
        NSLog(@"%@",index);
        __weak typeof(self)weakSelf = self;
        NSURL* url = [NSURL  URLWithString:index];//创建URL
        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.webView loadRequest:request];
        });
    }else
    {
        _zipUrl = @"http://mobilebackend.qdct-lsb.haier.net/api/v1/files/hwork/v1.zip";
        NSString *savePath = [[H5FilePathManager sharedInstance] baseZipSavePathwithappName:@"Hwork" andAppversion:@"v1"];
        [[H5Downloader sharedInstance] downLoadZipFile:_zipUrl toPath:savePath withZipName:@"Hwork" versionName:@"v1"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self v1t0v2downLoadPatch];
        });
    }

}

- (void)handleH5downLoad:(NSNotification *)notification
{
    NSString *currentV = [NSString stringWithFormat:@"%@-currentVersion",@"Hwork"];

    NSString *currentVersion = [[GHaierH5Context sharedContext]valueForKey:currentV];

    __weak typeof(self)weakSelf = self;
        NSString *urlPath = [[H5FilePathManager sharedInstance] baseSavePathwithappName:@"Hwork" andAppversion:currentVersion];
        NSLog(@"%@",urlPath);
        NSString *indexhtml = [[H5FilePathManager sharedInstance] pathForIndexHtmlinFolder:urlPath];
        NSURL* url = [NSURL  URLWithString:indexhtml];//创建URL
        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.webView loadRequest:request];
        });
    if ([currentV isEqualToString:@"v1"]) {
        [self v1t0v2downLoadPatch];
    }
    if ([currentVersion isEqualToString:@"v2"]) {
        [self v2t0v3downLoadPatch];
    }
   

}
- (void)handleH5PatchdownLoad:(NSNotification *)notification
{
    //merge Patch
    NSString *currentV = [[GHaierH5Context sharedContext] valueForKey:@"Hwork-currentVersion"];
    NSLog(@"%@",currentV);
    if ([currentV isEqualToString:@"v2"]) {
        [self v2tov3];
        return;
    }
    NSString *currentZipPath = [[H5FilePathManager sharedInstance] baseZipSavePathwithappName:@"Hwork" andAppversion:@"v1"];
    currentZipPath = [currentZipPath stringByAppendingPathComponent:@"Hwork"];
    
      NSString *patchPath = [[H5FilePathManager sharedInstance] basePatchSavePathwithappName:@"Hwork" andCurrentversion:@"v1" targetVersion:@"v2"];
    patchPath = [patchPath stringByAppendingPathComponent:@"Hwork"];
  //BOOL isSuccess  = [[PatchManager sharedInstance] mergePatch:currentZipPath differFilePath:patchPath appName:@"Hwork" versionName:@"v1" targetVersion:@"v2"];
    [[PatchManager sharedInstance] mergePatch:currentZipPath differFilePath:patchPath appName:@"Hwork" versionName:@"v1" targetVersion:@"v2" mergeResult:^(BOOL result) {
        if (result) {
            //需要将merge的zip替换到新的目录，覆盖这个目录，并将这个zip解压到新的目录更新界面
            NSString *newPath = [[H5FilePathManager sharedInstance] baseZipSavePathwithappName:@"Hwork" andAppversion:@"v2"];
            [[H5FilePathManager sharedInstance]createFileDirectories:newPath isRedo:YES];
            newPath = [newPath stringByAppendingPathComponent:@"Hwork"];
            NSString *mergedPath = [[H5FilePathManager sharedInstance] baseMergedZipSavePathwithappName:@"Hwork" andCurrentversion:@"v1" targetVersion:@"v2"];
            [[H5FilePathManager sharedInstance] moveFile:[mergedPath stringByAppendingPathComponent:@"Hwork"] toNewPath:newPath recreate:YES];
            //已经移到zip新的目录，需要解压
            NSString *finalPath = [[H5FilePathManager sharedInstance] baseSavePathwithappName:@"Hwork" andAppversion:@"v2"];
            [SSZipArchive unzipFileAtPath:newPath toDestination:finalPath overwrite:YES password:@"" error:NULL];
            NSString *index = [[H5FilePathManager sharedInstance] pathForIndexHtmlinFolder:finalPath];
            NSLog(@"%@",index);
            __weak typeof(self)weakSelf = self;
            NSURL* url = [NSURL  URLWithString:index];//创建URL
            NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.webView loadRequest:request];
            });
            [[GHaierH5Context sharedContext] setObject:@"v2" forKey:[NSString stringWithFormat:@"%@-currentVersion",@"Hwork"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self v2t0v3downLoadPatch];
            });
        }
    }];
    
    
}
- (void)v2tov3
{
    //merge Patch
    NSString *currentV = [[GHaierH5Context sharedContext] valueForKey:@"Hwork-currentVersion"];
    NSLog(@"%@",currentV);
    NSString *currentZipPath = [[H5FilePathManager sharedInstance] baseZipSavePathwithappName:@"Hwork" andAppversion:@"v2"];
    currentZipPath = [currentZipPath stringByAppendingPathComponent:@"Hwork"];
    
    NSString *patchPath = [[H5FilePathManager sharedInstance] basePatchSavePathwithappName:@"Hwork" andCurrentversion:@"v2" targetVersion:@"v3"];
    patchPath = [patchPath stringByAppendingPathComponent:@"Hwork"];
   // BOOL isSuccess  = [[PatchManager sharedInstance] mergePatch:currentZipPath differFilePath:patchPath appName:@"Hwork" versionName:@"v2" targetVersion:@"v3"];
    [[PatchManager sharedInstance] mergePatch:currentZipPath differFilePath:patchPath appName:@"Hwork" versionName:@"v2" targetVersion:@"v3" mergeResult:^(BOOL result) {
        if (result) {
            //需要将merge的zip替换到新的目录，覆盖这个目录，并将这个zip解压到新的目录更新界面
            NSString *newPath = [[H5FilePathManager sharedInstance] baseZipSavePathwithappName:@"Hwork" andAppversion:@"v3"];
            [[H5FilePathManager sharedInstance]createFileDirectories:newPath isRedo:YES];
            newPath = [newPath stringByAppendingPathComponent:@"Hwork"];
            NSString *mergedPath = [[H5FilePathManager sharedInstance] baseMergedZipSavePathwithappName:@"Hwork" andCurrentversion:@"v2" targetVersion:@"v3"];
            [[H5FilePathManager sharedInstance] moveFile:[mergedPath stringByAppendingPathComponent:@"Hwork"] toNewPath:newPath recreate:YES];
            //已经移到zip新的目录，需要解压
            NSString *finalPath = [[H5FilePathManager sharedInstance] baseSavePathwithappName:@"Hwork" andAppversion:@"v3"];
            [SSZipArchive unzipFileAtPath:newPath toDestination:finalPath overwrite:YES password:@"" error:NULL];
            NSString *index = [[H5FilePathManager sharedInstance] pathForIndexHtmlinFolder:finalPath];
            NSLog(@"%@",index);
            __weak typeof(self)weakSelf = self;
            NSURL* url = [NSURL  URLWithString:index];//创建URL
            NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.webView loadRequest:request];
            });
            [[GHaierH5Context sharedContext] setObject:@"v3" forKey:[NSString stringWithFormat:@"%@-currentVersion",@"Hwork"]];
        }
    }];
    
}


@end
