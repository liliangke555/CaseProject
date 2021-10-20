//
//  MDYTimeLImitedController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/10.
//

#import "MDYTimeLImitedController.h"
#import "MDYLiveRoomListController.h"
#import "MDYTimeLimtedCurriculunController.h"
@interface MDYTimeLImitedController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

@end

@implementation MDYTimeLImitedController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"限时秒杀";
    self.titles = [NSMutableArray arrayWithArray:@[@"课程秒杀", @"商品秒杀"]];
    
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
    MDYTimeLimtedCurriculunController *vc = [[MDYTimeLimtedCurriculunController alloc] init];
    CKWeakify(self);
    [vc setRefreshCountDownTime:^(NSInteger time) {
        
    }];
    vc.index = index;
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
            make.height.mas_equalTo(30);
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
            make.top.equalTo(self.categoryView.mas_bottom).mas_offset(8);
            make.left.right.bottom.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        // 关联到 categoryView
        self.categoryView.listContainer = _listContainerView;
        [_listContainerView.scrollView setScrollEnabled:NO];
    }
    return _listContainerView;
}
@end
