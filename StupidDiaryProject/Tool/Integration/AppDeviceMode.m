//
//  AppDeviceMode.m
//  DeviOSCP
//
//  Created by Dev-XiaoXiao on 2017/12/26.
//  Copyright © 2017年 Dev-XiaoXiao. All rights reserved.
//

#import "AppDeviceMode.h"
#import <sys/utsname.h>


/**
 应用BundleId(包名)
 */
const NSString * const getPackage_name(void)
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}


/**
 APP版本号(整型字符串)
 */
const NSString * const getAPP_Number_Version(void)
{
    NSString * appVersionStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSArray * arr = [appVersionStr componentsSeparatedByString:@"."];
    NSMutableString * mstr = [NSMutableString string];
    for (NSString * nstr in arr) {
        [mstr appendString:nstr];
    }
    return mstr;
}

/**
 APP版本号(字符串)
 */
const NSString * const getAPP_Str_Version(void)
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

/**
 APP Bunild号(字符串)
 */
const NSString * const getAPP_Str_Bunild(void)
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

/**
 设备名称
 */
const NSString * const getDevice_Name(void)
{
    return  [[UIDevice currentDevice] name];
}

/**
 设备系统版本
 */
const NSString * const getDevice_systemVersion(void)
{
    return [[UIDevice currentDevice] systemVersion];
}

/**
 设备UUID
 */
const NSString * const getDevice_UUID(void)
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

/**
 获取设备型号
 */
const NSString * const getDeviceModelName(void)
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone 系列
    if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7 (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7 (GSM)";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus (GSM)";
    if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone 8 (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone 8 (GSM)";
    if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus (GSM)";
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone X (GSM)";
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone X (GSM)";
    
    //iPod 系列
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad 系列
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceModel isEqualToString:@"iPad4,4"]
        ||[deviceModel isEqualToString:@"iPad4,5"]
        ||[deviceModel isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceModel isEqualToString:@"iPad4,7"]
        ||[deviceModel isEqualToString:@"iPad4,8"]
        ||[deviceModel isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    return deviceModel;
}

/**
 返回App以及设备信息Json
 */
const NSDictionary * const getAppDeviceInfo(void)
{
    NSLog(@"package_name == %@| APP_version ==%@ | Device_Name == %@ | Device_systemVersion == %@ | Device_UUID == %@ |DeviceModelName == %@",getPackage_name(),getAPP_Number_Version(), getDevice_Name(), getDevice_systemVersion(), getDevice_UUID(), getDeviceModelName());
    
    NSMutableDictionary * appleInfo =  [NSMutableDictionary dictionary];
    [appleInfo setObject: getPackage_name() forKey:@"package_name"];
    [appleInfo setObject: getAPP_Number_Version() forKey:@"getAPP_Number_Version"];
    [appleInfo setObject: getDevice_Name() forKey:@"Device_Name"];
    [appleInfo setObject: getDevice_systemVersion() forKey:@"Device_systemVersion"];
    [appleInfo setObject: getDevice_UUID() forKey:@"Device_UUID"];
    [appleInfo setObject: getDeviceModelName() forKey:@"DeviceModelName"];
    
    return appleInfo;
}

/**
 返回App以及设备信息Json字符串
 
 @return App以及设备信息Json字符串
 */
const NSString * const getAppDeviceInfoStr(void)
{
    NSMutableDictionary * appleInfo =  [NSMutableDictionary dictionary];
    [appleInfo setObject: getPackage_name() forKey:@"package_name"];
    [appleInfo setObject: getAPP_Number_Version() forKey:@"getAPP_Number_Version"];
    [appleInfo setObject: getDevice_Name() forKey:@"Device_Name"];
    [appleInfo setObject: getDevice_systemVersion() forKey:@"Device_systemVersion"];
    [appleInfo setObject: getDevice_UUID() forKey:@"Device_UUID"];
    [appleInfo setObject: getDeviceModelName() forKey:@"DeviceModelName"];
    
    NSError * parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:appleInfo options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}



