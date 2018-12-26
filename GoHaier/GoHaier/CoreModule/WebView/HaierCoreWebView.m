//
//  HaierCoreWebView.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/11/21.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "HaierCoreWebView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "H5Downloader.h"
#import "ImagePickerHandler.h"
#import "PhotoTakerHandler.h"
#import "BarCodeRecongnizerHandler.h"
#import "LocationHandler.h"
@interface HaierCoreWebView()
@end
@implementation HaierCoreWebView
- (instancetype)init
{
    if(self = [super init])
    {
        self.bridge = [WebViewJavascriptBridge bridgeForWebView:self handler:^(id data, WVJBResponseCallback responseCallback) {
            
        }];
        self.dataDetectorTypes = UIDataDetectorTypeAll;//自动检测网页上的电话号码,网页链接,邮箱;
        [self initweblogToNative];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleH5downLoad) name:DidDownloadH5BaseZipSuccess object:nil];
        [self registerHandlers];
    }
    
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.bridge = [WebViewJavascriptBridge bridgeForWebView:self webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
            
        }];
        self.dataDetectorTypes = UIDataDetectorTypeAll;//自动检测网页上的电话号码,网页链接,邮箱;
        [self initweblogToNative];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleH5downLoad) name:DidDownloadH5BaseZipSuccess object:nil];
        [self registerHandlers];

    }
    return self;
}
- (void)weblogToNative:(NSString *)showlog
{
    NSLog(@">>>> webview log : %@ <<<<", showlog);
    
}

- (void)initweblogToNative
{
    JSContext *ctx = [self valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    ctx[@"console"][@"log"] = ^(JSValue * msg) {
        NSLog(@">>>> webview log : %@ <<<<", msg);
    };
    ctx[@"console"][@"warn"] = ^(JSValue * msg) {
        NSLog(@">>>> webview warn : %@ <<<<", msg);
    };
    ctx[@"console"][@"error"] = ^(JSValue * msg) {
        NSLog(@">>>> webview error : %@ <<<<", msg);
    };
    
    
}
#pragma mark getters
- (NSArray *)handlerKeys
{
    if (!_handlerKeys) {
        _handlerKeys = [[NSArray alloc]init];
    }
    return _handlerKeys;
}
- (NSMutableDictionary *)handlerCallBacks
{
    if (!_handlerCallBacks) {
        _handlerCallBacks = [[NSMutableDictionary alloc]init];
    }
    return _handlerCallBacks;
}
- (void)registerHandlers
{
    [self registerNativeHandlers:[ImagePickerHandler sharedInstance]];
    [self registerNativeHandlers:[PhotoTakerHandler sharedInstance]];
    [self registerNativeHandlers:[BarCodeRecongnizerHandler sharedInstance]];
    [self registerNativeHandlers:[LocationHandler sharedInstance]];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - methods
- (BOOL)registerNativeHandlers:(BaseHandler *) handler;
{
    NSString *handlerKey  = [handler handlerKey];
    if (!handlerKey || [handlerKey isEqualToString:@""]) {
        NSLog(@"handlerkey error null or empty");
        return NO;
    }
    if ([self.handlerKeys containsObject: handlerKey]) {
        NSLog(@"handlerkey error repeated");
        return NO;
    }
    __weak typeof(self) weakSelf = self;
    [self.bridge registerHandler:handlerKey handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf.handlerCallBacks setObject:responseCallback forKey:handlerKey];
        [handler handlerMethod];
    }];
    handler.webCallBack = ^(id data) {
        [weakSelf respondToWeb:data withHandlerKey:handlerKey];
    };
    return YES;
}
- (BOOL)respondToWeb:(id) responseData withHandlerKey:(NSString *)handlerKey
{
    WVJBResponseCallback callBack = [_handlerCallBacks objectForKey:handlerKey];
    if (callBack) {
        callBack(responseData);
        return YES;
    }
    return NO;
}
- (void)handleH5downLoad
{
 //h5下载完成
    
}


@end
