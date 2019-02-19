//
//  PageGoBackHandler.m
//  GoHaier
//
//  Created by niuxinghua on 2019/2/18.
//  Copyright © 2019年 com.haier. All rights reserved.
//

#import "PageGoBackHandler.h"
static PageGoBackHandler *sharedInstance;
@implementation PageGoBackHandler

- (NSString *)handlerKey
{
    return @"ghaier_pagegoback";
}
- (void)handlerMethod:(id)data
{
    NSLog(@"handler key %@ method called",[self handlerKey]);
    if (_webView) {
        [_webView pageGoBack];
    }
}

@end
