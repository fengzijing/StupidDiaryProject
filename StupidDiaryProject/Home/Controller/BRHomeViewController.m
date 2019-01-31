//
//  HomeViewController.m
//  StupidDiaryProject
//
//  Created by 锋子 on 2019/1/3.
//  Copyright © 2019 锋子. All rights reserved.
//

#import "BRHomeViewController.h"
#import "AppDelegate.h"
#import "FSCalendar.h"
#import "MFDateFormatter.h"
#import <EventKit/EventKit.h>
#import "BRHomeTableViewCell.h"
#import "BRDiaryViewController.h"

@interface BRHomeViewController ()<FSCalendarDelegate, FSCalendarDataSource,UITableViewDelegate, UITableViewDataSource>
{
    FSCalendarScope currentScope;
    NSCalendar *chinessCalendar;
    NSArray *lunarChars;//农历
    NSArray *lunarMonths;
}
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic, copy) NSArray<EKEvent *> *events;
@property (strong, nonatomic) FSCalendar *calendar;
@property (nonatomic,strong) UITableView * tableView;

@end

@implementation BRHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *formatterStr = @"yyyy.MM.dd";
    self.navigationItem.title = [[MFDateFormatter share] stringOfDate:[NSDate date] format:formatterStr];
    [self customCalendarView];
    [self cusotmDataSource:[[MFDateFormatter share] stringOfDate:[NSDate date] format:formatterStr]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(0, 0, 30, 30);
    UIImage * image = [[UIImage alloc]init];
//    if ([JSUserInfo shareManager].header_image != nil) {
//        image = [JSUserInfo shareManager].header_image;
//        selectBtn.layer.cornerRadius = 15;
//        selectBtn.layer.masksToBounds = YES;
//        selectBtn.contentMode = UIViewContentModeScaleToFill;
//    }else{
        image = [UIImage imageNamed:@"menu"];
//    }
    [selectBtn setImage:image forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:selectBtn];
    [self customDiaryView];
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"refreshDiaryClassNotication" object:nil]takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        NSString *formatterStr = @"yyyy.MM.dd";
        [self cusotmDataSource:[[MFDateFormatter share] stringOfDate:self.calendar.selectedDate format:formatterStr]];
    }];
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
    //日历events
    if ([self preferredLanguageChiness]) {
        [self requestAccessToEntityType];
    }
}

-(void)customDiaryView{
    [self.view addSubview:self.tableView];
    UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(0,0,50,50)];
    [btn setBackgroundImage:[UIImage imageNamed:@"add_diary"] forState:UIControlStateNormal];
//    btn.backgroundColor=[UIColor orangeColor];
    [btn addTarget:self action:@selector(beginWriteDiary) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius=25;
    btn.center = CGPointMake(ScreenWidth-50, ScreenHeight-120);
    [self.view addSubview:btn];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [btn addGestureRecognizer:panGestureRecognizer];
}

-(void)beginWriteDiary{
    BRDiaryViewController * diaryVC = [[BRDiaryViewController alloc]init];
    diaryVC.isEditor = YES;
    [self.navigationController pushViewController:diaryVC animated:YES];
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


-(void)customCalendarView{
    
    chinessCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    lunarChars = @[@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"廿十",@"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十"];
    lunarMonths = @[@"正月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"冬月",@"腊月"];
    [self.view addSubview:self.calendar];
//    currentScope = FSCalendarScopeWeek;
    currentScope = FSCalendarScopeMonth;
    self.calendar.scope = currentScope;
    
    if (ScreenHeight>736) {
        self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.calendar.frame), ScreenWidth, ScreenHeight-88- CGRectGetMaxY(self.calendar.frame));
    }else{
        self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.calendar.frame), ScreenWidth, ScreenHeight-64- CGRectGetMaxY(self.calendar.frame));
    }

    self.calendar.backgroundColor = SMColorFromRGB(0xFFFFFF);
    self.calendar.appearance.headerTitleColor = SMColorFromRGB(0x666666);
    self.calendar.appearance.titleDefaultColor = SMColorFromRGB(0x999999);
    self.calendar.appearance.weekdayTextColor = SMColorFromRGB(0xA9A9A9);
    self.calendar.appearance.todayColor = SMColorFromRGB(0xeb5300);
    self.calendar.appearance.selectionColor = SMColorFromRGB(0x777CB5);
    self.calendar.appearance.subtitleFont = [UIFont systemFontOfSize:10.0];
    self.calendar.appearance.titleFont = [UIFont systemFontOfSize:12.0];
}


- (void)calendarChangeStype{
    if (currentScope == FSCalendarScopeWeek) {
        currentScope = FSCalendarScopeMonth;
    }else if (currentScope == FSCalendarScopeMonth){
        currentScope = FSCalendarScopeWeek;
    }
    
    [self.calendar setScope:currentScope animated: YES];
}

-(void)cusotmDataSource:(NSString*)date{
//    [JSUserInfo shareManager].allArray = [NSMutableArray array];
    NSMutableArray * arr = [NSMutableArray array];
    NSMutableArray * array = [JSUserInfo shareManager].allArray;
    if (array.count>0) {
        for (JSFastLoginModel * model in array) {
            if ([date isEqualToString:model.class_date]) {
                [arr addObject:model];
            }
        }
    }
    self.dataArr = arr;
    [self.tableView reloadData];
}


