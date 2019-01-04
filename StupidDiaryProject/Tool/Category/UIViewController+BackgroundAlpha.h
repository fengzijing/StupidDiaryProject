//
//  UIViewController+BackgroundAlpha.h
//  JSNavigationKit
//
//  Created by yky on 2017/10/24.
//

#import <UIKit/UIKit.h>

@interface UIViewController (BackgroundAlpha)

/*! 设置导航背景的alpha,针对有些页面导航栏是完全透明的情况 */
//@property(copy,nonatomic) NSString* js_navigationBackgroundAlpha;

///*! 设置导航栏title,item颜色 */
//@property(strong,nonatomic) UIColor* js_barTintColor;

/*!
 @brief 针对iOS automaticallyAdjustsScrollViewInsets失效，设置视图从屏幕左上方订单计算。
 @remark 调用此方法之后view的起始位置将从屏幕左订单开始
 
 @param scrollView 滚动视图，如tableView
 */
-(void)js_setAutomaticallyAdjustsScrollViewInsets_No:(UIScrollView*)scrollView;
/*!
 @brief 设置状态栏字体颜色，这里修改的是全局状态栏颜色
 
 @remark 如果页面离开，请把状态栏的颜色修改为项目默认颜色
 
 @param style UIStatusBarStyle
 */
- (void)js_setStatusBarStyle:(UIStatusBarStyle)style;

/**
 查找导航栏底部的黑线视图

 @param view <#view description#>
 @return <#return value description#>
 */
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view;
@end
