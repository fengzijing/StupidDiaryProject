//
//  PhotoDetailsCollectionViewCell.m
//  JSFPictureManager
//
//  Created by nuomi on 2017/9/18.
//  Copyright © 2017年 jsf. All rights reserved.


#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

#import "PhotoDetailsCollectionViewCell.h"


@interface PhotoDetailsCollectionViewCell ()

@property (nonatomic, strong) UIImageView *albumImageView;

@end

@implementation PhotoDetailsCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *albumImageView = [[UIImageView alloc] init];
        self.albumImageView = albumImageView;
        albumImageView.center = CGPointMake(KScreenWidth/2, KScreenHeight/2);
        
        [self.contentView addSubview:albumImageView];
        
    }
    return self;
}
- (void)setAlbumImage:(UIImage *)albumImage
{
    _albumImage = albumImage;
    self.albumImageView.bounds = CGRectMake(0, 0, albumImage.size.width, albumImage.size.height);
    self.albumImageView.image = albumImage;
}


@end
