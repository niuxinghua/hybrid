//
//  SingleWebviewViewController.m
//  GoHaier
//
//  Created by niuxinghua on 2019/3/27.
//  Copyright © 2019年 com.haier. All rights reserved.
//

#import "SingleWebviewViewController.h"
#import "UIBarButtonItem+UC.h"
#import "ViewControllerUtil.h"
@interface SingleWebviewViewController ()
@end

@implementation SingleWebviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
}
- (void)loadUrl:(NSString *)url
{

    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];

}
+ (BOOL)showSelfWith:(NSString *)url
{

    SingleWebviewViewController *controlelr = [[SingleWebviewViewController alloc] init];
    __block UIViewController *rootController = [[ViewControllerUtil sharedInstance] topViewController];
    UINavigationController *rootContent = [[UINavigationController alloc]initWithRootViewController:controlelr];
    
    controlelr.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        //处理webview回退的关系
        if (controlelr.webView.canGoBack) {
            [controlelr.webView goBack];
            return;
        }
        [rootController dismissViewControllerAnimated:NO completion:^{
            
        }];
        
    }];
    [rootController presentViewController:rootContent animated:NO completion:^{
        [controlelr.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }];
    return YES;
    
}


@end
