//
//  KDPermission.m
//  KDPermissionHelper
//
//  Created by mumu on 2019/1/15.
//  Copyright © 2019年 kd. All rights reserved.
//

#import "KDPermission.h"
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import <AddressBookUI/AddressBookUI.h>
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>


// 需要拼接的本地化格式,str是需要拼接的字符
#define KDPermissionFormat(key,str) \
[NSString stringWithFormat:KDPermissionLocal(key),str]
#define KDPermissionLocal(key) \
KDPermissionLocalized(key, key)
#define KDPermissionLocalized(key, comment) \
NSLocalizedStringFromTableInBundle(key, @"KDPermission", [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"KDPermission.bundle"]], nil)

#ifndef IS_IOS9_LATER
#define IS_IOS9_LATER ([[UIDevice currentDevice].systemVersion doubleValue]>=9.0)
#endif

#ifndef IS_IOS10_LATER
#define IS_IOS10_LATER ([[UIDevice currentDevice].systemVersion doubleValue]>=10.0)
#endif

typedef NS_ENUM(NSInteger, KDAuthorizationStatus)
{
    KDAuthorizationStatusNotDetermined = 0,// 未确定
    KDAuthorizationStatusRestricted ,//受限制
    KDAuthorizationStatusDenied ,//拒绝
    KDAuthorizationStatusAuthorized//已授权
};

@interface KDPermission ()<CLLocationManagerDelegate>

@property (nonatomic, copy) void (^completion)(BOOL isAuth);
@property (nonatomic, strong) CLLocationManager  *locationManager;

@end

@implementation KDPermission

+ (KDPermission *)helper
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

#pragma mark ====================   block    ====================

// block回调
- (void)returnBlock:(BOOL)result type:(NSString *)typeName
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.completion)
        {
            self.completion(result);
            self.completion = nil;
        }
        if (!result)
        {
            [self alertPemissionTip:typeName];
        }
    });
    if (_locationManager)
    {
        _locationManager = nil;
    }
}

#pragma mark ====================   Library    ====================

- (BOOL)isGetLibraryPemission
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    return status == PHAuthorizationStatusAuthorized;
}

- (void)getLibraryPemission:(void(^)(BOOL isAuth))completion
{
    NSString *typeName = KDPermissionLocal(@"photos");
    _completion = completion;
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status)
    {
        case PHAuthorizationStatusAuthorized:
            [self returnBlock:YES type:typeName];
            break;
        case PHAuthorizationStatusNotDetermined:
        {
            __weak typeof(self) weakSelf = self;
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
                BOOL isGet = (status == PHAuthorizationStatusAuthorized);
                [weakSelf returnBlock:isGet type:typeName];
            }];
        }
            break;
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:
        {
            [self returnBlock:NO type:typeName];
        }
            break;
        default:
            [self returnBlock:NO type:typeName];
            break;
    }
}

#pragma mark ====================   Camera    ====================

- (BOOL)isGetCameraPemission
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    return status == AVAuthorizationStatusAuthorized;
}
- (void)getCameraPemission:(void(^)(BOOL isAuth))completion
{
    NSString *typeName = KDPermissionLocal(@"camera");
    
    _completion = completion;
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (status) {
        case AVAuthorizationStatusAuthorized:
            [self returnBlock:YES type:typeName];
            break;
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            [self returnBlock:NO type:typeName];
            break;
        case AVAuthorizationStatusNotDetermined:
        {
            __weak typeof(self) weakSelf = self;
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                     completionHandler:^(BOOL granted) {
                [weakSelf returnBlock:granted type:typeName];
            }];
        }
            break;
        default:
            [self returnBlock:NO type:typeName];
            break;
    }
}

#pragma mark ====================   Audio    ====================

- (BOOL)isGetAudioPemission
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    return status == AVAuthorizationStatusAuthorized;
}

- (void)getAudioPemission:(void(^)(BOOL isAuth))completion
{
    NSString *typeName = KDPermissionLocal(@"audio");
    
    _completion = completion;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
    switch (status) {
        case AVAuthorizationStatusAuthorized:
            [self returnBlock:YES type:typeName];
            break;
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            [self returnBlock:NO type:typeName];
            break;
        case AVAuthorizationStatusNotDetermined:
        {
            __weak typeof(self) weakSelf = self;
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                [weakSelf returnBlock:granted type:typeName];
            }];
        }
            break;
        default:
            [self returnBlock:NO type:typeName];
            break;
    }
}

#pragma mark ====================   Location    ====================

- (BOOL)isGetLocationPemission
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    return ((kCLAuthorizationStatusAuthorizedWhenInUse == status) ||
            (kCLAuthorizationStatusAuthorizedAlways == status));
}
- (void)getLocationPemission:(void (^)(BOOL))completion
{
    NSString *typeName = KDPermissionLocal(@"location");
    
    _completion = completion;
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    switch (status)
    {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:
            [self returnBlock:YES type:typeName];
            break;
        case kCLAuthorizationStatusNotDetermined:
        {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.distanceFilter = 5;
            _locationManager.delegate = self;
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            {
                [_locationManager requestWhenInUseAuthorization];
            }
        }
            break;
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            [self returnBlock:NO type:typeName];
        } break;
        default:
            [self returnBlock:NO type:typeName];
        break;
    }
}

#pragma mark ====================   LocationAlways    ====================