- (BOOL)preferredLanguageChiness
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    BOOL isChinessLanguage;
    if ([preferredLang rangeOfString:@"zh-Hans"].location != NSNotFound) {//如果是中文
        isChinessLanguage = YES;
    }else{
        isChinessLanguage = NO;
    }
    return isChinessLanguage;
}
#pragma mark --- FSCalendar
- (void)requestAccessToEntityType{
    __weak typeof(self) weakSelf = self;
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {//请求日历权限
        if(granted) {
            NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow: -3600*24*360]; // 开始日期
            NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow: 3600*24*360]; // 截止日期
            NSPredicate *fetchCalendarEvents = [store predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
            NSArray<EKEvent *> *eventList = [store eventsMatchingPredicate:fetchCalendarEvents];
            NSArray<EKEvent *> *events = [eventList filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EKEvent * _Nullable event, NSDictionary<NSString *,id> * _Nullable bindings) {
                return event.calendar.subscribed;
            }]];
            
            weakSelf.events = events;
        }
    }];
}

- (NSArray*)eventsForDate:(NSDate *)date{
    NSArray*filteredEvents = [self.events filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EKEvent * _Nullable evaluatedObject, NSDictionary* _Nullable bindings) {
        return [evaluatedObject.occurrenceDate isEqualToDate:date];
    }]];
    return filteredEvents;
}//返回特殊节日的方法

- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date{
    if ([self preferredLanguageChiness]) {
        EKEvent *event = [self eventsForDate:date].firstObject;
        if (event) {
            return event.title;
        }
        
        NSInteger day = [chinessCalendar component:NSCalendarUnitDay fromDate:date];
        if (day == 1) {
            NSInteger month = [chinessCalendar component:NSCalendarUnitMonth fromDate:date];
            return lunarMonths[month - 1];
        }
        return lunarChars[day - 1]; // 初一、初二、初三...
    } else {
        return  nil;
    }
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    NSString *formatterStr = @"yyyy.MM.dd";
    self.navigationItem.title = [[MFDateFormatter share] stringOfDate:self.calendar.selectedDate format:formatterStr];
    [self cusotmDataSource:[[MFDateFormatter share] stringOfDate:self.calendar.selectedDate format:formatterStr]];
}

// 设置五行显示时的calendar布局
- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated {
    
    if (calendar == self.calendar) {
        calendar.frame = (CGRect){calendar.frame.origin, bounds.size};
        [self.tableView beginUpdates];
        if (ScreenHeight>736) {
            self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.calendar.frame), ScreenWidth, ScreenHeight-88- CGRectGetMaxY(self.calendar.frame));
        }else{
            self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.calendar.frame), ScreenWidth, ScreenHeight-64- CGRectGetMaxY(self.calendar.frame));
        }
        [self.tableView endUpdates];
    }
    NSLog(@"0---%f",calendar.frame.origin.y);
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


//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 190;
//}

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
    cell.weekLabel.text = NSLocalizedString(model.class_week, nil);
    cell.noteLabel.text = model.class_note;
    cell.timeLabel.text = model.class_hour;
    [cell.deleteBtn addTarget:self action:@selector(deleteDiary:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteBtn.tag = 1200+indexPath.row;
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JSFastLoginModel * model = self.dataArr[indexPath.row];
    BRDiaryViewController * diaryVC = [[BRDiaryViewController alloc]init];
    diaryVC.isEditor = NO;
    diaryVC.model = model;
    [self.navigationController pushViewController:diaryVC animated:YES];
}


-(void)deleteDiary:(UIButton*)sender{
    WS(wSelf);
    JSCommonAlertView *alter = [[JSCommonAlertView alloc]initWithTitle:nil  textArray:@[NSLocalizedString(@"确定删除该日记？", nil)] textAlignment:TextAlignmentCenter buttonStyle:ButtonLandscapeStyle];
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
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (currentScope == FSCalendarScopeWeek) {
        if (self.tableView.contentOffset.y<0) {
            currentScope = FSCalendarScopeWeek;
            [self calendarChangeStype];
        }
    }else if (currentScope == FSCalendarScopeMonth){
        if (self.tableView.contentOffset.y>0) {
            currentScope = FSCalendarScopeMonth;
            [self calendarChangeStype];
        }
    }
}


#pragma mark -- colorSet
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
    UIViewController *n = self.navigationController;
    UIViewController *s = n.tabBarController.selectedViewController;
    UIViewController *t = self.navigationController.topViewController;
    UIViewController *v = self.presentedViewController;
    
    if(t == self
       && (s == n || !s)
       && ([v isKindOfClass:[UIImagePickerController class]]))
    {
        NSLog(@"ignore didReceiveMemoryWarning %@",self.description);
        return;
    }
    
    NSString* systemVersion = [[UIDevice currentDevice] systemVersion];
    CGFloat sysVersion = [systemVersion floatValue];
    if (sysVersion >= 6.0)
    {
        if(self.isViewLoaded && !self.view.window){
            self.view = nil;
        }
    }
    
}


#pragma getter----setter

- (FSCalendar *)calendar{
    if (!_calendar) {
        _calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 300)];
        _calendar.layer.cornerRadius = 5.0;
        _calendar.dataSource = self;
        _calendar.delegate = self;
        _calendar.locale = [NSLocale currentLocale];
        _calendar.firstWeekday = 1;
        _calendar.appearance.headerDateFormat = @"yyyy.MM";
        _calendar.headerHeight = FSCalendarDefaultHourComponent;
        _calendar.appearance.headerMinimumDissolvedAlpha = 0;//上下月透明度
        [_calendar selectDate:[NSDate date]];//默认选中今天
    }
    return _calendar;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        if (ScreenHeight>736) {
            _tableView.frame = CGRectMake(0, CGRectGetMaxY(self.calendar.frame), ScreenWidth, ScreenHeight-88- CGRectGetMaxY(self.calendar.frame));
        }else{
            _tableView.frame = CGRectMake(0, CGRectGetMaxY(self.calendar.frame), ScreenWidth, ScreenHeight-64- CGRectGetMaxY(self.calendar.frame));
        }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 60;
    }
    return _tableView;
}



@end
