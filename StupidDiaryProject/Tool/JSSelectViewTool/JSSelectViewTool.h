//
//  JSSelectViewTool.h
//  JSFAddressSelect
//
//  Created by nuomi on 2017/11/21.
//  Copyright © 2017年 jsf. All rights reserved.
//

#define isEmpytLabelOrField(str) str==nil?@"":[str isEqual:[NSNull null]]?@"":str

#import <UIKit/UIKit.h>
#import "DefineHeader.h"

typedef NS_ENUM(NSInteger, CurrentUseTool) {
    CurrentUseAddress = 66,//地址选择
    CurrentUseSingle,//单行选择
    CurrentUseMonthAndDay//月和天(银行选择日期)
};

@interface JSSelectViewTool : UIView<NSXMLParserDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
/*地址选择的确认返回*/
typedef void(^CityBlock)(NSString * cityStr,NSString * areStr);
/*地址选择编码的确认返回*/
typedef void(^CityCodeBlock)(NSString * cityStr,NSString * provinceCode,NSString * cityCode,NSString * areCode);
/*银行日期选择*/
typedef void(^DateBlock)(NSString * monthStr,NSString * yearsStr);
/*最底部半透明视图*/
@property (nonatomic, strong)UIView * bgView;
/*window点击手势*/
@property (nonatomic, strong)UITapGestureRecognizer * tap;
/*放置‘确认’和‘取消’的视图*/
@property (nonatomic, strong)UIView * topView;
/*‘取消’视图*/
@property (nonatomic, strong) UIButton * leftBtn;
/*‘确认’视图*/
@property (nonatomic, strong) UIButton * rightBtn;
/*放置滚动视图的视图*/
@property (nonatomic, strong)UIView * bottomView;
/*滚动视图*/
@property (nonatomic, strong)UIPickerView * pickerView;
/*滚动视图上面的线*/
@property (nonatomic, strong) UIView * lineView;
/*城市选择回执*/
@property (nonatomic, strong)CityBlock myBlock;
/*城市选择编码回执*/
@property (nonatomic, strong)CityCodeBlock codeBlock;
/*城市选择回执*/
@property (nonatomic, strong)DateBlock dateBlock;
/*判断当前使用的类型（地址选择或单行选择或双行选择）*/
@property (nonatomic, assign) CurrentUseTool selectType;
/*数据源数组*/
@property (nonatomic,strong) NSMutableArray * dataArray;
/*确定键回调函数*/
@property (nonatomic,copy) void(^callBackBlock)(id obj,NSInteger currentIndex);
/*取消键回调函数*/
@property (nonatomic,copy) void(^cancelBlock)(void);

/*!
 @brief 单例获取对象
 @discussion  获取对象
 @code
 @remark
 @return
 */
+ (JSSelectViewTool *)sharedManager;

/*!
 @brief 所在地选择
 @discussion 所在地选择（省市区）
 @code  void(^jumpBlock)(NSString * cityStr,NSString * areStr)
 @remark
 @param block  包含： cityStr：城市名称  areStr：城市代码
 @return
 */
- (void)getCityFromPickerView:(CityBlock)block;

/*!
 @brief 所在地选择
 @discussion 所在地选择（省市区）
 @code  typedef void(^CityCodeBlock)(NSString * cityStr,NSString * provinceCode,NSString * cityCode,NSString * areCode)
 @remark
 @param block  包含： cityStr：城市名称  provinceCode：省编码 cityCode是编码 areStr：区编码
 @return
 */
- (void)getCityAndCodeFromPickerView:(CityCodeBlock)block;

/*!
 @brief 单行选择器
 @discussion 输入一个数组生成一个选择器
 @code
 @remark
 @param dataArray  一个可变数组 数组元素要是NSString类型
 @param currentIndex  要定位到的某一行
 @param (void(^)(void))cancelBlock  选择失败
 @param (void(^)(id obj,NSInteger currentIndex))confirmBlock  选择成功：obj:获取的元素currentIndex：最后选择的行
 @return
 */
-(void)inpour:(NSMutableArray *)dataArray currentIndexd:(NSInteger)currentIndex confirmBlock:(void(^)(id obj,NSInteger currentIndex))confirmBlock cancelBlock:(void(^)(void))cancelBlock;

/*!
 @brief 银行卡日期的选择
 @discussion 银行卡日期的选择（年和月）
 @code  void(^DateBlock)(NSString * monthStr,NSString * yearsStr)
 @remark
 @param block  monthStr：月  yearsStr：年
 @return
 */
- (void)getdateFromPickerView:(DateBlock)block;

@end
