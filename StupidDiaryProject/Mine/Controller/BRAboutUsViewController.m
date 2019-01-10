//
//  BRAboutUsViewController.m
//  StupidDiaryProject
//
//  Created by 锋子 on 2019/1/8.
//  Copyright © 2019 锋子. All rights reserved.
//

#import "BRAboutUsViewController.h"

@interface BRAboutUsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *bundleLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;

@end

@implementation BRAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"关于我们", nil);
    self.nameLabel.text = NSLocalizedString(@"项目名称：笨笨日记", nil);
    self.bundleLabel.text = NSLocalizedString(@"项目版本：V1.0.0", nil);
    self.noteLabel.text = NSLocalizedString(@"项目描述：笨笨日记是一款简单、方便的用于记录生活日常的日记应用。", nil);
}



@end
