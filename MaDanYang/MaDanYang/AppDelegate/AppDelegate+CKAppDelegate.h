//
//  AppDelegate+CKAppDelegate.h
//  CloudKind
//
//  Created by kckj on 2021/5/11.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (CKAppDelegate)<UITabBarControllerDelegate>
- (void)setRootViewControllerWithLogin:(BOOL)isLogin;
// 网络监测
- (void)NetworkMonitoring;
@end

NS_ASSUME_NONNULL_END
