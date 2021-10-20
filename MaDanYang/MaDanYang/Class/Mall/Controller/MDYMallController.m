//
//  MDYMallController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/3.
//

#import "MDYMallController.h"
#import "MDYHeaderBannerView.h"
#import "MDYTitleView.h"
#import "MDYItmeCollectionCell.h"
#import "MDYCurriculumCollectionCell.h"
#import "MDYAllGoodsController.h"
#import "MDYGoodsTimeLimitController.h"
#import "MDYGoodsGroupController.h"
#import "MDYSearchController.h"
#import "MDYGoodsDetailsController.h"
#import "MDYMallBannerRequest.h"
#import "MDYMallHomeReqeust.h"
@interface MDYMallController ()<UICollectionViewDelegate,UICollectionViewDataSource,MDYItemCollectionCellDelegate>{
    dispatch_group_t _group;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *homeImageModels;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger pageNum;
@end

@implementation MDYMallController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = [NSMutableArray array];
    [self createView];
    [self collectionView];
    CKWeakify(self);
    _group = dispatch_group_create();
    self.collectionView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        [weakSelf getMallBannerData];
        [weakSelf getMallGoods];
        dispatch_group_notify(self->_group, dispatch_get_main_queue(), ^{
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView reloadData];
        });
    }];
    self.collectionView.mj_footer = [MDYRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getMallGoods];
        dispatch_group_notify(self->_group, dispatch_get_main_queue(), ^{
            [weakSelf.collectionView.mj_footer endRefreshing];
            [weakSelf.collectionView reloadData];
        });
    }];
    [self.collectionView.mj_header beginRefreshing];
}
- (void)createView {
    UIImageView *backImageView = [[UIImageView alloc] init];
    [self.view addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    [backImageView setImage:[UIImage imageNamed:@"home_top_back"]];
    
    UIView *searchView = [[UIView alloc] init];
    [self.view addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(KStatusBarHeight + 8, 16, 0, 16));
        make.height.mas_equalTo(34);
    }];
    [searchView setBackgroundColor:KHexColor(0xFFFFFF66)];
    [searchView.layer setCornerRadius:6];
    [searchView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickSearch)]];
    
    UIImageView *searchIcon = [[UIImageView alloc] init];
    [searchView addSubview:searchIcon];
    [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchView.mas_left).mas_offset(8);
        make.centerY.equalTo(searchView.mas_centerY);
    }];
    [searchIcon setImage:[UIImage imageNamed:@"home_search_icon"]];
    
    UILabel *searchLabel = [[UILabel alloc] init];
    [searchView addSubview:searchLabel];
    [searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchIcon.mas_right).mas_offset(8);
        make.centerY.equalTo(searchIcon.mas_centerY);
    }];
    [searchLabel setFont:KSystemFont(14)];
    [searchLabel setText:@"搜索"];
    [searchLabel setTextColor:K_WhiteColor];
}
#pragma mark - Networking
- (void)getMallBannerData {
    MDYMallBannerRequest *request = [MDYMallBannerRequest new];
    request.hideLoadingView = YES;
    CKWeakify(self);
    dispatch_group_enter(_group);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        NSArray *array = response.data;
        if (array.count > 0) {
            weakSelf.homeImageModels = array;
        }
        dispatch_group_leave(self->_group);
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
    }];
}
- (void)getMallGoods {
    MDYMallHomeReqeust *reqeust = [MDYMallHomeReqeust new];
    reqeust.page = self.pageNum;
    reqeust.limit = 20;
    reqeust.hideLoadingView = YES;
    CKWeakify(self);
    dispatch_group_enter(_group);
    [reqeust asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        NSArray *array = response.data;
        if (weakSelf.pageNum == 1) {
            weakSelf.dataSource = [NSMutableArray arrayWithArray:array];
        } else {
            [weakSelf.dataSource addObjectsFromArray:array];
        }
        if (response.count <= weakSelf.dataSource.count) {
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            weakSelf.pageNum ++;
        }
        dispatch_group_leave(self->_group);
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
    }];
}
#pragma mark - IBAction
- (void)didClickSearch {
    MDYSearchController *vc = [[MDYSearchController alloc] init];
    vc.searchGoods = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - MDYItemCollectionCellDelegate
- (void)didSelectedIndex:(NSString *)title {
    if ([title isEqualToString:@"限时秒杀"]) {
        MDYGoodsTimeLimitController *vc = [[MDYGoodsTimeLimitController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([title isEqualToString:@"拼团抢购"]) {
        MDYGoodsGroupController *vc = [[MDYGoodsGroupController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        MDYAllGoodsController *vc = [[MDYAllGoodsController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0 && indexPath.section == 0) {
        return CGSizeMake(CK_WIDTH - 32, 60 + 32);
    }
    return CGSizeMake((CK_WIDTH - 32 - 16) / 2.0f, 183);
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(CK_WIDTH, 154);
    }
    CGSize size = CGSizeMake(CK_WIDTH, 56);
    return size;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            [collectionView registerClass:MDYHeaderBannerView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(MDYHeaderBannerView.class)];
            MDYHeaderBannerView *tempHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                     withReuseIdentifier:NSStringFromClass(MDYHeaderBannerView.class)
                                                                                            forIndexPath:indexPath];
            tempHeaderView.homeImageModels = self.homeImageModels;
            reusableView = tempHeaderView;
        } else {
            [collectionView registerClass:MDYTitleView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(MDYTitleView.class)];
            MDYTitleView *tempHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                     withReuseIdentifier:NSStringFromClass(MDYTitleView.class)
                                                                                            forIndexPath:indexPath];
            tempHeaderView.title = @"推荐商品";
            tempHeaderView.subTitle = @"";
            reusableView = tempHeaderView;
        }
    }
    return reusableView;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MDYItmeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYItmeCollectionCell.class) forIndexPath:indexPath];
        cell.dataSource = @[@{titleKey:@"限时秒杀",imageKey:@"mall_seckill_icon"},
                            @{titleKey:@"拼团抢购",imageKey:@"mall_buying_icon"},
                            @{titleKey:@"全部分类",imageKey:@"mall_all_icon"},];
        cell.delegate = self;
        return cell;
    }
    MDYCurriculumCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYCurriculumCollectionCell.class) forIndexPath:indexPath];
    MDYMallHomeModel *model = self.dataSource[indexPath.row];
    cell.mallModel = model;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    MDYMallHomeModel *model = self.dataSource[indexPath.row];
    MDYGoodsDetailsController *vc = [[MDYGoodsDetailsController alloc] init];
    vc.goodsId = model.goods_id;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setSectionInset:UIEdgeInsetsMake(16, 16, 16, 16)];
        [flowLayout setMinimumInteritemSpacing:16];
        [flowLayout setMinimumLineSpacing:16];
        [flowLayout setItemSize:CGSizeMake(CK_WIDTH, 78)];
        [flowLayout setSectionHeadersPinToVisibleBounds:NO];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(KNavBarAndStatusBarHeight + 10, 0, 0, 0));
        }];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        _collectionView.alwaysBounceVertical=YES;
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYItmeCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYItmeCollectionCell.class)];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYCurriculumCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYCurriculumCollectionCell.class)];
        
    }
    return _collectionView;
}
@end
