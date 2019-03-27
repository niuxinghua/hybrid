//
//  SingleWebviewViewController.h
//  GoHaier
//
//  Created by niuxinghua on 2019/3/27.
//  Copyright © 2019年 com.haier. All rights reserved.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SingleWebviewViewController : ViewController
@property(nonatomic,strong)UIWebView *webView;
- (void)loadUrl:(NSString *)url;
+ (BOOL)showSelfWith:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
