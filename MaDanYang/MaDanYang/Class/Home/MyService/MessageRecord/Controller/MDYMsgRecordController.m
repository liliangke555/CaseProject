//
//  MDYMsgRecordController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/11.
//

#import "MDYMsgRecordController.h"
#import "MDYMsgRecordCollectionCell.h"
#import "MDYServiceMessageRequest.h"
#import "MDYServiceMessageReadRequest.h"
#import "MDYServiceMessageAllReadRequest.h"
@interface MDYMsgRecordController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation MDYMsgRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"留言记录";
    self.dataSource = [NSMutableArray array];
    [self createView];
    CKWeakify(self);
    self.collectionView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        [weakSelf reloadRecord];
    }];
    self.collectionView.mj_footer = [MDYRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf reloadRecord];
    }];
    [self.collectionView.mj_header beginRefreshing];
}
- (void)createView {
    UIButton *button = [UIButton k_buttonWithTarget:self action:@selector(buttonAction:)];
    button.frame = CGRectMake(0, 0, 70, 24);
    [button setTitle:@"全部已读" forState:UIControlStateNormal];
    [button setTitleColor:K_TextBlackColor forState:UIControlStateNormal];
    [button.titleLabel setFont:KSystemFont(17)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
#pragma mark - Networking
- (void)reloadRecord {
    MDYServiceMessageRequest *request = [MDYServiceMessageRequest new];
    request.page = self.pageNum;
    request.limit = 20;
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
        }
        [weakSelf.collectionView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}
- (void)readRequestWitId:(MDYServiceMessageModel *)model {
    MDYServiceMessageReadRequest *request = [MDYServiceMessageReadRequest new];
    request.cid = model.uid;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            model.is_show = @"1";
            [weakSelf.collectionView reloadData];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark - IBAction
- (void)buttonAction:(UIButton *)sender {
    MDYServiceMessageAllReadRequest *request = [MDYServiceMessageAllReadRequest new];
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        if (response.code == 0) {
            [weakSelf.collectionView.mj_header beginRefreshing];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    MDYServiceMessageModel *model = self.dataSource[indexPath.item];
    return CGSizeMake(CK_WIDTH - 32, 160 + model.messageHeagit);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MDYMsgRecordCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYMsgRecordCollectionCell.class) forIndexPath:indexPath];
    MDYServiceMessageModel *model = self.dataSource[indexPath.item];
    [cell setModel:model];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    MDYServiceMessageModel *model = self.dataSource[indexPath.item];
    [self readRequestWitId:model];
}
#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setSectionInset:UIEdgeInsetsMake(16, 0, 16, 0)];
        [flowLayout setMinimumInteritemSpacing:0];
        [flowLayout setMinimumLineSpacing:24];
        [flowLayout setItemSize:CGSizeMake(CK_WIDTH, 78)];
        [flowLayout setSectionHeadersPinToVisibleBounds:NO];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        _collectionView.alwaysBounceVertical=YES;
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYMsgRecordCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYMsgRecordCollectionCell.class)];
        
    }
    return _collectionView;
}
@end
