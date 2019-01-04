//
//  JSDatePickerViewManager.h
//  JSTextVerifyTool
//
//  Created by 张永刚 on 2017/10/13.
//  Copyright © 2017年 YGZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DatePickerMode) {//DatePicker选择年月日
     /*! 只有时间 */
    modeTime,
     /*! 只有日期 */
    modeDate,
     /*! 两者都有 */
    modeDateAndTime
};

/*! 点击确定按钮回调 DatePicker年月日 */
typedef void(^JSDatePickerViewManagerBlock)(NSString *dateString, CGFloat timeStamp, NSDate *selectDate);
/*! 点击确定按钮回调 PickerView只能选择年月 */
typedef void(^JSPickerViewManagerBlock)(NSInteger year, NSInteger month);

@interface JSDatePickerViewManager : UIView

/*! 确定和取消按钮下面的view */
@property (nonatomic, strong, readonly) UIView *controlBgView;
/*! 遮罩view 用来控制其他控件不可点击 */
@property (nonatomic, strong, readonly) UIView *coverView;
/*! 确定按钮 */
@property (nonatomic, strong, readonly) UIButton *commitButton;
/*! 取消按钮 */
@property (nonatomic, strong, readonly) UIButton *cancelButton;
/*! 最小日期 DatePicker */
@property (nonatomic, strong) NSDate *minDate;
/*! 最大日期 可以不赋值 DatePicker */
@property (nonatomic, strong) NSDate *maxDate;
/*! 日期显示格式 默认格式:2016-12-10 DatePicker */
@property (nonatomic, assign) DatePickerMode pickerMode;

/*!
 @brief DatePicker初始化 可以选择年月日时分秒
 @param font 按钮字体大小
 @param dateFormat 格式化形式 传空时默认为:@"yyyy-MM-dd"
 */
- (instancetype)initWithButtonTitleFont:(CGFloat)font dateFormat:(NSString *)dateFormat;

/*!
 @brief pickerView初始化 只能选择年月
 @param font 按钮字体大小
 */
- (instancetype)initWithButtonTitleFont:(CGFloat)font;

/*!
 @brief 显示DatePickerViewManager 可以选择年月日时分秒的show方法
 @param timestamp 为上一次选择的时间戳，首次调用该方法时，如果传的是空，则在代理中<将要出现时>会返回minDate日期，不为空则返回对应的日期
 @param finish 点击确定按钮回调
 */
- (void)showDatePickerView:(NSString *)timestamp finishBlock:(JSDatePickerViewManagerBlock)finish;

/*!
 @brief PickerViewManager 只能选择年月的show方法
 */
- (void)showPickerView:(JSPickerViewManagerBlock)finish;

@end