- (BOOL)isGetLocationAlwaysPemission
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    return (kCLAuthorizationStatusAuthorizedAlways == status);
}

- (void)getLocationAlwaysPemission:(void(^)( BOOL isAuth))completion
{
    NSString *typeName = KDPermissionLocal(@"location");
    
    _completion = completion;
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    switch (status)
    {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self returnBlock:YES type:typeName];
            break;
        case kCLAuthorizationStatusNotDetermined:
        {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.distanceFilter = 5;
            _locationManager.delegate = self;
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [_locationManager requestAlwaysAuthorization];
            }
        }
            break;
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            [self returnBlock:NO type:typeName];
        } break;
        default:
            [self returnBlock:NO type:typeName];
            break;
    }
}

// CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (_completion && status != kCLAuthorizationStatusNotDetermined)
    {
        [self getLocationPemission:_completion];
    }
}

#pragma mark ====================   Contact    ====================

- (BOOL)isGetContactPemission
{
    KDAuthorizationStatus status = [self getContactStatus];
    return status == KDAuthorizationStatusAuthorized;
}

- (KDAuthorizationStatus)getContactStatus
{
    if (IS_IOS9_LATER)
    {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        switch (status) {
            case CNAuthorizationStatusNotDetermined:
                return KDAuthorizationStatusNotDetermined;
                break;
            case CNAuthorizationStatusRestricted:
                return KDAuthorizationStatusRestricted;
                break;
            case CNAuthorizationStatusDenied:
                return KDAuthorizationStatusDenied;
                break;
            case CNAuthorizationStatusAuthorized:
                return KDAuthorizationStatusAuthorized;
                break;
            default:
                return KDAuthorizationStatusDenied;
                break;
        }
    }
    else
    {
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        switch (status) {
            case kABAuthorizationStatusNotDetermined:
                return KDAuthorizationStatusNotDetermined;
                break;
            case kABAuthorizationStatusRestricted:
                return KDAuthorizationStatusRestricted;
                break;
            case kABAuthorizationStatusDenied:
                return KDAuthorizationStatusDenied;
                break;
            case kABAuthorizationStatusAuthorized:
                return KDAuthorizationStatusAuthorized;
                break;
            default:
                return KDAuthorizationStatusDenied;
                break;
        }
    }
}

- (void)getContactPemission:(void(^)(BOOL isAuth))completion
{
    NSString *typeName = KDPermissionLocal(@"addressbook");
    
    _completion = completion;
    
    KDAuthorizationStatus status = [self getContactStatus];
    
    switch (status) {
        case KDAuthorizationStatusAuthorized:
            [self returnBlock:YES type:typeName];
            break;
        case KDAuthorizationStatusDenied:
        case KDAuthorizationStatusRestricted:
            [self returnBlock:NO type:typeName];
            break;
        case KDAuthorizationStatusNotDetermined:
        {
            __weak typeof(self) weakSelf = self;
            [self showAddressBookAuthrity:^(BOOL succeed) {
                [weakSelf returnBlock:succeed type:typeName];
            }];
        }
            break;
        default:
            break;
    }
}
- (void)showAddressBookAuthrity:(void(^)(BOOL bAuthrity))block
{
    if (IS_IOS9_LATER)
    {
        CNContactStore *store = [CNContactStore new];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (block)
            {
                block(granted);
            }
        }];
    }
    else
    {
        ABAddressBookRef _abAddressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRequestAccessWithCompletion(_abAddressBook, ^(bool granted, CFErrorRef error){
            if (block)
            {
                block(granted);
            }
        });
    }
}

#pragma mark ====================   Notification    ====================

- (void)getNotificationPermissionBelow10
{
    UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)getNotificationPermission:(void(^)(BOOL isAuth))completion
{
    NSString *typeName = KDPermissionLocal(@"notification");
    _completion = completion;
    __weak typeof(self) weakSelf = self;
    if (!NSClassFromString(@"UNUserNotificationCenter") || !IS_IOS10_LATER)
    {
        UIUserNotificationType types = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
        [self returnBlock:(types != UIUserNotificationTypeNone) type:typeName];
        return;
    }
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = [UIApplication sharedApplication].delegate;

    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        switch (settings.authorizationStatus)
        {
            case UNAuthorizationStatusAuthorized:
                [weakSelf returnBlock:YES type:typeName];
                break;
                
            case UNAuthorizationStatusNotDetermined:
            {
                // 必须写代理，不然无法监听通知的接收与点击
                [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                    [weakSelf returnBlock:granted type:typeName];
                });
                }];
            }
                break;
            case UNAuthorizationStatusDenied:
                [weakSelf returnBlock:NO type:typeName];
                break;
            default:
                [weakSelf returnBlock:NO type:typeName];
                break;
        }
    }];
}

#pragma mark ====================   NoPermissionAlert    ====================

// 没获取到授权,弹出alert引导去系统设置页面
- (void)alertPemissionTip:(NSString *)pemissionType
{
    if (!_AutoShowAlert)
    {
        return;
    }
    NSString *strTip = KDPermissionFormat(@"_get.sys.permission.of", pemissionType);
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:strTip preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionGoSet = [UIAlertAction actionWithTitle:KDPermissionLocal(@"go.setting") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]])
        {
            //跳转到系统设置界面
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }];
    [alertVc addAction:actionGoSet];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:KDPermissionLocal(@"cancel") style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:actionCancel];
     
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVc animated:YES completion:^{
    }];
}

@end
