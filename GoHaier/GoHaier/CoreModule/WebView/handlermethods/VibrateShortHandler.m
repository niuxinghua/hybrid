//
//  VibrateShortHandler.m
//  GoHaier
//
//  Created by niuxinghua on 2019/2/27.
//  Copyright © 2019年 com.haier. All rights reserved.
//

#import "VibrateShortHandler.h"
#import <AudioToolbox/AudioToolbox.h>
static VibrateShortHandler *sharedInstance;
@implementation VibrateShortHandler
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
    return @"ghaier_vibrateShort";
}
- (void)handlerMethod:(id)data
{
    NSLog(@"handler key %@ method called",[self handlerKey]);
    AudioServicesPlaySystemSound(1519);
}
@end
