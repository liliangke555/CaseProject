//
//  CKNavigationController.m
//  CloudKind
//
//  Created by kckj on 2021/5/11.
//

#import "CKNavigationController.h"

@interface CKNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation CKNavigationController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationBar setShadowImage:[UIImage new]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setShadowImage:[UIImage new]];
//    [navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"signin_bottom_bg"] forBarMetrics:UIBarMetricsDefault];
    navigationBarAppearance.translucent = NO;
    NSDictionary *textAttributes = @{
        NSFontAttributeName : KMediumFont(17),
        NSForegroundColorAttributeName : K_TextBlackColor,
    };
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
    self.delegate = self;
    __weak typeof(self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
}
-(void)backController {
    [self popViewControllerAnimated:YES];
    
}
#pragma mark - Override
/// 跳转下一页事件
/// @param viewController 跳转的视图控制器
/// @param animated 是否动画
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        UIButton *button = [UIButton k_buttonWithTarget:self action:@selector(backController)];
        [button sizeToFit];
        button.frame = CGRectMake(0, 0, 24, 40);
        [button setTitle:@"  返回" forState:UIControlStateNormal];
        [button.titleLabel setFont:KSystemFont(16)];
        [button setTitleColor:K_TextBlackColor forState:UIControlStateNormal];
        [button setTitleColor:K_TextLightGrayColor forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateHighlighted];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    [super pushViewController:viewController animated:animated];
}
#pragma mark - ovrrideMethod
+ (void)initialize {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    NSDictionary *textAttributes = nil;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        textAttributes = @{
            NSFontAttributeName : [UIFont boldSystemFontOfSize:18.0f],
            NSForegroundColorAttributeName : [UIColor whiteColor],
        };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        textAttributes = @{
            UITextAttributeFont : [UIFont boldSystemFontOfSize:18.0f],
            UITextAttributeTextColor : [UIColor whiteColor],
            UITextAttributeTextShadowColor : [UIColor clearColor],
            UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero],
        };
#endif
    }
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}

@end
