//
//  IudgeViewController.m
//  BoardGamesItems
//
//  Created by 锋子 on 2018/12/12.
//  Copyright © 2018 锋子. All rights reserved.
//

#import "BRIudgeViewController.h"
#import "BRTransferViewController.h"
#import "BRDelegateViewController.h"
#import "AFNetworkReachabilityManager.h"

#import "AppDelegate.h"

#import "AppURL.h"
#import "AppDeviceMode.h"
#import "XXRequest.h"
#import "NSString+Code.h"

@interface BRIudgeViewController ()

@end

@implementation BRIudgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString * currentDateStr = [dateFormatter stringFromDate:currentDate];
    int comparisonResult = [self compareDate:currentDateStr withDate:@"2019-02-18"];
    if(comparisonResult >0){
        //endDate 大
        [self judgeIsWebView];
    }else{
        [self requestMainURL];
    }
    
}

//比较两个日期大小
-(int)compareDate:(NSString*)startDate withDate:(NSString*)endDate{
    
    int comparisonResult;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] init];
    date1 = [formatter dateFromString:startDate];
    date2 = [formatter dateFromString:endDate];
    NSComparisonResult result = [date1 compare:date2];
    NSLog(@"result==%ld",(long)result);
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending:
            comparisonResult = 1;
            break;
            //date02比date01小
        case NSOrderedDescending:
            comparisonResult = -1;
            break;
            //date02=date01
        case NSOrderedSame:
            comparisonResult = 0;
            break;
        default:
            NSLog(@"erorr dates %@, %@", date1, date2);
            break;
    }
    return comparisonResult;
}


- (BOOL)isReachable
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}

#pragma mark - == 请求主链接
- (void)requestMainURL
{
    if ([self isReachable]) {
        NSMutableDictionary * mbody = [NSMutableDictionary dictionary];
        [mbody setObject:@"WelcomeHome" forKey:@"api"];
        [mbody setObject:app_id forKey:@"app_id"];
        [mbody setObject: @"10" forKey:@"version"];
        [mbody setObject:app_secret forKey:@"app_secret"];
        [mbody setObject: getPackage_name() forKey:@"package_name"];
        [mbody setObject:market_secret forKey:@"market_secret"];
        [mbody setObject: getAppDeviceInfoStr() forKey:@"Apple_Info"];
        
        [[XXRequest RequestManager]PostRequestDataWithUrlStr:[NSString stringWithFormat:@"%@%@",[AppURL Manager].HttpHost,APP_API] body:mbody progressBlock:^(NSProgress *progress) {
            
        } success:^(NSObject *successData) {
//            [SVProgressHUD dismiss];
            //字典:
            NSDictionary * dict = (NSDictionary *)successData;
            if ([[dict objectForKey:@"code"]integerValue] == 100) {
                NSString * paramsStr = [dict objectForKey:@"params"];
                if (paramsStr.length > 0) {
                    NSDictionary * params = (NSDictionary*)[paramsStr codeStringToDictionary];
                    NSLog(@"params = %@",params);
                    if ([[params objectForKey:@"action_type"] isEqualToString:@"Go_Url"]) {
                        BRTransferViewController * web = [[BRTransferViewController alloc]init];
                        web.urlID = [params objectForKey:@"action_value"];
                        KEY_WINDOW.rootViewController = web;
                        [KEY_WINDOW makeKeyAndVisible];
                    } else {
                        [self judgeIsWebView];
                    }
                } else {
                    [self judgeIsWebView];
                }
            } else {
                [self judgeIsWebView];
            }
            
        } fail:^(NSObject *failError) {
//            [XXToast showCenterWithText:@"网络连接失败,请求错误" duration:3.5];
//            [SVProgressHUD dismiss];
            [self judgeIsWebView];
        }];
    } else {
        [self judgeIsWebView];
    }

    
}

-(void)judgeIsWebView{
    if ([JSUserInfo shareManager].token == nil) {
        BRDelegateViewController * delegateController = [BRDelegateViewController new];
        delegateController.isMine = NO;
        UINavigationController* foundNav = [[UINavigationController alloc]initWithRootViewController:delegateController];
        KEY_WINDOW.rootViewController = foundNav;
        [KEY_WINDOW makeKeyAndVisible];
    } else {
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        KEY_WINDOW.rootViewController = tempAppDelegate.LeftSlideVC;
        [KEY_WINDOW makeKeyAndVisible];
    }
}


@end
