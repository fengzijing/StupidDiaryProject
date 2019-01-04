//
//  AllAlbumViewController.m
//  JSFPictureManager
//
//  Created by nuomi on 2017/9/15.
//  Copyright © 2017年 jsf. All rights reserved.
//

#import "AllAlbumViewController.h"
#import "AllAlbumCollectionViewCell.h"
#import "PhotoDetailsCollectionViewController.h"
#import "JSFPictureManager.h"

@interface AllAlbumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,AllAlbumCollectionViewCellDelegate>
{
    NSInteger count;
}
/** collectionView */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 存放改文件夹下的所有图片 */
@property (nonatomic, strong) NSMutableArray *fetchArray;
/** 保存选中图片在fetchArray中的索引 */
@property (nonatomic, strong) NSMutableArray *selectArray;
/** 保存选中的图片（这里面的类型是PHAsset） */
@property (nonatomic, strong) NSMutableArray *selectImageArray;
/** 保存选中的图片（这里面的类型是UIImage） */
@property (nonatomic, strong) NSMutableArray *imageArray;
/** targetSize */
@property (nonatomic,assign) CGSize targetSize;
/** 确定按钮 */
@property (nonatomic, strong) UIButton *determineBtn;
/** 底部view */
@property (nonatomic, strong) UIView *bottomView;
/** 预览按钮 */
@property (nonatomic, strong) UIButton *previewBtn;
/** 覆盖底部view上的view */
@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) NSMutableArray * dataArr;

@end

@implementation AllAlbumViewController

static NSString *albumid = @"albumcellid";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //取消边缘延伸效果，如果不取消，那么collectionView滚动的时候，滚动不到正确的具体位置
    self.automaticallyAdjustsScrollViewInsets = NO;
    //创建collectionView
    [self createCollectionView];
    //    [self getAllSource];
    //获取资源
    [self getSource];
    //注册collectionViewcell
    [self.collectionView registerClass:[AllAlbumCollectionViewCell class] forCellWithReuseIdentifier:albumid];
    [self.collectionView reloadData];
    //滚动到最后一个cell
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.fetchArray.count-1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    count = self.selectCount;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectPreviewImages:) name:@"selectPreviewImagesNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectImagesCount:) name:@"selectImagesCountNotification" object:nil];
    
}

//通知改变后的selectCount值
- (void)selectImagesCount:(NSNotification *)info
{
    self.selectCount = [[info.object objectForKey:@"selectCount"] integerValue];
}

//通知改变选择的状态
- (void)selectPreviewImages:(NSNotification *)info
{
    NSMutableArray * array = info.object;
    [self.selectArray removeAllObjects];
    self.selectCount = count;
    for (NSInteger i=0; i<array.count; i++) {
        @autoreleasepool {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
            AllAlbumCollectionViewCell * cell = (AllAlbumCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexpath];
            NSString * selectStr = array[i];
            
            if ([selectStr isEqualToString:@"select"]) {
                cell.selectBtn.selected = NO;
                [self judgeImageSelectedStateWithButton:cell.selectBtn];
            }else{
                if (cell.selectBtn.selected) {
                    cell.selectBtn.selected = YES;
                    [self judgeImageSelectedStateWithButton:cell.selectBtn];
                }
            }
            
        }
        
    }
    
}

/**
 创建CollectionView
 */
- (void)createCollectionView
{
    //展示图片
    [self.view addSubview:self.collectionView];
    //创建底部
    [self.view addSubview:self.bottomView];
    //横线
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 0, self.bottomView.bounds.size.width, 1);
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.bottomView addSubview:lineView];
    //预览
    [self.bottomView addSubview:self.previewBtn];
    //确定
    [self.bottomView addSubview:self.determineBtn];
    //底部覆盖的view
    [self.bottomView addSubview:self.coverView];
    
}

/**
 预览
 */
- (void)previewClick:(UIButton *)sender
{
    PhotoDetailsCollectionViewController *detailsControl = [[PhotoDetailsCollectionViewController alloc] init];
    //选中的数据集合
    detailsControl.assetArray = self.selectImageArray;
    //告诉PhotoDetailsCollectionViewController控制器从第一个开始预览
    detailsControl.item = 0;
    detailsControl.preview = @"preview";
    [self.navigationController pushViewController:detailsControl animated:YES];
}
/**
 确定
 */
