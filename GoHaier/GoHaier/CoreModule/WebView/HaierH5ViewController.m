//
//  HaierH5ViewController.m
//  GoHaier
//
//  Created by niuxinghua on 2019/1/4.
//  Copyright © 2019年 com.haier. All rights reserved.
//

#import "HaierH5ViewController.h"
#import "ViewControllerUtil.h"
#import "UIBarButtonItem+UC.h"
#import "ImagePickerHandler.h"
#import "PhotoTakerHandler.h"
#import "BarCodeRecongnizerHandler.h"
#import "LocationHandler.h"
#import "H5Downloader.h"
#import "GHaierH5Context.h"
#import "PatchManager.h"
#import "H5FilePathManager.h"
#import "SSZipArchive.h"
#import "VersionController.h"
@interface HaierH5ViewController ()
@property(nonatomic,copy)NSString *appName;
@end

@implementation HaierH5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[HaierCoreWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    [self registerHandlers];
    [self loadCurrentVersionPathWithAPPName:_appName];
    
}


#pragma mark - controller methods
+ (BOOL)showContentWithAPPName:(NSString *)appName navigationMode:(BOOL)isnavigation fullScreenMode:(BOOL)isfullScreen animated:(BOOL)animation rootController:(UIViewController *)rootController
{
    NSString *currentVersion = [[GHaierH5Context sharedContext]currentVersionCodeWithAPPname:appName];
    if (!currentVersion || currentVersion.length <= 0) {
        //当前app的资源包还未下载下来
        return NO;
    }
    
    HaierH5ViewController *controlelr = [[HaierH5ViewController alloc]init];
    controlelr.appName = appName;
    if (controlelr) {
        if (isnavigation) {
            if (rootController.navigationController) {
                controlelr.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
                    
                    [rootController.navigationController popViewControllerAnimated:NO];
                    
                }];
                if (isfullScreen) {
                    //如果前端要求导航由前端控制.则直接present的方式弹出controller
                    [rootController presentViewController:controlelr animated:animation completion:^{
                        
                    }];
                }else{
                    [rootController.navigationController pushViewController:controlelr animated:animation];
                }
                return YES;
            }else
            {
                //rootcontroller不是导航控制器，创建一个导航控制器弹出这个controller
                
                UINavigationController *rootContent = [[UINavigationController alloc]initWithRootViewController:controlelr];
                controlelr.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
                    
                    [rootController dismissViewControllerAnimated:animation completion:^{
                        
                    }];
                    
                }];
                [rootController presentViewController:rootContent animated:animation completion:^{
                    
                }];
                return YES;
                
                
                
            }
        }else{
            //非导航方式弹出
            if (!isfullScreen) {
                UINavigationController *rootContent = [[UINavigationController alloc]initWithRootViewController:controlelr];
                controlelr.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
                    
                    [rootController dismissViewControllerAnimated:animation completion:^{
                        
                    }];
                    
                }];
                [rootController presentViewController:rootContent animated:animation completion:^{
                    
                }];
                return YES;
            }else
            {
                //导航交给前端处理
                [rootController presentViewController:controlelr animated:animation completion:^{
                    
                }];
                return YES;
            }
            
        }
        
    }
    return NO;
    
}

#pragma mark webview methods
//将这个注册从webviewy移到控制器，这边的插件应该是从plist拉取的，目前先固定
- (void)registerHandlers
{
    [_webView registerNativeHandlers:[ImagePickerHandler sharedInstance]];
    [_webView registerNativeHandlers:[PhotoTakerHandler sharedInstance]];
    [_webView registerNativeHandlers:[BarCodeRecongnizerHandler sharedInstance]];
    [_webView registerNativeHandlers:[LocationHandler sharedInstance]];
}





