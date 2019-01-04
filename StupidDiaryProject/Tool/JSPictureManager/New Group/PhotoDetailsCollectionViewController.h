//
//  PhotoDetailsCollectionViewController.h
//  JSFPictureManager
//
//  Created by nuomi on 2017/9/18.
//  Copyright © 2017年 jsf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoDetailsCollectionViewController : UICollectionViewController

/** 已经选中了多少张图片 */
@property (nonatomic,assign) NSInteger selectCount;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) NSMutableArray *assetArray;

@property (nonatomic, strong) NSMutableArray * dataArr;

@property (nonatomic,assign) NSInteger item;

@property (nonatomic, copy) NSString * preview;

@end
