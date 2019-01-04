//
//  NSString+Code.m
//  DeviOSCP
//
//  Created by Dev-XiaoXiao on 2017/12/18.
//  Copyright © 2017年 Dev-XiaoXiao. All rights reserved.
//

#import "NSString+Code.h"

@implementation NSString (Code)

/**
 正则验证字符(6-16字符数字组合，不区分大小写)

 @return 是否输入正确
 */
- (BOOL)isStringCodeWithString;
{
    // 判断长度大于8位后再接着判断是否同时包含数字和字符
    NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL  result = [pred evaluateWithObject:self];
    return result;
}

/**
 将json字符串转成字典
 
 @return 字典
 */
- (NSObject *)codeStringToDictionary
{
    NSData * data = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (data != nil) {
        
        return  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    }
    return @{};
}


@end
