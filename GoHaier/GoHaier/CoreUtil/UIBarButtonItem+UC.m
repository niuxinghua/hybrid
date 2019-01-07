#import "UIBarButtonItem+UC.h"
#import "UIColor+UC.h"

@implementation UIBarButtonItem (UC)

+ (UIBarButtonItem *)uc_backBarButtonItemWithAction:(void (^)())action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateHighlighted];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [button bk_addEventHandler:^(id sender) {
        action();
    } forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}

+ (UIBarButtonItem *)uc_barButtonItemWithAction:(void (^)())action text:(NSString *)text {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 5, 44, 44);
    [button setTitle:text forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [button bk_addEventHandler:^(id sender) {
        action();
    } forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor uCareGreenColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor uCareSelectedColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor buttonGaryColor] forState:UIControlStateDisabled];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}

+ (UIBarButtonItem *)uc_bacButtonItemWithAction:(void (^)())action image:(UIImage *)image {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 5, 44, 44);
    [button setImage:image forState:UIControlStateNormal];
    [button bk_addEventHandler:^(id sender) {
        action();
    } forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}

@end
