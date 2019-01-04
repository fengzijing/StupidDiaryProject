//
//  JSFastLoginModel.h
//  MatchingPlatform
//
//  Created by nuomi on 2016/12/19.
//  Copyright © 2016年 alan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSFastLoginModel : NSObject<NSCoding>


/*!
 模式
 */
@property(copy,nonatomic) NSString* class_model;

/*!
 年月日小时分钟
 */
@property(copy,nonatomic) NSString* class_date;

/*!
 添加时间年
 */
@property(copy,nonatomic) NSString* class_year;

/*!
 添加时间月
 */
@property(copy,nonatomic) NSString* class_month;

/*!
 写日记时间日
 */
@property(copy,nonatomic) NSString* class_day;

/*!
 写日记时间小时分钟
 */
@property(copy,nonatomic) NSString* class_hour;

/*!
 写日记时间周
 */
@property(copy,nonatomic) NSString* class_week;
/*!
 金额
 */
@property(copy,nonatomic) NSString* class_amount;
/*!
 时长
 */
@property(copy,nonatomic) NSString* class_timeLength;
/*!
 手数
 */
@property(copy,nonatomic) NSString* class_number;
/*!
 备注
 */
@property(copy,nonatomic) NSString* class_note;



- (instancetype)init;
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (instancetype)initWithCoder:(NSCoder *)aDecoder;

@end
