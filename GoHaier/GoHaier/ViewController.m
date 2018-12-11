//
//  ViewController.m
//  GoHaier
//
//  Created by niuxinghua on 2018/11/23.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "ViewController.h"
#import "HaierCoreWebView.h"
#import "ImagePickerHandler.h"
#import "PhotoTakerHandler.h"
#import "BarCodeRecongnizerHandler.h"
#import "H5Downloader.h"
#import "GHaierH5Context.h"
@interface ViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)HaierCoreWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    _webView = [[HaierCoreWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    
    [self loadHtml];
    [_webView registerNativeHandlers:[ImagePickerHandler sharedInstance]];
    [_webView registerNativeHandlers:[PhotoTakerHandler sharedInstance]];
    [_webView registerNativeHandlers:[BarCodeRecongnizerHandler sharedInstance]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleH5downLoad) name:DidDownloadH5Success object:nil];
    
}


- (void)loadHtml
{
    if ([GHaierH5Context isExitResource:@"GoHaier" appVersion:@"v0.0.1"]) {
        NSString *currentUrl = [[GHaierH5Context sharedContext] getBaseZipSavePath:@"GoHaier" versionName:@"v0.0.1"];
        [[GHaierH5Context sharedContext].h5Mapper setValue:currentUrl forKey:[NSString stringWithFormat:@"%@%@",@"GoHaier",@"v0.0.1"]];
        [self handleH5downLoad];
    }
    else
    {
        NSString *zipUrl = @"https://github.com/niuxinghua/GOHaierHTMLResource/blob/master/GoHaier.zip?raw=true";
        [[H5Downloader sharedInstance] downLoadZipFile:zipUrl fileName:@"GoHaier" unZipToPathwithVersion:@"v0.0.1"];
    }
   
    
    
    
    //    NSString *onlineurl = @"http://10.138.40.223:8081/test/";
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"html"];
    //    NSURL* url = [NSURL  URLWithString:onlineurl];//创建URL
    //    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    //    [_webView loadRequest:request];
    
}

- (void)handleH5downLoad
{
    __weak ViewController *weakSelf = self;
    NSString *urlPath = [[GHaierH5Context sharedContext].h5Mapper objectForKey:[NSString stringWithFormat:@"GoHaierv0.0.1"]];
    NSLog(@"%@",urlPath);
    NSString *indexhtml = [NSString stringWithFormat:@"%@/demo.html",urlPath];
    NSURL* url = [NSURL  URLWithString:indexhtml];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.webView loadRequest:request];
    });
}
@end
