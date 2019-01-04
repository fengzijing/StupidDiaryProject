//
//  JSCommonAlertView.m
//  JSCommonAlertView
//
//  Created by 张永刚 on 2017/11/7.
//  Copyright © 2017年 YGZhang. All rights reserved.
//

#import "JSCommonAlertView.h"

#define key_window           [UIApplication sharedApplication].delegate.window
#define kScreenWidth         [UIScreen mainScreen].bounds.size.width
#define kScreenHeight        [UIScreen mainScreen].bounds.size.height
#define AlertViewMaxWidth    kScreenWidth*0.67
#define ContentViewMaxWidth  AlertViewMaxWidth - 30
#define ContentTopMargin     20
#define ContentBottomMargin  20

#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kFontStyle [UIFont fontWithName:@"Microsoft YaHei" size:13.0f]

@interface JSCommonAlertView ()

 /*! 按钮数组 */
@property (nonatomic, strong) NSMutableArray <UIButton *>*tempButtonArray;
 /*! 第一种初始化方式的内容数组 */
@property (nonatomic, copy) NSArray *textArray;
/*! 左边内容数组 */
@property (nonatomic, copy) NSArray *leftTextArray;
/*! 右边内容数组 */
@property (nonatomic, copy) NSArray *rightTextArray;
 /*! 标题 */
@property (nonatomic, copy) NSString *title;
 /*! 内容居中方式 */
@property (nonatomic, assign) JSCommonAlertViewTextAlignment textAlignment;
 /*! 按钮排列样式 */
@property (nonatomic, assign) JSCommonAlertViewButtonStyle buttonStyle;
/*! 内容高度 */
@property (nonatomic, assign) CGFloat contentHeight;
/*! 回调的block数组，与addAction方法绑定 */
@property (nonatomic, strong) NSMutableArray *finishBlockArray;

@end

@implementation JSCommonAlertView

# pragma mark - 初始化1
- (instancetype)initWithTitle:(NSString *)title textArray:(NSArray<NSString *> *)textArray textAlignment:(JSCommonAlertViewTextAlignment)textAlignment buttonStyle:(JSCommonAlertViewButtonStyle)buttonStyle {
    if (self = [super init]) {
        _tempLabelArray = [NSMutableArray array];
        _tempButtonArray = [NSMutableArray array];
        _finishBlockArray = [NSMutableArray array];
        _textArray = textArray;
        _title = title;
        _textAlignment = textAlignment;
        _buttonStyle = buttonStyle;
        _bgView = [[UIView alloc] init];
        _bgView.frame = key_window.bounds;
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.5;
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
        [self layoutFirstStyleAlertViewSubviews];
    }
    return self;
}

# pragma mark - 初始化2
- (instancetype)initWithTitle:(NSString *)title leftTextArray:(NSArray<NSString *> *)leftTextArray rightTextArray:(NSArray<NSString *> *)rightTextArray buttonStyle:(JSCommonAlertViewButtonStyle)buttonStyle{
    if (self = [super init]) {
        if (leftTextArray.count != rightTextArray.count) {
            return self;
        }
        _leftLabelArray = [NSMutableArray array];
        _rightLabelArray = [NSMutableArray array];
        _leftTextArray = leftTextArray;
        _rightTextArray = rightTextArray;
        _tempButtonArray = [NSMutableArray array];
        _finishBlockArray = [NSMutableArray array];
        _title = title;
        _buttonStyle = buttonStyle;
        _bgView = [[UIView alloc] init];
        _bgView.frame = key_window.bounds;
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.5;
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
        [self layoutSecondStyleAlertViewSubviews];
    }
    return self;
}

