//
//  MDYDistributionManController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/15.
//

#import "MDYDistributionManController.h"
#import "MDYDistributionListCollectionCell.h"
#import "MDYDistributionDetailController.h"
#import "MDYSecondaryDistributionRequest.h"
@interface MDYDistributionManController ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, copy) NSString *keyString;
@end

@implementation MDYDistributionManController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"分销列表";
    self.dataSource = [NSMutableArray array];
    [self createView];
    CKWeakify(self);
    self.collectionView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        [weakSelf reloadManData];
    }];
    self.collectionView.mj_footer = [MDYRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf reloadManData];
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
    [headImageView sd_setImageWithURL:[NSURL URLWithString:self.manModel.headimgurl] placeholderImage:[UIImage imageNamed:@"default_avatar_icon"]];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).mas_offset(12);
        make.centerY.equalTo(view.mas_centerY);
    }];
    [nameLabel setText:self.manModel.nickname];
    [nameLabel setFont:KMediumFont(16)];
    [nameLabel setTextColor:K_WhiteColor];
    
    UILabel *numLabel = [[UILabel alloc] init];
    [view addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).mas_offset(-12);
        make.centerY.equalTo(view.mas_centerY);
    }];
    [numLabel setText:@"共(xx)人"];
    [numLabel setFont:KMediumFont(14)];
    [numLabel setTextColor:K_WhiteColor];
    self.numLabel = numLabel;
}
#pragma mark - Networing
- (void)reloadManData {
    MDYSecondaryDistributionRequest *request = [MDYSecondaryDistributionRequest new];
    request.u_id = self.manModel.u_id;
    request.limit = 20;
    request.key = self.keyString?:@"";
    request.page = self.pageNum;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
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
        [weakSelf.numLabel  setText:[NSString stringWithFormat:@"共(%ld)人",response.count]];
        [weakSelf.collectionView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
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
    MDYSecondaryDistributionModel *model = self.dataSource[indexPath.item];
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
            MDYPrimaryDistributionModel *manModel = [MDYPrimaryDistributionModel mj_objectWithKeyValues:model.mj_keyValues];
            vc.manModel = manModel;
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
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(118, 0, 0, 0));
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
