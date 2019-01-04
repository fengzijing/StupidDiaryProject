//
//  HomeViewController.m
//  StupidDiaryProject
//
//  Created by 锋子 on 2019/1/3.
//  Copyright © 2019 锋子. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"

@interface HomeViewController ()

@property (nonatomic,strong) UITableView * tableView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主界面";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(openOrCloseLeftList)];
    [self customDiaryView];
}

-(void)customDiaryView{
    [self.view addSubview:_tableView];
    UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(0,0,50,50)];
    [btn setBackgroundImage:[UIImage imageNamed:@"add_games"] forState:UIControlStateNormal];
//    btn.backgroundColor=[UIColor orangeColor];
    [btn addTarget:self action:@selector(beginWriteDiary) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius=25;
    btn.center = CGPointMake(ScreenWidth-50, ScreenHeight-120);
    [self.view addSubview:btn];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [btn addGestureRecognizer:panGestureRecognizer];
}

-(void)beginWriteDiary{
    
}

- (void) handlePan:(UIPanGestureRecognizer*) recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    CGFloat centerX=recognizer.view.center.x+ translation.x;
    CGFloat thecenter=0;
    
    [recognizer setTranslation:CGPointZero inView:self.view];
    
    if (recognizer.view.center.y+translation.y > ScreenHeight-100) {
        recognizer.view.center=CGPointMake(centerX, ScreenHeight-100);
    } else if (recognizer.view.center.y+translation.y < 25) {
        recognizer.view.center=CGPointMake(centerX, 25);
    } else {
        recognizer.view.center=CGPointMake(centerX, recognizer.view.center.y+ translation.y);
    }
    
    if(recognizer.state==UIGestureRecognizerStateEnded|| recognizer.state==UIGestureRecognizerStateCancelled) {
        if(centerX>ScreenWidth/2) {
            thecenter=ScreenWidth-50/2;
        }else{
            thecenter=50/2;
        }
        [UIView animateWithDuration:0.3 animations:^{
            recognizer.view.center=CGPointMake(thecenter, recognizer.view.center.y+ translation.y);
        }];
    }
}


- (void) openOrCloseLeftList
{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (tempAppDelegate.LeftSlideVC.closed) {
        [tempAppDelegate.LeftSlideVC openLeftView];
    } else {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVISTATUSBARHEIGHT) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 60;
    }
    return _tableView;
}

@end
