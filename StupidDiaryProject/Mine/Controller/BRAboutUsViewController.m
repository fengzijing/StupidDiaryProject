//
//  BRAboutUsViewController.m
//  StupidDiaryProject
//
//  Created by 锋子 on 2019/1/8.
//  Copyright © 2019 锋子. All rights reserved.
//

#import "BRAboutUsViewController.h"

@interface BRAboutUsViewController ()
@property (strong, nonatomic) IBOutlet UIView *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bundleLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;

@end

@implementation BRAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于我们";
}



@end
