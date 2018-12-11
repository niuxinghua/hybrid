

#import <UIKit/UIKit.h>

typedef  void(^scanResult)(NSString *);

@interface HaierQRScanViewController : UIViewController

@property(nonatomic,copy)scanResult resultBlock;

@end
