//
//  SMPageStyle.h
//  Pods
//
//  Created by yky on 2017/11/17.
//

//全工程公用宏定义,包含，颜色，样式，公用图片等等

#ifndef SMPageStyle_h
#define SMPageStyle_h

///================全局字体配置===================
//字体名称
#define SMGlobalFontName @"Microsoft YaHei"
//大号按钮字体
#define SMFontBigButton 15
//大号字体大小
#define SMFontBig 13
//中号字体大小
#define SMFontNormal 12
//小号字体大小
#define SMFontSmall 10

///=================全局颜色配置==================
//颜色16进制转换
#define SMColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//主题正文颜色
#define SMMainContent SMColorFromRGB(0x333333)
//说明类型文字
#define SMDeclaratives SMColorFromRGB(0x808080)
//价格，状态类型文字
#define SMPriceStatus SMColorFromRGB(0xeb5300)
//输入项占位符
#define SMPlaceHolder SMColorFromRGB(0Xb3b3b3)
//弹窗确认类型按钮，部分页面按钮
#define SMConfirmButton SMColorFromRGB(0x1592db)
//页面背景颜色
#define SMBackgroundColor SMColorFromRGB(0xefeff4)
//表格分割线颜色
#define SMSeparator SMColorFromRGB(0xe5e5e5)

static const char * _closeEmptyHandel = "sm_closeEmptyHandel";
static const char * _emptyMsg = "sm_emptyMsg";
static const char * _emptyImage = "sm_emptyImage";
static const char * _emptyType = "sm_emptyType";

#define EmptyMsgViewTag 8888
#define EmptyMsgTag 8889
#define EmptyIconTag 8890


//字符为空判断
#define isEmpytLabelOrField(str) str==nil?@"":[str isEqual:[NSNull null]]?@"":str
#define isEmpytNumberStr(str) str==nil?@"0":[str isEqual:[NSNull null]]?@"0":str

//弱引用
#define WS(wSelf)          __weak typeof(self) wSelf = self
//强引用
#define SS(sSelf)          __strong typeof(wSelf) sSelf = wSelf

//获取当前设备系统版本
#define SystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]
//获取设备物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//获取设备物理宽度
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
//获取Keywindow
#define KEY_WINDOW  [UIApplication sharedApplication].delegate.window
//状态栏高度
#define JS_StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define JS_NavBarHeight 44.0
//整个导航栏高度
#define JS_NavigationHeight (JS_StatusBarHeight + JS_NavBarHeight)



#endif /* SMPageStyle_h */
