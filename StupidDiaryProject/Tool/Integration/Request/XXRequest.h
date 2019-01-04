//
//  XXRequest.h
//  DeviOSCP
//
//  Created by Dev-XiaoXiao on 2017/12/11.
//  Copyright © 2017年 Dev-XiaoXiao. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void(^successBlock)(NSObject * successData);

typedef void(^failBlock)(NSObject * failError);

typedef void(^progressBlock)(NSProgress * progress);


/** 网络状态 */
typedef enum : NSUInteger {
    
    //2G网络
    NetworkStatusType2G = 1,
    
    //3G网络
    NetworkStatusType3G = 2,
    
    //4G网络
    NetworkStatusType4G = 3,
    
    //LTE网络
    NetworkStatusTypeLTE = 4,
    
    //WIFI网络
    NetworkStatusTypeWIFI = 5,
    
    //手机网络
    NetworkStatusTypePhone = 6,
    
    //网络不可用
    NetworkStatusTypeNotReachable = 0,
    
} NetworkStatusType;

/**
 网络状态回调
 
 @param type 当前回调
 */
typedef void(^statusBlock)(NetworkStatusType type);

/**
 请求数据基类
 */
@interface XXRequest : NSObject


/**
 初始化请求类

 @return 当前类实例化对象
 */
+ (instancetype)RequestManager;

/**
 Get 请求
 
 @param urlStr URL地址
 @param body 包体内容
 @param progressblock 请求进度
 @param successblock 数据请求成功的回调
 @param failblock 数据请求失败的回调
 */
- (void)GetRequestDataWithUrlStr: (NSString *)urlStr
                            body: (NSObject *)body
                   progressBlock: (progressBlock)progressblock
                         success: (successBlock)successblock
                            fail: (failBlock)failblock;

/**
 Post 请求
 
 @param urlStr URL地址
 @param body 包体内容
 @param progressblock 请求进度
 @param successblock 数据请求成功的回调
 @param failblock 数据请求失败的回调
 */
- (void)PostRequestDataWithUrlStr: (NSString *)urlStr
                             body: (NSObject *)body
                    progressBlock: (progressBlock)progressblock
                          success: (successBlock)successblock
                             fail: (failBlock)failblock;

/**
 获取网络状态
 */
+(NetworkStatusType )GETNetworkStatus;




/**
 当前网络状态，实时监控
 
 @param block 状态回调
 */
- (void)PusNetworkStatusTypeBlock: (statusBlock)block;

@end
