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

- (void)downLoadPatch
{
    _patchUrl = @"https://github.com/niuxinghua/GOHaierHTMLResource/blob/master/diff_GoHaier?raw=true";
    NSString *path = [[H5FilePathManager sharedInstance] basePatchSavePathwithappName:@"Hwork" andCurrentversion:@"v0.0.1" targetVersion:@"v0.0.2"];
    [[H5Downloader sharedInstance] downLoadPatchFile:_patchUrl toPath:path withPatchName:@"Hwork" CurrentVersion:@"v0.0.1" targetVersion:@"v0.0.2"];
    
}
- (void)loadHtml
{
//    if ([GHaierH5Context isExitResource:@"GoHaier" appVersion:@"v0.0.1PATCHVERSIONDIDAPPLY"]) {
//        __weak ViewController *weakSelf = self;
//        NSString *urlPath = [[GHaierH5Context sharedContext] getBaseZipSavePath:@"GoHaier" versionName:@"v0.0.1"];
//        NSLog(@"%@",urlPath);
//        NSString *indexhtml = [NSString stringWithFormat:@"%@/%@/demo.html",urlPath,@"GoHaier"];
//        NSURL* url = [NSURL  URLWithString:indexhtml];//创建URL
//        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf.webView loadRequest:request];
//        });
//    }
//   else if ([GHaierH5Context isExitResource:@"GoHaier" appVersion:@"v0.0.1"]) {
//        __weak ViewController *weakSelf = self;
//        NSString *urlPath = [[GHaierH5Context sharedContext] getBaseZipSavePath:@"GoHaier" versionName:@"v0.0.1"];
//        NSLog(@"%@",urlPath);
//        NSString *indexhtml = [NSString stringWithFormat:@"%@/demo.html",urlPath];
//        NSURL* url = [NSURL  URLWithString:indexhtml];//创建URL
//        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf.webView loadRequest:request];
//        });
//        [self downLoadPatch];
//    }
//    else
//    {
        _zipUrl = @"https://github.com/niuxinghua/GOHaierHTMLResource/blob/master/GoHaier.zip?raw=true";
        NSString *savePath = [[H5FilePathManager sharedInstance] baseZipSavePathwithappName:@"Hwork" andAppversion:@"v0.0.1"];
        [[H5Downloader sharedInstance] downLoadZipFile:_zipUrl toPath:savePath withZipName:@"Hwork" versionName:@"v0.0.1"];
    //}

    
    
    
//        NSString *onlineurl = @"http://10.138.40.223:8081/test/";
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"html"];
//        NSURL* url = [NSURL  URLWithString:path];//创建URL
//        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
//        [_webView loadRequest:request];
    
}

- (void)handleH5downLoad:(NSNotification *)notification
{
    __weak typeof(self)weakSelf = self;
        NSString *urlPath = [[H5FilePathManager sharedInstance] baseSavePathwithappName:@"Hwork" andAppversion:@"v0.0.1"];
        NSLog(@"%@",urlPath);
        NSString *indexhtml = [NSString stringWithFormat:@"%@/demo.html",urlPath];
        NSURL* url = [NSURL  URLWithString:indexhtml];//创建URL
        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.webView loadRequest:request];
        });
        [self downLoadPatch];
   

}
- (void)handleH5PatchdownLoad:(NSNotification *)notification
{
    //merge Patch
    NSString *currentV = [[GHaierH5Context sharedContext] valueForKey:@"Hwork-currentVersion"];
    NSLog(@"%@",currentV);
    NSString *targetVersion = @"v0.0.2";
    NSString *currentZipPath = [[H5FilePathManager sharedInstance] baseZipSavePathwithappName:@"Hwork" andAppversion:@"v0.0.1"];
    currentZipPath = [currentZipPath stringByAppendingPathComponent:@"Hwork"];
    
      NSString *patchPath = [[H5FilePathManager sharedInstance] basePatchSavePathwithappName:@"Hwork" andCurrentversion:@"v0.0.1" targetVersion:@"v0.0.2"];
    patchPath = [patchPath stringByAppendingPathComponent:@"Hwork"];
  BOOL isSuccess  = [[PatchManager sharedInstance] mergePatch:currentZipPath differFilePath:patchPath appName:@"Hwork" versionName:@"v0.0.1" targetVersion:@"v0.0.2"];
    if (isSuccess) {
        //需要将merge的zip替换到新的目录，覆盖这个目录，并将这个zip解压到新的目录更新界面
        
        
        
    }
    
}


@end
