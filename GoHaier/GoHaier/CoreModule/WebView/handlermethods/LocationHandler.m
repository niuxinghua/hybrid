//
//  LocationHandler.m
//  GoHaier
//
//  Created by niuxinghua on 2018/12/11.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "LocationHandler.h"
static LocationHandler* sharedInstance = nil;
@interface LocationHandler()<CLLocationManagerDelegate>{
    CLLocationManager *manager;
}


@end
@implementation LocationHandler
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LocationHandler alloc]init];
    });
    
    return sharedInstance;
}
- (NSString *)handlerKey
{
    return @"ghaier_accessLocation";
}


- (void)handlerMethod:(id)data
{
    NSLog(@"handler key %@ method called",[self handlerKey]);
    [manager startUpdatingLocation];
}
- (id)init {
    self = [super init];
    if (self) {
        // 打开定位 然后得到数据
        manager = [[CLLocationManager alloc] init];
        manager.delegate = self;
        //控制定位精度,越高耗电量越
        manager.desiredAccuracy = kCLLocationAccuracyBest;
        // 1. 适配 动态适配
        if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [manager requestWhenInUseAuthorization];
            [manager requestAlwaysAuthorization];
        }
        // 2. 另外一种适配 systemVersion 有可能是 8.1.1
        float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (osVersion >= 8) {
            [manager requestWhenInUseAuthorization];
            [manager requestAlwaysAuthorization];
        }
    }
    return self;
}

- (void)stop {
    [manager stopUpdatingLocation];
}


// 每隔一段时间就会调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    for (CLLocation *loc in locations) {
        CLLocationCoordinate2D l = loc.coordinate;
        double lat = l.latitude;
        double lnt = l.longitude;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:@(lat) forKey:@"latitude"];
        [dic setObject:@(lnt) forKey:@"longitude"];
        [self respondToWeb:dic];
    }
}
- (BOOL)respondToWeb:(id)data
{
    if (self.webCallBack) {
        self.webCallBack(data);
    }
    return YES;
}
//失败代理方法
//todo 失败回调没做
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
}

@end
