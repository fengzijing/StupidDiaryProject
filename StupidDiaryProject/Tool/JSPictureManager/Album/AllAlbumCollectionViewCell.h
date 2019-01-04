//
//  AllAlbumCollectionViewCell.h
//  JSFPictureManager
//
//  Created by nuomi on 2017/9/15.
//  Copyright © 2017年 jsf. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AllAlbumCollectionViewCell;

@protocol AllAlbumCollectionViewCellDelegate <NSObject>

@optional
- (void)albumCollectionViewCellBtn:(UIButton *)button;

@end

@interface AllAlbumCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *assetImage;

@property (nonatomic, strong) NSIndexPath *indexpath;

@property (nonatomic, strong) NSMutableArray *selectArray;

@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic,weak) id<AllAlbumCollectionViewCellDelegate> delegate;

@end
