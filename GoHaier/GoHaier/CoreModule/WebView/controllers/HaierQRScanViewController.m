

#import "HaierQRScanViewController.h"
#import "HaierQRScanView.h"
#import <Photos/Photos.h>

@interface HaierQRScanViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,HaierQRScanDelegate>
@property (nonatomic ,strong) HaierQRScanView *scanView;
@property (nonatomic ,strong) UIImagePickerController *imagePicker;
@end

@implementation HaierQRScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self.scanView startScanning];
}


- (void)setupViews{
    self.view.backgroundColor = [UIColor blackColor];
    UIBarButtonItem *libaryItem = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(openLibary)];
    self.navigationItem.rightBarButtonItem = libaryItem;
    self.navigationItem.title = @"自定义";
    [self.view addSubview:self.scanView];
}


- (void)openLibary{
    if (![self isLibaryAuthStatusCorrect]) {
        return;
    }
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}


- (NSString *)messageFromQRCodeImage:(UIImage *)image{
    if (!image) {
        return nil;
    }
    CIContext *context = [CIContext contextWithOptions:nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    NSArray *features = [detector featuresInImage:ciImage];
    if (features.count == 0) {
        return nil;
    }
    CIQRCodeFeature *feature = features.firstObject;
    return feature.messageString;
}


- (BOOL)isLibaryAuthStatusCorrect{
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusNotDetermined || authStatus == PHAuthorizationStatusAuthorized) {
        return YES;
    }
    return NO;
}





#pragma mark - imagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSString *result = [self messageFromQRCodeImage:image];
    if (result.length == 0) {
       
    }
    
}


#pragma mark - scanViewDelegate
- (void)scanView:(HaierQRScanView *)scanView pickUpMessage:(NSString *)message{
    [scanView stopScanning];
    if (self.resultBlock) {
        self.resultBlock(message);
    }
    [self scanViewDidTouchCloseButton];
}

- (void)scanViewDidTouchCloseButton
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - get

- (HaierQRScanView *)scanView{
    if (!_scanView) {
        _scanView = [[HaierQRScanView alloc]initWithFrame:self.view.bounds];
        _scanView.delegate = self;
        _scanView.showBorderLine = YES;
    }
    return _scanView;
}


- (UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.delegate = self;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    return _imagePicker;
}
@end
