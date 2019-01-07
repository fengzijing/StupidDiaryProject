//
//  MineViewController.m
//  StupidDiaryProject
//
//  Created by 锋子 on 2019/1/3.
//  Copyright © 2019 锋子. All rights reserved.
//

const CGFloat BackGroupHeight = 120;
const CGFloat HeadImageHeight= 60;

#import "BRMineViewController.h"
#import "AppDelegate.h"
#import "BRPersonViewController.h"

@interface BRMineViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIImageView *imageBG;
    UIImageView *headImageView;
    UILabel *nameLabel;
    UILabel *titleLabel;
}

@end

@implementation BRMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor blackColor];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageview.image = [UIImage imageNamed:@"leftbackiamge"];
    [self.view addSubview:imageview];
    
    UITableView *tableview = [[UITableView alloc] init];
    self.tableview = tableview;
    tableview.frame = self.view.bounds;
    tableview.dataSource = self;
    tableview.delegate  = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    self.tableview.contentInset=UIEdgeInsetsMake(BackGroupHeight, 0, 0, 0);
    [self cusotmHeaderView];
    [self changePersonInformation];
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"changePersonInformation" object:nil]takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self changePersonInformation];
    }];
}

-(void)changePersonInformation{
    if ([JSUserInfo shareManager].header_image != nil) {
        headImageView.image = [JSUserInfo shareManager].header_image;
    }
    if ([JSUserInfo shareManager].nickName.length>0) {
        nameLabel.text = [JSUserInfo shareManager].nickName;
    }
    
    if ([JSUserInfo shareManager].signature.length>0) {
        titleLabel.text = [JSUserInfo shareManager].signature;
    }
}

-(void)cusotmHeaderView
{
    imageBG = [[UIImageView alloc]init];
    imageBG.frame=CGRectMake(0, -BackGroupHeight, ScreenWidth, BackGroupHeight);
    imageBG.image=[UIImage imageNamed:@"background_image.jpg"];
    imageBG.contentMode = UIViewContentModeScaleAspectFill;
    imageBG.layer.masksToBounds = YES;
    [self.tableview addSubview:imageBG];
    
    UIView *BGView=[[UIView alloc]init];
    BGView.backgroundColor=[UIColor clearColor];
    BGView.frame=CGRectMake(0, -BackGroupHeight, ScreenWidth, BackGroupHeight);
    [self.tableview addSubview:BGView];
    
    //
    headImageView=[[UIImageView alloc]init];
    headImageView.image=[UIImage imageNamed:@"type_3c copy"];
    headImageView.layer.cornerRadius = 30;
    headImageView.layer.masksToBounds = YES;
    [BGView addSubview:headImageView];
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(BGView.mas_left).offset(20);
        make.top.equalTo(BGView.mas_top).offset(30);
        make.width.mas_offset(HeadImageHeight);
        make.height.mas_offset(HeadImageHeight);
    }];
    //
    
    nameLabel=[[UILabel alloc]init];
    if ([JSUserInfo shareManager].nickName.length==0) {
        NSString *name = [NSLocalizedString(@"昵称", nil) stringByReplacingOccurrencesOfString:@":" withString:@""];
        nameLabel.text = name;
    }
    nameLabel.textAlignment=NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = [UIColor whiteColor];
    [BGView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->headImageView.mas_right).offset(15);
        make.top.equalTo(self->headImageView.mas_top).offset(10);
        make.right.equalTo(BGView.mas_right).offset(-20);
    }];
    
    titleLabel=[[UILabel alloc]init];
    if ([JSUserInfo shareManager].signature.length==0) {
        NSString *name = [NSLocalizedString(@"个性签名", nil) stringByReplacingOccurrencesOfString:@":" withString:@""];
        titleLabel.text = name;
    }
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:11];
    titleLabel.numberOfLines = 2;
    titleLabel.textColor = [UIColor whiteColor];
    [BGView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->nameLabel.mas_left);
        make.top.equalTo(self->nameLabel.mas_bottom).offset(10);
        make.right.equalTo(BGView).offset(-20);
    }];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(setUpHeaderImage) forControlEvents:UIControlEventTouchUpInside];
    [BGView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(BGView);
    }];
    
    
}

-(void)setUpHeaderImage{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
    BRPersonViewController * personVC = [[BRPersonViewController alloc]init];
    [tempAppDelegate.mainNavigationController pushViewController:personVC animated:NO];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat xOffset = (yOffset + BackGroupHeight)/2;
    
    if (yOffset < -BackGroupHeight) {
        
        CGRect rect = imageBG.frame;
        rect.origin.y = yOffset;
        rect.size.height =  -yOffset ;
        rect.origin.x = xOffset;
        rect.size.width = ScreenWidth + fabs(xOffset)*2;
        
        imageBG.frame = rect;
    }
    
}


- (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"所有日记";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"意见反馈";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"隐私协议";
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"清除缓存";
    } else if (indexPath.row == 4) {
        cell.textLabel.text = @"关于我们";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    otherViewController *vc = [[otherViewController alloc] init];
    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
    
//    [tempAppDelegate.mainNavigationController pushViewController:vc animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 30)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
