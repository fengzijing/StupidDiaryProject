//
//  UIView+addGradualLaye.h
//  DeviOSCP
//
//  Created by Dev-XiaoXiao on 2017/12/26.
//  Copyright © 2017年 Dev-XiaoXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (addGradualLaye)


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
                         endPoint: (CGPoint)endPoint;

/**
 画图imgae对象
 @return image对象
 */
- (UIImage *)convertImage;

@end