- (void)loadHtmlWithPath:(NSString*)path
{
    //    if ([[[GHaierH5Context sharedContext] valueForKey:[NSString stringWithFormat:@"%@-currentVersion",@"Hwork"]] isEqualToString:@"v3"]) {
    //        NSString *finalPath = [[H5FilePathManager sharedInstance] baseSavePathwithappName:@"Hwork" andAppversion:@"v3"];
    //        NSString *index = [[H5FilePathManager sharedInstance] pathForIndexHtmlinFolder:finalPath];
    //        NSLog(@"%@",index);
    //        __weak typeof(self)weakSelf = self;
    //        NSURL* url = [NSURL  URLWithString:index];//创建URL
    //        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            [weakSelf.webView loadRequest:request];
    //        });
    //    }else
    //    {
    //        _zipUrl = @"http://mobilebackend.qdct-lsb.haier.net/api/v1/files/hwork/v1.zip";
    //        NSString *savePath = [[H5FilePathManager sharedInstance] baseZipSavePathwithappName:@"Hwork" andAppversion:@"v1"];
    //        [[H5Downloader sharedInstance] downLoadZipFile:_zipUrl toPath:savePath withZipName:@"Hwork" versionName:@"v1"];
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            [self v1t0v2downLoadPatch];
    //        });
    //    }
    dispatch_async(dispatch_get_main_queue(), ^{
        __weak typeof(self)weakSelf = self;
        NSURL* url = [NSURL  URLWithString:path];//创建URL
        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.webView loadRequest:request];
        });
    });
    
}

- (void)loadCurrentVersionPathWithAPPName:(NSString*)appName
{
    
    NSString *currentVersionName = [[GHaierH5Context sharedContext]currentVersionNameWithAPPname:appName];
    NSString *currentCode = [[GHaierH5Context sharedContext]currentVersionCodeWithAPPname:appName];
    NSString *realVersion = [NSString stringWithFormat:@"%@_%@",currentVersionName,currentCode];
    
    __weak typeof(self)weakSelf = self;
    NSString *urlPath = [[H5FilePathManager sharedInstance] baseSavePathwithappName:appName andAppversion:realVersion];
    NSLog(@"%@",urlPath);
    NSString *indexhtml = [[H5FilePathManager sharedInstance] pathForIndexHtmlinFolder:urlPath];
    NSURL* url = [NSURL  URLWithString:indexhtml];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.webView loadRequest:request];
    });
    
}

