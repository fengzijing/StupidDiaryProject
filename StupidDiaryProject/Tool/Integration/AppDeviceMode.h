//
//  AppDeviceMode.h
//  DeviOSCP
//
//  Created by Dev-XiaoXiao on 2017/12/26.
//  Copyright © 2017年 Dev-XiaoXiao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 应用BundleId(包名)
 */
const NSString * const getPackage_name(void);


/**
 APP版本号(整型字符串)
 */
const NSString * const getAPP_Number_Version(void);


/**
 APP版本号(字符串)
 */
const NSString * const getAPP_Str_Version(void);


/**
 APP Bunild号(字符串)
 */
const NSString * const getAPP_Str_Bunild(void);


/**
 设备名称
 */
const NSString * const getDevice_Name(void);


/**
 设备系统版本
 */
const NSString * const getDevice_systemVersion(void);


/**
 设备UUID
 */
const NSString * const getDevice_UUID(void);

/**
 获取设备型号
 */
const NSString * const getDeviceModelName(void);


/**
 返回App以及设备信息Json
 */
const NSDictionary * const getAppDeviceInfo(void);

/**
 返回App以及设备信息Json字符串
 
 @return App以及设备信息Json字符串
 */
const NSString * const getAppDeviceInfoStr(void);