# pragma mark - 布局第一种初始化方式子视图，不包括按钮
- (void)layoutFirstStyleAlertViewSubviews{
    if (_title.length != 0) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, ContentTopMargin, ContentViewMaxWidth, 20)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = kUIColorFromRGB(0x333333);
        _titleLabel.font = [UIFont fontWithName:@"Microsoft YaHei" size:15.0f];
        _titleLabel.text = _title;
        [self addSubview:_titleLabel];
    }
    
    for (int i = 0; i < _textArray.count; i++) {
        NSString *content = _textArray[i];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName,nil, NSForegroundColorAttributeName,nil];
        paragraph.lineBreakMode = NSLineBreakByCharWrapping;//适配中英文结合
        CGSize size = [content boundingRectWithSize:CGSizeMake(ContentViewMaxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary context:nil].size;
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kUIColorFromRGB(0x333333);
        label.font = kFontStyle;
        label.text = content;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.tag = i+1;
        if (_textAlignment == TextAlignmentLeft) {
            label.textAlignment = NSTextAlignmentLeft;
        }else if (_textAlignment == TextAlignmentCenter){
            label.textAlignment = NSTextAlignmentCenter;
        }else{
            label.textAlignment = NSTextAlignmentRight;
        }
        [self addSubview:label];
        [self layoutLabels:label height:size.height];
        [_tempLabelArray addObject:label];
    }
    
    if (_tempLabelArray.count == 0) {
        _contentHeight = ContentTopMargin + ContentBottomMargin + 30;
    }else{
        UILabel *lastLabel = _tempLabelArray.lastObject;
        _contentHeight = CGRectGetMaxY(lastLabel.frame) + ContentBottomMargin;
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _contentHeight, AlertViewMaxWidth, 0.5)];
    lineView.backgroundColor = kUIColorFromRGB(0xCCCCCC);
    [self addSubview:lineView];
}

- (void)layoutLabels:(UILabel *)label height:(CGFloat)height{
    CGFloat textSpace = 5;
    if (label.tag == 1) {
        if (_title.length != 0) {
            label.frame = CGRectMake(15, 50, ContentViewMaxWidth, height);
        }else{
            label.frame = CGRectMake(15, 20, ContentViewMaxWidth, height);
        }
    }else{
        UILabel *lastLabel = (UILabel *)[self viewWithTag:label.tag - 1];
        CGFloat last_max_y = CGRectGetMaxY(lastLabel.frame);
        label.frame = CGRectMake(15, last_max_y+textSpace, ContentViewMaxWidth, height);
    }
}

# pragma mark - 布局第二种初始化方式子视图，不包括按钮
- (void)layoutSecondStyleAlertViewSubviews{
    if (_title.length != 0) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, ContentTopMargin, ContentViewMaxWidth, 20)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = kUIColorFromRGB(0x333333);
        _titleLabel.font = [UIFont fontWithName:@"Microsoft YaHei" size:15.0f];
        _titleLabel.text = _title;
        [self addSubview:_titleLabel];
    }
    //选择左边内容最长的
    NSMutableArray *widthArray = [NSMutableArray array];
    for (NSString *text in _leftTextArray) {
        CGFloat width = [text sizeWithAttributes:@{NSFontAttributeName:kFontStyle}].width;
        [widthArray addObject:@(width)];
    }
    NSArray *sortedArray = [widthArray sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        if ([obj1 doubleValue] <= [obj2 doubleValue]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    CGFloat max_width = [sortedArray.firstObject doubleValue];
    for (int i = 0; i < _rightTextArray.count; i++) {
        NSString *content = _rightTextArray[i];
        //1是左右文字之间距离
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByCharWrapping;//适配中英文结合
        CGSize size = [content boundingRectWithSize:CGSizeMake(ContentViewMaxWidth-max_width-1, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontStyle, NSParagraphStyleAttributeName:paragraph} context:nil].size;
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kUIColorFromRGB(0x333333);
        label.font = kFontStyle;
        label.text = content;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.tag = i+1;
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
        [self layoutSecondStyleLabels:label height:size.height leftMargin:max_width];
        [_rightLabelArray addObject:label];
    }
    
    if (_rightLabelArray.count == 0) {
        _contentHeight = ContentTopMargin + ContentBottomMargin + 30;
    }else{
        UILabel *lastLabel = _rightLabelArray.lastObject;
        _contentHeight = CGRectGetMaxY(lastLabel.frame) + ContentBottomMargin;
    }
    
    [self layoutLeftLabels:max_width];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _contentHeight, AlertViewMaxWidth, 0.5)];
    lineView.backgroundColor = kUIColorFromRGB(0xCCCCCC);
    [self addSubview:lineView];
}

