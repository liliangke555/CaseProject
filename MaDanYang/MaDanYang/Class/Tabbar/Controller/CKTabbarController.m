//
//  CKTabbarController.m
//  CloudKind
//
//  Created by kckj on 2021/5/11.
//

#import "CKTabbarController.h"
#import "MDYHomeController.h"
#import "CKNavigationController.h"
#import "MDYMallController.h"
#import "MDYShoppingCarController.h"
#import "MDYMineController.h"

static CGFloat const hn_CYLTabBarControllerHeight = 49.0f;
@interface CKTabbarController ()
@property (nonatomic, readwrite, strong) CYLTabBarController *tabBarController;
@end

@implementation CKTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
}

- (instancetype)init {
    if (!(self = [super init])) {
        return nil;
    }
    
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIOffset titlePositionAdjustment = UIOffsetMake(0, 0);
    CYLTabBarController *tabBarController = [CYLTabBarController tabBarControllerWithViewControllers:self.tabbarViewControllers
                                                                               tabBarItemsAttributes:self.tabBarItemsAttributesForController
                                                                                         imageInsets:imageInsets
                                                                             titlePositionAdjustment:titlePositionAdjustment
                                                                                             context:@""];
    [self hn_customizeTabBarAppearance:tabBarController];
    return (self = (CKTabbarController *)tabBarController);
}
- (NSArray *)tabBarItemsAttributesForController {
    NSDictionary *locationAttributes = @{
        CYLTabBarItemTitle : @"首页",
        CYLTabBarItemImage : @"tabbar_home_normal",
        CYLTabBarItemSelectedImage : @"tabbar_home_selected",
    };
    NSDictionary *categoryAttributes = @{
        CYLTabBarItemTitle : @"商城",
        CYLTabBarItemImage : @"tabbar_mall_normal",
        CYLTabBarItemSelectedImage : @"tabbar_mall_selected",
    };
    
    NSDictionary *shopAttributes = @{
        CYLTabBarItemTitle : @"购物车",
        CYLTabBarItemImage : @"tabbar_shop_normal",
        CYLTabBarItemSelectedImage : @"tabbar_shop_selected",
    };
    
    NSDictionary *discountAttributes = @{
        CYLTabBarItemTitle : @"我的",
        CYLTabBarItemImage : @"tabbar_mine_normal",
        CYLTabBarItemSelectedImage : @"tabbar_mine_selected",
    };
    
    NSArray *hn_tabBarItemsAttributes = @[
        locationAttributes,
        categoryAttributes,
        shopAttributes,
        discountAttributes,
    ];
    return hn_tabBarItemsAttributes;
}
- (void)hn_customizeTabBarAppearance:(CYLTabBarController *)tabBarController {
    tabBarController.tabBarHeight = KIS_iPhoneX ? (hn_CYLTabBarControllerHeight +34) : hn_CYLTabBarControllerHeight;
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = K_TextGrayColor;
    normalAttrs[NSFontAttributeName] = KSystemFont(12);
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = K_TextBlackColor;
    selectedAttrs[NSFontAttributeName] = KSystemFont(12);
    
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    [self customizeTabBarSelectionIndicatorImage];
}
- (void)customizeTabBarSelectionIndicatorImage { 
    CGFloat hn_tabBarHeight = KIS_iPhoneX ? (hn_CYLTabBarControllerHeight + 34):hn_CYLTabBarControllerHeight;
    CGSize hn_selectionIndicatorImageSize = CGSizeMake(CYLTabBarItemWidth, hn_tabBarHeight);
    UITabBar *hn_tabBar = [self cyl_tabBarController].tabBar ?: [UITabBar appearance];
    [hn_tabBar setSelectionIndicatorImage:
     [[self class] hn_imageWithColor:[UIColor clearColor]
                                size:hn_selectionIndicatorImageSize]];
    [hn_tabBar setBackgroundImage:[UIImage ck_imageWithColor:[UIColor whiteColor]]];
    [hn_tabBar setShadowImage:[[self class] hn_imageWithColor:[UIColor k_colorWithHex:0xDDDDDDFF] size:CGSizeMake(CK_WIDTH, 0.5)]];
}
+ (UIImage *)hn_scaleImage:(UIImage *)image toScale:(float)scaleSize {
    UIGraphicsBeginImageContext(CGSizeMake([UIScreen mainScreen].bounds.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
+ (UIImage *)hn_imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width + 1, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
#pragma mark - Getter
- (NSArray *)tabbarViewControllers{
    
    //
    MDYHomeController *homeController = [[MDYHomeController alloc] init];
//    homeController.navigationItem.title = @"首页";
    CKNavigationController *homeNav = [[CKNavigationController alloc]
                                        initWithRootViewController:homeController];
    //
    MDYMallController *categoryController  = [[MDYMallController alloc] init];
//    categoryController.navigationItem.title = @"商城";
    CKNavigationController *categoryNav = [[CKNavigationController alloc]
                                            initWithRootViewController:categoryController];
    //
    MDYShoppingCarController *discountController = [[MDYShoppingCarController alloc] init];
    discountController.navigationItem.title = @"购物车";
    CKNavigationController *discountNav = [[CKNavigationController alloc]
                                                 initWithRootViewController:discountController];
    
    MDYMineController *mineController = [[MDYMineController alloc] init];
    mineController.navigationItem.title = @"我的";
    CKNavigationController *mineNav = [[CKNavigationController alloc]
                                                 initWithRootViewController:mineController];

    NSArray *tabbarViewControllerArr = @[
        homeNav,
        categoryNav,
        discountNav,
        mineNav,
    ];
    return tabbarViewControllerArr;
}
@end
