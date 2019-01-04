//
//  UIViewController+BackgroundAlpha.m
//  JSNavigationKit
//
//  Created by yky on 2017/10/24.
//

#import "UIViewController+BackgroundAlpha.h"
#import <objc/runtime.h>
@implementation UIViewController (BackgroundAlpha)

//static char *NavigationBackgroundAlpha = "NavigationBackgroundAlpha";
//static char *NavigationBarTintColor = "NavigationBarTintColor";

//+(void)load{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//
//        //获得viewController的生命周期方法的selector
//        SEL systemSel = @selector(viewDidLoad);
//        //自己实现的将要被交换的方法的selector
//        SEL swizzSel = @selector(app_viewDidLoad);
//        //两个方法的Method
//        Method systemMethod = class_getInstanceMethod([self class], systemSel);
//        Method swizzMethod = class_getInstanceMethod([self class], swizzSel);
//
//        //首先动态添加方法，实现是被交换的方法，返回值表示添加成功还是失败
//        BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
//        if (isAdd) {
//            //如果成功，说明类中不存在这个方法的实现
//            //将被交换方法的实现替换到这个并不存在的实现
//            class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
//        } else {
//            //否则，交换两个方法的实现
//            method_exchangeImplementations(systemMethod, swizzMethod);
//        }
//    });
//}
//- (void)app_viewDidLoad {
//    [self setJs_navigationBackgroundAlpha:@"1"];
//    [self app_viewDidLoad];
//}

//-(void)setJs_navigationBackgroundAlpha:(NSString *)js_navigationBackgroundAlpha
//{
//    objc_setAssociatedObject(self, NavigationBackgroundAlpha, js_navigationBackgroundAlpha, OBJC_ASSOCIATION_COPY_NONATOMIC);
//
//    [self.navigationController js_setNavigationBackgroundAlpha:[js_navigationBackgroundAlpha floatValue]];
//}
//
//-(NSString*)js_navigationBackgroundAlpha{
//    return objc_getAssociatedObject(self, NavigationBackgroundAlpha);
//}
//
//-(UIColor*)js_barTintColor
//{
//    return objc_getAssociatedObject(self, NavigationBarTintColor);
//}
//
//-(void)setJs_barTintColor:(UIColor *)js_barTintColor
//{
//    objc_setAssociatedObject(self, NavigationBarTintColor, js_barTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [self.navigationController js_barTintColor:js_barTintColor];
//}

-(void)js_setAutomaticallyAdjustsScrollViewInsets_No:(UIScrollView*)scrollView
{
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)js_setStatusBarStyle:(UIStatusBarStyle)style
{
    [UIApplication sharedApplication].statusBarStyle = style;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
    {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

@end
