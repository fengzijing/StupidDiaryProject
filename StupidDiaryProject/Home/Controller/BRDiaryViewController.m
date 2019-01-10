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
    self.navigationItem.title = NSLocalizedString(@"日记", nil);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"保存", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveDiary)];
    if (self.isEditor) {
        [self customTimeModel];
    }
}

-(void)customTimeModel{
    NSArray * arrWeek=[NSArray arrayWithObjects:@"周六",@"周日",NSLocalizedString(@"周一", nil),@"周二",@"周三",@"周四",@"周五", nil];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear |NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitWeekday | NSCalendarUnitHour |NSCalendarUnitMinute |NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger week = [comps weekday];
    NSInteger seconds = [comps second];
    self.model.class_second = [NSString stringWithFormat:@"%ld",(long)seconds];
    self.model.class_week = [arrWeek objectAtIndex:week%7];
    self.model.class_date = [[MFDateFormatter share] stringOfDate:[NSDate date] format:@"yyyy.MM.dd"];
    self.model.class_hour = [[MFDateFormatter share] stringOfDate:[NSDate date] format:@"HH:mm"];
}

-(void)saveDiary{
    if (self.model.class_note.length==0) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"请填写您的日记", nil)];
        return;
    }
    NSMutableArray * array = [JSUserInfo shareManager].allArray;
    for (NSInteger i=0; i<array.count; i++) {
        JSFastLoginModel * allModel = array[i];
        if ([allModel.class_date isEqualToString:self.model.class_date]&&[allModel.class_second isEqualToString:self.model.class_second]&&[allModel.class_hour isEqualToString:self.model.class_hour]) {
            [array removeObject:allModel];
            continue;
        }
    }
    [array addObject:self.model];
    [JSUserInfo shareManager].allArray = array;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshDiaryClassNotication" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshAllDiaryClassNotication" object:nil userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
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

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self.view endEditing:YES];
//}

-(JSFastLoginModel *)model{
    if (!_model) {
        _model = [[JSFastLoginModel alloc]init];
    }
    return _model;
}

@end
