//
//  JSLocalStorageKit.m
//  JSLocalStorageKit
//
//  Created by weiwei on 2017/9/18.
//  Copyright © 2017年 created by weiwei. All rights reserved.
//

#import "JSLocalStorageKit.h"

@implementation JSLocalStorageKit

+ (void)save:(id)data forKey:(NSString *)key localStorageType:(JSLocalStorageType)type{
    if (type&&type==JSLocalStorageTypeKeyChain) {
        NSMutableDictionary *keychainQuery = [self keyChainQueryDictionaryWithKey:key];
        SecItemDelete((CFDictionaryRef)keychainQuery);
        [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
        SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:key];
    }
    
}

+ (id)queryForKey:(NSString *)key localStorageType:(JSLocalStorageType)type{
    id result;
    if (type&&type==JSLocalStorageTypeKeyChain) {
        NSMutableDictionary *keyChainQuery = [self keyChainQueryDictionaryWithKey:key];
        [keyChainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
        [keyChainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
        CFDataRef keyData = NULL;
        if (SecItemCopyMatching((CFDictionaryRef)keyChainQuery, (CFTypeRef *)&keyData) == noErr) {
            
             result = [NSKeyedUnarchiver  unarchiveObjectWithData:(__bridge NSData *)keyData];
            
        }
        if (keyData) {
            CFRelease(keyData);
        }
    }else{
        result = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:key]];
    }
    return result;
}

+ (void)deleteForkey:(NSString *)key localStorageType:(JSLocalStorageType)type{
    
    if (type&&type==JSLocalStorageTypeKeyChain) {
        NSMutableDictionary *keyChainDictionary = [self keyChainQueryDictionaryWithKey:key];
        SecItemDelete((CFDictionaryRef)keyChainDictionary);
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSMutableDictionary *)keyChainQueryDictionaryWithKey:(NSString *)Key{
    NSMutableDictionary *keyChainQueryDictaionary = [[NSMutableDictionary alloc]init];
    [keyChainQueryDictaionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    [keyChainQueryDictaionary setObject:Key forKey:(id)kSecAttrService];
    [keyChainQueryDictaionary setObject:Key forKey:(id)kSecAttrAccount];
    return keyChainQueryDictaionary;
}



@end
