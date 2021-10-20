//
//  MDYHighDynamicController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/9.
//

#import "MDYHighDynamicController.h"
#import "MDYHomeDynamicCollectionCell.h"
#import "MDYDynamicDetailController.h"
#import "MDYHomeDynamicRequest.h"
#import "MDYPayDryingSheetRequest.h"
@interface MDYHighDynamicController ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageNum;
@end

@implementation MDYHighDynamicController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"优质晒单";
    self.dataSource = [NSMutableArray array];
    CKWeakify(self);
    self.collectionView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        [weakSelf getDynamicData];
    }];
    self.collectionView.mj_footer = [MDYRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getDynamicData];
    }];
    [self.collectionView.mj_header beginRefreshing];
}
- (void)showPayViewWithModel:(MDYHomeDynamicModel *)model {
    CKWeakify(self);
    MMPopupItemHandler block = ^(NSInteger index){
        if (index == 0) {
//            [weakSelf pushTZImagePickerController];
        } else {
            [weakSelf payDryingWithId:model];
        }
    };
    NSArray *items = @[MMItemMake(@"取消", MMItemTypeNormal, block),
                       MMItemMake(@"确定", MMItemTypeHighlight, block)];
    MMAlertView *view = [[MMAlertView alloc] initWithTitle:@"" image:^(UIImageView *imageView) {
        [imageView setImage:[UIImage imageNamed:@"pay_alter_icon"]];
    } detail:@"确认花费10积分来查看/提问问题么？" items:items];
    [view show];
}
#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_bg_icon"];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"还没有优质晒单数据～";
    NSDictionary *attributes = @{NSFontAttributeName: KSystemFont(14),
                                NSForegroundColorAttributeName:K_TextLightGrayColor};
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
#pragma mark - Networking
- (void)getDynamicData {
    MDYHomeDynamicRequest *request = [MDYHomeDynamicRequest new];
    request.hideLoadingView = YES;
    request.page = 1;
    request.limit = 20;
    request.is_index = 0;
    request.is_excellent = 1;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        if (response.code == 0) {
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
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}
- (void)payDryingWithId:(MDYHomeDynamicModel *)model {
    MDYPayDryingSheetRequest *request = [MDYPayDryingSheetRequest new];
    request.drying_sheet_id = model.drying_sheet_id;
    request.integral_type_id = @"";
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            model.integral_num = 0;
            [weakSelf.collectionView reloadData];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
            
    }];
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    MDYHomeDynamicModel *model = self.dataSource[indexPath.item];
    return CGSizeMake(CK_WIDTH - 32, 96 + model.cellHeight);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MDYHomeDynamicCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYHomeDynamicCollectionCell.class) forIndexPath:indexPath];
    MDYHomeDynamicModel *model = self.dataSource[indexPath.item];
    cell.name = model.nickname;
    cell.time = model.car_time;
    cell.headerImage = model.headimgurl;
    cell.detail = model.txt;
    cell.images = model.imgs;
    cell.integralNum = labs(model.integral_num);
    CKWeakify(self);
    [cell setDidClickCheck:^{
        [weakSelf showPayViewWithModel:model];
    }];
    __weak typeof(model)weakModel = model;
    [cell setDidCheckImage:^(NSInteger index) {
        [weakSelf showBrowerWithIndex:index data:weakModel.imgs view:nil];
    }];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MDYHomeDynamicModel *model = self.dataSource[indexPath.item];
    if (labs(model.integral_num) > 0) {
        [self showPayViewWithModel:model];
        return;
    }
    MDYDynamicDetailController *vc = [[MDYDynamicDetailController alloc] init];
    vc.homeModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setSectionInset:UIEdgeInsetsMake(16, 16, 0, 16)];
        [flowLayout setMinimumInteritemSpacing:0];
        [flowLayout setMinimumLineSpacing:16];
        [flowLayout setItemSize:CGSizeMake(CK_WIDTH, 78)];
        [flowLayout setSectionHeadersPinToVisibleBounds:NO];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        _collectionView.alwaysBounceVertical=YES;
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYHomeDynamicCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYHomeDynamicCollectionCell.class)];
        
    }
    return _collectionView;
}
@end
