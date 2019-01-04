//
//  JSPictureManager.h
//  MatchingPlatform
//
//  Created by nuomi on 16/3/21.
//  Copyright © 2016年 alan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSPictureManager : NSObject
///判断是否支持相机
+ (BOOL)isSourceCameraAvailable;
///判断是否支持相册
+ (BOOL)isSourceAlbumAvailable;
///判断是否支持图片库
+ (BOOL)isSourcePhotoLibraryAvailable;
///获取相册照片
- (BOOL)getPictureFromeAlbumInViewController:(__weak UIViewController *)controller block:(void (^)(NSArray *images,NSString *errorStr))block;
- (BOOL)getPictureInViewController:(__weak UIViewController *)controller block:(void (^)(NSArray *images,NSString *errorStr))block;
///从相机获得照片
- (BOOL)getPictureFromeCameraInViewController:(__weak UIViewController *)controller block:(void (^)(NSArray *images,NSString *errorStr))block;
///获得多张相册照片
- (BOOL)getMultiplePictureInViewController:(__weak UIViewController *)controller count:(long )count block:(void (^)(NSArray <UIImage *>*images,NSString *errorStr))block;
@end