- (void)determineClick:(UIButton *)sender
{
    [JSFPictureManager sharedManager].multiplePictureBlock(self.imageArray, nil);
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

/**
 获取改文件夹下的资源
 */
- (void)getSource
{
    PHAssetCollection *album = self.album;
    //只加载图片
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    PHFetchResult *albumResult = [PHAsset fetchAssetsInAssetCollection:album options:option];
    for (int i = 0; i < albumResult.count; i++) {
        PHAsset *asset = albumResult[i];
        [self.fetchArray addObject:asset];
    }
    
}
//没有使用，测试用的
- (void)getAllSource
{
    // 列出所有相册智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeMoment subtype:PHAssetCollectionSubtypeAny options:nil];
    // 这时 smartAlbums 中保存的应该是各个智能相册对应的 PHAssetCollection
    for (NSInteger i = 0; i < smartAlbums.count; i++) {
        // 获取一个相册（PHAssetCollection）
        PHCollection *collection = smartAlbums[i];
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            // 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset）
            //只加载图片
            PHFetchOptions *option = [[PHFetchOptions alloc] init];
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
            for (int i = 0; i < fetchResult.count; i++) {
                PHAsset *asset = fetchResult[i];
                [self.fetchArray addObject:asset];
            }
            
        }
    }
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.fetchArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AllAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:albumid forIndexPath:indexPath];
    
    PHAsset *asset = self.fetchArray[indexPath.item];
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager requestImageForAsset:asset targetSize:self.targetSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        cell.indexpath = indexPath;
        cell.selectArray = self.selectArray;
        cell.assetImage = result;
        cell.delegate = self;
    }];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoDetailsCollectionViewController *detailsControl = [[PhotoDetailsCollectionViewController alloc] init];
    //数据
    detailsControl.assetArray = self.fetchArray;
    //告诉PhotoDetailsCollectionViewController控制器，应该从第几个图片开始预览
    detailsControl.item = indexPath.item;
    if (self.dataArr.count>0) {
        [self.dataArr removeAllObjects];
    }
    for (NSInteger i=0; i<self.fetchArray.count; i++) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
        AllAlbumCollectionViewCell * cell = (AllAlbumCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexpath];
        NSString * selectStr;
        if (cell.selectBtn.selected==NO) {
            selectStr = @"isSelect";
        }else{
            selectStr = @"select";
        }
        
        [self.dataArr addObject:selectStr];
    }
    detailsControl.dataArr = self.dataArr;
    detailsControl.selectCount = self.selectCount;
    detailsControl.count = count;
    [self.navigationController pushViewController:detailsControl animated:YES];
}
/**
 AllAlbumCollectionViewCellDelegate代理方法
 */
