//
//  JSImageModel.m
//  MatchingPlatform
//
//  Created by nuomi on 16/3/22.
//  Copyright © 2016年 alan. All rights reserved.
//

#import "JSImageModel.h"
#import "Masonry.h"
#import "JSImageManager.h"
@interface JSImageModel (){
}


@property (nonatomic, strong) NSData *dataParam;
@end
@implementation JSImageModel
#pragma mark - lifecircle
- (void)dealloc{
    [_smallLoadingView removeFromSuperview];
    self.smallLoadingView = nil;
    [_errBtn removeFromSuperview];
}
#pragma mark - getting and setting
///自动上传图片
- (void)setImage:(UIImage *)image{

    self.state = ImageLoading;
    
    UIImage* newImage = [JSImageManager fixOrientation:image];
    
    NSData * data = UIImageJPEGRepresentation(newImage, 0.1);
    if (data == nil) {
         data = UIImagePNGRepresentation(newImage);
    }
//    if (data == nil) {
//        UIImage * tmpImage = [newImage  imageWithCornerRadius:0];
//        data = UIImageJPEGRepresentation(newImage,UIImageJPEGQuality);
//        if (data == nil) {
//            data = UIImagePNGRepresentation(tmpImage);
//        }
//    }
    
    _image = [UIImage imageWithData:data];
    _imageView.image = _image;
    
    if (_dontUpLoadImage) {
        return;
    }
    
//    if (data == nil) {
//        [SVProgressHUD showInfoWithStatus:@"部分图片上传失败"];
//        return;
//    }
}

-(void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
}

-(void)setImageId:(NSString *)imageId{
    _imageId = imageId;
}

- (void)setState:(ImageState)state{
    if (state == ImageLoading) {
        [self showLoading];
    }
    else if (state == ImageDeleted){
        [self showDelete];
    }
    else if (state == ImageLoadingFaild){
       
        [self showError];
    }
    else {
        [self showFinishLoading];
    }
    _state = state;
}

- (void)setImageView:(UIImageView *)imageView{
      _imageView =imageView;
    switch (_state) {
        case ImageLoading:
        [self showLoading];
            break;
        case ImageFinishLoading:
            [self showFinishLoading];
            break;
        case ImageLoadingFaild:
            [self showError];
            break;
        case ImageDeleted:
            [self showDelete];
            break;
        default:
            break;
    }
}
- (void)reloadPic{
    self.image = _image;
}
#pragma mark - privateMethod
#pragma mark 设置出错显示状态
- (void)showError{
    [self clearImageStateView];
    [_smallLoadingView stopAnimating];
    _smallLoadingView.hidden = YES;
    if (_imageView != nil) {
        if (_errBtn == nil) {
            _errBtn = [[UIButton alloc]initWithFrame:_imageView.bounds];
            [_errBtn setBackgroundImage:[UIImage imageNamed:@"pictureError"] forState:UIControlStateNormal];
            [_errBtn addTarget:self action:@selector(reloadPic) forControlEvents:UIControlEventTouchUpInside];
        }
        [_imageView addSubview:_errBtn];
    }
}
#pragma mark 设置加载显示状态
- (void)showLoading{
    [self clearImageStateView];
    if (_smallLoadingView == nil) {
        _smallLoadingView = [[UIActivityIndicatorView alloc]init];
        _smallLoadingView.frame = CGRectMake(0, 0, 20, 20);
        if (_imageView != nil) {
            __weak UIActivityIndicatorView * tmpUIActivityIndicatorView = _smallLoadingView;
            [_imageView addSubview:tmpUIActivityIndicatorView];
            [_smallLoadingView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(_imageView);
                make.height.mas_equalTo(20);
                make.width.mas_equalTo(20);
            }];
        }
    }
//    _smallLoadingView.hidden = NO;
//    [_smallLoadingView startAnimating];
  
}
#pragma  mark 显示完成状态
- (void)showFinishLoading{
   [self clearImageStateView];
}
#pragma mark 显示删除状态
- (void)showDelete{
    [self clearImageStateView];
}
#pragma mark 清理imageView上所有显示
- (void)clearImageStateView{
    [_smallLoadingView removeFromSuperview];
    [_errBtn removeFromSuperview];
    self.smallLoadingView = nil;
}


@end
