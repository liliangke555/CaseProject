//
//  AppDelegate+CKAppDelegate.m
//  CloudKind
//
//  Created by kckj on 2021/5/11.
//

#import "AppDelegate+CKAppDelegate.h"
#import "MDYMallController.h"
#import "MDYPlatformCerController.h"
#import <AFNetworking/AFNetworking.h>
#import "MDYUserInfoRequest.h"
@implementation AppDelegate (CKAppDelegate)
- (void)setRootViewControllerWithLogin:(BOOL)isLogin {
    if (isLogin) {
        CKTabbarController *tabbar = [[CKTabbarController alloc] init];
        tabbar.delegate = self;
        [self.window setRootViewController:tabbar];
        
    } else {
        MDYLoginViewController *tabbar = [[MDYLoginViewController alloc] init];
        CKNavigationController *nav = [[CKNavigationController alloc] initWithRootViewController:tabbar];
        [self.window setRootViewController:nav];
    }
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    __block BOOL isShould = YES;
    NSArray *array = viewController.childViewControllers;
    if ([array.firstObject isKindOfClass:MDYMallController.class]) {
        if ([[MDYSingleCache shareSingleCache].userModel.identity integerValue] != 1) {
            isShould = NO;
            MDYUserInfoRequest *request = [MDYUserInfoRequest new];
            request.hideLoadingView = YES;
            [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
                if (response.code != 0) {
                    return;
                }
                MDYUserModel *model = response.data;
                [MDYSingleCache shareSingleCache].userModel = model;
            } failHandler:^(MDYBaseResponse * _Nonnull response) {
            }];
            MDYPlatformCerController *vc = [[MDYPlatformCerController alloc] init];
            [[UIViewController currentNavigatonController] pushViewController:vc animated:YES];
            return isShould;
        }
    }
    return isShould;
}

// 网络监测
- (void)NetworkMonitoring {
    //1.创建网络状态监测管理者
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    //2.开启监听
    [manger startMonitoring];
    //3.监听网络状态的改变
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*
         AFNetworkReachabilityStatusUnknown = -1,
         AFNetworkReachabilityStatusNotReachable = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,
         */
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"此时没有网络");
//                self.isHaveNetworking = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"移动网络");
              
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi");
             
                break;
            default:
                break;
        }
    }];
}

@end
