//
//  MDYSearchController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/5.
//

#import "MDYSearchController.h"
#import "CollectionViewLeftOrRightAlignedLayout.h"
#import "MDYSearchHistoryCollectionCell.h"
#import "MDYSearchCollectionView.h"
#import "MDYSearchResultTableCell.h"
#import "MDYSearchCurriculumRequest.h"
#import "MDYSearchGoodsRequest.h"
#import "MDYGoodsDetailsController.h"
#import "MDYCourseDetailController.h"
@interface MDYSearchController ()<UITextFieldDelegate,HorizontalCollectionLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITextField *searchText;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, assign) NSInteger pageNum;
@end
static CGFloat topViewHeight = 50;
static NSString *homeSearchHistory = @"homeSearchHistory";
static NSString *mallSearchHistory = @"mallSearchHistory";
@implementation MDYSearchController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:self.isSearchGoods ? mallSearchHistory : homeSearchHistory];
    self.historyArray = [NSMutableArray arrayWithArray:array];
    self.resultArray = [NSMutableArray array];
    [self createView];
    [self scrollView];
    [self.scrollView addSubview:self.collectionView];
    [self.scrollView addSubview:self.tableView];
    CKWeakify(self);
    self.tableView.mj_footer = [MDYRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf seachCourseData];
    }];
}
- (void)createView {
    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.height.mas_equalTo(topViewHeight + KStatusBarHeight);
    }];
    self.topView = topView;
    
    UITextField *textField = [[UITextField alloc] init];
    [topView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).mas_offset(KStatusBarHeight + 8);
        make.height.mas_equalTo(34);
    }];
    [textField setTextColor:K_TextBlackColor];
    [textField.layer setCornerRadius:6];
    [textField setClipsToBounds:YES];
    [textField setBackgroundColor:KHexColor(0xF5F5F5FF)];
    textField.delegate = self;
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, 36, 34);
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setContentMode:UIViewContentModeCenter];
    imageView.frame = CGRectMake(0, 0, 36, 34);
    [imageView setImage:[UIImage imageNamed:@"search_gray_icon"]];
    [view addSubview:imageView];
    [textField setLeftViewMode:UITextFieldViewModeAlways];
    [textField setLeftView:view];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"搜索" attributes:
        @{NSForegroundColorAttributeName:K_TextLightGrayColor,
                        NSFontAttributeName:KSystemFont(14)
        }];
    textField.attributedPlaceholder = attrString;
    [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [textField setReturnKeyType:UIReturnKeySearch];
    self.searchText = textField;
    
    UIButton *backButton = [UIButton k_buttonWithTarget:self action:@selector(backButtonAction:)];
    [topView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).mas_offset(12);
        make.right.equalTo(textField.mas_left).mas_offset(-16);
        make.centerY.equalTo(textField.mas_centerY);
        make.width.mas_equalTo(60);
    }];
    [backButton setTitle:@"  返回" forState:UIControlStateNormal];
    [backButton setTitleColor:K_TextBlackColor forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
    [backButton.titleLabel setFont:KSystemFont(16)];
    
    UIButton *searchButton = [UIButton k_buttonWithTarget:self action:@selector(searchButtonAction:)];
    [topView addSubview:searchButton];
    [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textField.mas_right).mas_offset(16);
        make.right.equalTo(topView.mas_right).mas_offset(-12);
        make.centerY.equalTo(textField.mas_centerY);
        make.width.mas_equalTo(40);
    }];
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [searchButton setTitleColor:K_MainColor forState:UIControlStateNormal];
    [searchButton.titleLabel setFont:KMediumFont(14)];
}
#pragma mark - Networking
- (void)seachCourseData {
    MDYSearchCurriculumRequest *request = [MDYSearchCurriculumRequest new];
    request.key_word = self.searchText.text;
    request.page = self.pageNum;
    request.limit = 50;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
//        [weakSelf.tableView.mj_footer endRefreshing];
        if (weakSelf.pageNum == 1) {
            weakSelf.resultArray = [NSMutableArray arrayWithArray:response.data];
        } else {
            [weakSelf.resultArray addObjectsFromArray:response.data];
        }
        if (weakSelf.resultArray.count >= response.count) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            weakSelf.pageNum ++;
        }
        [weakSelf.tableView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
//        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
- (void)searchGoodsData {
    MDYSearchGoodsRequest *request = [MDYSearchGoodsRequest new];
    request.key_word = self.searchText.text;
    request.page = self.pageNum;
    request.limit = 50;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
//        [weakSelf.tableView.mj_footer endRefreshing];
        if (weakSelf.pageNum == 1) {
            weakSelf.resultArray = [NSMutableArray arrayWithArray:response.data];
        } else {
            [weakSelf.resultArray addObjectsFromArray:response.data];
        }
        if (weakSelf.resultArray.count >= response.count) {
//            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            weakSelf.pageNum ++;
        }
        [weakSelf.tableView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark - IBAction
- (void)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self.collectionView reloadData];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self toSearch];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.scrollView setContentOffset:CGPointMake(CK_WIDTH, 0) animated:YES];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length <= 0) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        [self toSearch];
    }
}
- (void)toSearch {
    if (![self.historyArray containsObject:self.searchText.text]) {
        [self.historyArray addObject:self.searchText.text];
        [[NSUserDefaults standardUserDefaults] setObject:self.historyArray forKey:self.isSearchGoods ? mallSearchHistory : homeSearchHistory];
    }
    if (self.isSearchGoods) {
        self.pageNum = 1;
        [self searchGoodsData];
    } else {
        self.pageNum = 1;
        [self seachCourseData];
    }
}
#pragma mark - HorizontalCollectionLayoutDelegate
- (NSString *)collectionViewItemSizeWithIndexPath:(NSIndexPath *)indexPath {
    return self.historyArray[indexPath.row];
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = CGSizeMake(CK_WIDTH, 56);
    return size;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.historyArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MDYSearchHistoryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYSearchHistoryCollectionCell.class) forIndexPath:indexPath];
    cell.title = self.historyArray[indexPath.item];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            [collectionView registerClass:MDYSearchCollectionView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(MDYSearchCollectionView.class)];
            MDYSearchCollectionView *tempHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                     withReuseIdentifier:NSStringFromClass(MDYSearchCollectionView.class)
                                                                                            forIndexPath:indexPath];
            CKWeakify(self);
            [tempHeaderView setDidClickDelete:^{
                [weakSelf.historyArray removeAllObjects];
                [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:weakSelf.isSearchGoods ? mallSearchHistory : homeSearchHistory];
                [weakSelf.collectionView reloadData];
            }];
            reusableView = tempHeaderView;
        }
    }
    return reusableView;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    self.searchText.text = self.historyArray[indexPath.item];
    [self.scrollView setContentOffset:CGPointMake(CK_WIDTH, 0) animated:YES];
    [self toSearch];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDYSearchResultTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MDYSearchResultTableCell.class)];
    if (self.isSearchGoods) {
        MDYSearchGoodsModel *model = [self.resultArray objectAtIndex:indexPath.row];
        [cell setSearchGoodsModel:model];
        return cell;
    }
    MDYSearchCurriculumModel *model = [self.resultArray objectAtIndex:indexPath.row];
    [cell setSearchCourseModel:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isSearchGoods) {
        MDYSearchGoodsModel *model = self.resultArray[indexPath.row];
        MDYGoodsDetailsController *vc = [[MDYGoodsDetailsController alloc] init];
        vc.goodsId = model.goods_id;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        MDYSearchCurriculumModel *model = self.resultArray[indexPath.row];
        MDYCourseDetailController *vc = [[MDYCourseDetailController alloc] init];
        vc.courseId = model.uid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_bg_icon"];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"当前还没有数据";
    NSDictionary *attributes = @{NSFontAttributeName: KSystemFont(14),
                                NSForegroundColorAttributeName:K_TextLightGrayColor};
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//    return -((CGRectGetHeight(scrollView.frame) / 2.0f) - 14);
//}
#pragma mark - Getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [self.view addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom);
            make.left.right.bottom.equalTo(self.view).insets(UIEdgeInsetsZero);
        }];
        [_scrollView setScrollEnabled:NO];
        [_scrollView setContentSize:CGSizeMake(CK_WIDTH * 2, 0)];
    }
    return _scrollView;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CollectionViewLeftOrRightAlignedLayout *flowLayout = [[CollectionViewLeftOrRightAlignedLayout alloc] init];
        flowLayout.lineSpacing = 8 ;
        flowLayout.interitemSpacing = 12;
        flowLayout.stringSpacing = 0;
        flowLayout.delegate = self;
        flowLayout.itemHeight = 22.0f;
        flowLayout.labelFont = KSystemFont(15);
        flowLayout.headerViewHeight = 56;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CK_WIDTH, CK_HEIGHT - topViewHeight - KStatusBarHeight) collectionViewLayout:flowLayout];
        [self.view addSubview:_collectionView];
        [_collectionView setBackgroundColor:K_WhiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.emptyDataSetDelegate = self;
        _collectionView.emptyDataSetSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYSearchHistoryCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYSearchHistoryCollectionCell.class)];
    }
    return _collectionView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(CK_WIDTH, 0, CK_WIDTH, CK_HEIGHT - topViewHeight - KStatusBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
        [_tableView setTableFooterView:[[UIView alloc] init]];
        [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, CK_WIDTH, 16)]];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setSeparatorColor:K_WhiteColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYSearchResultTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(MDYSearchResultTableCell.class)];
    }
    return _tableView;
}
@end
