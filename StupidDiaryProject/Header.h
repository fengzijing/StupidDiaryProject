//
//  Header.h
//  StupidDiaryProject
//
//  Created by 锋子 on 2019/1/3.
//  Copyright © 2019 锋子. All rights reserved.
//

#ifndef Header_h
#define Header_h


#define STATUSBAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height//状态栏高度
#define NAVISTATUSBARHEIGHT (marX(44) + STATUSBAR_HEIGHT)
#define marX(x) (x*SCREEN_WIDTH/375.0)//屏幕宽度比例

#import "SMPageStyle.h"
#import "Masonry.h"
#import "JSFPictureManager.h"
#import "ReactiveObjC.h"
#import "JSSelectViewTool.h"
#import "JSCommonAlertView.h"
#import "UITextView+CustomFont.h"
#import "UITableView+JSCustom.h"
#import "UIViewController+BackgroundAlpha.h"
#import "UIViewController+TouchAvatar.h"
#import "JSUserInfo.h"
#import "JSLocalStorageKit.h"
#import "JSFastLoginModel.h"
#import "SVProgressHUD.h"

//下拉刷新
#import "MJRefresh.h"
#import "XXRequest.h"
//键盘管理
#import "IQKeyboardManager.h"

#import "XFAssistiveTouch.h"

#import <XYSuspensionMenu.h>
#import <YYKit.h>
#import "XXToast.h"

//图片缓存
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>

#endif /* Header_h */
