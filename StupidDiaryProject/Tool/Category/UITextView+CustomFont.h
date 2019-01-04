//
//  UITextView+CustomFont.h
//  Pods
//
//  Created by yky on 2017/11/17.
//

#import <UIKit/UIKit.h>

@interface UITextView (CustomFont)
/**
 字体大小
 规范：字体大小
 15
 13
 12
 10
 */
@property (nonatomic, assign) IBInspectable NSInteger FontSize;

/**
 字体颜色
 规范：字体颜色（全APP共分5种类型）：
 value    说明                                    颜色
 0        正文主体（#333333）                        —黑色
 1        说明类型文字（#808080）                     —灰色
 2        价格、状态（#eb5300）                      —橙色
 3        输入项占位字色（#b3b3b3）                   -灰色
 4        弹窗提示确定类型按钮，特殊页面按钮（#1592db）   —蓝色
 */
@property (nonatomic, assign) IBInspectable NSInteger FontColor;


/**
 添加textView placeholder占位符
 */
@property (nonatomic, copy) IBInspectable NSString* PlaceHolder;


@end
