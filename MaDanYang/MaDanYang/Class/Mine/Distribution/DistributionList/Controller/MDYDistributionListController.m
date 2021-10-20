//
//  MDYDistributionListController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/12.
//

#import "MDYDistributionListController.h"
#import "MDYDistibutionListHeadView.h"
#import "MDYDistributionListCollectionCell.h"
#import "MDYDistributionDetailController.h"
#import "MDYDistributionManController.h"
#import "MDYPrimaryDistributionRequest.h"
@interface MDYDistributionListController ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, copy) NSString *keyString;
@end

@implementation MDYDistributionListController
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
    self.navigationItem.title = @"我的分销";
    self.dataSource = [NSMutableArray array];
    [self createView];
    CKWeakify(self);
    self.collectionView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        [weakSelf getPrimaryDistribution];
    }];
    self.collectionView.mj_footer = [MDYRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getPrimaryDistribution];
    }];
    [self.collectionView.mj_header beginRefreshing];
}
- (void)createView {
    MDYDistibutionListHeadView *headView = [[MDYDistibutionListHeadView alloc] init];
    [self.view addSubview:headView];
    [headView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.height.mas_equalTo(54);
    }];
    CKWeakify(self);
    [headView setDidToSearch:^(NSString * _Nonnull string) {
        [weakSelf.collectionView.mj_header beginRefreshing];
    }];
    __weak typeof(headView)weakView = headView;
    [headView setDidSelectedButton:^{
        [weakSelf showPickViewWithVIew:weakView];
    }];
}
- (void)showPickViewWithVIew:(MDYDistibutionListHeadView *)headView {
//    CKWeakify(self);
    __weak typeof(headView)weakView = headView;
    MDYPickerView *view = [[MDYPickerView alloc] initWithTitle:@"请选择" data:@[@"人数高→低",@"人数低→高",@"金额高→低",@"金额低→高"] didSelected:^(NSInteger index,NSString * _Nonnull string) {
//        weakSelf.typeString = string;
        [weakView setButtonString:string];
    }];
    [view show];
}
#pragma mark - Networking
- (void)getPrimaryDistribution {
    MDYPrimaryDistributionRequest *request = [MDYPrimaryDistributionRequest new];
    request.page = self.pageNum;
    request.limit = 20;
    request.key = self.keyString;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        if (weakSelf.pageNum == 1) {
            weakSelf.dataSource = [NSMutableArray arrayWithArray:response.data];
        } else {
            [weakSelf.dataSource addObjectsFromArray:response.data];
        }
        if (weakSelf.dataSource.count >= response.count) {
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            weakSelf.pageNum ++;
        }
        [weakSelf.collectionView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CK_WIDTH - 32, 82);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MDYDistributionListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYDistributionListCollectionCell.class) forIndexPath:indexPath];
    MDYPrimaryDistributionModel *model = self.dataSource[indexPath.item];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.headimgurl] placeholderImage:[UIImage imageNamed:@"default_avatar_icon"]];
    [cell.nameLabel setText:model.nickname];
    [cell.distributionButton setTitle:[NSString stringWithFormat:@"分销%@次",model.refer_unm] forState:UIControlStateNormal];
    [cell.detailButton setTitle:[NSString stringWithFormat:@"购买%@次",model.frequency] forState:UIControlStateNormal];
    CKWeakify(self);
    [cell setDidClickButtonAction:^(NSInteger index) {
        if (index == 1) {
            MDYDistributionDetailController *vc = [[MDYDistributionDetailController alloc] init];
            vc.uid = model.u_id;
            vc.name = model.nickname;
            vc.imageString = model.headimgurl;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else {
            MDYDistributionManController *vc = [[MDYDistributionManController alloc] init];
            vc.manModel = model;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}
#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_bg_icon"];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"还没有数据～";
    NSDictionary *attributes = @{NSFontAttributeName: KSystemFont(14),
                                NSForegroundColorAttributeName:K_TextLightGrayColor};
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setSectionInset:UIEdgeInsetsMake(12, 16, 0, 16)];
        [flowLayout setMinimumInteritemSpacing:0];
        [flowLayout setMinimumLineSpacing:16];
        [flowLayout setItemSize:CGSizeMake(CK_WIDTH, 78)];
        [flowLayout setSectionHeadersPinToVisibleBounds:NO];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.lessThanOrEqualTo(self.view.mas_top).mas_offset(54);
            make.bottom.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        _collectionView.alwaysBounceVertical=YES;
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYDistributionListCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYDistributionListCollectionCell.class)];
        
    }
    return _collectionView;
}
@end
