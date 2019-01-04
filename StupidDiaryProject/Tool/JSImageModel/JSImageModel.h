//
//  JSImageModel.h
//  MatchingPlatform
//
//  Created by nuomi on 16/3/22.
//  Copyright © 2016年 alan. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "JSImageManager.h"
#import "JSPictureManager.h"
#import "JSImageBrowser.h"

typedef enum {
  ImageLoading,
  ImageFinishLoading,
  ImageLoadingFaild,
  ImageDeleted
}ImageState;

@interface JSImageModel : NSObject
///原图
@property (strong, nonatomic) UIImage * image;
///图片id
@property (copy, nonatomic) NSString * imageId;

@property (copy, nonatomic) NSString * imageUrl;
///图片上传状态
@property (assign, nonatomic) ImageState  state;

///原图片框架
@property (weak, nonatomic) UIImageView * imageView;

@property (strong, nonatomic) UIActivityIndicatorView * smallLoadingView;
///出错按钮
@property (strong, nonatomic) UIButton * errBtn;

@property (nonatomic, assign) BOOL dontUpLoadImage;
- (void)reloadPic;
@end
