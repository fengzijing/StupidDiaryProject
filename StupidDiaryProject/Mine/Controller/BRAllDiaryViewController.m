//
//  BRAllDiaryViewController.m
//  StupidDiaryProject
//
//  Created by 锋子 on 2019/1/8.
//  Copyright © 2019 锋子. All rights reserved.
//

#import "BRAllDiaryViewController.h"
#import "BRHomeTableViewCell.h"
#import "BRDiaryViewController.h"
@interface BRAllDiaryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation BRAllDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"全部日记";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.dataArr = [JSUserInfo shareManager].allArray;
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"refreshAllDiaryClassNotication" object:nil]takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        self.dataArr = [JSUserInfo shareManager].allArray;
        [self.tableView reloadData];
    }];
}

#pragma mark -- UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        if (self.dataArr.count == 0) {
            [self.tableView showEmptyView];
        } else {
            [self.tableView hideEmptyView];
        }
    return self.dataArr.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * bgView = [UIView new];
    bgView.backgroundColor = [UIColor clearColor];
    return bgView;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JSFastLoginModel * model = self.dataArr[indexPath.row];
    BRHomeTableViewCell* cell = [BRHomeTableViewCell cellWithTableView:tableView];
    cell.dateLabel.text = model.class_date;
    cell.weekLabel.text = model.class_week;
    cell.noteLabel.text = model.class_note;
    cell.timeLabel.text = model.class_hour;
    [cell.deleteBtn addTarget:self action:@selector(deleteDiary:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteBtn.tag = 1200+indexPath.row;
    
    return cell;
    
}


-(void)deleteDiary:(UIButton*)sender{
    WS(wSelf);
    JSCommonAlertView *alter = [[JSCommonAlertView alloc]initWithTitle:NSLocalizedString(@"确定删除该日记？", nil)  textArray:nil textAlignment:TextAlignmentCenter buttonStyle:ButtonLandscapeStyle];
    [alter showAlertView:NSLocalizedString(@"否", nil) sureTitle:NSLocalizedString(@"是", nil) cancelBlock:^{
        
    } sureBlock:^{
        JSFastLoginModel * model = self.dataArr[sender.tag-1200];
        [wSelf.dataArr removeObjectAtIndex:sender.tag-1200];
        [wSelf.tableView reloadData];
        NSMutableArray * array = [JSUserInfo shareManager].allArray;
        for (NSInteger i=0; i<array.count; i++) {
            JSFastLoginModel * allModel = array[i];
            if ([allModel.class_date isEqualToString:model.class_date]&&[allModel.class_second isEqualToString:model.class_second]&&[allModel.class_hour isEqualToString:model.class_hour]) {
                [array removeObject:allModel];
                continue;
            }
        }
        [JSUserInfo shareManager].allArray = array;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshDiaryClassNotication" object:nil userInfo:nil];
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JSFastLoginModel * model = self.dataArr[indexPath.row];
    BRDiaryViewController * diaryVC = [[BRDiaryViewController alloc]init];
    diaryVC.isEditor = NO;
    diaryVC.model = model;
    [self.navigationController pushViewController:diaryVC animated:YES];
}

@end
