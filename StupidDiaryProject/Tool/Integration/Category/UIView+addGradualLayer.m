//
//  UIView+addGradualLaye.m
//  DeviOSCP
//
//  Created by Dev-XiaoXiao on 2017/12/26.
//  Copyright © 2017年 Dev-XiaoXiao. All rights reserved.
//

#import "UIView+addGradualLayer.h"

@implementation UIView (addGradualLayer)

/**
 添加渐变色:
 
 @param colors 颜色数组
 @param frame 渐变layer大小
 @param startPoint 开始点(0~1)
 @param endPoint 结束点(0~1)
 */
- (void)addGradualLayerWithColors: (NSArray *)colors
                       layerframe: (CGRect)frame
                       startPoint: (CGPoint)startPoint
                         endPoint: (CGPoint)endPoint
{
    CAGradientLayer *_gradientLayer = [CAGradientLayer layer];
    _gradientLayer.startPoint = startPoint;//第一个颜色开始渐变的位置
    _gradientLayer.endPoint = endPoint;//最后一个颜色结束的位置
    _gradientLayer.frame = frame;//设置渐变图层的大小
    _gradientLayer.colors = colors;
    [self.layer insertSublayer:_gradientLayer atIndex:0];
}


/**
 画图imgae对象
 
 @return image对象
 */
- (UIImage *)convertImage
{
    CGSize s = self.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
