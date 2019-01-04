//
//  ViewController.m
//  StupidDiaryProject
//
//  Created by 锋子 on 2019/1/3.
//  Copyright © 2019 锋子. All rights reserved.
//

#import "ViewController.h"
#import "IudgeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    IudgeViewController * iudgevc = [[IudgeViewController alloc]init];
    KEY_WINDOW.rootViewController = iudgevc;
}


@end
