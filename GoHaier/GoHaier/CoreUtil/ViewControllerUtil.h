//
//  ViewControllerUtil.h
//  GoHaier
//
//  Created by niuxinghua on 2018/11/25.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
ViewControllerModeNavigationed,
ViewControllerModePresented,
ViewControllerModeUnkown,
} HaierViewControllerMode;
@interface ViewControllerUtil : NSObject
- (UIViewController *)topViewController;
+ (instancetype)sharedInstance;
//判断当前显示的控制前是那种导航方式，navigation与present模式
- (HaierViewControllerMode)isTopViewControllerNavigationMode;
@end
