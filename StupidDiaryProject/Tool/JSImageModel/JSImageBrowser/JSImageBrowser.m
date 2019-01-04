//
//  JSImageBrowser.m
//  JSKit
//
//  Created by 张永刚 on 2018/1/11.
//

#import "JSImageBrowser.h"
#import <Photos/Photos.h>
#import "SVProgressHUD.h"

@interface JSImageBrowser ()

@property (nonatomic, strong) NSMutableArray *itemArray;

@property (nonatomic, assign) BOOL isLocal;

@end

@implementation JSImageBrowser

# pragma mark - 初始化
- (instancetype)initWithURL:(NSArray *)images placeHolderImage:(UIImage *)placeHolderImage  isLocal:(BOOL)isLocal{
    if (self = [super init]) {
        _isLocal = isLocal;
        _itemArray = [NSMutableArray array];
        [LBPhotoBrowserManager defaultManager].errorImage = placeHolderImage;
        if (isLocal) {
            for (UIImage *image in images) {
                LBPhotoLocalItem *item = [[LBPhotoLocalItem alloc] initWithImage:image frame:[UIScreen mainScreen].bounds];
                [_itemArray addObject:item];
            }
        }else{
            for (NSString *url in images) {
                LBPhotoWebItem *item = [[LBPhotoWebItem alloc] initWithURLString:url frame:[UIScreen mainScreen].bounds];
                item.placeholdImage = placeHolderImage;
                [_itemArray addObject:item];
            }
        }
    }
    return self;
}

# pragma mark - 显示图片
- (void)showImageWithIndex:(NSInteger)index superView:(UIView *)superView{
    if (_isLocal) {
        [[LBPhotoBrowserManager defaultManager] showImageWithLocalItems:_itemArray selectedIndex:index fromImageViewSuperView:superView];
    }else{
        [[LBPhotoBrowserManager defaultManager] showImageWithWebItems:_itemArray selectedIndex:index fromImageViewSuperView:superView];
    }
}

# pragma mark - 添加保存回调
- (void)addDefaultLongPressTitle{
    NSArray *titles = @[@"保存图片",@"取消"];
    [[LBPhotoBrowserManager defaultManager] addLongPressShowTitles:titles];
    [[LBPhotoBrowserManager defaultManager] addTitleClickCallbackBlock:^(UIImage *image, NSIndexPath *indexPath, NSString *title) {
        if ([title isEqualToString:@"保存图片"]) {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    [SVProgressHUD showSuccessWithStatus:@"保存到相册成功"];
                }else{
                    [SVProgressHUD showSuccessWithStatus:@"保存到相册失败"];
                }
            }];
        }
    }];
}

# pragma mark - 添加自定义长按手势
- (void)addCustomLongPressTitle:(NSArray *)titles reserveCallBack:(void(^)(UIImage *image, NSIndexPath *indexPath, NSString *title))reserveCallBack{
    [[LBPhotoBrowserManager defaultManager] addLongPressShowTitles:titles];
    [[LBPhotoBrowserManager defaultManager] addTitleClickCallbackBlock:reserveCallBack];
}

@end
