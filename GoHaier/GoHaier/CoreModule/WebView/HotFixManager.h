//
//  HotFixManager.h
//  GoHaier
//
//  Created by niuxinghua on 2019/3/22.
//  Copyright © 2019年 com.haier. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HotFixManager : NSObject
+ (instancetype)sharedManager;
- (void)setUp;
@end

NS_ASSUME_NONNULL_END
