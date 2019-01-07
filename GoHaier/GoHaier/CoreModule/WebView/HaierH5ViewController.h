//
//  HaierH5ViewController.h
//  GoHaier
//
//  Created by niuxinghua on 2019/1/4.
//  Copyright © 2019年 com.haier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HaierCoreWebView.h"
NS_ASSUME_NONNULL_BEGIN

@interface HaierH5ViewController : UIViewController<UIWebViewDelegate>
@property(nonatomic,strong)HaierCoreWebView *webView;

+ (BOOL)showContentWithUrl:(NSString *)filePath navigationMode:(BOOL)isnavigation fullScreenMode:(BOOL)isfullScreen animated:(BOOL)animation rootController:(UIViewController *)rootController;
@end

NS_ASSUME_NONNULL_END
