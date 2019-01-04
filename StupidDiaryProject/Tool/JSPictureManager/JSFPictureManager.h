//
//  JSFPictureManager.h
//  JSFPictureManager
//
//  Created by nuomi on 2017/9/14.
//  Copyright © 2017年 jsf. All rights reserved.
//

#define AppRootView  ([[[[[UIApplication sharedApplication] delegate] window] rootViewController] view])
#define AppRootViewController  ([[[[UIApplication sharedApplication] delegate] window] rootViewController])

#define kALERTTITLE @"设置图像"
#define kNOTSUPPORTCAMERAL @"设备不支持访问相机，请在设置->隐私->相机中进行设置！"
#define kNOTSUPPORTALBUM @"设备不支持访问相册，请在设置->隐私->照片中进行设置！"
#define kNOTSUPPORTGALLERY @"设备不支持访问图片库，请在设置->隐私->照片中进行设置！"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import <Photos/PHPhotoLibrary.h>

typedef void (^getPictureBlock)(UIImage *image);

typedef void (^getMultiplePictureBlock)(NSMutableArray <UIImage *>*images,NSString *errorStr);

@interface JSFPictureManager : NSObject<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,copy)getPictureBlock pictureBlock;

@property (nonatomic,copy)getMultiplePictureBlock multiplePictureBlock;


/*!
 @brief 单例
 @discussion  单例
 @code
 @param
 @remark
 */
+ (JSFPictureManager *)sharedManager;

/*!
 @brief 选择一张照片(可以选择获取图片的方法（相机/相册/图片库））
 @discussion  只能选择一张图片（可以从三个位置选择：1.图片库2.相册3.相机）
 @code
 @param block 选择图片后block返回的image
 @param
 @remark
 */
+ (void)shareGetPicture:(getPictureBlock)block;

/*!
 @brief 选择相机
 @discussion  从相机选择一张图片
 @code
 @param block 选择图片后block返回的image
 @param
 @remark
 */
- (void)getPictureFromCamera :(getPictureBlock)block;

/*!
 @brief 选择相册
 @discussion  从相册选择一张图片
 @code
 @param block 选择图片后block返回的image
 @param
 @remark
 */
- (void)getPictureFromAlbum:(getPictureBlock)block;

/*!
 @brief 选择图片库
 @discussion  从图片库选择一张图片
 @code
 @param block 选择图片后block返回的image
 @param
 @remark
 */
- (void)getPictureFromGallery:(getPictureBlock)block;

/*!
 @brief 选择多张照片
 @discussion  从图片库选择多张图片（最多选9张）
 @code
 @param block 选择图片后block返回的image
 @param count 已经选中的图片张数（需要把已经选择的图片张数加上否则选择的图片会多余9张）第一次选择count=0
 比如；count=5 这样你还可以选4张图片
 @remark
 */
- (void)getMultiplePictureInViewController:(__weak UIViewController *)controller count:(NSInteger)count block:(getMultiplePictureBlock)block;




@end
