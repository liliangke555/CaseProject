//
//  MDYMyQuestionController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/18.
//

#import "MDYMyQuestionController.h"
#import "MDYMyQuestionListController.h"
@interface MDYMyQuestionController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

@end

@implementation MDYMyQuestionController
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的问答";
    self.titles = [NSMutableArray arrayWithArray:@[@"全部", @"我发起的", @"我购买的"]];
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
    MDYMyQuestionListController *vc = [[MDYMyQuestionListController alloc] init];
    vc.indexType = index;
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
