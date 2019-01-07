//
//  BRDiaryViewController.h
//  StupidDiaryProject
//
//  Created by 锋子 on 2019/1/7.
//  Copyright © 2019 锋子. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRDiaryViewController : UIViewController

@property (nonatomic,strong) JSFastLoginModel * model;

@property (nonatomic,assign) BOOL isEditor;

@end

NS_ASSUME_NONNULL_END
