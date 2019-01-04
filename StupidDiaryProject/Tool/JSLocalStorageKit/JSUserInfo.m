//
//  JSUserInfo.m
//  Pods
//
//  Created by yky on 2017/11/21.
//

#import "JSUserInfo.h"
#import "JSLocalStorageKit.h"
#import "JSFastLoginModel.h"
//

//全部日记数组
#define AllUserNameArray @"AllUserNameArray"
//类别日记数组
#define ClassUserNameArray @"ClassUserNameArray"
//类别日记数组
#define GarbageUserNameArray @"GarbageUserNameArray"
//当前用户的token
#define User_Token @"User_Token"

//公司名称
#define User_nickName @"User_nickName"
//公司名称
#define User_signature @"User_signature"
//头像
#define User_Image @"User_Image"

@interface JSUserInfo()

@end

@implementation JSUserInfo

+(id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    static JSUserInfo* userInfo = nil;
    dispatch_once(&onceToken, ^{
        userInfo = [super allocWithZone:zone];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(networkStatusChange:) name:@"JSNetworkStatusChangeNotification" object:nil];
//        [userInfo getIPAddressByTB];
    });
    
    return userInfo;
}

+(JSUserInfo*)shareManager
{
    return [[self alloc]init];
}

#pragma mark - save & queue
-(id)getUserDefaultByKey:(NSString*)key
{
    return [JSLocalStorageKit queryForKey:key localStorageType:JSLocalStorageTypeUserDefault];
}

-(void)saveUserDefaultByKey:(NSString*)key result:(id)value
{
    [JSLocalStorageKit save:value forKey:key localStorageType:JSLocalStorageTypeUserDefault];
}

//-(id)getKeyChainByKey:(NSString*)key
//{
//    return [JSLocalStorageKit queryForKey:key localStorageType:JSLocalStorageTypeKeyChain];
//}
//
//-(void)saveKeyChainByKey:(NSString*)key result:(id)value
//{
//    [JSLocalStorageKit save:value forKey:key localStorageType:JSLocalStorageTypeKeyChain];
//}


- (NSArray *)sortedArrayUsingComparatorByPaymentTimeWithDataArr:(NSArray<JSFastLoginModel*> *)dataArr{
    
    NSMutableArray *sortArray = [dataArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        JSFastLoginModel *model1 = obj1;
        JSFastLoginModel *model2 = obj2;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy.MM.dd HH:mm ss"];
        NSString * time1 = [NSString stringWithFormat:@"%@.%@ %@",model1.class_year,model1.class_day,model1.class_hour];
        NSString * time2 = [NSString stringWithFormat:@"%@.%@ %@",model2.class_year,model2.class_day,model2.class_hour];
        NSDate *date1= [dateFormatter dateFromString:time1];
        NSDate *date2= [dateFormatter dateFromString:time2];
        
        if (date1 == [date1 earlierDate: date2]) { //不使用intValue比较无效
            return NSOrderedDescending;//降序
        }else if (date1 == [date1 laterDate: date2]) {
            return NSOrderedAscending;//升序
        }else{
            return NSOrderedSame;//相等
        }
    }];
    
    return sortArray;
}

#pragma mark - getter & setter


- (NSMutableArray<JSFastLoginModel *> *)allArray{
    NSUserDefaults * userdefaults = [NSUserDefaults standardUserDefaults];
    NSData * tmp = [userdefaults objectForKey:AllUserNameArray];
    if (tmp == nil) {
        return  [[NSMutableArray alloc]init];
    }
    else {
        NSArray * array = [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData: tmp]];
        return  [NSMutableArray arrayWithArray:[self sortedArrayUsingComparatorByPaymentTimeWithDataArr:array]];
    }
    
}
- (void)setAllArray:(NSMutableArray<JSFastLoginModel *> *)allArray{
    if (allArray == nil) {
        return;
    }
    NSUserDefaults * userdefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:allArray];
    [userdefaults setObject:data forKey:AllUserNameArray];
}


-(void)setNickName:(NSString *)nickName{
    [self saveUserDefaultByKey:User_nickName result:nickName];
}

- (NSString *)nickName{
    return [self getUserDefaultByKey:User_nickName];
}

-(void)setSignature:(NSString *)signature{
    [self saveUserDefaultByKey:User_signature result:signature];
}

- (NSString *)signature{
    return [self getUserDefaultByKey:User_signature];
}

-(void)setHeader_image:(UIImage *)header_image{
    [self saveUserDefaultByKey:User_Image result:header_image];
}

- (UIImage *)header_image{
    return [self getUserDefaultByKey:User_Image];
}

-(void)setToken:(NSString *)token{
    [self saveUserDefaultByKey:User_Token result:token];
}


- (NSString *)token{
    return [self getUserDefaultByKey:User_Token];
}


@end

