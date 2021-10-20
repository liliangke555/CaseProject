//
//  MBProgressHUD+CKhud.h
//  CloudKind
//
//  Created by kckj on 2021/5/18.
//

#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (CKhud)
/// 显示HUD 消息
/// @param message 消息内容
+ (void)showMessage:(NSString *)message;
+ (void)showMessage:(NSString *)message toView:(UIView * __nullable)view;

/// 成功HUD
/// @param message 消息内容
+ (void)showSuccessfulWithMessage:(NSString *)message;

/// Loading HUD
/// @param message 消息内容
+ (void)showLoadingWithMessage:(NSString *)message;

+ (void)hideHUD;
+ (void)hideHUDWithView:(UIView * __nullable)view;
@end

NS_ASSUME_NONNULL_END
