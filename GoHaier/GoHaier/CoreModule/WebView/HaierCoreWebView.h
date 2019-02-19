//
//  HaierCoreWebView.h
//  IntelligentLock
//
//  Created by niuxinghua on 2018/11/21.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridge.h"
#import "BaseHandler.h"
typedef void (^HandlerBlock)(void);
@interface HaierCoreWebView : UIWebView<UIWebViewDelegate>
@property WebViewJavascriptBridge* bridge;
- (BOOL)registerNativeHandlers:(BaseHandler *) handler;
@property(nonatomic,strong)NSArray* handlerKeys;
@property(nonatomic,strong)NSMutableDictionary<NSString *, WVJBResponseCallback>* handlerCallBacks;//真正的js回调
- (BOOL)respondToWeb:(id) responseData withHandlerKey:(NSString *)handlerKey;
- (void)weblogToNative:(NSString *)showlog;
- (void)pageGoBack;
@end
