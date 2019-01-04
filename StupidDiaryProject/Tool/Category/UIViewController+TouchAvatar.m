//
//  UIViewController+TouchAvatar.m
//  JSBaseSDK
//
//  Created by yky on 2017/12/26.
//

#import "UIViewController+TouchAvatar.h"
#import "JS3DImageViewController.h"
#import <objc/runtime.h>
//#import "SMCodeMacro.h"
#import "SMPageStyle.h"
#import "UIViewController+BackgroundAlpha.h"
@implementation UIViewController (TouchAvatar)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //获得viewController的生命周期方法的selector
        SEL systemSel = @selector(viewDidLoad);
        //自己实现的将要被交换的方法的selector
        SEL swizzSel = @selector(sm_viewDidLoad);
        //两个方法的Method
        Method systemMethod = class_getInstanceMethod([self class], systemSel);
        Method swizzMethod = class_getInstanceMethod([self class], swizzSel);
        
        //首先动态添加方法，实现是被交换的方法，返回值表示添加成功还是失败
        BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
        if (isAdd) {
            //如果成功，说明类中不存在这个方法的实现
            //将被交换方法的实现替换到这个并不存在的实现
            class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
        } else {
            //否则，交换两个方法的实现
            method_exchangeImplementations(systemMethod, swizzMethod);
        }
        //TODO,整理
        [self customGlobleNav];
        [self js_customBackButton];
    });
}

- (void)sm_viewDidLoad {
//    [self js_customBackButton];
    [self sm_viewDidLoad];
    //暂时处理连连左上角返回按钮隐藏 TODO
    if([NSStringFromClass([self class]) isEqualToString:@"LLRegResultViewController"]){
        [self.navigationController setNavigationBarHidden:YES];
    }
}
+ (void)js_customBackButton {
//    UIImage* backimage = JSImageName(@"sm_sm_goback");
//    [self.navigationController.navigationBar setBackIndicatorImage:backimage];
//    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:backimage];
//    UIBarButtonItem* backItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
//    [backItem setTintColor:[UIColor colorWithRed:0.690 green:0.690 blue:0.690 alpha:1.00]];
//    self.navigationItem.backBarButtonItem = backItem;
    NSBundle* smbundle = [NSBundle bundleForClass:NSClassFromString(@"JS3DImageViewController")];
    UIImage* backImage = [UIImage imageNamed:@"po_left_arrow" inBundle:smbundle compatibleWithTraitCollection:nil];
    [[UINavigationBar appearance] setBackIndicatorImage:backImage];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backImage];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-1500, 0) forBarMetrics:UIBarMetricsDefault];
}

+(void)customGlobleNav
{
    //初始化导航+导航字体
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]setBarTintColor:SMColorFromRGB(0x777CB5)];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [UINavigationBar appearance].barStyle = UIBarStyleBlack;
    
    if([UIFont fontNamesForFamilyName:@"Microsoft YaHei"]){
        UIFont* font = [UIFont fontWithName:@"Microsoft YaHei" size:18];
        if(font){
            [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:font}];
        }
    }
}

-(void)reigsterAvatar3DTouch:(UIImageView *)avatarImageView
{
    if (@available(iOS 9.0, *)) {
        avatarImageView.userInteractionEnabled = YES;
        [self registerForPreviewingWithDelegate:self sourceView:avatarImageView];
    }
}

-(UIViewController*)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    if (@available(iOS 9.0, *)){
        JS3DImageViewController* previewing = [JS3DImageViewController new];
        UIImageView* imageView = (UIImageView*)previewingContext.sourceView;
        previewing.avatarImage.image = imageView.image;
        return previewing;
    }else{
        return nil;
    }
}




@end

