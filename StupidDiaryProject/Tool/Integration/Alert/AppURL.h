//
//  AppURL.h
//  DeviOSCP
//
//  Created by Dev-XiaoXiao on 2017/12/18.
//  Copyright © 2017年 Dev-XiaoXiao. All rights reserved.
//

#import <Foundation/Foundation.h>
//api接口
#define APP_API @"/index.php?c=api&a=index"
// APPID
#define app_id  @"ce5ff1acc6be59143496b795d0026218"
//app密钥
#define app_secret @"ac95c966ade7906fab6295842e62d1c4"

//市场密钥
#define market_secret @"eff2981d41f7c5cf8e217a0f86ba6cec"



//WelcomeHome接口:
#define APP_TYPE_WelcomeHome @"WelcomeHome"

//注册:
#define APP_TYPE_registered  @"registered"

//登录:
#define APP_TYPE_CheckLogin  @"CheckLogin"

//更新开奖数据
#define APP_TYPE_GetLotteryData  @"GetLotteryData"

//更新开奖数据
#define APP_TYPE_GetLotteryDetailData  @"GetLotteryDetailData"



/**
 API接口
 */
@interface AppURL : NSObject

/**
 单例实例化

 @return 单例实例化对象
 */
+ (instancetype)Manager;

/**
 域名列表
 */
@property (nonatomic,strong) const NSArray * hostArrs;

/**
 当前域名：
 */
@property (nonatomic,strong) const NSString * HttpHost;




@end
