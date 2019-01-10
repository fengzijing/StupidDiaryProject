//
//  PersonViewController.m
//  JSHeartDiary
//
//  Created by 锋子 on 2018/11/30.
//  Copyright © 2018 锋子. All rights reserved.
//

#import "BRPersonViewController.h"
#import "BRPersonalTableViewCell.h"

@interface BRPersonViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) UIImage * headerImage;

@property (nonatomic,copy) NSString * nickName;

@property (nonatomic,copy) NSString * signature;


@end

@implementation BRPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"个人信息", nil);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.headerImage = [JSUserInfo shareManager].header_image;
    self.nickName = [JSUserInfo shareManager].nickName;
    self.signature = [JSUserInfo shareManager].signature;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"保存", nil) style:UIBarButtonItemStylePlain target:self action:@selector(savePersonData)];
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

-(void)savePersonData {
    if (self.headerImage != nil) {
        CGSize imaageSize=self.headerImage.size;
        imaageSize.width*=0.45;
        imaageSize.height*=0.45;
        self.headerImage=[self imageWithImage:self.headerImage scaledToSize:imaageSize];
        NSData*imageData=[NSData dataWithData:UIImageJPEGRepresentation(self.headerImage,0.1)];
        self.headerImage=[UIImage imageWithData:imageData];
        [JSUserInfo shareManager].header_image = self.headerImage;
    }
    if (self.nickName.length > 0) {
        [JSUserInfo shareManager].nickName = self.nickName;
    }
    if (self.signature.length > 0) {
        [JSUserInfo shareManager].signature = self.signature;
    }
    
    if ([JSUserInfo shareManager].header_image == nil && [JSUserInfo shareManager].nickName.length == 0 && [JSUserInfo shareManager].signature.length == 0) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"请添加信息", nil)];
        return;
    }
    
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"添加信息成功!", nil)];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changePersonInformation" object:nil userInfo:nil];
}


# pragma mark - UITableViewDelegate UITableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 60;
    } else {
        return 40;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BRPersonalTableViewCell* cell = [BRPersonalTableViewCell cellWithTableView:tableView];
    cell.headerImageView.hidden = YES;
    cell.rightField.hidden = NO;
    cell.rightIMageView.hidden = YES;
    if (indexPath.row == 0) {
        cell.headerImageView.hidden = NO;
        cell.rightIMageView.hidden = NO;
        cell.rightField.hidden = YES;
        cell.titleLabel.text = NSLocalizedString(@"头像", nil);
        if (self.headerImage != nil) {
            cell.headerImageView.image = self.headerImage;
        }
    } else if (indexPath.row == 1) {
        cell.titleLabel.text = NSLocalizedString(@"昵称", nil);
        cell.rightField.placeholder = NSLocalizedString(@"请输入昵称", nil);
        if (self.nickName.length>0) {
            cell.rightField.text = self.nickName;
        }
        @weakify(self);
        [[cell.rightField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            self.nickName = x;
        }];
    } else {
        cell.titleLabel.text = NSLocalizedString(@"个性签名", nil);
        cell.rightField.placeholder = NSLocalizedString(@"请输入个性签名", nil);
        if (self.signature.length>0) {
            cell.rightField.text = self.signature;
        }
        @weakify(self);
        [[cell.rightField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            self.signature = x;
        }];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        WS(wSelf);
        [JSFPictureManager shareGetPicture:^(UIImage *image) {
            wSelf.headerImage = image;
            [wSelf.tableView reloadData];
        }];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}


@end
