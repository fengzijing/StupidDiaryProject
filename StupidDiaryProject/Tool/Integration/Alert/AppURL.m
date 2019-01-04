//
//  AppURL.m
//  DeviOSCP
//
//  Created by Dev-XiaoXiao on 2017/12/18.
//  Copyright © 2017年 Dev-XiaoXiao. All rights reserved.
//

#import "AppURL.h"

static AppURL * appUrl = nil;

@implementation AppURL


/**
 单例实例化
 
 @return 单例实例化对象
 */
+ (instancetype)Manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (appUrl == nil) {
            appUrl = [[AppURL alloc]init];
        }
    });
    return appUrl;
}



@end
