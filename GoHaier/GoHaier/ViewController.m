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
#import "HaierH5ViewController.h"
#import "VersionController.h"
@interface ViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)HaierCoreWebView *webView;
@property(nonatomic,copy)NSString * patchUrl;
@property(nonatomic,copy)NSString * zipUrl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(50, 200, 100, 40)];
    [self.view addSubview:btn];
    [btn setTitle:@"跳到mintui" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showContent) forControlEvents:UIControlEventTouchUpInside];
   // [[VersionController sharedInstance] autoUpateApp:@"hwork"];
}

- (void)showContent
{
    [HaierH5ViewController showContentWithAPPName:@"mintui" navigationMode:YES fullScreenMode:NO animated:YES titleName:@"mintui" rootController:self pageName:@"index.html"];
}


@end
