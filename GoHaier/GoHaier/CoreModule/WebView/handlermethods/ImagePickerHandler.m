//
//  ImagePickerHandler.m
//  GoHaier
//
//  Created by niuxinghua on 2018/11/25.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "ImagePickerHandler.h"
#import "ViewControllerUtil.h"
static ImagePickerHandler* sharedInstance;
@implementation ImagePickerHandler

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
    return @"ghaier_choosePhoto";
}
- (void)handlerMethod:(id)data
{

    NSLog(@"handler key %@ method called",[self handlerKey]);
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [[[ViewControllerUtil sharedInstance]topViewController] presentViewController:imagePicker animated:YES completion:nil];

    }
}
- (BOOL)respondToWeb:(id)data
{
    
    if (self.webCallBack) {
        self.webCallBack(data);
    }
    return YES;
}
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
//切掉file 后把路径给前端
    NSURL *fileUrl = [info objectForKey:@"UIImagePickerControllerImageURL"];
    if ([fileUrl.absoluteString length] > 0) {
        NSArray *fileArray = [fileUrl.absoluteString componentsSeparatedByString:@"file://"];
        if (fileArray != nil && fileArray.count > 0) {
            NSString *url = @"";
            if (fileArray.count >= 2) {
                url = fileArray[1];
            }
            NSDictionary *dic = @{@"filePath":url};
            [self respondToWeb:dic];
            [picker dismissViewControllerAnimated:YES completion:nil];
        }
    }

    
    
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
@end
