//
//  MDYAnswerListController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/8.
//

#import "MDYAnswerListController.h"
#import "MDYHighAnswersCollectionCell.h"
#import "MDYQuestionDetailController.h"
#import "MDYTeacherPutQuestionRequest.h"
@interface MDYAnswerListController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageNum;
@end

@implementation MDYAnswerListController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"回答列表";
    self.dataSource =[NSMutableArray array];
    CKWeakify(self);
    self.collectionView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        [weakSelf getTeacherPutData];
    }];
    self.collectionView.mj_footer = [MDYRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf getTeacherPutData];
    }];
    [self.collectionView.mj_header beginRefreshing];
}
#pragma mark - Networking
- (void)getTeacherPutData {
    MDYTeacherPutQuestionRequest *request = [MDYTeacherPutQuestionRequest new];
    request.page = self.pageNum;
    request.limit = 20;
    request.admin_id = self.teacherId;
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
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CK_WIDTH - 32, 129);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MDYTeacherPutQuestionModel *model = [self.dataSource objectAtIndex:indexPath.item];
    MDYHighAnswersCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYHighAnswersCollectionCell.class) forIndexPath:indexPath];
    [cell setTeacherAnswerModel:model];
    CKWeakify(self);
    [cell setDidClickCheckButton:^{
        MDYQuestionDetailController *vc = [[MDYQuestionDetailController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MDYTeacherPutQuestionModel *model = [self.dataSource objectAtIndex:indexPath.item];
    MDYQuestionDetailController *vc = [[MDYQuestionDetailController alloc] init];
    vc.questionId = model.put_questions_id;
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
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        _collectionView.alwaysBounceVertical=YES;
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYHighAnswersCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYHighAnswersCollectionCell.class)];
        
    }
    return _collectionView;
}

@end
