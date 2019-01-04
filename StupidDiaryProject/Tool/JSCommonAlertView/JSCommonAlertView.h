//
//  JSCommonAlertView.h
//  JSCommonAlertView
//
//  Created by 张永刚 on 2017/11/7.
//  Copyright © 2017年 YGZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JSCommonAlertViewTextAlignment) {
    /*! 靠左排版 */
    TextAlignmentLeft,
    /*! 居中排版 */
    TextAlignmentCenter,
    /*! 靠右排版 */
    TextAlignmentRight
};

typedef NS_ENUM(NSInteger, JSCommonAlertViewButtonStyle) {
    /*! 按钮横向排列 */
    ButtonLandscapeStyle,
    /*! 按钮纵向排列 */
    ButtonVerticalStyle
};

 /*! 选择之后的回调 */
typedef void(^JSAlertViewBlock)(void);

@interface JSCommonAlertView : UIView

 /*! title，属性自定义设置 */
@property (nonatomic, strong, readonly) UILabel *titleLabel;
 /*! 下面按钮，属性自定义设置 */
@property (nonatomic, strong, readonly) NSArray <UIButton *>*buttonArray;
 /*! 背景view，属性自定义设置 */
@property (nonatomic, strong, readonly) UIView *bgView;
 /*! 第一种初始化方式的内容label数组 */
@property (nonatomic, strong) NSMutableArray <UILabel *>*tempLabelArray;
 /*! 第二种初始化方式的左边label数组 */
@property (nonatomic, strong) NSMutableArray <UILabel *>*leftLabelArray;
 /*! 第二种初始化方式的右边label数组 */
@property (nonatomic, strong) NSMutableArray <UILabel *>*rightLabelArray;

/*!
 @brief 初始化 每行只有一个label
 @param title 顶部标题
 @param textArray 内容 如果只有一条则title居中
 @param textAlignment 内容对齐方式
 @param buttonStyle 按钮排版样式
 */
- (instancetype)initWithTitle:(NSString *)title textArray:(NSArray <NSString *>*)textArray textAlignment:(JSCommonAlertViewTextAlignment)textAlignment buttonStyle:(JSCommonAlertViewButtonStyle)buttonStyle;

/*!
 @brief 初始化 每行有两个label
 @param title 顶部标题
 @param leftTextArray 左边label内容
 @param rightTextArray 右边label内容  左右边数组元素个数必须相同，否则不进行布局
 @param buttonStyle 按钮排版样式
 */
- (instancetype)initWithTitle:(NSString *)title leftTextArray:(NSArray <NSString *>*)leftTextArray rightTextArray:(NSArray <NSString *>*)rightTextArray buttonStyle:(JSCommonAlertViewButtonStyle)buttonStyle;

/*!
 @brief 添加点击事件
 @param buttonTitle 按钮标题
 @param finishBlock 完成回调
 */
- (void)addAction:(NSString *)buttonTitle finishBlock:(JSAlertViewBlock)finishBlock;

/*!
 @brief 显示弹框
 */
- (void)showAlertView;

/*!
 @brief 只有一个按钮快速调用，不用调用addAction方法
 @param buttonTitle 按钮标题
 @param sureBlock 完成回调
 */
- (void)showAlertView:(NSString *)buttonTitle sureBlock:(JSAlertViewBlock)sureBlock;

/*!
 @brief 只有两个按钮快速调用，不用调用addAction方法
 @param sureTitle 右边标题
 @param cancelTitle 左边标题
 @param sureBlock 确定回调
 @param cancelBlock 取消回调
 */
- (void)showAlertView:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle cancelBlock:(JSAlertViewBlock)cancelBlock sureBlock:(JSAlertViewBlock)sureBlock;

@end
