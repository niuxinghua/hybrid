//
//  VibrateHandler.m
//  GoHaier
//
//  Created by niuxinghua on 2019/2/27.
//  Copyright © 2019年 com.haier. All rights reserved.
//

#import "VibrateHandler.h"
#import <AudioToolbox/AudioToolbox.h>
static VibrateHandler *sharedInstance;
@implementation VibrateHandler
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
    return @"ghaier_vibrate";
}
- (void)handlerMethod:(id)data
{
    NSLog(@"handler key %@ method called",[self handlerKey]);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}
@end
