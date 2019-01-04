//
//  JSDatePickerViewManager.m
//  JSTextVerifyTool
//
//  Created by 张永刚 on 2017/10/13.
//  Copyright © 2017年 YGZhang. All rights reserved.
//

#import "JSDatePickerViewManager.h"

#define KeyWindow    [UIApplication sharedApplication].keyWindow
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface JSDatePickerViewManager () <UIPickerViewDataSource,UIPickerViewDelegate>

/*! 当前datePicker 每一次弹出的datePicker都是全新的 */
@property (nonatomic, strong) UIDatePicker *datePicker;
/*! PickerView */
@property (nonatomic, strong) UIPickerView *pickerView;
/*! 年数组 */
@property (nonatomic, strong) NSMutableArray *yearArray;
/*! 月数组 */
@property (nonatomic, strong) NSMutableArray *monthArray;
 /*! 选中的年和月 */
@property (nonatomic, assign) NSInteger yearIndex;
@property (nonatomic, assign) NSInteger monthIndex;
/*! 日期格式化 */
@property (nonatomic, strong) NSDateFormatter *formatter;
 /*! 点击确定按钮回调 DatePicker */
@property (nonatomic, copy) JSDatePickerViewManagerBlock finishBlock;
 /*! 点击确定按钮回调 PickerView */
@property (nonatomic, copy) JSPickerViewManagerBlock pickerViewBlock;

@end

@implementation JSDatePickerViewManager

# pragma mark - DatePicker初始化
- (instancetype)initWithButtonTitleFont:(CGFloat)font dateFormat:(NSString *)dateFormat{
    if (self = [super init]) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = dateFormat;
        if (dateFormat == nil || [dateFormat isEqualToString:@""]) {
            _formatter.dateFormat = @"yyyy-MM-dd";
        }
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight/3 - 40)];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.timeZone = [NSTimeZone localTimeZone];
        [self setCommonSubview:font];
    }
    return self;
}

# pragma mark - PickerView初始化
- (instancetype)initWithButtonTitleFont:(CGFloat)font{
    if (self = [super init]) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight/3 - 40)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [self setCommonSubview:font];
    }
    return self;
}

- (void)setCommonSubview:(CGFloat)font{
    [self generateCorners];
    _coverView = [[UIView alloc] init];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0.3;
    _coverView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [KeyWindow addSubview:_coverView];
    
    self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight/3);
    self.backgroundColor = kUIColorFromRGB(0x808080);
    if (_datePicker) {
        [_pickerView removeFromSuperview];
        [self addSubview:_datePicker];
    }
    if (_pickerView) {
        [_datePicker removeFromSuperview];
        [self addSubview:_pickerView];
    }
    [KeyWindow addSubview:self];
    
    _controlBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 39.5)];
    _controlBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_controlBgView];
    
    _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commitButton.titleLabel.font = [UIFont systemFontOfSize:font];
    [_commitButton setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [_commitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    CGSize rightSize = [_commitButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}];
    CGFloat rightWidth = rightSize.width + 20;
    _commitButton.frame = CGRectMake(ScreenWidth - rightWidth, 0, rightWidth, 39.5);
    [_commitButton addTarget:self action:@selector(selectFinish) forControlEvents:UIControlEventTouchUpInside];
    [_controlBgView addSubview:_commitButton];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:font];
    [_cancelButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    CGSize leftSize = [_cancelButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}];
    CGFloat leftWidth = leftSize.width + 20;
    _cancelButton.frame = CGRectMake(0, 0, leftWidth, 39.5);
    [_cancelButton addTarget:self action:@selector(selectCancel) forControlEvents:UIControlEventTouchUpInside];
    [_controlBgView addSubview:_cancelButton];
}

- (void)generateCorners{
    CGRect bounds = CGRectMake(0, 0, ScreenWidth, ScreenHeight/3);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = bounds;
    shapeLayer.path = path.CGPath;
    self.layer.mask = shapeLayer;
    self.clipsToBounds = YES;
}

