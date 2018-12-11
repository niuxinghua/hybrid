//
//  LocationHandler.m
//  GoHaier
//
//  Created by niuxinghua on 2018/12/11.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "LocationHandler.h"
static LocationHandler* sharedInstance = nil;
@implementation LocationHandler
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LocationHandler alloc]init];
    });
    
    return sharedInstance;
}
- (NSString *)handlerKey
{
    return @"ghaier_accessLocation";
}


- (void)handlerMethod
{
    NSLog(@"handler key %@ method called",[self handlerKey]);
   
}
@end
