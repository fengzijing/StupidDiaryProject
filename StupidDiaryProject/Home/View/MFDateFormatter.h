//
//  MFDateFormatter.h
//  Mfate
//
//  Created by 施胜强 on 2018/11/28.
//  Copyright © 2018年 施胜强. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFDateFormatter : NSObject

+ (instancetype)share;

/*
 *  根据传入的日期格式转换日期
 */
- (NSString *)stringOfDate:(NSDate *)date format:(NSString *)format;

- (NSDate *)dateOfString:(NSString *)dateStr format:(NSString *)format;

/**
 周几
 */
- (NSString *)weekDayOfDate:(NSString *)dateStr dateFormatter:(NSString *)formatter;

@end

NS_ASSUME_NONNULL_END
