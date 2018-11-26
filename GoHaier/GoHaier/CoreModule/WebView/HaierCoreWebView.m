//
//  HaierCoreWebView.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/11/21.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "HaierCoreWebView.h"
@implementation HaierCoreWebView
- (instancetype)init
{
    if(self = [super init])
    {
        self.bridge = [WebViewJavascriptBridge bridgeForWebView:self handler:^(id data, WVJBResponseCallback responseCallback) {
            
        }];

    }
    
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.bridge = [WebViewJavascriptBridge bridgeForWebView:self handler:^(id data, WVJBResponseCallback responseCallback) {
           
        }];
       
    }
    return self;
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
    [self.bridge registerHandler:handlerKey handler:^(id data, WVJBResponseCallback responseCallback) {
        [self.handlerCallBacks setObject:responseCallback forKey:handlerKey];
        [handler handlerMethod];
    }];
    __weak typeof(HaierCoreWebView) *weakSelf = self;
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

@end
