//
//  AppMacro.h
//  Aicai1030
//
//  Created by IOS on 2017/10/30.
//  Copyright © 2017年 IOS. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

#pragma mark - == 常用的宏
/**
 屏幕宽
 */
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

/**
 屏幕高
 */
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//屏幕宽与设计图的比例 (plus设计图)
#define SCREEN_WIDTH_RATIO(size)  SCREEN_WIDTH/414 * size

//屏幕高与设计图的比例 (plus设计图)
#define SCREEN_HEIGHT_RATIO(size)  SCREEN_HEIGHT/736 * size


#define  iPhoneX ((SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f) ||(SCREEN_WIDTH == 812.f && SCREEN_HEIGHT == 375.f) ? YES : NO)
// 适配iPhone X 状态栏高度
#define  MC_StatusBarHeight      (iPhoneX ? 44.f : 20.f)
// 适配iPhone X Tabbar高度
#define  MC_TabbarHeight         (iPhoneX ? (49.f+34.f) : 49.f)
// 适配iPhone X Tabbar距离底部的距离
#define  MC_TabbarSafeBottomMargin         (iPhoneX ? 34.f : 0.f)
// 适配iPhone X 导航栏高度
#define  MC_NavHeight  (iPhoneX ? 88.f : 64.f)


#define SAFE_WIDTH [UIScreen mainScreen].bounds.size.width

#define SAFE_WIDTH_HORI (SCREEN_WIDTH - MC_StatusBarHeight - MC_TabbarSafeBottomMargin)

#define SAFE_HEIGHT (SCREEN_HEIGHT - MC_StatusBarHeight - MC_TabbarSafeBottomMargin)

#define SAFE_HEIGHT_HORI (SCREEN_HEIGHT - MC_TabbarSafeBottomMargin)
/**
 RGB颜色

 @param R 红
 @param G 绿
 @param B 蓝
 @param A 不透明度
 @return 颜色对象
 */
#define ColorWithRGB(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

/**
 16进制颜色

 @param Hex 16进制颜色
 @param A 不透明度
 @return 颜色对象
 */
#define ColorWith1Hex(Hex,A) [UIColor colorWithRed:((Hex & 0xFF0000)>> 16)/255.0 green:((Hex & 0xFF00)>> 8)/255.0 blue:(Hex & 0xFF)/255.0 alpha:A]

/**
 弱引用block
 */
#define WeakBlockSelf(type)  __weak  __block typeof(type) weakBlockType = type;

/**
 弱引用
 */
#define WeakSelf(type)  __weak  typeof(type) weakType = type;


/**
 URL
 */
#define  URLWithStr(str) [NSURL URLWithString:str]


/**
 设置字体Font
 @param size 大小
 @return UIFont对象
 */
#define FontWithSize(size)  [UIFont systemFontOfSize:size]

/**
 设置加粗字体Font

 @param size 大小
 @return UIFont对象
 */
#define BoldFontWithSize(size) [UIFont boldSystemFontOfSize:size]

/**
 设置图片

 @param name 图片名字
 @return 图片对象
 */
#define ImageWithName(name) [UIImage imageNamed:name]

#define  AppCGRectMake(x,y,width,height) CGRectMake(x, y,width, height)
#pragma mark - == APP主体

//导航条颜色
#define NAV_COLOR ColorWith1Hex(0xFF623C,1.0)
//主题色
#define Center_COLOR ColorWith1Hex(0xFF623C,1.0)
//默认颜色
#define CenterNor_COLOR ColorWith1Hex(0x666666 ,1.0)




#pragma mark - == 系统相关
//app包名()
#define package_name    [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]
//APP版本号:
#define APP_version     [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

//设备名称
#define Device_Name     [[UIDevice currentDevice] name]


// 设备版本号
#define Device_systemVersion    [[UIDevice currentDevice] systemVersion]

//设备UUID
#define Device_UUID [[UIDevice currentDevice] identifierForVendor]



//获取系统版本
#define IOS_VERSION ［[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion ［UIDevice currentDevice] systemVersion]
//app 版本号
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]



#endif /* AppMacro_h */
