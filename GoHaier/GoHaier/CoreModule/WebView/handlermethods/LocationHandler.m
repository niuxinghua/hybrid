//
//  LocationHandler.m
//  GoHaier
//
//  Created by niuxinghua on 2018/12/11.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "LocationHandler.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
static LocationHandler* sharedInstance = nil;
#define AMapSecret @"1e3d64678b71071e3567eb1c20981098"
@interface LocationHandler()<AMapLocationManagerDelegate>{
}

@property (nonatomic,strong)AMapLocationManager *manager;
@end
@implementation LocationHandler
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LocationHandler alloc]init];
        [AMapServices sharedServices].apiKey = AMapSecret;
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
    [self.manager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        NSMutableDictionary *data =@{}.mutableCopy;
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
            [data setObject:@(location.verticalAccuracy) forKey:@"accuracy"];
            [data setObject:regeocode.adcode forKey:@"adCode"];
            [data setObject:regeocode.formattedAddress forKey:@"address"];
            [data setObject:regeocode.city forKey:@"city"];
            [data setObject:regeocode.citycode forKey:@"cityCode"];
            [data setObject:regeocode.description forKey:@"description"];
            [data setObject:regeocode.country forKey:@"country"];
            [data setObject:@(location.coordinate.latitude) forKey:@"latitude"];
            [data setObject:@(location.coordinate.longitude) forKey:@"longitude"];
            [data setObject:regeocode.province forKey:@"province"];
            [data setObject:@(location.speed) forKey:@"speed"];
            [data setObject:regeocode.street forKey:@"street"];
            [data setObject:regeocode.number forKey:@"streeNum"];
            [self respondToWeb:data];
        }
    }];
}
- (id)init {
    self = [super init];
    if (self) {
        self.manager = [[AMapLocationManager alloc] init];
        self.manager.delegate = self;
        // 带逆地理信息的一次定位（返回坐标和地址信息）
        [self.manager setDesiredAccuracy:kCLLocationAccuracyBest];
        //   定位超时时间，最低2s，此处设置为10s
        self.manager.locationTimeout =10;
        //   逆地理请求超时时间，最低2s，此处设置为10s
        self.manager.reGeocodeTimeout = 10;
    }
    return self;
}



@end
