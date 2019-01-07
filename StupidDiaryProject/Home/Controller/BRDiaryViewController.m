//
//  BRDiaryViewController.m
//  StupidDiaryProject
//
//  Created by 锋子 on 2019/1/7.
//  Copyright © 2019 锋子. All rights reserved.
//

#import "BRDiaryViewController.h"
#import "BRDiaryTableViewCell.h"
#import "MFDateFormatter.h"

@interface BRDiaryViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation BRDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"日记";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"保存", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveDiary)];
    if (self.isEditor) {
        self.model.class_date = [[MFDateFormatter share] stringOfDate:[NSDate date] format:@"yyyy.MM.dd"];
        self.model.class_hour = [[MFDateFormatter share] stringOfDate:[NSDate date] format:@"HH:ss"];
    } else {
        
    }
}

-(void)saveDiary{
    
}

# pragma mark - UITableViewDelegate UITableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};//指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(ScreenWidth - 60, 0)/*计算高度要先指定宽度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.model.class_note.length>0) {
        CGFloat noteHeight = [self calculateRowHeight:self.model.class_note fontSize:13];
        return noteHeight+105;
    } else {
        return 260;
    }
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BRDiaryTableViewCell * cell = [BRDiaryTableViewCell cellWithTableView:tableView];
    cell.dateLabel.text = self.model.class_date;
    cell.timeLabel.text = self.model.class_hour;
    if (self.model.class_note.length==0) {
        cell.textView.PlaceHolder = NSLocalizedString(@"开始写日记...",nil);
    } else {
        cell.textView.text = self.model.class_note;
    }
    @weakify(self);
    cell.textView.delegate = self;
    [[cell.textView rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        self.model.class_note = x;
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    [textView endEditing:YES];
    self.model.class_note = textView.text;
    [self.tableView reloadData];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(JSFastLoginModel *)model{
    if (!_model) {
        _model = [[JSFastLoginModel alloc]init];
    }
    return _model;
}

@end
