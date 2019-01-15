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

+ (BOOL)showContentWithAPPName:(NSString *)appName navigationMode:(BOOL)isnavigation fullScreenMode:(BOOL)isfullScreen animated:(BOOL)animation titleName:(NSString *)title rootController:(UIViewController *)rootController pageName:(NSString *)pageName;

@property(nonatomic,copy)NSString *PageName;
@property(nonatomic,copy)NSString *titleName;
@end

NS_ASSUME_NONNULL_END
