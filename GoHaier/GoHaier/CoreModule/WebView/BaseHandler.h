//
//  BaseHandler.h
//  GoHaier
//
//  Created by niuxinghua on 2018/11/26.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^CallBackHandlerBlock)(id data);
@interface BaseHandler : NSObject
- (NSString *)handlerKey;
- (void)handlerMethod:(id)data;
- (BOOL)respondToWeb:(id)data;
@property (nonatomic,copy)CallBackHandlerBlock webCallBack;
@end
