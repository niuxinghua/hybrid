//
//  BarCodeRecongnizerHandler.m
//  GoHaier
//
//  Created by niuxinghua on 2018/11/25.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "BarCodeRecongnizerHandler.h"
#import <Photos/Photos.h>
#import "HaierQRScanViewController.h"
#import "ViewControllerUtil.h"
@interface BarCodeRecongnizerHandler()
@end
static BarCodeRecongnizerHandler* sharedInstance;
@implementation BarCodeRecongnizerHandler
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super alloc]init];
    });
    return sharedInstance;
}
- (NSString *)handlerKey
{
    return @"ghaier_scanQrcode";
}


- (void)handlerMethod
{
    NSLog(@"handler key %@ method called",[self handlerKey]);
    HaierQRScanViewController *controller = [[HaierQRScanViewController alloc]init];
    __weak typeof (BarCodeRecongnizerHandler)*weakSelf = self;
    controller.resultBlock = ^(NSString * result) {
        if (weakSelf.webCallBack) {
            weakSelf.webCallBack(result);
        }
    };
    [[[ViewControllerUtil sharedInstance] topViewController] presentViewController:controller animated:NO completion:^{
        
    }];
}
@end