//- (void)handleH5downLoad:(NSNotification *)notification
//{
//    NSString *currentV = [NSString stringWithFormat:@"%@-currentVersion",@"Hwork"];
//
//    NSString *currentVersion = [[GHaierH5Context sharedContext]valueForKey:currentV];
//
//    __weak typeof(self)weakSelf = self;
//    NSString *urlPath = [[H5FilePathManager sharedInstance] baseSavePathwithappName:@"Hwork" andAppversion:currentVersion];
//    NSLog(@"%@",urlPath);
//    NSString *indexhtml = [[H5FilePathManager sharedInstance] pathForIndexHtmlinFolder:urlPath];
//    NSURL* url = [NSURL  URLWithString:indexhtml];//创建URL
//    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [weakSelf.webView loadRequest:request];
//    });
//    if ([currentV isEqualToString:@"v1"]) {
//        [self v1t0v2downLoadPatch];
//    }
//    if ([currentVersion isEqualToString:@"v2"]) {
//        [self v2t0v3downLoadPatch];
//    }
//
//
//}
//- (void)handleH5PatchdownLoad:(NSNotification *)notification
//{
//    //merge Patch
//    NSString *currentV = [[GHaierH5Context sharedContext] valueForKey:@"Hwork-currentVersion"];
//    NSLog(@"%@",currentV);
//    if ([currentV isEqualToString:@"v2"]) {
//        [self v2tov3];
//        return;
//    }
//    NSString *currentZipPath = [[H5FilePathManager sharedInstance] baseZipSavePathwithappName:@"Hwork" andAppversion:@"v1"];
//    currentZipPath = [currentZipPath stringByAppendingPathComponent:@"Hwork"];
//
//    NSString *patchPath = [[H5FilePathManager sharedInstance] basePatchSavePathwithappName:@"Hwork" andCurrentversion:@"v1" targetVersion:@"v2"];
//    patchPath = [patchPath stringByAppendingPathComponent:@"Hwork"];
//    //BOOL isSuccess  = [[PatchManager sharedInstance] mergePatch:currentZipPath differFilePath:patchPath appName:@"Hwork" versionName:@"v1" targetVersion:@"v2"];
//    [[PatchManager sharedInstance] mergePatch:currentZipPath differFilePath:patchPath appName:@"Hwork" versionName:@"v1" targetVersion:@"v2" mergeResult:^(BOOL result) {
//        if (result) {
//            //需要将merge的zip替换到新的目录，覆盖这个目录，并将这个zip解压到新的目录更新界面
//            NSString *newPath = [[H5FilePathManager sharedInstance] baseZipSavePathwithappName:@"Hwork" andAppversion:@"v2"];
//            [[H5FilePathManager sharedInstance]createFileDirectories:newPath isRedo:YES];
//            newPath = [newPath stringByAppendingPathComponent:@"Hwork"];
//            NSString *mergedPath = [[H5FilePathManager sharedInstance] baseMergedZipSavePathwithappName:@"Hwork" andCurrentversion:@"v1" targetVersion:@"v2"];
//            [[H5FilePathManager sharedInstance] moveFile:[mergedPath stringByAppendingPathComponent:@"Hwork"] toNewPath:newPath recreate:YES];
//            //已经移到zip新的目录，需要解压
//            NSString *finalPath = [[H5FilePathManager sharedInstance] baseSavePathwithappName:@"Hwork" andAppversion:@"v2"];
//            [SSZipArchive unzipFileAtPath:newPath toDestination:finalPath overwrite:YES password:@"" error:NULL];
//            NSString *index = [[H5FilePathManager sharedInstance] pathForIndexHtmlinFolder:finalPath];
//            NSLog(@"%@",index);
//            __weak typeof(self)weakSelf = self;
//            NSURL* url = [NSURL  URLWithString:index];//创建URL
//            NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf.webView loadRequest:request];
//            });
//            [[GHaierH5Context sharedContext] setObject:@"v2" forKey:[NSString stringWithFormat:@"%@-currentVersion",@"Hwork"]];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self v2t0v3downLoadPatch];
//            });
//        }
//    }];
//
//
//}
//- (void)v2tov3
//{
//    //merge Patch
//    NSString *currentV = [[GHaierH5Context sharedContext] valueForKey:@"Hwork-currentVersion"];
//    NSLog(@"%@",currentV);
//    NSString *currentZipPath = [[H5FilePathManager sharedInstance] baseZipSavePathwithappName:@"Hwork" andAppversion:@"v2"];
//    currentZipPath = [currentZipPath stringByAppendingPathComponent:@"Hwork"];
//
//    NSString *patchPath = [[H5FilePathManager sharedInstance] basePatchSavePathwithappName:@"Hwork" andCurrentversion:@"v2" targetVersion:@"v3"];
//    patchPath = [patchPath stringByAppendingPathComponent:@"Hwork"];
//    // BOOL isSuccess  = [[PatchManager sharedInstance] mergePatch:currentZipPath differFilePath:patchPath appName:@"Hwork" versionName:@"v2" targetVersion:@"v3"];
//    [[PatchManager sharedInstance] mergePatch:currentZipPath differFilePath:patchPath appName:@"Hwork" versionName:@"v2" targetVersion:@"v3" mergeResult:^(BOOL result) {
//        if (result) {
//            //需要将merge的zip替换到新的目录，覆盖这个目录，并将这个zip解压到新的目录更新界面
//            NSString *newPath = [[H5FilePathManager sharedInstance] baseZipSavePathwithappName:@"Hwork" andAppversion:@"v3"];
//            [[H5FilePathManager sharedInstance]createFileDirectories:newPath isRedo:YES];
//            newPath = [newPath stringByAppendingPathComponent:@"Hwork"];
//            NSString *mergedPath = [[H5FilePathManager sharedInstance] baseMergedZipSavePathwithappName:@"Hwork" andCurrentversion:@"v2" targetVersion:@"v3"];
//            [[H5FilePathManager sharedInstance] moveFile:[mergedPath stringByAppendingPathComponent:@"Hwork"] toNewPath:newPath recreate:YES];
//            //已经移到zip新的目录，需要解压
//            NSString *finalPath = [[H5FilePathManager sharedInstance] baseSavePathwithappName:@"Hwork" andAppversion:@"v3"];
//            [SSZipArchive unzipFileAtPath:newPath toDestination:finalPath overwrite:YES password:@"" error:NULL];
//            NSString *index = [[H5FilePathManager sharedInstance] pathForIndexHtmlinFolder:finalPath];
//            NSLog(@"%@",index);
//            __weak typeof(self)weakSelf = self;
//            NSURL* url = [NSURL  URLWithString:index];//创建URL
//            NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf.webView loadRequest:request];
//            });
//            [[GHaierH5Context sharedContext] setObject:@"v3" forKey:[NSString stringWithFormat:@"%@-currentVersion",@"Hwork"]];
//        }
//    }];
//
//}
//




- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"webview dealloc");
}

@end
