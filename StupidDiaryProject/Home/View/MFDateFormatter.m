//
//  MFDateFormatter.m
//  Mfate
//
//  Created by 施胜强 on 2018/11/28.
//  Copyright © 2018年 施胜强. All rights reserved.
//

#import "MFDateFormatter.h"

#define weekDayArr @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"]

@implementation MFDateFormatter

static MFDateFormatter *formatter = nil;

+ (instancetype)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!formatter) {
            formatter = [[MFDateFormatter alloc] init];
        }
    });
    
    return formatter;
}

- (NSString *)stringOfDate:(NSDate *)date format:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

- (NSDate *)dateOfString:(NSString *)dateStr format:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:dateStr];
}

- (NSString *)weekDayOfDate:(NSString *)dateStr dateFormatter:(NSString *)formatter{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    [dateFormatter setDateFormat:formatter];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    calendar.locale = [NSLocale currentLocale];
    comps = [calendar components:unitFlags fromDate:date];
    return weekDayArr[[comps weekday] - 1];
}

@end
