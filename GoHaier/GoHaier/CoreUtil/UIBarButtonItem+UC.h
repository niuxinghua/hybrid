#import <UIKit/UIKit.h>
#import <BlocksKit/BlocksKit+UIKit.h>
//#import "BlocksKit+UIKit.h"

/**
 *  UIBarButtonItem 
 */
@interface UIBarButtonItem (UC)

+ (UIBarButtonItem *)uc_backBarButtonItemWithAction:(void (^)())action;
+ (UIBarButtonItem *)uc_barButtonItemWithAction:(void (^)())action text:(NSString *)text;
+ (UIBarButtonItem *)uc_bacButtonItemWithAction:(void (^)())action image:(UIImage *)image;

@end
