//
//  JSLocalStorageKit.h
//  JSLocalStorageKit
//
//  Created by weiwei on 2017/9/18.
//  Copyright © 2017年 created by weiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @brief 存储的方式
 */
typedef NS_ENUM(NSInteger,JSLocalStorageType){
    
    JSLocalStorageTypeUserDefault,
    JSLocalStorageTypeKeyChain,
};

@interface JSLocalStorageKit : NSObject
/*!
 @brief 存
 @param data 要存储的数据
 @param key  存储的标识key
 @param type 存储的方式
 */
+ (void)save:(id)data forKey:(NSString *)key localStorageType:(JSLocalStorageType)type;
/*!
 @brief 取
 @param  key  存储的标识key
 @param  type 存储的方式
 @return id   取存储的值
 */
+ (id)queryForKey:(NSString *)key localStorageType:(JSLocalStorageType)type;
/*!
 @brief 删
 @param key  存储的标识key
 @param type 存储的方式
 */
+ (void)deleteForkey:(NSString *)key localStorageType:(JSLocalStorageType)type;


@end
