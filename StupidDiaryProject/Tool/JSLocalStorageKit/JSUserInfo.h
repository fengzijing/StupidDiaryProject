//
//  JSUserInfo.h
//  Pods
//
//  Created by yky on 2017/11/21.
//

#import <Foundation/Foundation.h>
#import "JSLocalStorageKit.h"
#import <UIKit/UIKit.h>

@class JSFastLoginModel;
@class JSClassModel;
@interface JSUserInfo : NSObject


+(JSUserInfo *)shareManager;

/**
 *  全部类别日记
 */
@property (strong, nonatomic) NSMutableArray <JSFastLoginModel *> * allArray;

/**
 *  token
 */
@property (copy, nonatomic) NSString *token;
/**
 device token
 */
@property (copy,nonatomic) NSString* pushDeviceToken;


/**
 *  昵称
 */
@property (copy, nonatomic) NSString *nickName;

/**
 *  个性签名
 */
@property (copy, nonatomic) NSString *signature;

/**
*  头像
*/
@property (copy , nonatomic) UIImage * header_image;

@end

