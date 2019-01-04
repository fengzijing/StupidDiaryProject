//
//  GroupTableViewCell.m
//  JSFPictureManager
//
//  Created by nuomi on 2017/9/15.
//  Copyright © 2017年 jsf. All rights reserved.
//

#import "GroupTableViewCell.h"

@interface GroupTableViewCell ()

@property (nonatomic, strong) UIImageView *nameImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation GroupTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UIImageView *nameImageView = [[UIImageView alloc] init];
        self.nameImageView = nameImageView;
        nameImageView.frame = CGRectMake(10, 0, 80, 80);
        [self.contentView addSubview:nameImageView];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        self.nameLabel = nameLabel;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:nameLabel];
        
    }
    
    return self;
}
- (void)setNameImage:(UIImage *)nameImage
{
    _nameImage = nameImage;
    self.nameImageView.image = nameImage;
    self.nameImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.nameImageView.clipsToBounds = YES;
}
- (void)setNameTitle:(NSString *)nameTitle
{
    _nameTitle = nameTitle;
    self.nameLabel.text = nameTitle;
    [self.nameLabel sizeToFit];
    self.nameLabel.center = CGPointMake(CGRectGetMaxX(self.nameImageView.frame) + 10 + self.nameLabel.bounds.size.width/2, self.nameImageView.center.y);
}

@end
