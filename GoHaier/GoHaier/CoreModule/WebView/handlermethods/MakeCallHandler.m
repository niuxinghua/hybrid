//
//  MakeCallHandler.m
//  GoHaier
//
//  Created by niuxinghua on 2019/2/27.
//  Copyright © 2019年 com.haier. All rights reserved.
//

#import "MakeCallHandler.h"
static MakeCallHandler *sharedInstance;
@implementation MakeCallHandler
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc]init];
    });
    return sharedInstance;
}
- (NSString *)handlerKey
{
    return @"ghaier_makePhoneCall";
}
- (void)handlerMethod:(id)data
{
    NSLog(@"handler key %@ method called",[self handlerKey]);
    NSString *telePhone = (NSString *)data;
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",telePhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]]
}
@end
