//
//  MDYPointOrderController.m
//  MaDanYang
//
//  Created by kckj on 2021/7/31.
//

#import "MDYPointOrderController.h"
#import "MDYOrderListController.h"
#import "MDYPointOrderListController.h"
@interface MDYPointOrderController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

@end

@implementation MDYPointOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titles = [NSMutableArray arrayWithArray:@[@"全部", @"待发货",@"待收货"]];
    [self.categoryView reloadData];
    [self.listContainerView reloadData];
}
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}
#pragma mark - JXCategoryListContainerViewDelegate
// 返回列表的数量
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}
// 根据下标 index 返回对应遵守并实现 `JXCategoryListContentViewDelegate` 协议的列表实例
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    MDYPointOrderListController *vc = [[MDYPointOrderListController alloc] init];
    if (index == 1) {
        vc.orderState = 2;
    } else if (index == 2) {
        vc.orderState = 3;
    } else {
        vc.orderState = index;
    }
    return vc;
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
            make.height.mas_equalTo(44);
        }];
        [_categoryView setBackgroundColor:K_WhiteColor];
        _categoryView.titles = self.titles;
        _categoryView.titleColorGradientEnabled = YES;
        [_categoryView setTitleFont:KSystemFont(16)];
        [_categoryView setTitleColor:K_TextGrayColor];
        [_categoryView setTitleSelectedColor:K_TextBlackColor];
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = K_MainColor;
        lineView.indicatorHeight = 2.0f;
//        lineView.indicatorWidth = 60;
        _categoryView.indicators = @[lineView];
        
        UIView *view = [[UIView alloc] init];
        [_categoryView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(_categoryView).insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(0.5f);
        }];
        [view setBackgroundColor:K_SeparatorColor];
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
