//
//  JS3DImageViewController.m
//  JSBaseSDK
//
//  Created by yky on 2017/12/26.
//

#import "JS3DImageViewController.h"

@interface JS3DImageViewController ()

@end

@implementation JS3DImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImageView*)avatarImage
{
    if(_avatarImage == nil){
        _avatarImage = [[UIImageView alloc]init];
        _avatarImage.frame = self.view.frame;
        [self.view addSubview:_avatarImage];
    }
    return _avatarImage;
}

-(NSArray<id<UIPreviewActionItem>> *)previewActionItems
{
    UIPreviewAction* action = [UIPreviewAction actionWithTitle:@"关注" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
    }];
    UIPreviewAction* sendMsg = [UIPreviewAction actionWithTitle:@"发消息" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
    }];
    return @[action,sendMsg];
}

@end
