//
//  AppDelegate.m
//  MaDanYang
//
//  Created by kckj on 2021/6/3.
//

#import "AppDelegate.h"
#import "AppDelegate+CKAppDelegate.h"
#import <WechatOpenSDK/WXApi.h>
#import <AlipaySDK/AlipaySDK.h>
#import <ImSDK/ImSDK.h>
@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    if ([MDYSingleCache shareSingleCache].token.length > 0) {
        [self setRootViewControllerWithLogin:YES];
    } else {
        [self setRootViewControllerWithLogin:NO];
    }
    
    [self.window makeKeyAndVisible];
    
    [self NetworkMonitoring];
    
    [WXApi registerApp:MDYWechatAppID universalLink:MDYUniversalLink];
    
    return YES;
}
/// 在这里写支持的旋转方向，为了防止横屏方向，应用启动时候界面变为横屏模式
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    // 可以这么写
    if (self.allowOrentitaionRotation) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self ___dealWithZFBPayWithResultDic:resultDic];
        }];
    }
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self ___dealWithZFBPayWithResultDic:resultDic];
        }];
    }
    return [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}
#pragma mark - Alipay
//支付宝支付结果处理
- (void)___dealWithZFBPayWithResultDic:(NSDictionary *)resultDic {
    if ([resultDic[@"resultStatus"] intValue] == 9000) {
        //支付成功
        [MBProgressHUD showSuccessfulWithMessage:@"支付成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:MDYWechatPaySuccess object:nil];
    }else {
        [MBProgressHUD showMessage:@"支付失败"];
    }
}
#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp{
    if([resp isKindOfClass:[SendAuthResp class]]){
        SendAuthResp *resp2 = (SendAuthResp *)resp;
        if (resp2.errCode != 0 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showMessage:@"微信授权失败"];
            });
            return;
        }
        if([resp2.state isEqualToString:@"login_state"]){//微信授权成功
//            [MBProgressHUD showMessage:resp2.code];
            [[NSNotificationCenter defaultCenter] postNotificationName:MDYWechatLoginSuccess object:resp2];
        }
    }
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *req = (PayResp *)resp;
        if (req.errCode == WXSuccess){
            [MBProgressHUD showSuccessfulWithMessage:@"支付成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:MDYWechatPaySuccess object:nil];
        }else if (req.errCode == WXErrCodeUserCancel) {
            //用户点击了取消
            [MBProgressHUD showMessage:@"您已取消支付"];
            [[UIViewController currentNavigatonController] popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showMessage:@"支付失败"];
            [[UIViewController currentNavigatonController] popViewControllerAnimated:YES];
        }
    }
}
@end
