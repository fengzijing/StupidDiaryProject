//
//  NSDictionary+codeString.h
//  DeviOSCP
//
//  Created by Dev-XiaoXiao on 2017/12/18.
//  Copyright © 2017年 Dev-XiaoXiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (codeString)


/**
 将字典转成json字符串

 @return json字符串
 */
- (NSString *)codeDictionaryToString;

@end
