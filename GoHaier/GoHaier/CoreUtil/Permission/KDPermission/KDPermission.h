//
//  KDPermission.h
//  KDPermissionHelper
//
//  Created by mumu on 2019/1/15.
//  Copyright © 2019年 kd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDPermission : NSObject

+ (KDPermission *)helper;

/**
 自动展示权限被拒绝去系统设置的alert,默认NO不展示
 */
@property (nonatomic, assign) BOOL AutoShowAlert;

/**
 获取通相册权限
 
 @param completion 回调
 */
- (void)getLibraryPemission:(void(^)( BOOL isAuth))completion;
- (BOOL)isGetLibraryPemission;

/**
 获取通相机权限
 
 @param completion 回调
 */
- (void)getCameraPemission:(void(^)(BOOL isAuth))completion;
- (BOOL)isGetCameraPemission;

/**
 获取通麦克风权限
 
 @param completion 回调
 */
- (void)getAudioPemission:(void(^)(BOOL isAuth))completion;
- (BOOL)isGetAudioPemission;

/**
 获取通位置权限
 
 @param completion 回调
 */
- (void)getLocationPemission:(void(^)( BOOL isAuth))completion;
- (BOOL)isGetLocationPemission;

/**
 获取通位置权限(AllTime)
 
 @param completion 回调
 */
- (void)getLocationAlwaysPemission:(void(^)( BOOL isAuth))completion;
- (BOOL)isGetLocationAlwaysPemission;

/**
 获取通讯录权限

 @param completion 回调
 */
- (void)getContactPemission:(void(^)(BOOL isAuth))completion;
- (BOOL)isGetContactPemission;

/**
 获取通知权限
 
 默认把UNUserNotificationCenterDelegate复制给[UIApplication sharedApplication].delegate,请手动实现相关代理处理推送消息
 如果更改请设置[UNUserNotificationCenter currentNotificationCenter].delegate
 
 ios10以下的不会自动申请权限,需要调用getNotificationPermissionBelow10 提前手动申请通知权限

 @param completion 回调
 */
- (void)getNotificationPermission:(void(^)(BOOL isAuth))completion;

/**
 手动申请通知权限,低于ios10的
 */
- (void)getNotificationPermissionBelow10 NS_DEPRECATED_IOS(8_0, 10_0, "Use [KDPermission getNotificationPermission:]");


@end