- (void)layoutSecondStyleLabels:(UILabel *)label height:(CGFloat)height leftMargin:(CGFloat)leftMargin{
    CGFloat textSpace = 5;
    if (label.tag == 1) {
        if (_title.length != 0) {
            label.frame = CGRectMake(leftMargin+15+1, 50, ContentViewMaxWidth-leftMargin-1, height);
        }else{
            label.frame = CGRectMake(leftMargin+15+1, 20, ContentViewMaxWidth-leftMargin-1, height);
        }
    }else{
        UILabel *lastLabel = (UILabel *)[self viewWithTag:label.tag - 1];
        CGFloat last_max_y = CGRectGetMaxY(lastLabel.frame);
        label.frame = CGRectMake(leftMargin+15+1, last_max_y+textSpace, ContentViewMaxWidth-leftMargin-1, height);
    }
}

- (void)layoutLeftLabels:(CGFloat)max_width{
    for (int i = 0; i < _rightLabelArray.count; i++) {
        UILabel *rightLabel = _rightLabelArray[i];
        CGFloat y = rightLabel.frame.origin.y;
        NSString *content = _leftTextArray[i];
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kUIColorFromRGB(0x333333);
        label.font = kFontStyle;
        label.text = content;
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentRight;
        CGFloat height = [content sizeWithAttributes:@{NSFontAttributeName:kFontStyle}].height;
        label.frame = CGRectMake(15, y, max_width, height);
        [self addSubview:label];
    }
}

# pragma mark - 添加点击事件
- (void)addAction:(NSString *)buttonTitle finishBlock:(JSAlertViewBlock)finishBlock{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = kFontStyle;
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_tempButtonArray addObject:button];
    [_finishBlockArray addObject:finishBlock];
    [self addSubview:button];
    [self setButtonTitleColorAndFrame];
}

# pragma mark - 设置按钮颜色和frame
- (void)setButtonTitleColorAndFrame{
    if (_tempButtonArray.count == 0) {
        return;
    }
    if (_tempButtonArray.count == 1) {
        [_tempButtonArray.firstObject setTitleColor:kUIColorFromRGB(0x1592db) forState:UIControlStateNormal];
        _tempButtonArray.firstObject.frame = CGRectMake(0, _contentHeight, AlertViewMaxWidth, 35);
    }else if (_tempButtonArray.count == 2){
        if (_buttonStyle == ButtonLandscapeStyle) {
            [_tempButtonArray[0] setTitleColor:kUIColorFromRGB(0x6c6c6c) forState:UIControlStateNormal];
            [_tempButtonArray[1] setTitleColor:kUIColorFromRGB(0x1592db) forState:UIControlStateNormal];
            _tempButtonArray[0].frame = CGRectMake(0, _contentHeight, AlertViewMaxWidth/2, 35);
            _tempButtonArray[1].frame = CGRectMake(AlertViewMaxWidth/2, _contentHeight, AlertViewMaxWidth/2, 35);
            [self setButtonLandScapeLine:_tempButtonArray[0]];
        }else{
            [_tempButtonArray[0] setTitleColor:kUIColorFromRGB(0x1592db) forState:UIControlStateNormal];
            [_tempButtonArray[1] setTitleColor:kUIColorFromRGB(0x6c6c6c) forState:UIControlStateNormal];
            _tempButtonArray[0].frame = CGRectMake(0, _contentHeight, AlertViewMaxWidth, 35);
            _tempButtonArray[1].frame = CGRectMake(0, _contentHeight+35, AlertViewMaxWidth, 35);
            [self setButtonVerticalLine:_tempButtonArray[1]];
        }
    }else{
        if (_buttonStyle == ButtonLandscapeStyle) {
            for (int i = 0; i < _tempButtonArray.count; i++) {
                CGFloat buttonWidth = AlertViewMaxWidth/_tempButtonArray.count;
                UIButton *button = _tempButtonArray[i];
                [button setTitleColor:kUIColorFromRGB(0x1592db) forState:UIControlStateNormal];
                button.frame = CGRectMake(i*buttonWidth, _contentHeight, buttonWidth, 35);
                if (i != _tempButtonArray.count - 1) {
                    [self setButtonLandScapeLine:_tempButtonArray[i]];
                }
            }
        }else{
            for (int i = 0; i < _tempButtonArray.count; i++) {
                UIButton *button = _tempButtonArray[i];
                button.frame = CGRectMake(0, _contentHeight+i*35, AlertViewMaxWidth, 35);
                if (i != 0) {
                    [self setButtonVerticalLine:_tempButtonArray[i]];
                }
                if (i == _tempButtonArray.count - 1) {
                    [button setTitleColor:kUIColorFromRGB(0x6c6c6c) forState:UIControlStateNormal];
                }else{
                    [button setTitleColor:kUIColorFromRGB(0x1592db) forState:UIControlStateNormal];
                }
            }
        }
    }
}

