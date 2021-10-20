//
//  UIViewController+MDYCurrentController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/11.
//

#import "UIViewController+MDYCurrentController.h"

@implementation UIViewController (MDYCurrentController)
+(instancetype)findBestViewController:(UIViewController *)vc {
    if (vc.presentedViewController) {
        return [self findBestViewController:vc.presentedViewController];
    }else if ([vc isKindOfClass:[UISplitViewController class]]){
        UISplitViewController *StockNewspaperssvc = (UISplitViewController *)vc;
        if (StockNewspaperssvc.viewControllers.count>0) {
            return [self findBestViewController:StockNewspaperssvc.viewControllers.lastObject];
        }else{
            return vc;
        }
    }else if ([vc isKindOfClass:[UINavigationController class]]){
        UINavigationController* StockNewspaperssvc = (UINavigationController*) vc;
        if (StockNewspaperssvc.viewControllers.count > 0) {
            return [self findBestViewController:StockNewspaperssvc.topViewController];
        } else {
            return vc;
        }
    }else if ([vc isKindOfClass:[UITabBarController class]]){
        UITabBarController* StockNewspaperssvc = (UITabBarController *)vc;
        if (StockNewspaperssvc.viewControllers.count > 0) {
            return [self findBestViewController:StockNewspaperssvc.selectedViewController];
        } else {
            return vc;
        }
    }else{
        return vc;
    }
}

+(UIViewController *)currentViewController{
    UIViewController *StockNewspapersviewController = [[UIApplication sharedApplication].delegate window].rootViewController;
    return [UIViewController findBestViewController:StockNewspapersviewController];
}

+ (UINavigationController *)currentNavigatonController {
    
    UIViewController * StockNewspaperscurrentViewController =  [UIViewController currentViewController];
    
    return StockNewspaperscurrentViewController.navigationController;
}
@end
