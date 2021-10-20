//
//  MDYDistributionDetailController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/15.
//

#import "MDYDistributionDetailController.h"
#import "MDYDistributionCoinCollectionCell.h"
#import "MDYDistributionInfoRequest.h"
@interface MDYDistributionDetailController ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation MDYDistributionDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"分销列表";
    self.dataSource = [NSMutableArray array];
    [self createView];
    CKWeakify(self);
    self.collectionView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        [weakSelf reloadDistributionInfo];
    }];
    self.collectionView.mj_footer = [MDYRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf reloadDistributionInfo];
    }];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)createView {
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(24, 16, 0, 16));
        make.height.mas_equalTo(82);
    }];
    [view setBackgroundColor:K_MainColor];
    [view.layer setCornerRadius:6];
    [view setClipsToBounds:YES];
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    [view addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).mas_offset(12);
        make.centerY.equalTo(view.mas_centerY);
        make.width.height.mas_equalTo(50);
    }];
    [headImageView.layer setCornerRadius:25];
    [headImageView setClipsToBounds:YES];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:self.imageString] placeholderImage:[UIImage imageNamed:@"default_avatar_icon"]];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).mas_offset(12);
        make.centerY.equalTo(view.mas_centerY);
    }];
    [nameLabel setText:self.name];
    [nameLabel setFont:KMediumFont(16)];
    [nameLabel setTextColor:K_WhiteColor];
    
    UILabel *numLabel = [[UILabel alloc] init];
    [view addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).mas_offset(-12);
        make.centerY.equalTo(view.mas_centerY);
    }];
    [numLabel setText:@"共0积分"];
    [numLabel setFont:KMediumFont(14)];
    [numLabel setTextColor:K_WhiteColor];
    self.numLabel = numLabel;
}
#pragma mark - Networking
- (void)reloadDistributionInfo {
    MDYDistributionInfoRequest *request = [MDYDistributionInfoRequest new];
    request.u_id = self.uid;
    request.page = self.pageNum;
    request.limit = 20;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        MDYDistributionInfoModel *model = response.data;
        [weakSelf.numLabel setText:[NSString stringWithFormat:@"共%@积分",model.sum]];
        if (weakSelf.pageNum == 1) {
            weakSelf.dataSource = [NSMutableArray arrayWithArray:model.list];
        } else {
            [weakSelf.dataSource addObjectsFromArray:model.list];
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
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CK_WIDTH - 32, 54);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MDYDistributionCoinCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYDistributionCoinCollectionCell.class) forIndexPath:indexPath];
    MDYDistributionInfoListModel *model = self.dataSource[indexPath.item];
    [cell.titlelabel setText:model.integral_txt];
    [cell.coinLabel setText:model.integral_num];
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
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(118, 0, 0, 0));
        }];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        _collectionView.alwaysBounceVertical=YES;
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYDistributionCoinCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYDistributionCoinCollectionCell.class)];
        
    }
    return _collectionView;
}
@end
