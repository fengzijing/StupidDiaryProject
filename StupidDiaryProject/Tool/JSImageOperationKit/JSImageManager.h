//
//  JSImageManager.h
//  JSImageOperationKit
//
//  Created by weiwei on 2017/9/14.
//  Copyright © 2017年 created by weiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JSImageManager : NSObject
/*!
 @brief 图片拉伸
 @param capInsets    拉伸的范围
 @param origialImage 原始图片
 @return             目标图片
 */
+ (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets image:(UIImage *)origialImage;

/*!
 @brief 保存图片到相册
 */
+(void)saveToPhotosAlbum:(UIImage *)origialImage;

/*!
 @brief 截取某一个视图大小区域的图片
 @param view         原始view
 @return             目标图片
 */
+ (UIImage *)screenShoot:(UIView *)view;


/*!
 @brief 根据三基色（0-255）做滤镜效果
 @param origialImage 原始图片
 @param red          红
 @param green        绿
 @param blue         蓝
 @return             目标图片
 */
+(UIImage *)filter:(UIImage *)origialImage red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

/*!
 @brief 图片转换方向
 @param origialImage 原始图片
 @return             目标图片
 */
+(UIImage*)fixOrientation:(UIImage *)origialImage;

/*!
 @brief 将任意图片处理带圆角图片
 @remark imageViewMode = scale to fill
 @param origialImage 原始图片
 @param radius       切角度
 @return             目标图片
 */
+(UIImage *)tailorImage:(UIImage *)origialImage radius:(CGFloat)radius;

/*!
 @brief 将任意图片处理成圆形
 @param origialImage 原始图片
 @return             目标图片
 */
+(UIImage *)circleImage:(UIImage *)origialImage;

/*!
 @brief 按比例缩放图片
 @param sourceImage 原始图片
 @param size        指定图片大小
 @return            目标图片
 */
- (UIImage*)imageCompressWithSimple:(UIImage*)sourceImage scaledToSize:(CGSize)size;

/*!
 @brief 按比例缩放图片
 @param sourceImage 原始图片
 @param size        图片显示的区域
 @return            目标图片
 */
+(UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

/*!
 @brief 指定宽度按比例缩放图片
 @param sourceImage 原始图片
 @param defineWidth 指定宽度
 @return            目标图片
 */
+(UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

/*!
 @brief 由颜色生成图片
 @param color 颜色值
 @return      目标图片
 */
+(UIImage *)imageWithBgColor:(UIColor *)color;
/*!
 @brief 由颜色生成矩形纯色图片
 @param color 颜色值
 @param size  图片尺寸
 @return      目标图片
 */
+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/*!
 @brief 由颜色生成带圆角的矩形纯色图片
 @param color  颜色值
 @param size   图片尺寸
 @param radius 切角度
 @return       目标图片
 */
+ (UIImage *)drawRoundRectImageWithColor:(UIColor *)color size:(CGSize)size radius:(CGFloat)radius;

/*!
 @brief 由颜色生成圆形纯色图片
 @param color      颜色值
 @param size       图片尺寸
 @param empty      是否实心圆
 @param lineWidth  线条宽度
 @return           目标图片
 */
+ (UIImage *)drawRoundImageWithColor:(UIColor *)color lineWidth:(CGFloat)lineWidth size:(CGSize)size isEmpty:(BOOL)empty;

@end
