//
//  MDYMianOrderController.m
//  MaDanYang
//
//  Created by kckj on 2021/7/31.
//

#import "MDYMianOrderController.h"
#import "MDYMyOrderController.h"
#import "MDYPointOrderController.h"
@interface MDYMianOrderController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@end

@implementation MDYMianOrderController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    NSDictionary *textAttributes = @{
        NSFontAttributeName : KMediumFont(17),
        NSForegroundColorAttributeName : K_TextBlackColor,
    };
    [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSMutableArray *mvcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (id vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"MDYPlaceOrderController")]) {
            [mvcs removeObject:vc];
        }
    }
    self.navigationController.viewControllers = mvcs;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的订单";
    self.titles = [NSMutableArray arrayWithArray:@[@"普通订单", @"积分订单"]];
    [self.categoryView reloadData];
    [self.listContainerView reloadData];
}
#pragma mark - JXCategoryListContainerViewDelegate
// 返回列表的数量
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}
// 根据下标 index 返回对应遵守并实现 `JXCategoryListContentViewDelegate` 协议的列表实例
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 0) {
        MDYMyOrderController *vc = [[MDYMyOrderController alloc] init];
        return vc;
    } else {
        MDYPointOrderController *vc = [[MDYPointOrderController alloc] init];
        return vc;
    }
}
#pragma mark - Getter
- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.delegate = self;
        [self.view addSubview:_categoryView];
        [_categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).mas_offset(16);
            make.left.right.equalTo(self.view).insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(33);
        }];
        [_categoryView setBackgroundColor:K_WhiteColor];
        _categoryView.titles = self.titles;
        _categoryView.titleColorGradientEnabled = YES;
        [_categoryView setTitleFont:KSystemFont(16)];
        [_categoryView setTitleColor:K_MainColor];
        [_categoryView setTitleSelectedColor:K_WhiteColor];
        JXCategoryIndicatorBackgroundView *lineView = [[JXCategoryIndicatorBackgroundView alloc] init];
        lineView.indicatorColor = K_MainColor;
        [lineView setIndicatorWidth:88];
        [lineView setIndicatorCornerRadius:4];
        _categoryView.indicators = @[lineView];
    }
    return _categoryView;
}
- (JXCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        [self.view addSubview:_listContainerView];
        [_listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.categoryView.mas_bottom);
            make.left.right.bottom.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        // 关联到 categoryView
        self.categoryView.listContainer = _listContainerView;
    }
    return _listContainerView;
}
@end
