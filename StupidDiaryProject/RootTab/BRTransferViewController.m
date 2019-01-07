//
//  TransferViewController.m
//  BoardGamesItems
//
//  Created by 锋子 on 2018/12/12.
//  Copyright © 2018 锋子. All rights reserved.
//

#import "BRTransferViewController.h"

#import "AppURL.h"
#import "AppDeviceMode.h"
#import "XXRequest.h"
#import "NSString+Code.h"

@interface BRTransferViewController ()<UIWebViewDelegate>

{
    NSArray * bottomArr;
}
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightCons;

@property (nonatomic,strong)    NSDictionary * params;

@property (nonatomic,strong)    NSArray * ads;

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation BRTransferViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    [SVProgressHUD showWithStatus:@"正在加载~~~"];
    [self requestMainURL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRotateAction:) name:UIDeviceOrientationDidChangeNotification object:nil];
}


-(void)doRotateAction:(NSNotification *)notification {
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
        self.bottomHeightCons.constant = -44;
        NSLog(@"竖屏");
    } else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        self.bottomHeightCons.constant = -94;
        NSLog(@"横屏");
    }
}

#pragma mark - == 请求主链接
- (void)requestMainURL
{
    //
        _urlID = @"3";
    NSMutableDictionary * mbody = [NSMutableDictionary dictionary];
    [mbody setObject:@"GetWebInfo" forKey:@"api"];
    [mbody setObject:app_id forKey:@"app_id"];
    [mbody setObject: getAPP_Number_Version() forKey:@"version"];
    [mbody setObject:app_secret forKey:@"app_secret"];
    [mbody setObject: getPackage_name() forKey:@"package_name"];
    [mbody setObject:market_secret forKey:@"market_secret"];
    [mbody setObject: getAppDeviceInfoStr() forKey:@"Apple_Info"];
    [mbody setObject: _urlID forKey:@"params"];
    
    WeakSelf(self)
    [[XXRequest RequestManager]PostRequestDataWithUrlStr:[NSString stringWithFormat:@"%@%@",[AppURL Manager].HttpHost,APP_API] body:mbody progressBlock:^(NSProgress *progress) {
        
    } success:^(NSObject *successData) {
        //字典:
        NSDictionary * dict = (NSDictionary *)successData;
        if ([[dict objectForKey:@"code"]integerValue] == 100) {
            NSString * paramsStr = [dict objectForKey:@"params"];
            if (paramsStr.length > 0) {
                weakType.params = (NSDictionary*)[paramsStr codeStringToDictionary];
                NSLog(@"params = %@",weakType.params);
                
                [weakType creationUI];
            }
        } else {
            
        }
        NSString * strMsg = [dict objectForKey:@"msg"];
        if (strMsg.length > 0 && ![strMsg isEqualToString:@" "]) {
            
            //            [XXToast showCenterWithText:[dict objectForKey:@"msg"] duration:3.5];
        }
        
    } fail:^(NSObject *failError) {
        //        [XXToast showCenterWithText:@"网络连接失败,请求错误" duration:3.5];
        //        [self goAppHome];
    }];
    
}

#pragma mark -- === UI视图:
- (void)creationUI
{
    
    _urlStr = [NSString stringWithBase64EncodedString:[_params objectForKey:@"url_address"]];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
    
    _webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_webView reload];
    }];
    
    
    NSString * Base64str = [_params objectForKey:@"bottom"];
    NSString * bottomArrStr  = [NSString stringWithBase64EncodedString:Base64str];
    bottomArr = (NSArray *)[bottomArrStr  codeStringToDictionary];
    NSLog(@"bottomArr == %@",bottomArr);
    
    self.bottomView.backgroundColor = ColorWithRGB(37, 130, 97, 1.0);
    self.scrollView.backgroundColor = ColorWithRGB(37, 130, 97, 1.0);
    
    CGFloat  width = SCREEN_WIDTH / bottomArr.count;
    self.scrollView.contentSize = CGSizeMake(width * bottomArr.count, 50);
    for (NSInteger i = 0; i< bottomArr.count; i++) {
        NSDictionary * dict = bottomArr[i];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:dict[@"title"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
        [btn addTarget:self action:@selector(cilkBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i + 10;
        
        btn.frame = CGRectMake(width * i, 0, width, 50);
        [self.scrollView addSubview:btn];
    }
    
    
    
}
- (void)cilkBtn: (UIButton *)sender
{
    NSDictionary * dict = bottomArr[sender.tag - 10];
    
    //跳转链接
    if ([dict[@"action_type"]isEqualToString:@"Go_Url"]) {
        NSString * str = [dict objectForKey:@"action_value"];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    }
    
    //服务
    if ([dict[@"action_type"]isEqualToString:@"Go_Service"]) {
        
        
        
    }
    //跳转界面
    if ([dict[@"action_type"]isEqualToString:@"Go_View"]) {
        
        
        
    }
    //拨打电话
    if ([dict[@"action_type"]isEqualToString:@"Go_Call"]) {
        
        
        
    }
    
    
    //发送短信
    if ([dict[@"action_type"]isEqualToString:@"Go_Sms"]) {
        
    }
    //刷新
    if ([dict[@"action_type"]isEqualToString:@"Go_Refresh"]) {
        
        [_webView reload];
    }
    //后退
    if ([dict[@"action_type"]isEqualToString:@"Go_Back"]) {
        
        [_webView goBack];
        
    }
    //清除缓存
    if ([dict[@"action_type"]isEqualToString:@"Go_Clean"]) {
        
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
        NSURLCache * cache = [NSURLCache sharedURLCache];
        
        [cache removeAllCachedResponses];
        
        [cache setDiskCapacity:0];
        
        [cache setMemoryCapacity:0];
        [SVProgressHUD showWithStatus:@"正在清理~~~"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [XXToast showCenterWithText:@"请理完成"];
        });
    }
    
    
    //切换TAB
    if ([dict[@"action_type"]isEqualToString:@"Go_Tab"]) {
        
        
        
    }
    
    
    
}



#pragma mark - === UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSArray *nCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *  Cookie in nCookies ) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:Cookie];
    }
    
    NSURL *URL=request.URL;
    NSString *scheme=[URL scheme];
    
    if ([scheme isEqualToString:@"http"]||[scheme isEqualToString:@"https"]) {
        return YES;
    }
    else{
        [[UIApplication sharedApplication]openURL:URL];
        return NO;
    }
}
//开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD showWithStatus:@"正在加载~~~"];
}
//加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView.scrollView.mj_header endRefreshing];
    [SVProgressHUD dismiss];
}
//开始失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
    [webView.scrollView.mj_header endRefreshing];
    [SVProgressHUD dismiss];
}


@end
