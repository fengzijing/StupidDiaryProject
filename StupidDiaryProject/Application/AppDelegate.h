//
//  AppDelegate.h
//  StupidDiaryProject
//
//  Created by 锋子 on 2019/1/3.
//  Copyright © 2019 锋子. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRLeftSlideViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BRLeftSlideViewController *LeftSlideVC;
@property (strong, nonatomic) UINavigationController *mainNavigationController;


@end

