//
//  JSImageBrowser.h
//  JSKit
//
//  Created by 张永刚 on 2018/1/11.
//

#import <Foundation/Foundation.h>
#import "LBPhotoBrowserManager.h"

@interface JSImageBrowser : NSObject

 /*! 初始化 isLocal:是否本地图片 */
- (instancetype)initWithURL:(NSArray *)images placeHolderImage:(UIImage *)placeHolderImage isLocal:(BOOL)isLocal;
/*! 显示图片 */ 
- (void)showImageWithIndex:(NSInteger)index superView:(UIView *)superView;
 /*! 添加保存回调 */
- (void)addDefaultLongPressTitle;
 /*! 添加自定义长按手势 */
- (void)addCustomLongPressTitle:(NSArray *)titles reserveCallBack:(void(^)(UIImage *image, NSIndexPath *indexPath, NSString *title))reserveCallBack;

@end
