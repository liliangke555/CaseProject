//
//  MDYLiveRoomMianController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/7.
//

#import "MDYLiveRoomMianController.h"
#import "MDYLiveRoomListController.h"
@interface MDYLiveRoomMianController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryNumberView *categoryView;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

@end

@implementation MDYLiveRoomMianController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titles = [NSMutableArray arrayWithArray:@[@"正在直播", @"直播预告", @"直播回放"]];
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
    MDYLiveRoomListController *vc = [[MDYLiveRoomListController alloc] init];
    if (index == 0) {
        vc.liveState = 1;
    } else if (index == 1) {
        vc.liveState = 0;
    } else {
        vc.liveState = 2;
    }
    return vc;
}
#pragma mark - Getter
- (JXCategoryNumberView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryNumberView alloc] init];
        _categoryView.delegate = self;
        [self.view addSubview:_categoryView];
        [_categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).mas_offset(16);
            make.left.right.equalTo(self.view).insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(44);
        }];
        [_categoryView setBackgroundColor:K_WhiteColor];
        _categoryView.titles = self.titles;
        _categoryView.numberLabelOffset = CGPointMake(20, 8);
        _categoryView.shouldMakeRoundWhenSingleNumber = YES;
        _categoryView.numberLabelHeight = 19;
        _categoryView.numberBackgroundColor = KHexColor(0xFF4646FF);
        _categoryView.numberLabelFont = KMediumFont(12);
        _categoryView.titleColorGradientEnabled = YES;
        [_categoryView setTitleFont:KSystemFont(16)];
        [_categoryView setTitleColor:K_TextGrayColor];
        [_categoryView setTitleSelectedColor:K_TextBlackColor];
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = K_MainColor;
        lineView.indicatorHeight = 2.0f;
        lineView.indicatorWidth = 60;
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
