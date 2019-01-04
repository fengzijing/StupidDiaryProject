//
//  NSString+Code.h
//  DeviOSCP
//
//  Created by Dev-XiaoXiao on 2017/12/18.
//  Copyright © 2017年 Dev-XiaoXiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Code)

/**
 正则验证字符(6-16字符数字组合，不区分大小写)
 
 @return 是否输入正确
 */
- (BOOL)isStringCodeWithString;

/**
 将json字符串转成字典
 
 @return 字典
 */
- (NSObject *)codeStringToDictionary;



@end
