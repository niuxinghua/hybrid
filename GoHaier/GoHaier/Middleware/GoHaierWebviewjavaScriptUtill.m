//
//  GoHaierWebviewjavaScriptUtill.m
//  GoHaier
//
//  Created by niuxinghua on 2018/11/25.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "GoHaierWebviewjavaScriptUtill.h"

@implementation GoHaierWebviewjavaScriptUtill
static GoHaierWebviewjavaScriptUtill *sharedInstance;
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GoHaierWebviewjavaScriptUtill alloc]init];
    });
    return sharedInstance;
}

@end
