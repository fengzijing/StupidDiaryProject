//
//  UITableView+JSCustom.h
//  ServiceModule
//
//  Created by yky on 2017/12/8.
//


#import <UIKit/UIKit.h>
#import "SMPageStyle.h"

typedef enum : NSUInteger {
    //默认空空如也
    SMTBDefaultEmptyType = 0,
} SMTBEmptyType;

@interface UITableView (JSCustom)

///关闭空白控制，默认开启，YES关闭
@property (assign, nonatomic) BOOL closeEmptyHandel;
/*!空视图提示语句*/
@property(copy,nonatomic) NSString* emptyMsg;

/*!空视图占位图名称*/
@property(copy,nonatomic) NSString* emptyImage;

/*!<#Description#>*/
@property(assign,nonatomic) SMTBEmptyType emptyType;


/**
 手动调用显示EmptyView;
 */
-(void)showEmptyView;
/**
 手动调用隐藏EmptyView;
 */
-(void)hideEmptyView;
@end