- (void)albumCollectionViewCellBtn:(UIButton *)button
{
    [self judgeImageSelectedStateWithButton:button];
}
//判断选择图片的数量变化
- (void)judgeImageSelectedStateWithButton:(UIButton *)isSelectBtn
{
    if (isSelectBtn.selected) {//把取消选中的相册从数组中删除
        isSelectBtn.selected = NO;
        for (int i = 0; i < self.selectArray.count; i++) {
            if ([@(isSelectBtn.tag) isEqualToNumber:self.selectArray[i]]) {
                [self.selectArray removeObjectAtIndex:i];
                self.selectCount--;
            }
        }
    }else if (!isSelectBtn.selected) {//把选中的相册加入数组中
        if (self.selectCount >= 9) {
            UIAlertController *alterControl = [UIAlertController alertControllerWithTitle:@"" message:@"最多只能够选择9张图片" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
            [alterControl addAction:action];
            [self presentViewController:alterControl animated:YES completion:nil];
            return;
        }
        isSelectBtn.selected = YES;
        [self.selectArray addObject:@(isSelectBtn.tag)];
        self.selectCount++;
        //排序,把选中的相册按照以前的顺序排序
        for (int i = 0; i < self.selectArray.count-1; i++) {
            for (int j = 0; j < self.selectArray.count - i - 1; j++) {
                NSInteger firstIndex = [self.selectArray[j] integerValue];
                NSInteger secondIndex = [self.selectArray[j+1] integerValue];
                if (firstIndex > secondIndex) {
                    NSInteger tempIndex = [self.selectArray[j] integerValue];
                    self.selectArray[j] = self.selectArray[j+1];
                    self.selectArray[j+1]= @(tempIndex);
                }
                
            }
        }
        
    }
    //把选中的图片转换为PHAsset类型加入到selectImageArray数组中，把选中的图片转换为UIImage类型存储在imageArray数组中
    self.selectImageArray = nil;
    self.imageArray = nil;
    for (int i = 0; i < self.selectArray.count; i++) {
        NSInteger index = [self.selectArray[i] integerValue];
        if (index < self.fetchArray.count) {
            PHAsset *asset = self.fetchArray[index];
            [self.selectImageArray addObject:asset];
            PHImageManager *imageManager = [PHImageManager defaultManager];
            [imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                if (result) {
                    [self.imageArray addObject:result];
                }
            }];
        }
    }
    //处理底部 预览和确定 按钮的状态
    if (self.selectArray.count > 0) {
        self.coverView.hidden = YES;
        [self.previewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        NSString *str = [NSString stringWithFormat:@"(%ld)确定",(long)self.selectArray.count];
        [self.determineBtn setTitle:str forState:UIControlStateNormal];
        [self.determineBtn sizeToFit];
        self.determineBtn.center = CGPointMake(self.bottomView.bounds.size.width-(self.determineBtn.bounds.size.width/2+10), self.bottomView.bounds.size.height/2);
    }else
    {
        self.coverView.hidden = NO;
        [self.previewBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.determineBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.determineBtn sizeToFit];
        self.determineBtn.center = CGPointMake(self.bottomView.bounds.size.width-(self.determineBtn.bounds.size.width/2+10), self.bottomView.bounds.size.height/2);
    }
    
}

# pragma mark - 懒加载

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat margin = 4;
        CGFloat itemWH = (self.view.bounds.size.width - 5 * margin)/4;
        layout.itemSize = CGSizeMake(itemWH, itemWH);
        layout.minimumLineSpacing = margin;
        layout.minimumInteritemSpacing = margin;
        layout.sectionInset = UIEdgeInsetsMake(margin, margin, 0, margin);
        self.targetSize = CGSizeMake(itemWH * 2, itemWH * 2);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64-50) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}
//创建底部
-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.collectionView.frame), self.view.bounds.size.width, 50);
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}
//预览
-(UIButton *)previewBtn
{
    if (!_previewBtn) {
        _previewBtn = [[UIButton alloc] init];
        [_previewBtn setTitle:@"预览" forState:UIControlStateNormal];
        _previewBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_previewBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_previewBtn sizeToFit];
        _previewBtn.center = CGPointMake(10 + _previewBtn.bounds.size.width/2, self.bottomView.bounds.size.height/2);
        [_previewBtn addTarget:self action:@selector(previewClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previewBtn;
}

//确定
- (UIButton *)determineBtn
{
    if (!_determineBtn) {
        _determineBtn = [[UIButton alloc] init];
        [_determineBtn setTitle:@"确定" forState:UIControlStateNormal];
        _determineBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_determineBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [_determineBtn sizeToFit];
        _determineBtn.center = CGPointMake(self.bottomView.bounds.size.width-(_determineBtn.bounds.size.width/2+10), self.bottomView.bounds.size.height/2);
        [_determineBtn addTarget:self action:@selector(determineClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _determineBtn;
}

//底部覆盖的view
-(UIView*)coverView
{
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.frame = self.bottomView.bounds;
        _coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    }
    return _coverView;
}


- (NSMutableArray *)fetchArray
{
    if (_fetchArray == nil) {
        _fetchArray = [NSMutableArray array];
    }
    return _fetchArray;
}

- (NSMutableArray *)selectArray
{
    if (_selectArray == nil) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (NSMutableArray *)selectImageArray
{
    if (_selectImageArray == nil) {
        _selectImageArray = [NSMutableArray array];
    }
    return _selectImageArray;
}
- (NSMutableArray *)imageArray
{
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
