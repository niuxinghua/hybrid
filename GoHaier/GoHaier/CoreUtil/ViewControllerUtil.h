//
//  ViewControllerUtil.h
//  GoHaier
//
//  Created by niuxinghua on 2018/11/25.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ViewControllerUtil : NSObject
- (UIViewController *)topViewController;
+ (instancetype)sharedInstance;
@end
