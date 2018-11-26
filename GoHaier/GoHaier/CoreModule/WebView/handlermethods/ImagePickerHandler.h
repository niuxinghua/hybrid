//
//  ImagePickerHandler.h
//  GoHaier
//
//  Created by niuxinghua on 2018/11/25.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseHandler.h"
@interface ImagePickerHandler : BaseHandler<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
+ (instancetype)sharedInstance;
@end
