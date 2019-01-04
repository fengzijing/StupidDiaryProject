//
//  AllAlbumViewController.h
//  JSFPictureManager
//
//  Created by nuomi on 2017/9/15.
//  Copyright © 2017年 jsf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface AllAlbumViewController : UIViewController

/** 文件夹下的资源图片 */
@property (nonatomic, strong) PHAssetCollection *album;
/** 已经选中了多少张图片 */
@property (nonatomic,assign) NSInteger selectCount;

@end
