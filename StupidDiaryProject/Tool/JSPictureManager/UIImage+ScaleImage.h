//
//  UIImage+ScaleImage.h
//  JSFPictureManager
//
//  Created by nuomi on 2017/9/15.
//  Copyright © 2017年 jsf. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIImage (ScaleImage)

+ (UIImage*)image:(UIImage *)image ByScalingAndCroppingForSize:(CGSize)targetSize;

- (UIImage *)scaleImageToSize:(CGSize)newSize;

@end
