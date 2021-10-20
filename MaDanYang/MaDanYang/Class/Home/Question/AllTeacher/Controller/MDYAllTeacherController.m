//
//  MDYAllTeacherController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/8.
//

#import "MDYAllTeacherController.h"
#import "MDYTeacherCollectionViewCell.h"
#import "MDYAllQuestionHightView.h"
#import "MDYAnswerListController.h"
#import "MDYToQuestionController.h"
#import "MDYTeacherListRequest.h"
@interface MDYAllTeacherController ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) MDYAllQuestionHightView *hightView;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger selectedSwitch;
@end

@implementation MDYAllTeacherController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"全部教师";
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, 120, 44);
    [view addSubview:self.hightView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.dataSource = [NSMutableArray array];
    CKWeakify(self);
    self.collectionView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        [weakSelf getAllTeacherList];
    }];
    self.collectionView.mj_footer = [MDYRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getAllTeacherList];
    }];
    [self.collectionView.mj_header beginRefreshing];
}
#pragma mark - Networking
- (void)getAllTeacherList {
    MDYTeacherListRequest *request = [MDYTeacherListRequest new];
    request.limit = 20;
    request.page = self.pageNum;
    request.is_excellent = 0;
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
#pragma mark - IBAction
- (void)switchChange:(UISwitch *)sender {
    self.selectedSwitch = sender.isOn;
    [self.collectionView.mj_header beginRefreshing];
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CK_WIDTH - 32, 129);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MDYTeacherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYTeacherCollectionViewCell.class) forIndexPath:indexPath];
    MDYTeacherListModel *model = self.dataSource[indexPath.row];
    [cell setTeacherModel:model];
    CKWeakify(self);
    [cell setDidCheckBlock:^{
        MDYAnswerListController *vc = [[MDYAnswerListController alloc] init];
        vc.teacherId = model.admin_id;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [cell setDidToQuestionBlock:^{
        MDYToQuestionController *vc = [[MDYToQuestionController alloc] init];
        vc.teacherModel = model;
        [weakSelf.navigationController pushViewController:vc animated:YES];
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
    NSString *title = @"还没有教师数据～";
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
        [flowLayout setSectionInset:UIEdgeInsetsMake(16, 16, 0, 16)];
        [flowLayout setMinimumInteritemSpacing:0];
        [flowLayout setMinimumLineSpacing:16];
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
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYTeacherCollectionViewCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYTeacherCollectionViewCell.class)];
    }
    return _collectionView;
}
- (MDYAllQuestionHightView *)hightView {
    if (!_hightView) {
        _hightView = [[MDYAllQuestionHightView alloc] init];
        _hightView.frame = CGRectMake(0, 0, 140, 44);
//        [_hightView.selectedSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
        CKWeakify(self);
        [_hightView setDidSelectedSwitch:^(UIButton * _Nonnull sender) {
            weakSelf.selectedSwitch = sender.isSelected;
            [weakSelf.collectionView.mj_header beginRefreshing];
        }];
    }
    return _hightView;
}
@end
