//
//  VersionController.h
//  GoHaier
//
//  Created by niuxinghua on 2018/12/26.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString* const DidDownloadH5BaseZipSuccess;
extern NSString* const DidDownloadH5PatchSuccess;
NS_ASSUME_NONNULL_BEGIN
typedef void(^VersionUpdateBlcok)(BOOL success);
@interface VersionController : NSObject
+(instancetype)sharedInstance;
-(void)updateToLatestVersion:(NSString*)appName isSuccess:(VersionUpdateBlcok)updateBlock;
- (BOOL)autoUpateApp:(NSString *)appName;
- (void)updataAll;
@property(nonatomic,copy)NSString *currentAppName;
- (BOOL)innerVersionCopyToOutside:(NSString *)appName;
@end

NS_ASSUME_NONNULL_END
