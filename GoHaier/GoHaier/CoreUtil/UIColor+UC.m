#import "UIColor+UC.h"

@implementation UIColor (UC)

/**
 *   专用绿色
 */
+ (UIColor *)uCareGreenColor {
    return [UIColor colorWithRed:0/255.f green:202/255.f blue:218/255.f alpha:1.f];
}

/**
 *   选中绿色
 */
+ (UIColor *)uCareSelectedColor {
    return [UIColor colorWithRed:1/255.f green:135/255.f blue:147/255.f alpha:1.f];
}

/**
 * tableView 背景灰
 */
+ (UIColor *)tableViewBackgroundGrayColor {
    return [UIColor colorWithRed:242/255.f green:242/255.f blue:242/255.f alpha:1.f];
}

/**
 * 竖分割线 灰
 */
+ (UIColor *)verticalLineGrayColor {
    return [UIColor colorWithRed:247/255.f green:247/255.f blue:247/255.f alpha:1.f];
}

/**
 * 横分割线 灰
 */
+ (UIColor *)acrossLineGrayColor {
    return [UIColor colorWithRed:200/255.f green:200/255.f blue:200/255.f alpha:1.f];
}

/**
 * 按钮 蓝
 */
+ (UIColor *)buttonBlueColor {
    return [UIColor colorWithRed:0/255.f green:113/255.f blue:255/255.f alpha:1.f];
}

/**
 * 按钮 灰
 */
+ (UIColor *)buttonGaryColor {
    return [UIColor colorWithRed:146/255.f green:146/255.f blue:146/255.f alpha:1.f];
}

/**
 * 按钮 背景灰
 */
+ (UIColor *)buttonBackgroundGrayColor {
    return [UIColor colorWithRed:248/255.f green:248/255.f blue:248/255.f alpha:1.f];
}

/**
 * placeholderColor 文字
 */
+ (UIColor *)textPlaceholderColoer {
    return [UIColor colorWithRed:141/255.f green:141/255.f blue:141/255.f alpha:1.f];
}

/**
 * 仿textfield placeholder 文字颜色
 */
+ (UIColor *)textFieldPlaceholderColor {
    return [UIColor colorWithRed:205/255.f green:205/255.f blue:205/255.f alpha:1.f];
}

/**
 * progress placeholder 进度
 */
+ (UIColor *)progressPlaceholderColor {
    return [UIColor colorWithRed:227/255.f green:227/255.f blue:227/255.f alpha:1.f];
}

@end
