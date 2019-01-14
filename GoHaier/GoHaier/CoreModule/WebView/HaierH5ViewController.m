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
    _webView.scrollView.scrollEnabled = NO;
    [self.view addSubview:_webView];
    [self registerHandlers];
    [self loadCurrentVersionPathWithAPPName:_appName];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWebview:) name:DidDownloadH5BaseZipSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWebview:) name:DidDownloadH5PatchSuccess object:nil];

}


- (void)refreshWebview:(NSNotification *)notification
{
    NSDictionary *dic = notification.object;
    if ([[dic objectForKey:@"appName"] isEqualToString:_appName]) {
        [self loadCurrentVersionPathWithAPPName:_appName];
    }
    
    
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
    NSURL* url = [NSURL  URLWithString:indexhtml];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.webView loadRequest:request];
    });
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"webview dealloc");
}

@end
