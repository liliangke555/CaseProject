//
//  MDYMyQuestionListController.m
//  MaDanYang
//
//  Created by kckj on 2021/6/18.
//

#import "MDYMyQuestionListController.h"
#import "MDYHighAnswersCollectionCell.h"
#import "MDYQuestionDetailController.h"
#import "MDYMyQuestionAllRequest.h"
#import "MDYPutQuestionTypeReqeust.h"
#import "MDYMyQuestionMyPutReqeust.h"
#import "MDYMyQuestionMyBuyRequest.h"
@interface MDYMyQuestionListController ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *typeArray;
@property (nonatomic, assign) NSInteger selectedTypeIndex;
@property (nonatomic, strong) UIButton *typeButton;

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation MDYMyQuestionListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = [NSMutableArray array];
    [self createView];
    [self getQeustionTypeData];
    CKWeakify(self);
    self.collectionView.mj_header = [MDYRefreshHeader headerWithRefreshingBlock:^{
        MDYPutQuestionTypeModel *model = weakSelf.typeArray[weakSelf.selectedTypeIndex];
        if (weakSelf.indexType == 0) {
            [weakSelf getAllQuestionDataWithType:model];
        } else if (weakSelf.indexType == 1) {
            [weakSelf getMyPutQuestionDataWithType:model];
        } else {
            [weakSelf getMyBuyQuestionDataWithType:model];
        }
    }];
    self.collectionView.mj_footer = [MDYRefreshFooter footerWithRefreshingBlock:^{
        MDYPutQuestionTypeModel *model = weakSelf.typeArray[weakSelf.selectedTypeIndex];
        if (weakSelf.indexType == 0) {
            [weakSelf getAllQuestionDataWithType:model];
        } else if (weakSelf.indexType == 1) {
            [weakSelf getMyPutQuestionDataWithType:model];
        } else {
            [weakSelf getMyBuyQuestionDataWithType:model];
        }
    }];
}
#pragma mark - SetupView
- (void)createView {
    UIView *downView = [[UIView alloc] init];
    [self.view addSubview:downView];
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(16, 16, 0, 16));
        make.height.mas_equalTo(34);
    }];
    [downView setBackgroundColor:KHexColor(0xF5F5F5FF)];
    [downView.layer setCornerRadius:6];
    [downView setClipsToBounds:YES];
    
    UIButton *selectedButton = [UIButton k_buttonWithTarget:self action:@selector(selectedButtonAction:)];
    [downView addSubview:selectedButton];
    [selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(downView.mas_left).mas_offset(16);
        make.centerY.equalTo(downView.mas_centerY);
        make.right.equalTo(downView.mas_right);
    }];