# pragma mark - 确定操作
- (void)selectFinish{
    if (_finishBlock) {
        NSString *strDate = [_formatter stringFromDate:_datePicker.date];
        _finishBlock(strDate, _datePicker.date.timeIntervalSince1970, _datePicker.date);
    }
    if (_pickerViewBlock) {
        _pickerViewBlock(_yearIndex,_monthIndex);
    }
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight/3);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_coverView removeFromSuperview];
    }];
}

# pragma mark - 取消操作
- (void)selectCancel{
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight/3);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_coverView removeFromSuperview];
    }];
}

# pragma mark - 显示datePicker
- (void)showDatePickerView:(NSString *)timestamp finishBlock:(JSDatePickerViewManagerBlock)finish{
    _finishBlock = finish;
    if (timestamp && ![timestamp isEqualToString:@""]) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp.doubleValue];
        [_datePicker setDate:date animated:YES];
    }
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = CGRectMake(0, 2*ScreenHeight/3, ScreenWidth, ScreenHeight/3);
    }];
}

# pragma mark - 设置最小date setter方法
- (void)setMinDate:(NSDate *)minDate{
    _minDate = minDate;
    _datePicker.minimumDate = _minDate;
}

# pragma mark - 设置最大date setter方法
- (void)setMaxDate:(NSDate *)maxDate{
    _maxDate = maxDate;
    _datePicker.maximumDate = _maxDate;
}

# pragma mark - 设置datePickerMode setter方法
- (void)setPickerMode:(DatePickerMode)pickerMode{
    _pickerMode = pickerMode;
    if (_pickerMode == modeTime) {
        _datePicker.datePickerMode = UIDatePickerModeTime;
    }
    if (_pickerMode == modeDate) {
        _datePicker.datePickerMode = UIDatePickerModeDate;
    }
    if (_pickerMode == modeDateAndTime) {
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
}

# pragma mark - 显示pickerView
- (void)showPickerView:(JSPickerViewManagerBlock)finish{
    _pickerViewBlock = finish;
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = CGRectMake(0, 2*ScreenHeight/3, ScreenWidth, ScreenHeight/3);
    }];
    NSCalendarUnit calenderUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:calenderUnit fromDate:[NSDate date]];
    _yearIndex = components.year;
    _monthIndex = components.month;
    _monthArray = [NSMutableArray array];
    _yearArray = [NSMutableArray array];
    for (int i = 1; i < 13; i++) {
        NSString *month = [NSString stringWithFormat:@"%d月",i];
        [_monthArray addObject:month];
    }
    for (int i = 1970; i <= 2099; i++) {
        NSString *year = [NSString stringWithFormat:@"%d年",i];
        [_yearArray addObject:year];
    }
    [self.pickerView reloadComponent:0];
    [self.pickerView reloadComponent:1];
    [self.pickerView selectRow:_yearIndex-1970 inComponent:0 animated:YES];
    [self.pickerView selectRow:_monthIndex-1 inComponent:1 animated:YES];
}

# pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return _yearArray.count;
    }else {
        return _monthArray.count;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        _yearIndex = row + 1970;
    }else{
        _monthIndex = row + 1;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    for (UIView *speartorView in pickerView.subviews) {
        if (speartorView.frame.size.height < 1) {
            speartorView.layer.borderWidth = 0.5;
            speartorView.layer.borderColor = kUIColorFromRGB(0xE6E6E6).CGColor;
            speartorView.backgroundColor = kUIColorFromRGB(0xE6E6E6);
        }
    }
    UILabel * pickerLabel = (UILabel *)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return _yearArray[row];
    }else{
        return _monthArray[row];
    }
}

- (void)dealloc{
    _datePicker = nil;
    _controlBgView = nil;
    _commitButton = nil;
    _cancelButton = nil;
    _formatter = nil;
    _finishBlock = nil;
}

@end