# pragma mark - 绘制横向排版按钮的灰色线
- (void)setButtonLandScapeLine:(UIButton *)button{
    for (CALayer *layer in button.layer.sublayers) {
        if (layer.frame.size.width == 0.5) {
            [layer removeFromSuperlayer];
        }
    }
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(button.frame.size.width, 0, 0.5, 35);
    layer.backgroundColor = kUIColorFromRGB(0xCCCCCC).CGColor;
    [button.layer addSublayer:layer];
}

# pragma mark - 绘制纵向排版按钮的灰色线
- (void)setButtonVerticalLine:(UIButton *)button{
    for (CALayer *layer in button.layer.sublayers) {
        if (layer.frame.size.height == 0.5) {
            [layer removeFromSuperlayer];
        }
    }
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, button.frame.size.width, 0.5);
    layer.backgroundColor = kUIColorFromRGB(0xCCCCCC).CGColor;
    [button.layer addSublayer:layer];
}

# pragma mark - 显示弹窗
- (void)showAlertView{
    CGFloat alertViewHeight = 0;
    if (_buttonStyle == ButtonLandscapeStyle) {
        alertViewHeight = _contentHeight+35;
    }else{
        alertViewHeight = _contentHeight+_tempButtonArray.count*35;
    }
    if (_tempButtonArray.count == 0) {
        alertViewHeight = _contentHeight;
    }
    
    self.frame = CGRectMake(0, 0, AlertViewMaxWidth, alertViewHeight);
    self.center = key_window.center;
    [self startAnimationAlert];
    
    [key_window addSubview:_bgView];
    [key_window addSubview:self];
}

# pragma mark - 开启动画
- (void)startAnimationAlert{
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.5;
    popAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 0.01f)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.values = values;
    
    [self.layer addAnimation:popAnimation forKey:nil];
}

# pragma mark - 点击按钮
- (void)clickButton:(UIButton *)sender{
    NSInteger index = [_tempButtonArray indexOfObject:sender];
    JSAlertViewBlock finishBlock;
    if (_finishBlockArray.count > index) {
        finishBlock = _finishBlockArray[index];
    }
    if (finishBlock) {
        finishBlock();
    }
    [self.layer removeAllAnimations];
    [_bgView removeFromSuperview];
    [self removeFromSuperview];
}

- (NSArray<UIButton *> *)buttonArray{
    return _tempButtonArray;
}

# pragma mark - 只有一个按钮快速调用，不用调用addAction方法
- (void)showAlertView:(NSString *)buttonTitle sureBlock:(JSAlertViewBlock)sureBlock{
    [self addAction:buttonTitle finishBlock:sureBlock];
    [self showAlertView];
}

# pragma mark - 只有两个按钮快速调用，不用调用addAction方法
- (void)showAlertView:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle cancelBlock:(JSAlertViewBlock)cancelBlock sureBlock:(JSAlertViewBlock)sureBlock{
    [self addAction:cancelTitle finishBlock:cancelBlock];
    [self addAction:sureTitle finishBlock:sureBlock];
    [self showAlertView];
}

- (void)dealloc{
    _bgView = nil;
    _titleLabel = nil;
    _tempLabelArray = nil;
    _tempButtonArray = nil;
    _textArray = nil;
    _finishBlockArray = nil;
    _leftTextArray = nil;
    _rightTextArray = nil;
    _leftLabelArray = nil;
    _rightLabelArray = nil;
}

@end
