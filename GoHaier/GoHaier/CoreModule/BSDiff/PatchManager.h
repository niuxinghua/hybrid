//
//  PatchManaer.h
//  GoHaier
//
//  Created by niuxinghua on 2018/12/11.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^MergeResultBlock)(BOOL result);
@interface PatchManager : NSObject
+ (instancetype)sharedInstance;
- (void)mergePatch:(NSString *)oldFilePath differFilePath:(NSString*)differFilePath appName:(NSString*)appName versionName:(NSString*)versionName targetVersion:(NSString *)targetVersion mergeResult:(MergeResultBlock)resultBlock;
@end
