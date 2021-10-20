//
//  CKScreen.h
//  CloudKind
//
//  Created by kckj on 2021/5/11.
//

#ifndef CKScreen_h
#define CKScreen_h

#import "AppDelegate.h"

/**屏幕宽度*/
#define CK_WIDTH  [UIScreen mainScreen].bounds.size.width
/**屏幕高度*/
#define CK_HEIGHT [UIScreen mainScreen].bounds.size.height

/**以6s为标准，定义一个宽度比例，用于计算动态高度*/
#define CK_Sales  DEVICE_WIDTH/375
///状态栏高度
#define KStatusHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define KIs_iphone [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone
/*({BOOL isPhone = NO;\
if (@available(iOS 12.0, *)) {\
isPhone = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone);\
} else {\
isPhone = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);\
}\
(isPhone);})*/

/*状态栏高度*/
#define KStatusBarHeight (CGFloat)(KIS_iPhoneX?(44.0):(20.0))
/*导航栏高度*/
#define KNavBarHeight (44)
/*状态栏和导航栏总高度*/
#define KNavBarAndStatusBarHeight (CGFloat)(KIS_iPhoneX?(88.0):(64.0))
/*TabBar高度*/
#define KTabBarHeight (CGFloat)(KIS_iPhoneX?(49.0 + 34.0):(49.0))
/*顶部安全区域远离高度*/
#define KTopBarSafeHeight (CGFloat)(KIS_iPhoneX?(44.0):(0))
/*底部安全区域远离高度*/
#define KBottomSafeHeight (CGFloat)(KIS_iPhoneX?(34.0):(0))
/*iPhoneX的状态栏高度差值*/
#define KTopBarDifHeight (CGFloat)(KIS_iPhoneX?(24.0):(0))
/*导航条和Tabbar总高度*/
#define KNavAndTabHeight (KNavBarAndStatusBarHeight + KTabBarHeight)

#define CK_Window [UIApplication sharedApplication].keyWindow
/**通用单例类*/
#define CK_interface(className) \
+ (className *)shared##className;

#define CK_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToKen; \
dispatch_once(&onceToKen, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared##className \
{ \
static dispatch_once_t onceToKen; \
dispatch_once(&onceToKen, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}

#define KIS_IPHONE_4 ([[UIScreen mainScreen] bounds].size.height == 480.0f)
#define KIS_IPHONE_5 ([[UIScreen mainScreen] bounds].size.height == 568.0f)
#define KIS_IPHONE_6 ([[UIScreen mainScreen] bounds].size.height == 667.0f)
#define KIS_IPHONE_6_PLUS ([[UIScreen mainScreen] bounds].size.height == 736.0f)
#define KIS_iPhoneX CK_WIDTH >=375.0f && CK_HEIGHT >=812.0f&& KIs_iphone

#define kAPPDelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#define CKWeakify(o)        __weak   typeof(self) weakSelf = o;
#define CKStrongify(o)      __strong typeof(self) o = strongSelf;

#endif /* CKScreen_h */
