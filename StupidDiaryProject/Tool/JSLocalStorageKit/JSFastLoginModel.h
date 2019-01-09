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
 年月日小时分钟
 */
@property(copy,nonatomic) NSString* class_date;

/*!
 写日记时间日
 */
@property(copy,nonatomic) NSString* class_second;

/*!
 写日记时间小时分钟
 */
@property(copy,nonatomic) NSString* class_hour;

/*!
 写日记时间周
 */
@property(copy,nonatomic) NSString* class_week;

/*!
 备注
 */
@property(copy,nonatomic) NSString* class_note;



- (instancetype)init;
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (instancetype)initWithCoder:(NSCoder *)aDecoder;

@end
