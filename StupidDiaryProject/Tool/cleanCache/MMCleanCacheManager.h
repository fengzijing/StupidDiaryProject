//
//  MMCleanCacheManager.h
//  AFNetworking
//
//  Created by weiwei on 2017/12/20.
//

#import <Foundation/Foundation.h>

@interface MMCleanCacheManager : NSObject
/* 创建单例 */
+ (MMCleanCacheManager *)Cachesclear;

/* 计算SDWebImage的缓存大小*/
-(long long)CalculatePictureCaches;

/* 清除SDWebImage的缓存*/
-(void)clearPictureCaches;

/* 计算webview的缓存大小*/
-(long long)CalculateWebViewCaches;

/* 清除webview的缓存*/
-(void)clearWebViewCaches;

/* 计算总的缓存大小*/
-(long long)CalculateAllCaches;

/* 清除总的的缓存*/
-(void)clearAllCaches;
@end
