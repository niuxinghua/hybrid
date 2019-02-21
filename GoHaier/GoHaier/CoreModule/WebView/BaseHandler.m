//
//  BaseHandler.m
//  GoHaier
//
//  Created by niuxinghua on 2018/11/26.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "BaseHandler.h"

@implementation BaseHandler
- (NSString *)handlerKey
{
    return @"";
}
- (void)handlerMethod:(id)data
{
    
}
- (BOOL)respondToWeb:(id)data
{
    if (self.webCallBack) {
        self.webCallBack(data);
    }
    return YES;
}
@end
