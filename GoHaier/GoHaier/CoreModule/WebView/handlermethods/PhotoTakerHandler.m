//
//  PhotoTakerHandler.m
//  GoHaier
//
//  Created by niuxinghua on 2018/11/25.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "PhotoTakerHandler.h"
#import "ViewControllerUtil.h"
#import <AVFoundation/AVFoundation.h>
static PhotoTakerHandler* sharedInstance;
@implementation PhotoTakerHandler
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super alloc]init];
    });
    return sharedInstance;
}
- (NSString *)handlerKey
{
    return @"ghaier_takePhoto";
}

- (void)handlerMethod:(id)data
{
    
    NSLog(@"handler key %@ method called",[self handlerKey]);
    if ([[KDPermission helper] isGetCameraPemission]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[ViewControllerUtil sharedInstance]topViewController] presentViewController:imagePicker animated:YES completion:nil];
            });
            
        }
    }else{
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                 completionHandler:^(BOOL granted) {
                                     NSError *error;
                                     if (granted) {
                                         if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                                             UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
                                             imagePicker.delegate = self;
                                             imagePicker.allowsEditing = YES;
                                             imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [[[ViewControllerUtil sharedInstance]topViewController] presentViewController:imagePicker animated:YES completion:nil];
                                             });
                                             
                                         }
                                     }else {
                                     }
                                 }];
    }
}
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //    UIImage *newImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //    NSData *imageData = UIImageJPEGRepresentation(newImage, 1);
    //    NSString *base64=[imageData base64EncodedStringWithOptions:NSUTF8StringEncoding];
    //    [picker dismissViewControllerAnimated:YES completion:nil];
    //    [self.bridge callHandler:@"imageData" data:@{@"image":base64}];
    //切掉file 后把路径给前端
    NSString *url =  [self loadImageFinished:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    NSDictionary *dic = @{@"filePath":url};
    [self respondToWeb:dic];
    [picker dismissViewControllerAnimated:YES completion:nil];
    //    NSURL *fileUrl = [info objectForKey:@"UIImagePickerControllerImageURL"];
    //    if ([fileUrl.absoluteString length] > 0) {
    //        NSArray *fileArray = [fileUrl.absoluteString componentsSeparatedByString:@"file://"];
    //        if (fileArray != nil && fileArray.count > 0) {
    //            NSString *url = @"";
    //            if (fileArray.count >= 2) {
    //                url = fileArray[1];
    //            }
    //            NSDictionary *dic = @{@"filePath":url};
    //            [self respondToWeb:dic];
    //            [picker dismissViewControllerAnimated:YES completion:nil];
    //        }
    //  }
    
}

- (NSString *)loadImageFinished:(UIImage *)image
{
    
    NSString *path_document = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString *imagePath = [path_document stringByAppendingString:@"/Documents/current.png"];
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
    return imagePath;
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

@end
