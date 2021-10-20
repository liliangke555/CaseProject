//
//  UIViewController+MDYCurrentController.h
//  MaDanYang
//
//  Created by kckj on 2021/6/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (MDYCurrentController)
+ (UIViewController *)currentViewController;
+ (UINavigationController *)currentNavigatonController;
@end

NS_ASSUME_NONNULL_END
