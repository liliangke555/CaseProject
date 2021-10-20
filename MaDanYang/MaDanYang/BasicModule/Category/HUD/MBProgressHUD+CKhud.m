//
//  MBProgressHUD+CKhud.m
//  CloudKind
//
//  Created by kckj on 2021/5/18.
//

#import "MBProgressHUD+CKhud.h"
#import <Lottie/Lottie.h>

@implementation MBProgressHUD (CKhud)
+ (void)showMessage:(NSString *)message {
    [self showMessage:message toView:nil];
}
+ (void)showMessage:(NSString *)message toView:(UIView * __nullable)view {
    if (!view) {
        view = [UIApplication sharedApplication].delegate.window;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.mode = MBProgressHUDModeCustomView;
    hud.contentColor = K_WhiteColor;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = K_hudBackgroundColor;
    hud.userInteractionEnabled = NO;
    [hud hideAnimated:YES afterDelay:1.5f];
}
+ (void)showSuccessfulWithMessage:(NSString *)message
{
    [self showSuccessfulWithMessage:message view:nil];
}
+ (void)showSuccessfulWithMessage:(NSString *)message view:(UIView *)view
{
    if (view == nil){
        view = (UIView*)[UIApplication sharedApplication].delegate.window;
    }
    LOTAnimationView *animationView = [LOTAnimationView animationWithFilePath:[[NSBundle mainBundle] pathForResource:@"lf30_editor_SbFWzN" ofType:@"json"]];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = animationView;
    if (message.length > 0) {
        hud.label.text = message;
        [hud.label setFont:[UIFont systemFontOfSize:14]];
        hud.label.numberOfLines = 2;
    }
    hud.square = YES;
    hud.contentColor = K_WhiteColor;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = K_hudBackgroundColor;
    [hud hideAnimated:YES afterDelay:1.5f];
    [animationView play];
}
+ (void)showLoadingWithMessage:(NSString *)message
{
    [self showLoadingWithMessage:message view:nil];
}
+ (void)showLoadingWithMessage:(NSString *)message view:(UIView *)view {
    if (view == nil){
        view = (UIView*)[UIApplication sharedApplication].delegate.window;
    }
    LOTAnimationView *animationView = [LOTAnimationView animationWithFilePath:[[NSBundle mainBundle] pathForResource:@"lf20_RZPIuU" ofType:@"json"]];
    animationView.loopAnimation = YES;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = animationView;
    if (message.length > 0) {
        hud.label.text = message;
        [hud.label setFont:[UIFont systemFontOfSize:14]];
        hud.label.numberOfLines = 2;
    }
    hud.square = YES;
    hud.contentColor = K_WhiteColor;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = K_hudBackgroundColor;
    [animationView play];
}

+ (void)hideHUD {
    [self hideHUDWithView:nil];
}
+ (void)hideHUDWithView:(UIView *)view {
    if (view == nil){
        view = (UIView*)[UIApplication sharedApplication].delegate.window;
    }
    [MBProgressHUD hideHUDForView:view animated:YES];
}
@end
