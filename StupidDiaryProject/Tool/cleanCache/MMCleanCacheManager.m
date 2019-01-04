//
//  MMCleanCacheManager.m
//  AFNetworking
//
//  Created by weiwei on 2017/12/20.
//

#import "MMCleanCacheManager.h"
#import <WebKit/WebKit.h>
#import "YYCache.h"
#import "SDImageCache.h"
@implementation MMCleanCacheManager

+ (MMCleanCacheManager *)Cachesclear{
    static MMCleanCacheManager * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager =  [[MMCleanCacheManager alloc]init];
    });
    return manager;
}


-(long long)CalculatePictureCaches{
    return [[SDImageCache sharedImageCache] getSize];
}

-(void)clearPictureCaches{
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)clearWkWebViewCache{
    if (@available(iOS 9.0, *)) {
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        }];
    }
}

///清空首页时间戳缓存
- (void)clearHPMainCache
{
//    [JSLocalStorageKit save:@"0" forKey:HPMainBannerStap localStorageType:JSLocalStorageTypeUserDefault];
//    [JSLocalStorageKit save:@"0" forKey:HPMainRootModelStap localStorageType:JSLocalStorageTypeUserDefault];
//    [JSLocalStorageKit save:@"0" forKey:HPPartModuleStap localStorageType:JSLocalStorageTypeUserDefault];
//    [JSLocalStorageKit save:@"0" forKey:HPPartCategrayModelStap localStorageType:JSLocalStorageTypeUserDefault];
//    [JSLocalStorageKit save:@"0" forKey:HPPartCirclePictureModelStap localStorageType:JSLocalStorageTypeUserDefault];
//    [JSLocalStorageKit save:@"0" forKey:HPCapacityMouleStap localStorageType:JSLocalStorageTypeUserDefault];
//    [JSLocalStorageKit save:@"0" forKey:HPCapacityCategrayModelStap localStorageType:JSLocalStorageTypeUserDefault];
//    [JSLocalStorageKit save:@"0" forKey:HPCapacityTopLineModelStap localStorageType:JSLocalStorageTypeUserDefault];
//    [JSLocalStorageKit save:@"0" forKey:HPCapacityHotStyleModelStap localStorageType:JSLocalStorageTypeUserDefault];
//    [JSLocalStorageKit save:@"0" forKey:HPCapacityCirclePictureModelStap localStorageType:JSLocalStorageTypeUserDefault];
//    YYCache* cache = [YYCache cacheWithName:@"JSNetworkCache"];
//    [cache removeAllObjects];
}

-(long long)CalculateWebViewCaches{
    
//    NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
//                                                               NSUserDomainMask, YES)[0];
//    NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary]
//                            objectForKey:@"CFBundleIdentifier"];
//    webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
//    webKitFolderInCaches = [NSString
//                            stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
//    
//    NSFileManager  *fileMananger = [NSFileManager defaultManager];
//    
//    float size=0.00;
//    float weight=0.00;
//    //
//    if ([fileMananger fileExistsAtPath:webkitFolderInLib]) {
//        NSDictionary *dic = [fileMananger attributesOfItemAtPath:webkitFolderInLib error:nil];
//        if ([dic[NSFileType] isEqualToString:@"NSFileTypeDirectory"]) {
//            
//            NSDirectoryEnumerator *enumerator = [fileMananger enumeratorAtPath:webkitFolderInLib];
//            for (NSString *subpath in enumerator) {
//                NSString *fullSubpath = [webkitFolderInLib stringByAppendingPathComponent:subpath];
//                size += [[fileMananger attributesOfItemAtPath:fullSubpath error:nil] fileSize];
//            }
//            
//            
//        }
//        //        else{
//        //            size=[[fileMananger attributesOfItemAtPath:webkitFolderInLib error:nil] fileSize];
//        //
//        //        }
//        
//        
//    }else{
//        
//    }
//    //
//    if ([fileMananger fileExistsAtPath:webKitFolderInCaches]) {
//        NSDictionary *dic = [fileMananger attributesOfItemAtPath:webKitFolderInCaches error:nil];
//        if ([dic[NSFileType] isEqualToString:@"NSFileTypeDirectory"]) {
//            
//            NSDirectoryEnumerator *enumerator = [fileMananger enumeratorAtPath:webKitFolderInCaches];
//            for (NSString *subpath in enumerator) {
//                NSString *fullSubpath = [webKitFolderInCaches stringByAppendingPathComponent:subpath];
//                weight += [[fileMananger attributesOfItemAtPath:fullSubpath error:nil] fileSize];
//            }
//            
//            
//        }
//        //        else{
//        //            weight=[[fileMananger attributesOfItemAtPath:webKitFolderInCaches error:nil] fileSize];
//        //
//        //        }
//        
//        
//    }else{
//        
//    }
//    
//    //    return size+weight;
    return 0;
    
}

-(void)clearWebViewCaches{
    
//    [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
//    [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:nil];
}


-(long long)CalculateAllCaches{
    return [[MMCleanCacheManager Cachesclear] CalculatePictureCaches]+[[MMCleanCacheManager Cachesclear] CalculateWebViewCaches];
}

-(void)clearAllCaches{
    
    [[MMCleanCacheManager Cachesclear] clearPictureCaches];
//    [[MMCleanCacheManager Cachesclear] clearWebViewCaches];
    [[MMCleanCacheManager Cachesclear] clearWkWebViewCache];
//    [[MMCleanCacheManager Cachesclear] clearHPMainCache];
}
@end