//    [selectedButton setTitle:@"鼻科" forState:UIControlStateNormal];
    [selectedButton.titleLabel setFont:KSystemFont(14)];
    [selectedButton setTitleColor:K_TextBlackColor forState:UIControlStateNormal];
    [selectedButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    self.typeButton = selectedButton;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [selectedButton addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(selectedButton.mas_right).mas_offset(-12);
        make.centerY.equalTo(selectedButton.mas_centerY);
    }];
    [imageView setImage:[UIImage imageNamed:@"more_down_gray"]];
}
#pragma mark - Networking
- (void)getQeustionTypeData {
    MDYPutQuestionTypeReqeust *request = [MDYPutQuestionTypeReqeust new];
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        weakSelf.typeArray = response.data;
        if (weakSelf.typeArray.count > 0) {
            weakSelf.selectedTypeIndex = 0;
            MDYPutQuestionTypeModel *model = weakSelf.typeArray[0];
            [weakSelf.typeButton setTitle:model.type_name forState:UIControlStateNormal];
            [weakSelf.collectionView.mj_header beginRefreshing];
        }
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        
    }];
}
- (void)getAllQuestionDataWithType:(MDYPutQuestionTypeModel *)model {
    MDYMyQuestionAllRequest *reqeust = [MDYMyQuestionAllRequest new];
    reqeust.integral_type_id = model.integral_type_id;
    reqeust.page = self.pageNum;
    reqeust.limit = 20;
    reqeust.hideLoadingView = YES;
    CKWeakify(self);
    [reqeust asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        if (weakSelf.pageNum == 1) {
            weakSelf.dataSource = [NSMutableArray arrayWithArray:response.data];
        } else {
            [weakSelf.dataSource addObjectsFromArray:response.data];
        }
        weakSelf.pageNum ++;
        if (weakSelf.dataSource.count >= response.count) {
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.collectionView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}
- (void)getMyPutQuestionDataWithType:(MDYPutQuestionTypeModel *)model {
    MDYMyQuestionMyPutReqeust *reqeust = [MDYMyQuestionMyPutReqeust new];
    reqeust.integral_type_id = model.integral_type_id;
    reqeust.page = self.pageNum;
    reqeust.limit = 20;
    reqeust.hideLoadingView = YES;
    CKWeakify(self);
    [reqeust asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        if (weakSelf.pageNum == 1) {
            weakSelf.dataSource = [NSMutableArray arrayWithArray:response.data];
        } else {
            [weakSelf.dataSource addObjectsFromArray:response.data];
        }
        weakSelf.pageNum ++;
        if (weakSelf.dataSource.count >= response.count) {
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.collectionView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}
- (void)getMyBuyQuestionDataWithType:(MDYPutQuestionTypeModel *)model {
    MDYMyQuestionMyBuyRequest *reqeust = [MDYMyQuestionMyBuyRequest new];
    reqeust.integral_type_id = model.integral_type_id;
    reqeust.page = self.pageNum;
    reqeust.limit = 20;
    reqeust.hideLoadingView = YES;
    CKWeakify(self);
    [reqeust asyncRequestWithsuccessHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        if (weakSelf.pageNum == 1) {
            weakSelf.dataSource = [NSMutableArray arrayWithArray:response.data];
        } else {
            [weakSelf.dataSource addObjectsFromArray:response.data];
        }
        weakSelf.pageNum ++;
        if (weakSelf.dataSource.count >= response.count) {
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.collectionView reloadData];
    } failHandler:^(MDYBaseResponse * _Nonnull response) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}
#pragma mark - IBAction
- (void)selectedButtonAction:(UIButton *)sender {
    if (self.typeArray.count <= 0) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (MDYPutQuestionTypeModel *model in self.typeArray) {
        [array addObject:model.type_name];
    }
    CKWeakify(self);
    MDYPickerView *view = [[MDYPickerView alloc] initWithTitle:@"" data:array didSelected:^(NSInteger index,NSString * _Nonnull string) {
        weakSelf.selectedTypeIndex = index;
        [sender setTitle:string forState:UIControlStateNormal];
        [weakSelf.collectionView.mj_header beginRefreshing];
    }];
    [view show];
}
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CKWeakify(self);
    MDYHighAnswersCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MDYHighAnswersCollectionCell.class) forIndexPath:indexPath];
    if (self.indexType == 0) {
        MDYMyQuestionAllModel *model = self.dataSource[indexPath.row];
        [cell setAllModel:model];
    } else if (self.indexType == 1) {
        MDYMyQuestionMyPutModel *model = self.dataSource[indexPath.row];
        [cell setMyPutModel:model];
    } else {
        MDYMyQuestionMyBuyModel *model = self.dataSource[indexPath.row];
        [cell setMyBuyModel:model];
    }
    
    [cell setDidClickCheckButton:^{
        NSString *string = @"";
        if (weakSelf.indexType == 0) {
            MDYMyQuestionAllModel *model = self.dataSource[indexPath.row];
            string = model.put_questions_id;
        }  else if (self.indexType == 1) {
            MDYMyQuestionMyPutModel *model = self.dataSource[indexPath.row];
            string = model.put_questions_id;
        } else {
            MDYMyQuestionMyBuyModel *model = self.dataSource[indexPath.row];
            string = model.put_questions_id;
        }
        MDYQuestionDetailController *vc = [[MDYQuestionDetailController alloc] init];
//        vc.mySelf = YES;
        vc.questionId = string;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MDYQuestionDetailController *vc = [MDYQuestionDetailController new];
    if (self.indexType == 0) {
        MDYMyQuestionAllModel *model = self.dataSource[indexPath.row];
        vc.questionId = model.put_questions_id;
    } else if (self.indexType == 1) {
        MDYMyQuestionMyPutModel *model = self.dataSource[indexPath.row];
        vc.questionId = model.put_questions_id;
    } else {
        MDYMyQuestionMyBuyModel *model = self.dataSource[indexPath.row];
        vc.questionId = model.put_questions_id;
    }
    vc.mySelf = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_bg_icon"];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"还没有问答数据～";
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
        [flowLayout setItemSize:CGSizeMake(CK_WIDTH - 32, 129)];
        [flowLayout setSectionHeadersPinToVisibleBounds:NO];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view).insets(UIEdgeInsetsMake(66, 0, 0, 0));
        }];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        _collectionView.alwaysBounceVertical=YES;
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(MDYHighAnswersCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(MDYHighAnswersCollectionCell.class)];
        
    }
    return _collectionView;
}
@end
