//
//  NSDictionary+codeString.m
//  DeviOSCP
//
//  Created by Dev-XiaoXiao on 2017/12/18.
//  Copyright © 2017年 Dev-XiaoXiao. All rights reserved.
//

#import "NSDictionary+codeString.h"

@implementation NSDictionary (codeString)


/**
 将字典转成json字符串
 
 @return json字符串
 */
- (NSString *)codeDictionaryToString
{
    NSError * parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    if (jsonData != nil) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return @"";
 
}

@end
