//
//  GroupTableViewController.m
//  JSFPictureManager
//
//  Created by nuomi on 2017/9/15.
//  Copyright © 2017年 jsf. All rights reserved.
//

#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)

#import "GroupTableViewController.h"
#import <Photos/Photos.h>
#import "GroupTableViewCell.h"
#import "AllAlbumViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface GroupTableViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 保存相册文件夹 */
@property (nonatomic, strong) NSMutableArray *fetchArray;
/** 存储视频文件夹 */
@property (nonatomic, strong) NSMutableArray *videoArray;
/** 计时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 存储所有的图片 */
@property (nonatomic, strong) PHAssetCollection *allAlbum;
@end

@implementation GroupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    self.title = @"相簿";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //从相册中获取资源
    [self getSource];
    //计时，每隔0.2s判断一次改程序是否被允许访问相册，当允许访问相册的时候，计时器停止工作
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(authorizationStateChange) userInfo:nil repeats:YES];
    self.timer = timer;
    
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 从相册中获取资源,获取的是文件夹
 */
- (void)getSource
{
    //1，PHAssetCollectionTypeSmartAlbum
    PHFetchResult * albumsFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    // 这时 smartAlbums 中保存的应该是各个智能相册对应的 PHAssetCollection
    for (NSInteger i = 0; i < albumsFetchResult.count; i++) {
        // 获取一个相册（PHAssetCollection）
        PHCollection * collection = albumsFetchResult[i];
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            if ([assetCollection.localizedTitle isEqualToString:@"Videos"]) {//过滤掉视频
                [self.videoArray addObject:assetCollection];
                continue;
            }
            if ([assetCollection.localizedTitle isEqualToString:@"All Photos"]) {
                self.allAlbum = assetCollection;
            }
            //只加载图片
            PHFetchOptions *option = [[PHFetchOptions alloc] init];
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
            // 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset）
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
            if (fetchResult.count > 0) {
                [self.fetchArray addObject:assetCollection];
            }
        }
    }
    
    
    //2，PHAssetCollectionTypeAlbum
    PHFetchResult * ownAlbumsFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    // 这时 smartAlbums 中保存的应该是各个智能相册对应的 PHAssetCollection
    for (NSInteger i = 0; i < ownAlbumsFetchResult.count; i++) {
        // 获取一个相册（PHAssetCollection）
        PHCollection * collection = ownAlbumsFetchResult[i];
        
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            
            if ([assetCollection.localizedTitle isEqualToString:@"Videos"]) {//过滤掉视频
                [self.videoArray addObject:assetCollection];
                continue;
            }
            //只加载图片
            PHFetchOptions *option = [[PHFetchOptions alloc] init];
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
            // 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset）
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
            
            if (fetchResult.count > 0) {
                [self.fetchArray addObject:assetCollection];
            }
        }
    }
    
}

/**
 计时器的方法，来监测改程序是否被授权访问相册，如果授权访问相册了，那么计时器停止工作
 */
- (void)authorizationStateChange
{
    if ([self authorizationStateAuthorized]) {//允许访问相册，计时器停止工作
        [self.timer invalidate];
        self.timer = nil;
        
        if (self.fetchArray.count == 0) {
            /**
             计时器停止工作的时候，重新获取以下相册中的数据，
             这段代码，只有当程序第一次访问相册的时候，或者在viewDidLoad中获取相册数据失败的时候，才会执行
             
             */
            [self getSource];
        }
        //刷新数据
        [self.tableView reloadData];
    }
}

/**
 判断是否授权，yes授权成功，no没有授权
 */
- (BOOL)authorizationStateAuthorized {
    if (iOS8Later) {
        if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) return YES;
    } else {
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized) return YES;
    }
    return NO;
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.fetchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellid = @"albumTableCell";
    GroupTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[GroupTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    
    PHAssetCollection *album = self.fetchArray[indexPath.row];
    //只加载图片
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    PHFetchResult *albumResult = [PHAsset fetchAssetsInAssetCollection:album options:option];
    //文件夹的名称
    NSString *title = [self getchineseAlbum:album.localizedTitle];
    
    //文件夹中的图片有多少张
    NSUInteger albumCount = albumResult.count;
    cell.nameTitle = [NSString stringWithFormat:@"%@(%ld)",title,(long)albumCount];
    //取出文件夹中的第一张图片作为文件夹的显示图片
    PHAsset *firstAsset = [albumResult firstObject];
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    
    [imageManager requestImageForAsset:firstAsset targetSize:CGSizeMake(160, 160) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        cell.nameImage = result;
    }];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PHAssetCollection *album = self.fetchArray[indexPath.row];
    AllAlbumViewController *albumControl = [[AllAlbumViewController alloc] init];
    //改文件夹的数据
    albumControl.album = album;
    //已经选中的相册中的照片的数量
    albumControl.selectCount = self.selectCount;
    [self.navigationController pushViewController:albumControl animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

/**
 把英文的文件夹名称转换为中文
 */
- (NSString *)getchineseAlbum:(NSString *)name
{
    NSString *newName;
    if ([name rangeOfString:@"Roll"].location != NSNotFound)         newName = @"相机胶卷";
    else if ([name rangeOfString:@"Stream"].location != NSNotFound)  newName = @"我的照片流";
    else if ([name rangeOfString:@"Added"].location != NSNotFound)   newName = @"最近添加";
    else if ([name rangeOfString:@"Selfies"].location != NSNotFound) newName = @"自拍";
    else if ([name rangeOfString:@"shots"].location != NSNotFound)   newName = @"截屏";
    else if ([name rangeOfString:@"Videos"].location != NSNotFound)  newName = @"视频";
    else if ([name rangeOfString:@"Panoramas"].location != NSNotFound)  newName = @"全景照片";
    else if ([name rangeOfString:@"Favorites"].location != NSNotFound)  newName = @"个人收藏";
    else if ([name rangeOfString:@"All Photos"].location != NSNotFound)  newName = @"所有照片";
    else newName = name;
    return newName;
}

# pragma mark - 懒加载
- (NSMutableArray *)fetchArray
{
    if (_fetchArray == nil) {
        _fetchArray = [NSMutableArray array];
    }
    return _fetchArray;
}
- (NSMutableArray *)videoArray
{
    if (_videoArray == nil) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}


@end
