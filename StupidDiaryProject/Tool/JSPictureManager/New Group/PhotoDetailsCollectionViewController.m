
//
//  PhotoDetailsCollectionViewController.m
//  JSFPictureManager
//
//  Created by nuomi on 2017/9/18.
//  Copyright © 2017年 jsf. All rights reserved.
//

#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

#define BundleImage(imageName)  [UIImage imageNamed:imageName inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil]

#import "PhotoDetailsCollectionViewController.h"
#import "PhotoDetailsCollectionViewCell.h"
#import <Photos/Photos.h>
#import "UIImage+ScaleImage.h"

#import "JSFPictureManager.h"


@interface PhotoDetailsCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray * imageArray;
@property (nonatomic, strong) NSMutableArray * imageArr;
@property (nonatomic, strong) UIButton * selectBtn;
@property (nonatomic, assign) NSInteger index;

@end

@implementation PhotoDetailsCollectionViewController

static NSString * const reuseIdentifier = @"albumcellid";

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(KScreenWidth, KScreenHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预览";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popVC)];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[PhotoDetailsCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    //滚动到item的位置
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.item inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
    self.selectBtn = [[UIButton alloc] init];
    self.selectBtn.selected = NO;
    self.selectBtn.frame = CGRectMake(self.view.bounds.size.width-27, 0, 27, 27);
    if ([self.dataArr[self.item] isEqualToString:@"isSelect"]) {
        [self.selectBtn setImage:BundleImage(@"def_picker") forState:UIControlStateNormal];
    }else{
        [self.selectBtn setImage:BundleImage(@"sel_picker") forState:UIControlStateNormal];
    }
    [self.selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.selectBtn];
    if (![self.preview isEqualToString:@"preview"]) {
        self.navigationItem.rightBarButtonItem = rightItem;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureClick)];
        
    }
    self.imageArray = [NSMutableArray array];
    self.imageArr = [NSMutableArray array];
    [self getSelectImageArray];
}
//确认
- (void)sureClick{
    [JSFPictureManager sharedManager].multiplePictureBlock(self.imageArray, nil);
    [self dismissViewControllerAnimated:YES completion:nil];
}
//选择图片
- (void)selectClick:(UIButton*)sender
{
    if (self.imageArr.count>=9-self.count) {
        NSString * str = self.dataArr[self.index];
        if ([str isEqualToString:@"select"]) {
            [self.selectBtn setImage:BundleImage(@"def_picker") forState:UIControlStateNormal];
            [self.dataArr replaceObjectAtIndex:self.index withObject:@"isSelect"];
            self.selectCount= self.selectCount-1;
            if (![self.preview isEqualToString:@"preview"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"selectPreviewImagesNotification" object:self.dataArr];
            }
            [self getSelectImageArray];
        }else{
            UIAlertController *alterControl = [UIAlertController alertControllerWithTitle:@"" message:@"最多只能够选择9张图片" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
            [alterControl addAction:action];
            [self presentViewController:alterControl animated:YES completion:nil];
            return;
        }
        
    }else{
        [self rightButtonClick];
        
    }
    
    
}
//改变选择图片的状态
- (void)rightButtonClick
{
    NSString * str = self.dataArr[self.index];
    if ([str isEqualToString:@"isSelect"]) {
        [self.selectBtn setImage:BundleImage(@"sel_picker") forState:UIControlStateNormal];
        [self.dataArr replaceObjectAtIndex:self.index withObject:@"select"];
        self.selectCount= self.selectCount+1;
    }else{
        [self.selectBtn setImage:BundleImage(@"def_picker") forState:UIControlStateNormal];
        [self.dataArr replaceObjectAtIndex:self.index withObject:@"isSelect"];
        self.selectCount= self.selectCount-1;
    }
    if (![self.preview isEqualToString:@"preview"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectPreviewImagesNotification" object:self.dataArr];
    }
    [self getSelectImageArray];
}
//获取已经选择的图片的image数组
- (void)getSelectImageArray
{
    [self.imageArr removeAllObjects];
    for (int i=0; i<self.dataArr.count; i++) {
        NSString * str = self.dataArr[i];
        if ([str isEqualToString:@"select"]) {
            [self.imageArr addObject:@(i)];
        }
    }
    if (self.imageArr.count>0) {
        for (int i=0; i<self.imageArr.count; i++) {
            NSInteger index = [self.imageArr[i] integerValue];
            if (index < self.assetArray.count) {
                PHAsset *asset = self.assetArray[index];
                PHImageManager *imageManager = [PHImageManager defaultManager];
                [imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    if (result) {
                        [self.imageArray addObject:result];
                    }
                }];
            }
            
        }
        
    }
    
}
# pragma mark -  scrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.index = scrollView.contentOffset.x/KScreenWidth;
    NSString * str = self.dataArr[self.index];
    if ([str isEqualToString:@"isSelect"]) {
        [self.selectBtn setImage:BundleImage(@"def_picker") forState:UIControlStateNormal];
    }else{
        [self.selectBtn setImage:BundleImage(@"sel_picker") forState:UIControlStateNormal];
    }
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoDetailsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    PHAsset *asset = self.assetArray[indexPath.item];
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        //处理图片按照比例缩放
        if (result.size.width > KScreenWidth || result.size.height > KScreenHeight) {
            CGFloat proportionW = result.size.width / KScreenWidth;
            CGFloat proportionH = result.size.height / KScreenHeight;
            if (proportionW > proportionH) {
                result = [UIImage image:result ByScalingAndCroppingForSize:CGSizeMake(result.size.width/proportionW, result.size.height/proportionW)];
            }else
            {
                result = [UIImage image:result ByScalingAndCroppingForSize:CGSizeMake(result.size.width/proportionH, result.size.height/proportionH)];
            }
        }
        cell.albumImage = result;
    }];
    return cell;
}
#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * selectCt = [NSString stringWithFormat:@"%ld",(long)self.selectCount];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectImagesCountNotification" object:@{@"selectCount":selectCt}];
    [self popVC];
}
-(void)popVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
