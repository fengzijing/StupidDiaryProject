//
//  JSPictureManager.m
//  MatchingPlatform
//
//  Created by nuomi on 16/3/21.
//  Copyright © 2016年 alan. All rights reserved.
//

#import "JSPictureManager.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import <AssetsLibrary/AssetsLibrary.h>

//#import "UIImage+MCAdditions.h"
typedef void (^PicturePicekerBlock)(NSArray *images,NSString *errorStr);

@interface JSPictureManager ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>{
    
    
}
@property (copy, nonatomic) PicturePicekerBlock callBackBlock;
@property (strong,nonatomic) TZImagePickerController * elcPicker;
/*!<#Description#>*/
@property(strong,nonatomic) dispatch_semaphore_t semaph;
@end
@implementation JSPictureManager

+ (BOOL)isSourceCameraAvailable{
    return  [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
+ (BOOL)isSourceAlbumAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}
+ (BOOL)isSourcePhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)getPictureFromeAlbumInViewController:(UIViewController *)controller block:(void (^)(NSArray *images,NSString *errorStr))block{
    if (![JSPictureManager isSourceAlbumAvailable]) {
        block(nil,@"无法访问相册");
        return FALSE;
    }
    self.callBackBlock = block;
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.delegate = self;
    picker.sourceType = sourcheType;
    [controller presentViewController:picker animated:YES completion:nil];
    return YES;
}

- (BOOL)getPictureInViewController:(UIViewController *)controller block:(void (^)(NSArray *images,NSString *errorStr))block{
    if (![JSPictureManager isSourcePhotoLibraryAvailable]) {
        block(nil,@"无法访问图片库");
        return FALSE;
    }
    self.callBackBlock = block;
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.sourceType = sourcheType;
    [controller presentViewController:picker animated:YES completion:nil];
    return YES;
}
///从相机获得照片
- (BOOL)getPictureFromeCameraInViewController:(UIViewController *)controller block:(void (^)(NSArray *images,NSString *errorStr))block{
    if (![JSPictureManager isSourceCameraAvailable]) {
        block(nil,@"无法访问照相机");
        return FALSE;
    }
    self.callBackBlock = block;
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    picker.sourceType = sourcheType;
    picker.editing = YES;
    [controller presentViewController:picker animated:YES completion:nil];
    
    return YES;
}
- (BOOL)getMultiplePictureInViewController:(UIViewController *)controller count:(long )count block:(void (^)(NSArray <UIImage *>*images,NSString *errorStr))block{
    self.callBackBlock = block;
    if (count <= 0) {
        return NO;
    }
    self.elcPicker.maxImagesCount = count;
    self.elcPicker.autoDismiss = NO;
    [controller presentViewController:self.elcPicker animated:YES completion:nil];
    return YES;
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    __weak typeof(self) wSelf = self;
    _semaph = dispatch_semaphore_create(1);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for(id assect in assets){
            dispatch_semaphore_wait(_semaph, DISPATCH_TIME_FOREVER);
            [self js_getOriginalPhotoWithAsset:assect completion:^(UIImage *photo, NSDictionary *info) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (wSelf.callBackBlock) {
//                        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
//                        [SVProgressHUD show];
                        wSelf.callBackBlock(@[photo],@"获取成功");
                    }
                });
                dispatch_semaphore_signal(wSelf.semaph);
            }];
        }
    });
    self.elcPicker = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)js_getOriginalPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo,NSDictionary *info))completion {
    [self getOriginalPhotoWithAsset:asset newCompletion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        if (completion) {
            completion(photo,info);
        }
    }];
}

- (void)getOriginalPhotoWithAsset:(id)asset newCompletion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion {
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
        option.networkAccessAllowed = YES;
        option.resizeMode = PHImageRequestOptionsResizeModeFast;
        option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage *result, NSDictionary *info) {
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinined && result) {
                result = [[TZImageManager manager] fixOrientation:result];
                BOOL isDegraded = [[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                if (completion) completion(result,info,isDegraded);
            }
        }];
    } else if ([asset isKindOfClass:[ALAsset class]]) {
        ALAsset *alAsset = (ALAsset *)asset;
        ALAssetRepresentation *assetRep = [alAsset defaultRepresentation];
        
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            CGImageRef originalImageRef = [assetRep fullResolutionImage];
            UIImage *originalImage = [UIImage imageWithCGImage:originalImageRef scale:1.0 orientation:UIImageOrientationUp];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(originalImage,nil,NO);
            });
        });
    }
}

- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    //    FBRetainCycleDetector *detector = [[FBRetainCycleDetector alloc] init];
    //    [detector addCandidate:self];
    //    NSSet *retainCycles = [detector findRetainCycles];
    //    NSLog(@"FBRetainCycleDetector -->>> %@", retainCycles);
}

-(void)dealloc
{
    NSLog(@"JSPictureManager delloc");
}

-(TZImagePickerController*)elcPicker
{
    if(_elcPicker == nil){
        _elcPicker = [[TZImagePickerController alloc] initWithMaxImagesCount:4 columnNumber:[UIScreen mainScreen].bounds.size.width/70 delegate:self pushPhotoPickerVc:YES];
        // 3. 设置是否可以选择视频/图片/原图
        _elcPicker.allowPickingVideo = NO;
        //    imagePickerVc.allowPickingImage = NO;
        _elcPicker.allowPickingOriginalPhoto = NO;
        _elcPicker.allowPickingVideo = NO;
        _elcPicker.allowCrop = NO;
        _elcPicker.allowTakePicture = YES; // 在内部显示拍照按钮
    }
    
    return _elcPicker;
}
@end
